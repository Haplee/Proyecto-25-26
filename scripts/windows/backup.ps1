# --- CONFIGURACIÓN ---
# Rutas y Directorios
$sourceDir = "C:\ProgramData\CentralAlarma\config" # Directorio de configuración a respaldar
$tmpDir    = "C:\Temp\BackupAgent"               # Directorio temporal para la copia
$logFile   = "C:\ProgramData\BackupAgent\agent.log" # Fichero de log del agente

# Identificadores del Equipo
$clienteId = "CLIENTE_01"                       # ID único del cliente/empresa
$equipoId  = $env:COMPUTERNAME                  # ID único del equipo (usamos el nombre del equipo)

# Configuración del Servidor de Backups
$serverUrl = "https://127.0.0.1/upload.php"       # URL del script backend
$authToken = "TU_SECRET_TOKEN_AQUI"           # Token de autenticación (debe coincidir con el del servidor)

# --- INICIO DEL SCRIPT ---

# Función para registrar mensajes
function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] - $Message"
    Add-Content -Path $logFile -Value $logMessage
}

# Crear directorios y fichero de log si no existen
if (-not (Test-Path -Path $tmpDir)) { New-Item -Path $tmpDir -ItemType Directory -Force | Out-Null }
if (-not (Test-Path -Path (Split-Path $logFile -Parent))) { New-Item -Path (Split-Path $logFile -Parent) -ItemType Directory -Force | Out-Null }
if (-not (Test-Path -Path $logFile)) { New-Item -Path $logFile -ItemType File -Force | Out-Null }

Write-Log "--- INICIO DEL PROCESO DE BACKUP ---"

# 1. Comprobar si el directorio de origen existe
if (-not (Test-Path -Path $sourceDir -PathType Container)) {
    Write-Log "ERROR: El directorio de origen '$sourceDir' no existe. Abortando."
    exit 1
}

# 2. Crear el nombre del archivo de backup
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFilename = "${equipoId}_config_${timestamp}.zip"
$backupTmpPath = Join-Path -Path $tmpDir -ChildPath $backupFilename

# 3. Crear el archivo comprimido
Write-Log "Creando archivo de backup temporal en '$backupTmpPath'..."
try {
    Compress-Archive -Path $sourceDir -DestinationPath $backupTmpPath -Force
    Write-Log "Archivo de backup creado con éxito."
} catch {
    Write-Log "ERROR: No se pudo crear el archivo de backup. Detalles: $_"
    exit 1
}

# 4. Enviar el backup al servidor
Write-Log "Enviando '$backupFilename' al servidor..."

$headers = @{
    "X-Auth-Token" = $authToken
}

$form = @{
    clienteId  = $clienteId
    equipoId   = $equipoId
    backupFile = Get-Item -Path $backupTmpPath
}

try {
    $response = Invoke-RestMethod -Uri $serverUrl -Method Post -ContentType "multipart/form-data" -Headers $headers -Form $form

    Write-Log "ÉXITO: El servidor respondió correctamente. Mensaje: $response"
} catch {
    $statusCode = $_.Exception.Response.StatusCode.Value__
    $statusDescription = $_.Exception.Response.StatusDescription
    Write-Log "ERROR: El servidor respondió con un error (Código: $statusCode - $statusDescription)."
}

# 5. Limpieza
Write-Log "Limpiando archivos temporales..."
Remove-Item -Path $backupTmpPath -Force

Write-Log "--- FIN DEL PROCESO DE BACKUP ---"

exit 0
