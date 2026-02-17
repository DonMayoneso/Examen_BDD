document.addEventListener('DOMContentLoaded', () => {
    const viewer = document.getElementById('image-viewer');
    const fullImg = document.getElementById('full-image');
    const closeBtn = document.querySelector('.close-viewer');
    
    // Variables de estado
    let scale = 1;
    let isDragging = false;
    let pos = { x: 0, y: 0 };
    let start = { x: 0, y: 0 };

    document.querySelectorAll('.diagram-container img').forEach(img => {
        img.style.cursor = 'zoom-in';
        img.addEventListener('click', () => {
            viewer.style.display = 'flex';
            fullImg.src = img.src;
            resetState();
        });
    });

    document.getElementById('zoom-in').onclick = (e) => { 
        e.stopPropagation(); 
        scale += 0.3; 
        updateTransform(); 
    };

    document.getElementById('zoom-out').onclick = (e) => { 
        e.stopPropagation(); 
        if (scale > 0.5) scale -= 0.3; 
        updateTransform(); 
    };

    document.getElementById('reset-zoom').onclick = (e) => { 
        e.stopPropagation(); 
        resetState(); 
    };

    fullImg.addEventListener('mousedown', (e) => {
        if (scale <= 1) return;
        isDragging = true;
        fullImg.style.cursor = 'grabbing';
        start = { x: e.clientX - pos.x, y: e.clientY - pos.y };
        e.preventDefault();
    });

    window.addEventListener('mousemove', (e) => {
        if (!isDragging) return;
        pos.x = e.clientX - start.x;
        pos.y = e.clientY - start.y;
        updateTransform();
    });

    window.addEventListener('mouseup', () => {
        isDragging = false;
        fullImg.style.cursor = scale > 1 ? 'grab' : 'zoom-in';
    });

    function updateTransform() {
        fullImg.style.transform = `translate(${pos.x}px, ${pos.y}px) scale(${scale})`;
    }

    function resetState() {
        scale = 1;
        pos = { x: 0, y: 0 };
        fullImg.style.cursor = 'grab';
        updateTransform();
    }

    const closeViewer = () => {
        viewer.style.display = 'none';
        resetState();
    };

    closeBtn.onclick = closeViewer;

    viewer.onclick = (e) => {
        if (e.target === viewer) closeViewer();
    };

    document.addEventListener('keydown', (e) => {
        if (e.key === "Escape" && viewer.style.display === 'flex') {
            closeViewer();
        }
    });
});