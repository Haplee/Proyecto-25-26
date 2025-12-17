# Memoria Final ASIR: Sistema Automatizado de Copias de Seguridad

Este repositorio contiene la memoria final del proyecto de Grado Superior en **Administración de Sistemas Informáticos en Red (ASIR)**. La memoria se presenta en formato de una página web estática, profesional y auto-contenida, lista para su publicación.

## Descripción del Proyecto

El proyecto consiste en el diseño, implementación y documentación de un **"Sistema Automatizado de Copias de Seguridad y Gestión Centralizada de Configuraciones de Centrales de Alarma"**. La solución aborda la necesidad crítica de proteger y asegurar la recuperabilidad de las configuraciones de sistemas de seguridad en un entorno empresarial simulado.

La arquitectura se basa en un modelo cliente-servidor:
-   **Clientes Ligeros:** Scripts en Bash (para sistemas Linux) y PowerShell (para sistemas Windows) se encargan de recolectar los archivos de configuración, comprimirlos y enviarlos de forma segura al servidor central.
-   **Servidor Central:** Un servidor Linux con un stack Apache/PHP actúa como punto final para recibir los backups. Implementa un script PHP que valida las peticiones mediante un token de autenticación y organiza los archivos recibidos en una estructura de directorios lógica (`CLIENT_ID/MACHINE_ID/TIMESTAMP`).

Esta página web actúa como la documentación técnica completa del proyecto, detallando cada fase del ciclo de vida del mismo: análisis, diseño, tecnologías, implementación, seguridad, pruebas y conclusiones.

## Tecnologías Utilizadas

La página web de la memoria ha sido desarrollada utilizando exclusivamente tecnologías frontend estándar, sin dependencias de frameworks o sistemas de backend, para garantizar la máxima portabilidad y facilidad de despliegue.

-   **HTML5:** Para la estructura semántica del contenido.
-   **CSS3:** Para el diseño visual, incluyendo el uso de Flexbox, Media Queries para el diseño responsive y variables CSS para una fácil personalización.
-   **JavaScript (ligero):** Utilizado únicamente para mejorar la experiencia de usuario, como el desplazamiento suave (smooth scroll) en el menú de navegación.
-   **Google Fonts:** Para la importación de tipografías profesionales (Roboto).

## Estructura del Repositorio

La estructura de archivos está pensada para ser clara, mantenible y compatible directamente con el despliegue en servicios como GitHub Pages.

```
/
├── index.html       # Fichero principal con todo el contenido de la memoria.
├── css/
│   └── style.css    # Hoja de estilos que define el aspecto visual de la web.
├── js/
│   └── script.js    # Script para funcionalidades adicionales de UX.
└── README.md        # Este mismo archivo.
```

## Cómo Publicar en GitHub Pages

Puedes publicar esta memoria como un sitio web público de forma gratuita y sencilla siguiendo estos pasos:

1.  **Sube el código a GitHub:** Asegúrate de que todos los archivos (`index.html`, las carpetas `css` y `js`, etc.) están subidos a tu repositorio de GitHub.

2.  **Ve a la Configuración:** Dentro de tu repositorio en GitHub, haz clic en la pestaña **"Settings"**.

3.  **Accede a la sección "Pages":** En el menú lateral izquierdo, busca y haz clic en la opción **"Pages"**.

4.  **Configura la Fuente de Despliegue:**
    -   En la sección "Build and deployment", bajo "Source", selecciona la opción **"Deploy from a branch"**.
    -   A continuación, en la sección "Branch", asegúrate de que esté seleccionada tu rama principal (normalmente `main` o `master`).
    -   Elige la carpeta `/(root)` y haz clic en **"Save"**.

5.  **¡Listo!** GitHub tardará uno o dos minutos en construir y desplegar tu sitio. Una vez que termine, aparecerá un mensaje de confirmación con la URL pública de tu página (por ejemplo: `https://TU_USUARIO.github.io/NOMBRE_DEL_REPOSITORIO/`).

Con estos pasos, tu proyecto final estará presentado de una forma profesional y accesible para cualquiera.
