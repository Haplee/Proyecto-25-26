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

    const scrollToTopBtn = document.getElementById('scrollToTopBtn');

    if (scrollToTopBtn) {
        // Muestra u oculta el botón basado en la posición del scroll, usando una clase CSS.
        window.addEventListener('scroll', function() {
            if (window.scrollY > 300) {
                scrollToTopBtn.classList.add('is-visible');
            } else {
                scrollToTopBtn.classList.remove('is-visible');
            }
        });

        // Cuando se hace clic en el botón, desplaza la página a la parte superior.
        scrollToTopBtn.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth' // Desplazamiento suave.
            });
        });
    }
});
