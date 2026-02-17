USE streameduxr_db;

-- CATÁLOGOS BASE
INSERT INTO rol (nombre_rol, descripcion) VALUES 
('Admin', 'Control total del sistema'),
('Docente', 'Creador de contenido y tutor'),
('Estudiante', 'Usuario final de aprendizaje');

INSERT INTO tipo_contenido (nombre) VALUES 
('Video 4K'), ('Podcast'), ('Imagen 360'), ('Documento PDF'), ('Experiencia XR');

INSERT INTO tag (nombre_tag) VALUES 
('Medicina'), ('Ingeniería'), ('Historia'), ('Arte'), ('Programación'), 
('Realidad Virtual'), ('Metaverso'), ('Anatomía'), ('Python'), ('Cálculo');

INSERT INTO plan (nombre, precio_mensual, max_usuarios) VALUES 
('Basic Tech', 49.99, 100),
('Standard Edu', 199.99, 500),
('Premium Corp', 499.99, 2000),
('Global Scholar', 999.99, 5000),
('Free Trial', 0.00, 10);

-- INSTITUCIONES (5)
INSERT INTO institucion (nombre, pais, dominio_web, creado_por) VALUES 
('Universidad Central de Innovación', 'Ecuador', 'uci.edu.ec', 'SystemSetup'),
('Instituto Tecnológico XR Sur', 'Argentina', 'itxr.com.ar', 'SystemSetup'),
('Pontificia Académica Global', 'Chile', 'pag.cl', 'SystemSetup'),
('Politécnico de Ciencias Aplicadas', 'Colombia', 'pca.edu.co', 'SystemSetup'),
('Escuela Superior de Artes Digitales', 'Perú', 'esad.edu.pe', 'SystemSetup');

-- USUARIOS (30) - 6 por institución
INSERT INTO usuario (id_institucion, id_rol, nombre_completo, email, password_hash) VALUES 
-- Institución 1: Universidad Central de Innovación (Ecuador) 🇪🇨
(1, 1, 'Carlos Admin One', 'admin1@uci.edu.ec', 'hash_p1'),
(1, 2, 'Dra. Elena Ramos', 'eramos@uci.edu.ec', 'hash_p2'),
(1, 3, 'Juan Pérez', 'jperez@uci.edu.ec', 'hash_p3'),
(1, 3, 'Maria García', 'mgarcia@uci.edu.ec', 'hash_p4'),
(1, 3, 'Luis Torres', 'ltorres@uci.edu.ec', 'hash_p5'),
(1, 3, 'Ana Belén', 'abelen@uci.edu.ec', 'hash_p6'),

-- Institución 2: Instituto Tecnológico XR Sur (Argentina) 🇦🇷
(2, 2, 'Prof. Marcos Soria', 'msoria@itxr.com.ar', 'hash_p7'),
(2, 3, 'Estudiante ITXR 1', 'est1@itxr.com.ar', 'hash_p8'),
(2, 3, 'Estudiante ITXR 2', 'est2@itxr.com.ar', 'hash_p9'),
(2, 3, 'Lechugo Milaneso', 'lmilaneso@itxr.com.ar', 'hash_p10'),
(2, 3, 'Sofia Martin', 'smartin@itxr.com.ar', 'hash_p11'),
(2, 3, 'Diego Sanchez', 'dsanchez@itxr.com.ar', 'hash_p12'),

-- Institución 3: Pontificia Académica Global (Chile) 🇨🇱
(3, 2, 'Dra. Carmen Gloria', 'cgloria@pag.cl', 'hash_p13'),
(3, 3, 'Eustaquio Advismario', 'eadvismario@pag.cl', 'hash_p14'),
(3, 3, 'Javier Iturra', 'jiturra@pag.cl', 'hash_p15'),
(3, 3, 'Paz Figueroa', 'pfigueroa@pag.cl', 'hash_p16'),
(3, 3, 'Gonzalo Vial', 'gvial@pag.cl', 'hash_p17'),
(3, 3, 'Francisca Ruiz', 'fruiz@pag.cl', 'hash_p18'),

-- Institución 4: Politécnico de Ciencias Aplicadas (Colombia) 🇨🇴
(4, 1, 'Roberto Forero', 'rforero@pca.edu.co', 'hash_p19'),
(4, 2, 'Alicia Jaramillo', 'ajaramillo@pca.edu.co', 'hash_p20'),
(4, 3, 'Mayoneso Perez', 'mperez@pca.edu.co', 'hash_p21'),
(4, 3, 'Kevin Miller', 'kmiller@pca.edu.co', 'hash_p22'),
(4, 3, 'Sarah Wilson', 'swilson@pca.edu.co', 'hash_p23'),
(4, 3, 'Michael Brown', 'mbrown@pca.edu.co', 'hash_p24'),

