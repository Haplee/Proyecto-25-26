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

    // --- Lógica combinada para Scrollspy y botón Scroll-to-Top ---
    const sections = document.querySelectorAll('main section[id]');
    const nav = document.querySelector('nav');
    const navHeight = nav ? nav.offsetHeight : 0;
    const scrollToTopBtn = document.getElementById('scrollToTopBtn');

    function handleScroll() {
        const scrollPosition = window.scrollY;

        // 1. Lógica del Scrollspy para resaltar la navegación
        let currentSectionId = '';
        sections.forEach(section => {
            // Se considera una sección como activa si su parte superior ha pasado el punto de referencia (la parte superior de la vista menos la altura de la navegación)
            const sectionTop = section.offsetTop - navHeight - 1; // 1px de buffer
            if (scrollPosition >= sectionTop) {
                currentSectionId = section.getAttribute('id');
            }
        });

        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === `#${currentSectionId}`) {
                link.classList.add('active');
            }
        });

        // 2. Lógica del botón para volver arriba
        if (scrollToTopBtn) {
            if (scrollPosition > 300) {
                scrollToTopBtn.classList.add('is-visible');
            } else {
                scrollToTopBtn.classList.remove('is-visible');
            }
        }
    }

    // Añadir el listener una sola vez para mejorar el rendimiento
    window.addEventListener('scroll', handleScroll);

    // Ejecutar una vez al cargar para establecer el estado inicial
    handleScroll();

    // Lógica del clic para el botón de volver arriba (si existe)
    if (scrollToTopBtn) {
        scrollToTopBtn.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
});
