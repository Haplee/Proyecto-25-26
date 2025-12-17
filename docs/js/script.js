document.addEventListener('DOMContentLoaded', function() {
    // Esta función se asegura de que el DOM esté completamente cargado antes de ejecutar el script.

    // Selecciona todos los enlaces de la barra de navegación que apuntan a anclas internas (href="#...").
    const navLinks = document.querySelectorAll('nav a[href^="#"]');

    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Previene el comportamiento por defecto del ancla, que es un salto brusco.
            e.preventDefault();

            // Obtiene el ID de la sección de destino desde el atributo href del enlace.
            const targetId = this.getAttribute('href');

            // Busca en el documento el elemento con el ID correspondiente.
            const targetElement = document.querySelector(targetId);

            // Si el elemento de destino existe, se desplaza suavemente hasta él.
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth', // Activa el desplazamiento suave.
                    block: 'start'      // Alinea el inicio del elemento con el inicio del viewport.
                });
            }
        });
    });

    // --- Lógica para el botón de Scroll-to-Top ---

    // Selecciona el botón por su ID.
    const scrollToTopBtn = document.getElementById('scrollToTopBtn');

    // Muestra u oculta el botón basado en la posición del scroll.
    window.addEventListener('scroll', function() {
        // Si el desplazamiento vertical es mayor a 300px, muestra el botón.
        if (window.scrollY > 300) {
            scrollToTopBtn.style.display = 'block';
            // Se usa un pequeño retardo para asegurar que el 'display' se aplique antes de la transición de opacidad.
            setTimeout(() => {
                scrollToTopBtn.style.opacity = '1';
                scrollToTopBtn.style.visibility = 'visible';
            }, 10);
        } else {
            // Si está cerca de la parte superior, oculta el botón.
            scrollToTopBtn.style.opacity = '0';
            scrollToTopBtn.style.visibility = 'hidden';
            // Espera a que la transición termine para cambiar el display a 'none'.
            setTimeout(() => {
                if (window.scrollY <= 300) {
                    scrollToTopBtn.style.display = 'none';
                }
            }, 400); // 400ms coincide con la duración de la transición en CSS.
        }
    });

    // Cuando se hace clic en el botón, desplaza la página a la parte superior.
    scrollToTopBtn.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth' // Desplazamiento suave.
        });
    });
});