-- Institución 5: Escuela Superior de Artes Digitales (Perú) 🇵🇪
(5, 2, 'Prof. Fernando Szyszlo', 'fszyszlo@esad.edu.pe', 'hash_p25'),
(5, 3, 'Valentina Rios', 'vrios@esad.edu.pe', 'hash_p26'),
(5, 3, 'Sebastian Gomez', 'sgomez@esad.edu.pe', 'hash_p27'),
(5, 3, 'Camila Restrepo', 'crestrepo@esad.edu.pe', 'hash_p28'),
(5, 3, 'Daniela Vargas', 'dvargas@esad.edu.pe', 'hash_p29'),
(5, 3, 'Luz Cusco', 'lcusco@esad.edu.pe', 'hash_p30');

-- 4. CONTENIDOS (40) - Mezcla de categorías y tipos (1=Video, 2=Podcast, 3=360, 4=PDF, 5=XR)
INSERT INTO contenido (id_tipo_contenido, titulo, descripcion, idioma, estado) VALUES 

-- Tecnología y Programación
(5, 'Exploración de Célula 3D', 'Viaje inmersivo al núcleo celular en VR', 'Español', 'Publicado'),
(1, 'Introducción a Algoritmos', 'Fundamentos de lógica y diagramas de flujo', 'Español', 'Publicado'),
(1, 'Masterclass Python Avanzado', 'Decoradores, generadores y metaprogramación', 'Español', 'Publicado'),
(4, 'Guía de Arquitectura Hexagonal', 'Documento técnico sobre patrones de diseño', 'Español', 'Publicado'),
(5, 'Simulador de Redes Cisco XR', 'Configuración de routers en entorno virtual', 'Inglés', 'Publicado'),
(1, 'Seguridad en el Metaverso', 'Cómo proteger activos digitales en entornos XR', 'Español', 'Publicado'),

-- Medicina y Salud
(5, 'Atlas de Anatomía Humana XR', 'Disección virtual del sistema nervioso', 'Español', 'Publicado'),
(3, 'Tour 360: Quirófano de Alta Complejidad', 'Exploración de equipamiento médico avanzado', 'Español', 'Publicado'),
(1, 'Fisiopatología Renal', 'Clase magistral sobre el ciclo de la urea', 'Español', 'Publicado'),
(2, 'Podcast: Bioética en el Siglo XXI', 'Discusión sobre edición genética y leyes', 'Español', 'Publicado'),
(5, 'Cirugía de Corazón Abierto VR', 'Práctica guiada de sutura cardiovascular', 'Inglés', 'Publicado'),
(4, 'Manual de Primeros Auxilios', 'Protocolos internacionales de emergencia', 'Español', 'Publicado'),

-- Historia y Arte
(3, 'Tour 360: Museo del Louvre', 'Recorrido virtual por la galería de pintura italiana', 'Francés', 'Publicado'),
(3, 'Machu Picchu Inmersivo', 'Exploración 360 de la ciudadela inca', 'Español', 'Publicado'),
(2, 'Podcast: El Imperio de los Incas', 'Historia de la expansión del Tahuantinsuyo', 'Español', 'Publicado'),
(1, 'Documental: Renacimiento Digital', 'El impacto de la tecnología en el arte clásico', 'Español', 'Publicado'),
(5, 'Taller de Escultura 3D', 'Modelado virtual con herramientas de precisión', 'Español', 'Publicado'),
(4, 'Compendio de Mitología Griega', 'Análisis de los mitos de la creación', 'Español', 'Publicado'),

-- Ingeniería y Física
(5, 'Laboratorio de Química XR', 'Simulación de reacciones químicas peligrosas', 'Español', 'Publicado'),
(5, 'Mecánica de Fluidos VR', 'Visualización de flujos laminares y turbulentos', 'Español', 'Publicado'),
(1, 'Cálculo Multivariable', 'Derivadas parciales e integrales dobles', 'Español', 'Publicado'),
(4, 'Tablas de Resistencia de Materiales', 'PDF técnico para ingeniería civil', 'Español', 'Publicado'),
(3, 'Vista 360: Represa Hidroeléctrica', 'Inspección de turbinas y sala de control', 'Español', 'Publicado'),
(1, 'Termodinámica Aplicada', 'Leyes de la energía y ciclos de potencia', 'Inglés', 'Publicado'),

