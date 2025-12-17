# Proyecto Final ASIR: Sistema Centralizado de Backups para Configuraciones de Alarmas

## 1. Introducción y Arquitectura

Este proyecto presenta una solución cliente-servidor robusta y automatizada para la gestión de copias de seguridad de configuraciones críticas de centrales de alarma. El sistema está diseñado para operar en entornos heterogéneos (Windows y Linux) y centraliza los backups en un servidor web seguro, accesible para los técnicos autorizados.

### 1.1. Arquitectura Cliente-Servidor

- **Servidor Central (Linux + Apache + PHP):**
  - Actúa como el repositorio central y seguro para todos los backups.
  - Un script PHP (`upload.php`) gestiona la recepción de ficheros, autentica a los clientes mediante un token secreto y organiza las copias en una estructura de directorios lógica (`/cliente/equipo/backup.tar.gz`).
  - El acceso web al directorio de backups está protegido por autenticación básica (`.htaccess`) y la comunicación se cifra mediante HTTPS.

- **Clientes (Agentes en Windows y Linux):**
  - En cada equipo de cliente (Windows o Linux) se ejecuta un agente ligero (script de PowerShell o Bash).
  - Este agente se configura como una tarea programada (`cron` en Linux, Programador de Tareas en Windows) para ejecutarse periódicamente.
  - El script localiza los ficheros de configuración, los comprime, genera un nombre de fichero con fecha y hora, y lo envía de forma segura al servidor central a través de una petición HTTP POST.

