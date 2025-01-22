# Web-IA-Detection

**Detect-IA** es un sistema avanzado de detección de objetos basado en YOLOv5 que permite la grabación, procesamiento y notificación automática de eventos detectados en tiempo real a través de Telegram. Este proyecto está diseñado para detectar personas, gatos y perros desde flujos de cámaras y ofrece una interfaz web para su gestión.

---

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
├── templates/
│   └── index.html    # Interfaz web
└── requirements.txt  # Dependencias necesarias
```

## Configuración

### Requisitos previos

- **Python 3.8+**
- **YOLOv5:** Instalado y configurado.
- **FFmpeg:** Para procesamiento de videos.
- **Dependencias de Python:** Instálalas ejecutando:

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

## Futuras mejoras 🌟

1. Implementar detección de múltiples objetos en un solo script.
2. Agregar opciones de configuración avanzadas directamente desde la interfaz web.
3. Integrar almacenamiento en la nube para los resultados procesados.

---

## Contribuciones 🤝

¡Siéntete libre de contribuir a este proyecto! Puedes:
- Abrir un **Pull Request** con tus mejoras.
- Reportar problemas en la sección de **Issues** del repositorio.

---
