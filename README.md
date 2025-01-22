# Web-IA-Detection 🚀

**WEB-IA-Detect** es un sistema avanzado de detección de objetos basado en YOLOv5 que permite la grabación, procesamiento y notificación automática de eventos detectados en tiempo real a través de Telegram. Este proyecto está diseñado para detectar personas, gatos y perros desde flujos de cámaras y ofrece una interfaz web para su gestión.

---
## Demostración del uso. 🎥
![Demostración](./demo.gif)

## 🚀 Características principales

- **Grabación de video**: Captura y comprime videos desde cámaras en tiempo real.
- **Detección de objetos**: Identifica objetos específicos (personas, gatos, perros) en los videos.
- **Notificaciones**: Envía alertas detalladas, videos y fotogramas de detecciones vía Telegram.
- **Gestión web**: Incluye una aplicación Flask para iniciar/detener grabaciones y revisar logs.
- **Soporte para múltiples scripts**: Administra diferentes procesos de detección simultáneamente.

---

## 📁 Estructura del proyecto

```plaintext
Detect-IA/
├── analisis.sh       # Script para detección de personas
├── perro.sh          # Script para detección de perros
├── gato.sh           # Script para detección de gatos
├── app.py            # Aplicación Flask
├── config.py         # Configuración de rutas para scripts y logs
├── config.sh         # Configuración de variables (Telegram, rutas, cámara)
 templates/
│   └── index.html    # Interfaz web
├── requirements.txt  # Dependencias necesarias
└── install.sh # Dependencias necesarias de linux

```

## Configuración

### Configuración de los Archivos `config.py` y `config.sh` 📂

### Archivo `config.py`
Este archivo define las rutas base del proyecto, así como las rutas para los scripts y los archivos de logs. Es útil para centralizar la configuración de las rutas y facilitar modificaciones en el futuro.

### Código:

```python
import os

BASE_DIR = "ruta absoluta del proyecto"  # Cambia esto a la ruta absoluta, por ejemplo: "/root/DetectIAPerson"

# Configuración de scripts y logs
LOG_FILES = {
    'analisis': os.path.join(BASE_DIR, "detection.log"),
    'perro': os.path.join(BASE_DIR, "perros.log"),
    'gato': os.path.join(BASE_DIR, "gatos.log"),
}

SCRIPTS = {
    'analisis': os.path.join(BASE_DIR, "analisis.sh"),
    'perro': os.path.join(BASE_DIR, "perro.sh"),
    'gato': os.path.join(BASE_DIR, "gato.sh"),
}
```
### Configuración:
- **BASE_DIR**: Cambia `"ruta absoluta del proyecto"` a la ubicación completa de tu proyecto. Usa el comando `pwd` en la terminal dentro del directorio del proyecto para obtener esta ruta.
  - **Ejemplo**: 
    ```python
    BASE_DIR = "/root/DetectIAPerson"
    ```
---

### Archivo `config.sh`

Este archivo contiene configuraciones necesarias para interactuar con Telegram, especificar la fuente del video, y definir el directorio de salida.

### Código:
```bash
# Configuración de Telegram
TOKEN="TuTokendelBotDeTelegram"
CHAT_ID="TuChatID"
URL="https://api.telegram.org/bot$TOKEN/sendVideo"
MESSAGE_URL="https://api.telegram.org/bot$TOKEN/sendMessage"
PHOTO_URL="https://api.telegram.org/bot$TOKEN/sendPhoto"
DOCUMENT_URL="https://api.telegram.org/bot$TOKEN/sendDocument"

# Ruta de salida absoluta donde se aloja el proyecto
OUTPUT_DIR="RUTAABSOLUTA"

# URL del video de origen
VIDEO_URL="URLDELA_CAMARA_DE_VIDEO"
```



### Requisitos previos

- **Python 3.8+**
- **YOLOv5:** Instalado y configurado.
- **FFmpeg:** Para procesamiento de videos.
- **Dependencias de Python:** Instálalas ejecutando:
- 
 ```bash
  ./install.sh
  ```

  ```bash
  pip install -r requirements.txt
  ```

## Configuración del Bot de Telegram

1. **Registrar un bot en Telegram** y obtener tu `TOKEN` y `CHAT_ID`.
2. **Configurar las variables** en `config.sh`:
   - Añade el `TOKEN` y `CHAT_ID` correspondientes.

---

## Configuración del Proyecto

1. **Ruta absoluta del proyecto**:
   - Modifica la variable `BASE_DIR` en `config.py`.
   - Actualiza `OUTPUT_DIR` en `config.sh`.

---

## Uso

### Ejecutar la Aplicación Flask

```bash
python3 app.py
```
La aplicación estará disponible en: [http://localhost:4040](http://localhost:4040).

---

## 🚀 Funcionalidades Principales

### 🌐 Interfaz Web
1. Accede a la página principal.
2. Selecciona el script que deseas ejecutar (personas, perros o gatos).
3. Configura la duración de la grabación.
4. Revisa los logs y resultados desde la misma interfaz.

### 🛠️ Ejecución Manual de Scripts
Si prefieres ejecutar los scripts desde la terminal, utiliza los siguientes comandos:

```bash
bash analisis.sh 10  # Grabar y procesar por 10 minutos
bash perro.sh 5      # Grabar y procesar por 5 minutos
bash gato.sh 15      # Grabar y procesar por 15 minutos
```

## Personalización 🚀

### Agregar nuevos objetos:
Puedes modificar los scripts para detectar clases adicionales. Por ejemplo:
- Usa el parámetro `--class 0` para detectar personas.
- Usa `--class 15` para detectar gatos.
- Usa `--class 16` para detectar perros.

### Actualizar rutas de cámaras:
Edita el archivo `config.sh` y cambia el valor de `VIDEO_URL` para actualizar la fuente del video.

---

## Logs 📜

Cada script genera un archivo de log separado para facilitar el monitoreo:
- `detection.log`: Registra las detecciones de personas.
- `perros.log`: Registra las detecciones de perros.
- `gatos.log`: Registra las detecciones de gatos.

Los logs incluyen:
- Detalles de las detecciones.
- Información sobre errores ocurridos.

---

## Seguridad 🔒

### Evitar ejecuciones simultáneas:
Los scripts implementan mecanismos de bloqueo (`LOCKFILE`) para prevenir conflictos al ejecutar múltiples instancias.

### Validación de entradas:
Los parámetros ingresados son validados antes de iniciar cualquier grabación para evitar errores.

---

## Contribuciones 🤝

¡Siéntete libre de contribuir a este proyecto! Puedes:
- Abrir un **Pull Request** con tus mejoras.
- Reportar problemas en la sección de **Issues** del repositorio.

---