![Diagrama de Arquitectura](httpsd://i.imgur.com/ARQUITECTURA_PLACEHOLDER.png) (*Diagrama conceptual*)

---

## 2. Relación con los Módulos de ASIR

Este proyecto es una aplicación práctica e integrada de los conocimientos adquiridos en varios módulos del ciclo formativo de ASIR:

- **Implantación de Sistemas Operativos (ISO):** Instalación, configuración y gestión de clientes Windows y Linux. Uso del Programador de Tareas y `cron`.
- **Planificación y Administración de Redes (PAR):** Diseño de la arquitectura cliente-servidor, direccionamiento IP y configuración de servicios de red.
- **Fundamentos de Hardware (FH):** Comprensión del almacenamiento y la criticidad de los datos de configuración.
- **Gestión de Bases de Datos (GBD):** Aunque no usa una BBDD SQL, se aplican principios de integridad y disponibilidad de datos.
- **Lenguajes de Marcas y Sistemas de Gestión de Información (LMSGI):** El backend PHP y la interacción con el servidor web son conceptos relacionados.
- **Administración de Sistemas Operativos (ASO):** Scripting avanzado en Bash y PowerShell, gestión de permisos en el sistema de ficheros y automatización de tareas.
- **Servicios de Red e Internet (SRI):** Configuración de un servidor web Apache, implementación de HTTPS con certificados SSL/TLS y configuración de la autenticación (`.htaccess`).
- **Seguridad y Alta Disponibilidad (SAD):** Aseguramiento del servidor (hardening), cifrado de comunicaciones, gestión de tokens de autenticación y diseño de una estrategia de recuperación de datos.
- **Empresa e Iniciativa Emprendedora (EIE):** Planteamiento de una solución a una necesidad empresarial real, con un enfoque en la eficiencia y la seguridad.

---

## 3. Manual de Instalación y Configuración

### 3.1. Configuración del Servidor Central (Debian/Ubuntu)

**1. Instalar Apache, PHP y Utilidades:**
```bash
sudo apt-get update
sudo apt-get install -y apache2 php libapache2-mod-php apache2-utils
```

**2. Crear Estructura de Directorios y Permisos:**
```bash
sudo mkdir -p /var/www/backups
sudo chown www-data:www-data /var/www/backups
sudo chmod 755 /var/www/backups
```

**3. Desplegar el Backend (`upload.php`):**
- Copia el fichero `upload.php` proporcionado a `/var/www/html/`.
- Edita el fichero y establece un token secreto seguro en la variable `$secretToken`.
```bash
sudo mv upload.php /var/www/html/upload.php
sudo chown www-data:www-data /var/www/html/upload.php
sudo chmod 644 /var/www/html/upload.php
```

**4. Crear y Configurar el Fichero de Log:**
```bash
sudo touch /var/log/backup_server.log
sudo chown www-data:www-data /var/log/backup_server.log
```

**5. Habilitar HTTPS:**
```bash
sudo a2enmod ssl headers
sudo a2ensite default-ssl
sudo systemctl restart apache2
```
*Nota importante sobre seguridad: Para un entorno de producción, es **imprescindible** generar e instalar un certificado SSL/TLS válido (por ejemplo, usando Let's Encrypt). El uso de certificados autofirmados sin la debida configuración de confianza en los clientes puede provocar fallos de conexión. La validación de certificados no debe ser omitida.*

**6. Proteger el Directorio de Backups:**
- Crea el fichero `/var/www/backups/.htaccess` con el siguiente contenido:
```
Options -Indexes
AuthType Basic
AuthName "Acceso Restringido para Técnicos"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user
```
- Crea el primer usuario técnico (se te pedirá una contraseña):
```bash
sudo htpasswd -c /etc/apache2/.htpasswd tecnico1
```

### 3.2. Configuración del Cliente Linux (Bash)

**1. Desplegar el Agente:**
- Copia el script `backup_agent.sh` a una ruta adecuada en el equipo cliente, por ejemplo, `/usr/local/bin/`.
- Dale permisos de ejecución: `chmod +x /usr/local/bin/backup_agent.sh`.

**2. Configurar el Agente:**
- Edita el script `backup_agent.sh` y ajusta las siguientes variables:
  - `SOURCE_DIR`: Ruta a la configuración de la central de alarma.
  - `CLIENTE_ID`: Identificador del cliente.
  - `SERVER_URL`: URL completa del `upload.php` en el servidor.
  - `AUTH_TOKEN`: El mismo token secreto que configuraste en el servidor.

**3. Programar la Tarea con `cron`:**
- Abre el editor de cron: `sudo crontab -e`.
- Añade una línea para ejecutar el backup diariamente a las 02:00 AM:
```
0 2 * * * /usr/local/bin/backup_agent.sh
```

### 3.3. Configuración del Cliente Windows (PowerShell)

**1. Desplegar el Agente:**
- Copia el script `Backup-Agent.ps1` a una ruta estable, como `C:\Program Files\BackupAgent\`.

**2. Configurar el Agente:**
- Edita `Backup-Agent.ps1` y ajusta las variables en la sección de configuración:
  - `$sourceDir`: Ruta a los ficheros de configuración (ej: `C:\ProgramData\CentralAlarma\config`).
  - `$clienteId`: Identificador del cliente.
  - `$serverUrl`: URL del `upload.php`.
  - `$authToken`: El token secreto del servidor.

**3. Programar la Tarea con el Programador de Tareas:**
- Abre el "Programador de Tareas" (`taskschd.msc`).
- Crea una nueva tarea básica:
  - **Desencadenador:** Diario, a las 02:00 AM.
  - **Acción:** Iniciar un programa.
  - **Programa/script:** `powershell.exe`
  - **Agregar argumentos (opcional):** `-ExecutionPolicy Bypass -File "C:\Program Files\BackupAgent\Backup-Agent.ps1"`
- Configura la tarea para que se ejecute con los privilegios más altos y aunque el usuario no haya iniciado sesión.

---

## 4. Guía de Uso para Técnicos

**Acceso a los Backups:**

1. Abre un navegador web.
2. Navega a la URL del directorio de backups: `https://<IP_DEL_SERVIDOR>/backups/`.
3. Se te solicitará un nombre de usuario y una contraseña. Utiliza las credenciales creadas por el administrador del sistema (ej: `tecnico1`).
4. Una vez autenticado, podrás navegar por la estructura de directorios organizada por cliente y equipo para descargar el fichero de backup que necesites.

**Restauración de una Configuración:**

1. Descarga el fichero `.tar.gz` (Linux) o `.zip` (Windows) correspondiente.
2. Descomprímelo en una ubicación temporal.
3. Sigue los procedimientos específicos del software de la central de alarmas para restaurar la configuración desde los ficheros recuperados.
