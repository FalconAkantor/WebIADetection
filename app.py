from flask import Flask, request, render_template
import subprocess
import os
import config

app = Flask(__name__)

# Diccionario global para almacenar procesos por script
processes = {}

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/start', methods=['POST'])
def start_script():
    data = request.get_json()
    duration = data.get('duration', 1)  # Valor por defecto de 1 minuto si no se especifica
    script_key = data.get('script', 'analisis')  # Valor por defecto: analisis.sh

    # Verificar si el script existe y no está ya en ejecución
    if script_key not in processes:
        script_path = config.SCRIPTS.get(script_key)  # Accede desde config.py
        log_file_path = config.LOG_FILES.get(script_key, config.LOG_FILES['analisis'])  # Asignar el log correspondiente

        if script_path:
            # Iniciar el script y redirigir stdout/stderr al archivo de log
            with open(log_file_path, 'w') as log_file:
                process = subprocess.Popen(["/bin/bash", script_path, str(duration)], stdout=log_file, stderr=log_file)
                processes[script_key] = process  # Guardar el proceso en el diccionario
            return f"Grabación {script_key} iniciada por {duration} minuto(s)."
        else:
            return "Script no encontrado."
    return f"El script {script_key} ya está en ejecución."

@app.route('/stop', methods=['POST'])
def stop_script():
    data = request.get_json()
    script_key = data.get('script', 'analisis')

    # Verificar si el proceso está en ejecución
    process = processes.get(script_key)
    if process:
        process.terminate()
        del processes[script_key]  # Eliminar el proceso del diccionario
        return f"Grabación {script_key} detenida."
    return f"No hay ningún script {script_key} en ejecución."

@app.route('/logs/<script>', methods=['GET'])
def get_logs(script):
    log_file = config.LOG_FILES.get(script)
    if log_file and os.path.exists(log_file):
        with open(log_file, 'r') as file:
            logs = file.read()
        return logs
    return f"No se encontró el archivo de log para {script}."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4040)
