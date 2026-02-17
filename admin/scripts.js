/**
 * SISTEMA DE CARGA (LOADING SPINNER)
 * Muestra el overlay con el spinner cuando se procesan datos
 */
function showLoader() {
    const loader = document.getElementById('loader-overlay');
    if (loader) {
        loader.style.display = 'flex';
    }
}

/**
 * GESTIÓN DE MODALES
 */
function openModal(id) {
    const modal = document.getElementById(id);
    if (modal) {
        modal.style.display = 'flex';
        modal.animate([
            { opacity: 0, transform: 'scale(0.95)' },
            { opacity: 1, transform: 'scale(1)' }
        ], { duration: 200, easing: 'ease-out' });
    }
}

function closeModal(id) {
    const modal = document.getElementById(id);
    if (modal) {
        modal.style.display = 'none';
    }
}

/**
 * PREPARACIÓN DE EDICIÓN DE USUARIO
 * Toma los datos de los campos ocultos en el listado y los inyecta en el modal
 */
function prepareEdit(id) {
    const nameInput = document.getElementById('data_n_' + id);
    const emailInput = document.getElementById('data_e_' + id);
    
    if (nameInput && emailInput) {
        document.getElementById('edit_id').value = id;
        document.getElementById('edit_nombre').value = nameInput.value;
        document.getElementById('edit_email').value = emailInput.value;
        
        openModal('editUserModal');
    }
}

/**
 * CONSOLA SQL
 * Inyecta el query en el textarea y expande el contenedor si está colapsado
 */
function setQuery(sql) {
    const consoleArea = document.getElementById('sql_console');
    const detailsTag = document.querySelector('details.card');
    
    if (consoleArea) {
        consoleArea.value = sql;
        if (detailsTag) detailsTag.open = true;
        
        // Desplazamiento al ancla de la consola
        window.location.hash = "sql_console";
    }
}

/**
 * GESTIÓN DE PERSISTENCIA DE SCROLL Y NOTIFICACIONES
 */
const scrollIds = ['sidebar-scroll', 'main-scroll', 'user-list-scroll', 'user-detail-scroll'];

window.addEventListener('load', function() {
    // 1. Restaurar posición de los Scrolls guardados en sessionStorage
    scrollIds.forEach(function(id) {
        const el = document.getElementById(id);
        const savedPos = sessionStorage.getItem('scroll-' + id);
        if (el && savedPos) {
            el.scrollTop = savedPos;
        }
    });

    // 2. Auto-ocultar notificaciones (Alert Toasts) después de 5 segundos
    const notification = document.getElementById('notification');
    if (notification) {
        setTimeout(function() {
            notification.style.transition = "all 0.5s ease";
            notification.style.opacity = "0";
            notification.style.transform = "translateY(-10px)";
            // Eliminar del DOM tras la animación
            setTimeout(() => notification.style.display = "none", 500);
        }, 5000);
    }
});

/**
 * GUARDAR SCROLL ANTES DE SALIR O RECARGAR
 */
window.addEventListener('beforeunload', function() {
    scrollIds.forEach(function(id) {
        const el = document.getElementById(id);
        if (el) {
            sessionStorage.setItem('scroll-' + id, el.scrollTop);
        }
    });
});

/**
 * CIERRE DE MODAL AL HACER CLIC FUERA DEL CONTENIDO
 */
window.onclick = function(event) {
    // Si el clic es en el fondo oscuro (overlay), cerramos el modal
    if (event.target.classList.contains('modal-overlay')) {
        event.target.style.display = 'none';
    }
};