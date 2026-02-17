<?php
include 'db_config.php';

// Capturamos la acción por GET o POST
$action = isset($_REQUEST['action']) ? $_REQUEST['action'] : '';

/**
 * 1. ELIMINACIÓN GENÉRICA (Modo DB)
 * Detecta automáticamente el nombre de la llave primaria de la tabla
 */
if ($action == 'delete') {
    $table = $_GET['table'];
    $id = $_GET['id'];

    try {
        // Consultamos la estructura de la tabla para obtener el nombre de la primera columna (PK)
        $stmt_cols = $pdo->query("DESCRIBE $table");
        $first_col = $stmt_cols->fetch();
        $pk_name = $first_col['Field'];

        $sql = "DELETE FROM $table WHERE $pk_name = ?";
        $pdo->prepare($sql)->execute(array($id));
        
        header("Location: index.php?mode=db&table=$table&status=deleted#data-view");
    } catch (Exception $e) {
        die("Error crítico al eliminar: " . $e->getMessage());
    }
}

/**
 * 2. ELIMINACIÓN DE USUARIO (Modo Maestro)
 * Borra toda la actividad relacionada para evitar errores de llave foránea
 */
if ($action == 'delete_user') {
    $id = $_GET['id'];
    try {
        $pdo->beginTransaction();
        
        // Limpiamos rastro en tablas dependientes
        $pdo->prepare("DELETE FROM resena WHERE id_usuario = ?")->execute(array($id));
        $pdo->prepare("DELETE FROM consumo WHERE id_usuario = ?")->execute(array($id));
        
        // Nota: En compra_detalle primero habría que borrar si no hay cascada en la BDD
        $pdo->prepare("DELETE FROM compra WHERE id_usuario = ?")->execute(array($id));
        
        // Finalmente el usuario
        $pdo->prepare("DELETE FROM usuario WHERE id_usuario = ?")->execute(array($id));
        
        $pdo->commit();
        header("Location: index.php?mode=master&status=user_deleted");
    } catch (Exception $e) {
        $pdo->rollBack();
        die("Error al eliminar usuario: " . $e->getMessage());
    }
}

/**
 * 3. CREACIÓN DE USUARIO (Modo Maestro)
 */
if ($action == 'create_user') {
    try {
        // id_rol = 3 suele ser 'Estudiante' por defecto en este sistema
        $sql = "INSERT INTO usuario (id_institucion, id_rol, nombre_completo, email, password_hash) 
                VALUES (?, 3, ?, ?, ?)";
        $pdo->prepare($sql)->execute(array(
            $_POST['id_institucion'],
            $_POST['nombre_completo'],
            $_POST['email'],
            $_POST['password'] 
        ));
        header("Location: index.php?mode=master&status=user_created");
    } catch (Exception $e) {
        die("Error al registrar usuario: " . $e->getMessage());
    }
}

/**
 * 4. EDICIÓN DE USUARIO (Modo Maestro)
 */
if ($action == 'edit_user') {
    try {
        $sql = "UPDATE usuario SET nombre_completo = ?, email = ? WHERE id_usuario = ?";
        $pdo->prepare($sql)->execute(array(
            $_POST['nombre_completo'],
            $_POST['email'],
            $_POST['id_usuario']
        ));
        header("Location: index.php?mode=master&explore_user=" . $_POST['id_usuario'] . "&status=user_updated");
    } catch (Exception $e) {
        die("Error al actualizar: " . $e->getMessage());
    }
}

/**
 * 5. INSERCIÓN GENÉRICA DINÁMICA (Modo DB)
 * Procesa el array 'data' enviado por el modal de "Añadir Registro"
 */
if ($action == 'insert_generic') {
    $table = $_POST['table'];
    $data = $_POST['data']; // Array asociativo [columna => valor]

    try {
        $cols = array_keys($data);
        $placeholders = array_fill(0, count($cols), '?');

        $sql = "INSERT INTO $table (" . implode(',', $cols) . ") VALUES (" . implode(',', $placeholders) . ")";
        $pdo->prepare($sql)->execute(array_values($data));

        header("Location: index.php?mode=db&table=$table&status=inserted#data-view");
    } catch (Exception $e) {
        die("Error en inserción dinámica: " . $e->getMessage());
    }
}

/**
 * 6. CREACIÓN DE RESEÑA RÁPIDA (Modo Maestro)
 */
if ($action == 'create_review') {
    try {
        $pdo->prepare("INSERT INTO resena (id_usuario, id_contenido, calificacion, comentario, fecha_resena) 
                       VALUES (?, ?, ?, ?, NOW())")
            ->execute(array(
                $_POST['id_usuario'], 
                $_POST['id_contenido'], 
                $_POST['calificacion'], 
                $_POST['comentario']
            ));
        header("Location: index.php?mode=master&explore_user=".$_POST['id_usuario']."&status=review_added");
    } catch (Exception $e) {
        die("Error al publicar reseña: " . $e->getMessage());
    }
}
?>