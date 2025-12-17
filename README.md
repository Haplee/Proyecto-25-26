# Proyecto ASIR: Sistema Automatizado de Copias de Seguridad y Gestión Centralizada

## 1. Descripción del Proyecto

Este repositorio contiene todos los artefactos del proyecto final del Ciclo Formativo de Grado Superior en **Administración de Sistemas Informáticos en Red (ASIR)**. El proyecto consiste en el diseño e implementación de un sistema centralizado para la gestión y automatización de copias de seguridad de configuraciones de centrales de alarma.

El sistema se compone de dos elementos principales:
-   **Scripts de Cliente:** Agentes ligeros diseñados para ejecutarse en sistemas Windows y Linux, responsables de recopilar, comprimir y enviar las configuraciones al servidor central.
-   **Servidor de Gestión:** Un servidor web central que recibe, organiza y almacena de forma segura las copias de seguridad enviadas por los clientes.

La memoria técnica completa del proyecto está documentada en un sitio web estático profesional, también incluido en este repositorio y diseñado para ser desplegado a través de GitHub Pages.

## 2. Estructura del Repositorio

El repositorio está organizado siguiendo buenas prácticas para garantizar la claridad, mantenibilidad y escalabilidad del proyecto.

```
.
├── .github/              # (Opcional) Workflows de CI/CD para automatización.
│   └── workflows/
│       └── deploy.yml
├── docs/                 # Contiene el sitio web estático de la memoria del proyecto.
│   ├── assets/           # Recursos como imágenes, logos, etc.
│   │   └── images/
│   ├── css/              # Hojas de estilo CSS.
│   │   └── style.css
│   ├── js/               # Scripts de JavaScript (funcionalidad ligera).
│   │   └── script.js
│   └── index.html        # Fichero principal de la memoria del proyecto.
├── scripts/              # Scripts de automatización para los clientes.
│   ├── linux/            # Scripts para sistemas operativos basados en Linux.
│   │   └── backup.sh
│   └── windows/          # Scripts para sistemas operativos Windows.
│       └── backup.ps1
├── .gitignore            # Ficheros y carpetas a ignorar por Git.
├── LICENSE               # Licencia del proyecto (MIT).
└── README.md             # Este archivo.
```

### Descripción de Carpetas y Archivos

-   **`docs/`**: Directorio raíz del sitio web estático. El contenido de esta carpeta está configurado para ser servido directamente por GitHub Pages.
    -   `index.html`: Punto de entrada de la web, contiene toda la memoria técnica.
    -   `css/style.css`: Define la apariencia visual y el diseño responsive.
    -   `js/script.js`: Añade funcionalidades interactivas menores, como el scroll suave.
    -   `assets/images/`: Almacena las imágenes y otros recursos visuales utilizados en la web.
-   **`scripts/`**: Contiene los scripts de cliente para la automatización de las copias de seguridad.
    -   `linux/backup.sh`: Script en Bash para clientes Linux.
    -   `windows/backup.ps1`: Script en PowerShell para clientes Windows.
-   **`.github/workflows/`**: (Opcional) Puede contener workflows de GitHub Actions para automatizar tareas como el despliegue del sitio web o la ejecución de tests.
-   **`.gitignore`**: Especifica qué archivos no deben ser rastreados por Git (e.g., dependencias, logs, archivos de entorno).
-   **`LICENSE`**: Archivo de licencia que define los términos de uso y distribución del código.
-   **`README.md`**: Documentación principal que proporciona una visión general del proyecto y su estructura.

## 3. Despliegue en GitHub Pages

La memoria del proyecto, contenida en la carpeta `docs/`, puede ser publicada como un sitio web profesional de forma gratuita a través de GitHub Pages.

Siga estos pasos para el despliegue:

1.  **Navegue a la configuración del repositorio:** En la página principal de su repositorio en GitHub, haga clic en la pestaña "Settings".
2.  **Acceda a la sección de "Pages":** En el menú lateral izquierdo, seleccione "Pages".
3.  **Configure la fuente de despliegue:**
    -   En la sección "Build and deployment", bajo "Source", seleccione la opción **"Deploy from a branch"**.
    -   En el desplegable "Branch", asegúrese de que esté seleccionada la rama `main` (o `master`) y, justo al lado, elija la carpeta **`/docs`** como fuente.
4.  **Guarde los cambios:** Haga clic en el botón "Save".
5.  **Acceda a su sitio web:** GitHub tardará unos minutos en construir y desplegar su sitio. Una vez listo, la URL de acceso (ej: `https://<tu-usuario>.github.io/<nombre-del-repositorio>/`) aparecerá en la parte superior de la sección "Pages".

## 4. Autor y Licencia

-   **Autor:** `[Tu Nombre Completo]`
-   **Curso Académico:** `[Año Académico, ej: 2024-2025]`
-   **Licencia:** Este proyecto está bajo la [Licencia MIT](LICENSE).
