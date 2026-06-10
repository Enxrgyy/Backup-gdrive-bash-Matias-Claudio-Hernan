#!/bin/bash
# cleanup_gdrive.sh  -  Elimina respaldos antiguos de Google Drive
CONFIG_DIR="$HOME/backup_gdrive/config"
SCRIPT_DIR="$HOME/backup_gdrive/scripts"
LOG_FILE="$HOME/backup_gdrive/logs/backup_$(date +%Y%m).log"
GDRIVE_FOLDER="Respaldos_Linux"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

# Obtener token
ACCESS_TOKEN=$(bash $SCRIPT_DIR/refresh_token.sh)
if [ -z "$ACCESS_TOKEN" ]; then
  log "ERROR: No se pudo obtener token de acceso."
  exit 1
fi

MAX_DAYS=7
CUTOFF=$(date -d "-${MAX_DAYS} days" '+%Y-%m-%dT%H:%M:%S')

# Buscar carpeta
FOLDER_SEARCH=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://www.googleapis.com/drive/v3/files?q=name='$GDRIVE_FOLDER'+and+mimeType='application/vnd.google-apps.folder'+and+trashed=false&fields=files(id,name)")
FOLDER_ID=$(echo "$FOLDER_SEARCH" | jq -r '.files[0].id')

# Eliminar archivos antiguos
log "Buscando respaldos con mas de $MAX_DAYS dias..."
OLD_FILES=$(curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://www.googleapis.com/drive/v3/files?q=parents='$FOLDER_ID'+and+createdTime<'${CUTOFF}Z'&fields=files(id,name)")

echo "$OLD_FILES" | jq -r '.files[] | .id' | while read FILE_ID; do
  FILE_NAME=$(echo "$OLD_FILES" | jq -r ".files[] | select(.id==\"$FILE_ID\") | .name")
  curl -s -X DELETE \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    "https://www.googleapis.com/drive/v3/files/$FILE_ID"
  log "Eliminado respaldo antiguo: $FILE_NAME"
done

log "Limpieza completada."
