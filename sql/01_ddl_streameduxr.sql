CREATE DATABASE IF NOT EXISTS streameduxr_db;
USE streameduxr_db;

CREATE TABLE IF NOT EXISTS institucion (
    id_institucion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    pais VARCHAR(100),
    dominio_web VARCHAR(100) UNIQUE,
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    actualizado_en DATETIME ON UPDATE CURRENT_TIMESTAMP,
    creado_por VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_institucion INT NOT NULL,
    id_rol INT NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    actualizado_en DATETIME ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_inst FOREIGN KEY (id_institucion) REFERENCES institucion(id_institucion) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_user_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tipo_contenido (
    id_tipo_contenido INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS contenido (
    id_contenido INT AUTO_INCREMENT PRIMARY KEY,
    id_tipo_contenido INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    idioma VARCHAR(20) DEFAULT 'Español',
    fecha_publicacion DATE,
    estado ENUM('Borrador', 'Publicado', 'Archivado') DEFAULT 'Borrador',
    rating_promedio DECIMAL(3,2) DEFAULT 0.00,
    rating_count INT DEFAULT 0,
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cont_tipo FOREIGN KEY (id_tipo_contenido) REFERENCES tipo_contenido(id_tipo_contenido) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS archivo_multimedia (
    id_archivo INT AUTO_INCREMENT PRIMARY KEY,
    id_contenido INT NOT NULL,
    formato VARCHAR(10) NOT NULL,
    resolucion VARCHAR(20),
    tamano_bytes BIGINT,
    codec VARCHAR(50),
    url_ubicacion VARCHAR(550) NOT NULL,
    metadatos_json JSON,
    CONSTRAINT fk_file_cont FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS accesibilidad_contenido (
    id_accesibilidad INT AUTO_INCREMENT PRIMARY KEY,
    id_contenido INT NOT NULL,
    tiene_subtitulos BOOLEAN DEFAULT FALSE,
    tiene_audiodescripcion BOOLEAN DEFAULT FALSE,
    lenguaje_senas BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_acc_cont FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS tag (
    id_tag INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tag VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS contenido_tag (
    id_contenido INT NOT NULL,
    id_tag INT NOT NULL,
    PRIMARY KEY (id_contenido, id_tag),
    CONSTRAINT fk_ctag_cont FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido) ON DELETE CASCADE,
    CONSTRAINT fk_ctag_tag FOREIGN KEY (id_tag) REFERENCES tag(id_tag) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS curso (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    id_institucion INT NULL,
    titulo VARCHAR(200) NOT NULL,
    es_institucional BOOLEAN DEFAULT FALSE,
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_curso_inst FOREIGN KEY (id_institucion) REFERENCES institucion(id_institucion) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS curso_contenido (
    id_curso INT NOT NULL,
    id_contenido INT NOT NULL,
    orden_secuencia INT DEFAULT 0,
    PRIMARY KEY (id_curso, id_contenido),
    CONSTRAINT fk_cc_curso FOREIGN KEY (id_curso) REFERENCES curso(id_curso) ON DELETE CASCADE,
    CONSTRAINT fk_cc_cont FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS plan (
    id_plan INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio_mensual DECIMAL(10,2) NOT NULL,
    max_usuarios INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS suscripcion (
    id_suscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_institucion INT NOT NULL,
    id_plan INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado ENUM('Activa', 'Vencida', 'Cancelada') DEFAULT 'Activa',
    CONSTRAINT fk_sus_inst FOREIGN KEY (id_institucion) REFERENCES institucion(id_institucion) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sus_plan FOREIGN KEY (id_plan) REFERENCES plan(id_plan) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS compra (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    monto_total DECIMAL(10,2) NOT NULL,
    estado_pago ENUM('Pendiente', 'Completado', 'Fallido') DEFAULT 'Pendiente',
    CONSTRAINT fk_comp_user FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS compra_detalle (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    id_contenido INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_det_comp FOREIGN KEY (id_compra) REFERENCES compra(id_compra) ON DELETE CASCADE,
    CONSTRAINT fk_det_cont FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    moneda VARCHAR(10) DEFAULT 'USD',
    metodo_pago VARCHAR(50),
    referencia_transaccion VARCHAR(100) UNIQUE,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pago_comp FOREIGN KEY (id_compra) REFERENCES compra(id_compra) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS consumo (
    id_consumo BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_contenido INT NOT NULL,
    dispositivo VARCHAR(100),
    sesion_id VARCHAR(100),
    tiempo_reproducido_seg INT DEFAULT 0,
    progreso_pct DECIMAL(5,2) DEFAULT 0.00,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cons_user FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_cons_cont FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS resena (
    id_resena INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_contenido INT NOT NULL,
    calificacion TINYINT,
    comentario TEXT,
    fecha_resena DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unq_user_cont UNIQUE (id_usuario, id_contenido),
    CONSTRAINT fk_res_user FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_res_cont FOREIGN KEY (id_contenido) REFERENCES contenido(id_contenido) ON DELETE CASCADE,
    CONSTRAINT chk_calificacion CHECK (calificacion BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_usuario_email ON usuario(email);
CREATE INDEX idx_contenido_titulo ON contenido(titulo);
CREATE INDEX idx_consumo_fecha ON consumo(fecha_hora);
CREATE INDEX idx_pago_referencia ON pago(referencia_transaccion);
CREATE INDEX idx_compra_status ON compra(estado_pago);

ALTER TABLE tag ADD FULLTEXT INDEX idx_tag_nombre (nombre_tag);