# Sistema de Respaldo Automático a Google Drive con Bash
# Asignatura: Redes Avanzadas 1
## Descripción 
Sistema de respaldo automatizado desarrollado íntegramente en Bash, que comprime directorios locales y los sube a Google Drive consumiendo directamente la API REST de Google con OAuth 2.0, sin depender de herramientas de terceros como rclone o gdrive. La ejecución se programa con cron y cada respaldo queda registrado en un archivo de log con marca de tiempo.
# Integrantes del Grupo
* **Matías Peralta**
* **Hernán Vera** 
* **Claudio Zambra**
## Requisitos
-Linux con Bash 

-curl — peticiones HTTP a la API de Google

-tar / gzip — compresión del respaldo

-cron — programación de la ejecución automática

-Una cuenta de Google y un proyecto en Google Cloud Console con la Google Drive API habilitada

## Instalacion y Uso

1.- Clonar el repositorio y entrar a la carpeta del proyecto.

2.- Dar permisos de ejecución a los scripts de la carpeta scripts/.

3.- Ejecutar auth_gdrive.sh para conectar la cuenta de Google (solo la primera vez).

4.- Ejecutar backup_gdrive.sh para hacer un respaldo y comprobar que funciona. El resultado queda en la carpeta logs/.

5.- Agregar el script al crontab para que el respaldo se ejecute solo según el horario configurado.

## Seguridad

El archivo config/token.json guarda los datos de acceso a la cuenta de Google, por eso está en el .gitignore y no se sube al repositorio.
Seguridad

El archivo config/token.json guarda los datos de acceso a la cuenta de Google, por eso está en el .gitignore y no se sube al repositorio.

**[Ver Informe Técnico PDF](./InformeRedesavanzadas.pdf)**
