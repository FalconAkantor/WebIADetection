import os

BASE_DIR = "ruta absoluta del proyecto"  # Cambia esto a la ruta absoluta en mi caso era /root/DetectIAPerson

# Configuraci�n de scripts y logs
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