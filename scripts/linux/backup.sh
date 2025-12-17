#!/bin/bash

# --- CONFIGURACIÓN ---
# Rutas y Directorios
SOURCE_DIR="/etc/central-alarma/config" # Directorio de configuración a respaldar
TMP_DIR="/tmp/backup_agent"             # Directorio temporal para la copia
LOG_FILE="/var/log/backup_agent.log"    # Fichero de log del agente

# Identificadores del Equipo
CLIENTE_ID="CLIENTE_01"                 # ID único del cliente/empresa
EQUIPO_ID=$(hostname)                   # ID único del equipo (usamos el hostname)

# Configuración del Servidor de Backups
SERVER_URL="https://127.0.0.1/upload.php" # URL del script backend
AUTH_TOKEN="TU_SECRET_TOKEN_AQUI"         # Token de autenticación (debe coincidir con el del servidor)

# --- INICIO DEL SCRIPT ---

# Función para registrar mensajes
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Crear directorios necesarios si no existen
mkdir -p "$TMP_DIR"
touch "$LOG_FILE"

log "--- INICIO DEL PROCESO DE BACKUP ---"

# 1. Comprobar si el directorio de origen existe
if [ ! -d "$SOURCE_DIR" ]; then
    log "ERROR: El directorio de origen '$SOURCE_DIR' no existe. Abortando."
    exit 1
fi

# 2. Crear el nombre del archivo de backup con fecha y hora
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
BACKUP_FILENAME="${EQUIPO_ID}_config_${TIMESTAMP}.tar.gz"
BACKUP_TMP_PATH="$TMP_DIR/$BACKUP_FILENAME"

# 3. Crear el archivo comprimido
log "Creando archivo de backup temporal en '$BACKUP_TMP_PATH'..."
tar -czf "$BACKUP_TMP_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# Comprobar que el archivo se ha creado
if [ ! -f "$BACKUP_TMP_PATH" ]; then
    log "ERROR: No se pudo crear el archivo de backup. Compruebe permisos y espacio."
    exit 1
fi
log "Archivo de backup creado con éxito."

# 4. Enviar el backup al servidor
log "Enviando '$BACKUP_FILENAME' al servidor..."
HTTP_RESPONSE=$(curl --silent --write-out "HTTPSTATUS:%{http_code}" \
    -X POST \
    -H "X-Auth-Token: $AUTH_TOKEN" \
    -F "clienteId=$CLIENTE_ID" \
    -F "equipoId=$EQUIPO_ID" \
    -F "backupFile=@$BACKUP_TMP_PATH" \
    "$SERVER_URL")

# Extraer el código de estado y el cuerpo de la respuesta
HTTP_STATUS=$(echo "$HTTP_RESPONSE" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
HTTP_BODY=$(echo "$HTTP_RESPONSE" | sed -e 's/HTTPSTATUS\:.*//g')

# 5. Comprobar el resultado
if [ "$HTTP_STATUS" -eq 200 ]; then
    log "ÉXITO: El servidor respondió con código 200. Mensaje: $HTTP_BODY"
else
    log "ERROR: El servidor respondió con un error (Código: $HTTP_STATUS). Mensaje: $HTTP_BODY"
fi

# 6. Limpieza
log "Limpiando archivos temporales..."
rm -f "$BACKUP_TMP_PATH"

log "--- FIN DEL PROCESO DE BACKUP ---"

exit 0
