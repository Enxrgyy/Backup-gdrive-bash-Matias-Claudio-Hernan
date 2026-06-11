#!/bin/bash
# cleanup_gdrive.sh  -  Elimina respaldos antiguos de Google Drive
CONFIG_DIR="$HOME/backup_gdrive/config"
SCRIPT_DIR="$HOME/backup_gdrive/scripts"
LOG_FILE="$HOME/backup_gdrive/logs/backup_$(date +%Y%m).log"
GDRIVE_FOLDER="Respaldos_Linux"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

ACCESS_TOKEN=$(bash $SCRIPT_DIR/refresh_token.sh)
if [ -z "$ACCESS_TOKEN" ]; then
  log "ERROR: No se pudo obtener token de acceso."
  exit 1
fi

MAX_DAYS=0
CUTOFF=$(date -u -d "-${MAX_DAYS} days" '+%Y-%m-%dT%H:%M:%SZ')

FOLDER_SEARCH=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://www.googleapis.com/drive/v3/files?q=name%3D'$GDRIVE_FOLDER'%20and%20mimeType%3D'application%2Fvnd.google-apps.folder'%20and%20trashed%3Dfalse&fields=files(id,name)")
FOLDER_ID=$(echo "$FOLDER_SEARCH" | jq -r '.files[0].id')

log "Buscando respaldos con mas de $MAX_DAYS dias..."
QUERY="parents%3D'${FOLDER_ID}'%20and%20createdTime%3C'${CUTOFF}'"
OLD_FILES=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://www.googleapis.com/drive/v3/files?q=${QUERY}&fields=files(id,name)")

echo "$OLD_FILES" | jq -r '.files[]? | .id' | while read FILE_ID; do
  FILE_NAME=$(echo "$OLD_FILES" | jq -r ".files[]? | select(.id==\"$FILE_ID\") | .name")
  curl -s -X DELETE \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    "https://www.googleapis.com/drive/v3/files/$FILE_ID"
  log "Eliminado respaldo antiguo: $FILE_NAME"
done

log "Limpieza completada."
