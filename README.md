# Sistema de Respaldo Automático a Google Drive con Bash
# Asignatura: Redes Avanzadas 1
## Descripción 
Sistema de respaldo automatizado desarrollado íntegramente en Bash, que comprime directorios locales y los sube a Google Drive consumiendo directamente la API REST de Google con OAuth 2.0, sin depender de herramientas de terceros como rclone o gdrive. La ejecución se programa con cron y cada respaldo queda registrado en un archivo de log con marca de tiempo.
# Integrantes del Grupo
* **Matías Peralta**
* **Hernán Vera** 
* **Claudio Zambra**
## Requisitos
Linux con Bash 
curl — peticiones HTTP a la API de Google
tar / gzip — compresión del respaldo
cron — programación de la ejecución automática
Una cuenta de Google y un proyecto en Google Cloud Console con la Google Drive API habilitada