-- Negocios y Soft Skills
(2, 'Podcast: Liderazgo en Equipos Remotos', 'Consejos para gestionar talento global', 'Español', 'Publicado'),
(1, 'Estrategias de Marketing Digital', 'SEO, SEM y embudos de conversión', 'Español', 'Publicado'),
(4, 'Plantilla de Plan de Negocios', 'Estructura base para startups tecnológicas', 'Inglés', 'Publicado'),
(1, 'Gestión de Conflictos', 'Técnicas de negociación y mediación', 'Español', 'Publicado'),

-- Sección "Especiales" (Guiños)
(2, 'Podcast: ¿Lechugo es una IA?', 'Debate conspirativo sobre la identidad de Lechugo Milaneso', 'Español', 'Publicado'),
(1, 'Cocina Molecular con Mayoneso', 'Cómo hacer emulsiones digitales perfectas', 'Español', 'Publicado'),
(5, 'Eustaquio Advismario: El Oráculo', 'Experiencia mística con el profesor Eustaquio', 'Español', 'Publicado'),

-- Varios y Miscelánea
(3, 'Auroras Boreales 360', 'Espectáculo visual capturado en Noruega', 'Multilenguaje', 'Publicado'),
(2, 'Podcast: Astronomía para Principiantes', 'Guía para identificar constelaciones', 'Español', 'Publicado'),
(4, 'Diccionario de Términos XR', 'Glosario completo de Realidad Extendida', 'Español', 'Publicado'),
(5, 'Simulador de Vuelo Comercial', 'Cabina interactiva de un Boeing 747', 'Inglés', 'Publicado'),
(1, 'Yoga y Mindfulness VR', 'Sesión guiada en un entorno de bosque digital', 'Español', 'Publicado'),
(1, 'Ciberseguridad Personal', 'Cómo evitar el phishing y proteger datos', 'Español', 'Publicado'),
(2, 'Podcast: La Economía del Conocimiento', 'Hacia dónde va el trabajo en Latam', 'Español', 'Publicado'),
(4, 'Código Ético de StreamEduXR', 'Normas de convivencia en la plataforma', 'Español', 'Publicado'),
(1, 'Finanzas para Estudiantes', 'Ahorro e inversión desde la universidad', 'Español', 'Publicado');

-- 5. CARGA DE ARCHIVOS MULTIMEDIA (80 REGISTROS TOTALES)

-- BLOQUE 1: Recursos principales (40 registros)
INSERT INTO archivo_multimedia (id_contenido, formato, url_ubicacion, metadatos_json)
SELECT 
    id_contenido,
    CASE id_tipo_contenido
        WHEN 1 THEN 'mp4'
        WHEN 2 THEN 'mp3'
        WHEN 3 THEN 'png'
        WHEN 4 THEN 'pdf'
        WHEN 5 THEN 'glb'
    END,
    CASE id_tipo_contenido
        WHEN 1 THEN CONCAT('assets/media/vid/vid', LPAD(MOD(id_contenido - 1, 14), 2, '0'), '.mp4')
        WHEN 2 THEN CONCAT('assets/media/aud/aud', LPAD(MOD(id_contenido - 1, 14), 2, '0'), '.mp3')
        WHEN 3 THEN CONCAT('assets/media/img/img', LPAD(MOD(id_contenido - 1, 14), 2, '0'), '.png')
        WHEN 4 THEN CONCAT('assets/media/doc/doc', LPAD(MOD(id_contenido - 1, 14), 2, '0'), '.pdf')
        WHEN 5 THEN CONCAT('assets/media/ra/ra',   LPAD(MOD(id_contenido - 1, 14), 2, '0'), '.glb')
    END,
    '{"calidad": "High-Res", "archivo": "Principal"}'
FROM contenido;

-- Recursos adicionales (40 registros restantes)
INSERT INTO archivo_multimedia (id_contenido, formato, url_ubicacion, metadatos_json)
SELECT 
    id_contenido,
    IF(id_tipo_contenido = 5, 'json', 'png'),
    IF(id_tipo_contenido = 5, 
       CONCAT('assets/media/dat/dat', LPAD(MOD(id_contenido - 1, 14), 2, '0'), '.json'),
       CONCAT('assets/media/img/img', LPAD(MOD(id_contenido - 1, 14), 2, '0'), '.png')
    ),
    '{"calidad": "High-Res", "archivo": "Extra"}'
