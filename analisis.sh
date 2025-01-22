#!/bin/bash

echo  "============================================"
echo  "               Detect-IA by Akantor"
echo " ============================================"

source ./config.sh

# Archivo de bloqueo
LOCKFILE="$OUTPUT_DIR/analisis.lock"

# Verificar si ya existe una instancia en ejecución
if [ -f "$LOCKFILE" ]; then
    echo "El script ya se está ejecutando. Saliendo..."
    exit 1
fi

# Crear archivo de bloqueo
echo $$ > "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

# Validar entrada de duración
if [ -z "$1" ] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Debes proporcionar una duración válida en minutos como argumento."
    exit 1
fi

duration_minutes=$1

# Número de fotogramas por segundo
FPS=0.5  # Esto significa 1 fotograma cada 2 segundos

# Bitrate objetivo para la compresión
BITRATE="500k"

# Nombre del archivo de salida con marca de tiempo
VIDEO_TIMESTAMP=$(date +'%Y%m%d_%H%M%S')
OUTPUT_FILE="$OUTPUT_DIR/video_$VIDEO_TIMESTAMP.mp4"
LOG_FILE="$OUTPUT_DIR/detection.log"

# Funciones para mensajes de Telegram
send_message() {
    local message=$1
    curl -s -F chat_id="$CHAT_ID" -F text="$message" "$MESSAGE_URL"
}

send_error_message() {
    local message=$1
    echo "$message" | tee -a "$LOG_FILE" 2>&1
    curl -s -F chat_id="$CHAT_ID" -F text="$message" "$MESSAGE_URL"
}

# Limpiar el archivo de log al inicio del script
> "$LOG_FILE"

# Redirigir toda la salida y errores al log
exec >> "$LOG_FILE" 2>&1

# Verificar y eliminar directorios exp2 a exp9 si existe exp9
runs_dir="$OUTPUT_DIR/runs/detect"
if [ -d "$runs_dir/exp9" ]; then
    echo "Directorio exp9 encontrado. Eliminando exp2 a exp9..."
    for i in {2..9}; do
        if [ -d "$runs_dir/exp$i" ]; then
            rm -r "$runs_dir/exp$i"
            echo "Eliminado $runs_dir/exp$i"
        fi
    done
else
    echo "exp9 no existe. No se eliminarán directorios."
fi

# Grabar video durante la duración especificada en minutos y comprimir
echo "Grabando y comprimiendo video durante $duration_minutes minutos..."
ffmpeg -nostdin -hide_banner -loglevel error -i "$VIDEO_URL" -t "$((duration_minutes * 60))" \
-vf "fps=$FPS,scale=640:-1" -c:v libx264 -preset veryslow -b:v $BITRATE -c:a aac -b:a 128k "$OUTPUT_FILE"

# Verificar si se grabó el video correctamente
if [ ! -f "$OUTPUT_FILE" ]; then
    send_error_message "Error: No se pudo grabar el video correctamente."
    exit 1
fi

# Enviar mensaje con la fecha del video
video_date=$(date +'%d de %B')
send_message "Video grabado el $video_date."

# Procesar el video usando detect.py
echo "Procesando video con detect.py..."
python3 "$OUTPUT_DIR/detect.py" --source "$OUTPUT_FILE" --weights "$OUTPUT_DIR/yolov5s.pt" --conf-thres 0.35 --class 0

# Directorio donde se guardan los resultados de detect.py
results_directory=$(find "$OUTPUT_DIR/runs/detect" -type d -name "exp*" | sort | tail -n 1)

# Verificar si se encontraron archivos de resultados
if [ -z "$results_directory" ]; then
    send_error_message "No se encontraron resultados de detección en $results_directory"
    exit 1
fi

# Obtener el nombre del archivo de video procesado más reciente
processed_video=$(ls -t "$results_directory"/*.mp4 | head -n 1)

# Verificar si se encontró algún video procesado
if [ -z "$processed_video" ]; then
    send_error_message "No se encontraron videos procesados en $results_directory"
    exit 1
fi

# Enviar mensaje con el total de fotogramas con personas detectadas
echo "Analizando detección de personas..."
detections=0
detection_frames=()

# Procesar el archivo de log
while IFS= read -r line; do
    if [[ "$line" == *"person"* ]]; then
        frame=$(echo "$line" | grep -oP '\(\K[0-9]+(?=/)')
        if [[ -n "$frame" && "$frame" =~ ^[0-9]+$ ]]; then
            detection_frames+=("$frame")
            detections=$((detections + 1))
        fi
    fi
done < "$LOG_FILE"

# Enviar resumen con el total de fotogramas con personas detectadas
if [ $detections -eq 0 ]; then
    send_message "No se detectó a ninguna persona en el video."
else
    send_message "Se detectaron un total de $detections fotogramas con personas en el video."
    echo "Extrayendo fotogramas del video procesado donde se detectó a una persona..."
    for frame in "${detection_frames[@]}"; do
        # Restar 1 al número de fotograma para evitar el siguiente fotograma
        adjusted_frame=$((frame - 1))
        # Guardar los fotogramas dentro del directorio de la ejecución actual (runs/expX)
        frame_file="$results_directory/frame_$adjusted_frame.png"
        ffmpeg -nostdin -hide_banner -loglevel error -i "$processed_video" -vf "select=eq(n\,$adjusted_frame)" -vsync vfr "$frame_file"
        if [ -f "$frame_file" ]; then
            curl -s -F chat_id="$CHAT_ID" -F photo=@"$frame_file" "$PHOTO_URL"
            if [ $? -ne 0 ]; then
                send_error_message "Error: No se pudo enviar el fotograma $adjusted_frame por Telegram."
            fi
        else
            send_error_message "Error: No se pudo extraer el fotograma $adjusted_frame."
        fi
    done
fi

# Enviar el video procesado con título
video_title="Video Procesado - $video_date"
echo "Enviando video procesado por Telegram..."
curl -s -F chat_id="$CHAT_ID" -F caption="$video_title" -F video=@"$processed_video" "$URL"
if [ $? -ne 0 ]; then
    send_error_message "Error: No se pudo enviar el video procesado por Telegram."
    exit 1
fi
echo "Video procesado enviado por Telegram."

# Enviar el archivo de log por Telegram
echo "Enviando archivo de log por Telegram..."
curl -s -F chat_id="$CHAT_ID" -F document=@"$LOG_FILE" "$DOCUMENT_URL"
if [ $? -ne 0 ]; then
    send_error_message "Error: No se pudo enviar el archivo de log por Telegram."
    exit 1
fi
echo "Archivo de log enviado por Telegram."

echo "Proceso completado."