FROM contenido;

-- 6. CURSOS (20) 
-- Mundo del Diseño Multimedia y Artes Digitales

INSERT INTO curso (id_institucion, titulo, es_institucional) VALUES 
-- Institución 1: Universidad Central de Innovación (Ecuador)
(1, 'Diseño de Interfaces Centrado en el Usuario (UX)', 1),
(1, 'Producción de Contenido para Video Streaming', 1),
(1, 'Narrativas Transmedia en Entornos Digitales', 1),
(1, 'Arquitectura de Información para Web 3.0', 1),

-- Institución 2: Instituto Tecnológico XR Sur (Argentina)
(2, 'Desarrollo de Entornos de Realidad Aumentada (AR)', 1),
(2, 'Diseño de Personajes para Videojuegos 3D', 1),
(2, 'Programación Creativa para Instalaciones Inmersivas', 1),
(2, 'Game Design: Mecánicas y Level Design', 1),

-- Institución 3: Pontificia Académica Global (Chile)
(3, 'Animación 2D y Motion Graphics Avanzado', 1),
(3, 'Postproducción de Color para Cine Digital', 1),
(3, 'Diseño de Experiencias (UI) para Realidad Virtual', 1),
(3, 'Composición Digital y Chroma Key', 1),

-- Institución 4: Politécnico de Ciencias Aplicadas (Colombia)
(4, 'Composición de Audio Espacial para Medios', 1),
(4, 'Edición de Video de Alta Resolución (8K)', 1),
(4, 'Producción de Podcasts Profesionales', 1),

-- Institución 5: Escuela Superior de Artes Digitales (Perú)
(5, 'Modelado y Texturizado para Realidad Virtual', 1),
(5, 'Efectos Visuales (VFX) en Cine y Publicidad', 1),
(5, 'Ilustración Digital y Concept Art para Multimedia', 1),

-- Cursos Globales (Venta Directa)
(NULL, 'Fundamentos del Diseño Multimedia Moderno', 0),
(NULL, 'Optimización de Activos para WebXR', 0);


-- 7. COMPRAS, DETALLES Y PAGOS (30 Transacciones Variadas)

DELIMITER //
CREATE PROCEDURE tmp_seed_compras()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_user_id INT;
    DECLARE v_cont_id INT;
    DECLARE v_monto DECIMAL(10,2);
    DECLARE v_fecha DATETIME;
    DECLARE v_metodo VARCHAR(50);
    DECLARE v_id_compra INT;

    WHILE i <= 30 DO
        -- 1. Seleccionar usuario y contenido aleatorio
        SET v_user_id = (SELECT id_usuario FROM usuario WHERE id_rol = 3 ORDER BY RAND() LIMIT 1);
        SET v_cont_id = (SELECT id_contenido FROM contenido ORDER BY RAND() LIMIT 1);
        
        -- 2. Generar monto aleatorio
        SET v_monto = ROUND(9.99 + (RAND() * 110), 2);
        
        -- 3. Generar fecha aleatoria entre Enero y Febrero
        SET v_fecha = DATE_ADD('2026-01-01 08:00:00', INTERVAL (RAND() * 1000) HOUR);
        
        -- 4. Variar método de pago
        SET v_metodo = ELT(FLOOR(1 + (RAND() * 5)), 'Tarjeta de Crédito', 'PayPal', 'Stripe', 'Apple Pay', 'Transferencia');

        -- 5. Insertar Cabecera de Compra
        INSERT INTO compra (id_usuario, monto_total, estado_pago, fecha_compra) 
        VALUES (v_user_id, v_monto, 'Completado', v_fecha);
        
        SET v_id_compra = LAST_INSERT_ID();

        -- 6. Insertar Detalle (Obligatorio para integridad)
        INSERT INTO compra_detalle (id_compra, id_contenido, precio_unitario)
        VALUES (v_id_compra, v_cont_id, v_monto);

        -- 7. Insertar Pago vinculado
        INSERT INTO pago (id_compra, monto, metodo_pago, referencia_transaccion, fecha_pago)
        VALUES (v_id_compra, v_monto, v_metodo, CONCAT('STRM-', UUID_SHORT()), v_fecha);

        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL tmp_seed_compras();
DROP PROCEDURE tmp_seed_compras;

-- 8. CONSUMOS (200)
DELIMITER //

CREATE PROCEDURE tmp_seed_consumo()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE v_device VARCHAR(100);
    
    WHILE i < 200 DO
        -- Seleccionar un dispositivo multimedia de forma aleatoria
        SET v_device = ELT(FLOOR(1 + (RAND() * 6)), 
            'Meta Quest 3 (XR)', 
            'MacBook Pro M3 Max', 
            'PC Desktop (RTX 4090)', 
            'iPad Pro (Apple Pencil)', 
            'Wacom Cintiq Pro', 
            'Smartphone (Mobile Review)');

        INSERT INTO consumo (id_usuario, id_contenido, dispositivo, tiempo_reproducido_seg, progreso_pct, fecha_hora)
        VALUES (

            (SELECT id_usuario FROM usuario WHERE id_rol = 3 ORDER BY RAND() LIMIT 1),
            (SELECT id_contenido FROM contenido ORDER BY RAND() LIMIT 1),
            v_device,

            FLOOR(60 + (RAND() * 7140)), 

            ROUND(RAND() * 100, 2),

            -- Distribución en los últimos 45 días

            DATE_SUB('2026-02-13 12:00:00', INTERVAL FLOOR(RAND() * 1080) HOUR)
        );
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL tmp_seed_consumo();
DROP PROCEDURE tmp_seed_consumo;

-- 9. RESEÑAS (60)
INSERT IGNORE INTO resena (id_usuario, id_contenido, calificacion, comentario)
SELECT 
    id_usuario, 
    id_contenido, 
    CASE 
        WHEN nombre_completo LIKE '%Lechugo%' THEN 5
        WHEN nombre_completo LIKE '%Mayoneso%' THEN 4
        WHEN calificacion_random < 0.2 THEN 1
        ELSE FLOOR(2 + RAND() * 4) 
    END as calificacion,
    CASE 
        -- El Lore de los personajes
        WHEN nombre_completo LIKE '%Lechugo%' THEN 
            ELT(FLOOR(1 + (RAND() * 3)), 
                'Le puse lechuga al monitor y ahora el curso huele a milanesa de pollo. 10/10 y mucha clorofila.',
                '¿Este video se puede empanar? Pregunto para un amigo que es una planta de procesamiento.',
                'Si el Metaverso no tiene papas fritas, yo me vuelvo a la huerta. El render está muy crocante.')
        
        WHEN nombre_completo LIKE '%Mayoneso%' THEN 
            ELT(FLOOR(1 + (RAND() * 3)), 
                'El render es tan suave que me dieron ganas de echarle limón y batirlo hasta que emulsione.',
                'Le falta más densidad lipídica al archivo .glb, pero se desliza bien por el procesador.',
                'Instalé este curso en una licuadora y ahora mi Wi-Fi sabe a salsa tártara. ¡Épico!')
        
        WHEN nombre_completo LIKE '%Eustaquio%' THEN 
            ELT(FLOOR(1 + (RAND() * 3)), 
                'La ontología del píxel en este polígono diverge de mi desayuno cuántico. Procedo a levitar.',
                'He visto el fin del renderizado y solo había un pingüino tocando el acordeón. Inaceptable.',
                'El algoritmo de este video me habló en arameo y me pidió prestado un destornillador astral.')
        
        -- Comentarios de usuarios "normales" pero confundidos
        ELSE ELT(FLOOR(1 + (RAND() * 10)), 
            'No sé si estoy aprendiendo diseño o si mi mouse me está intentando hipnotizar.',
            'Intenté exportar este modelo 3D y mi gato empezó a hablar en binario. Ayuda.',
            'El curso es genial, pero mi monitor ahora flota a 10 centímetros del escritorio.',
            '¿Alguien más siente que el audio espacial le está contando secretos de la CIA?',
            'Le doy 5 estrellas porque el profesor se parece a un primo que vende empanadas.',
            'Me quedé dormido viendo el tutorial y desperté sabiendo cómo hablar con las nubes.',
            'La resolución es tan alta que puedo ver mis errores del pasado en el fondo del video.',
            'Este PDF es tan pesado que mi disco duro ahora hace pesas en el gimnasio.',
            'La realidad aumentada me hizo creer que mi silla era un unicornio. Casi me caigo.',
            'Busqué "Diseño Multimedia" y terminé entendiendo por qué los patos graznan en fa sostenido.')
    END as comentario
FROM (
    SELECT c.id_usuario, c.id_contenido, u.nombre_completo, RAND() as calificacion_random
    FROM consumo c
    JOIN usuario u ON c.id_usuario = u.id_usuario
    LIMIT 100 
) AS subquery
LIMIT 60;