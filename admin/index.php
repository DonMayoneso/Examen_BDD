<?php 
include 'db_config.php'; 

// Parámetros de navegación (Compatibilidad PHP 5.6)
$mode = isset($_GET['mode']) ? $_GET['mode'] : 'db'; 
$current_table = isset($_GET['table']) ? $_GET['table'] : 'usuario';
$explore_id = isset($_GET['explore_user']) ? $_GET['explore_user'] : null;
$status = isset($_GET['status']) ? $_GET['status'] : '';
$search = isset($_GET['search_user']) ? $_GET['search_user'] : '';

// Lógica de Query SQL para el modo DB
$is_custom_query = false;
if (isset($_POST['query']) && !empty($_POST['query'])) {
    $sql = $_POST['query'];
    $is_custom_query = true;
} else {
    $sql = "SELECT * FROM $current_table LIMIT 100";
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StreamEduXR Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="styles.css">
    <style>
        /* CSS CRÍTICO PARA COMPONENTES DINÁMICOS */
        .modal-overlay { 
            display: none; position: fixed; top: 0; left: 0; 
            width: 100%; height: 100%; background: rgba(0, 20, 30, 0.85); 
            backdrop-filter: blur(8px); z-index: 99999; justify-content: center; align-items: center; 
        }
        .modal-content { 
            background: white; width: 95%; max-width: 500px; padding: 2.5rem; 
            border-radius: 20px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5); color: var(--color-navy);
        }

        /* LOADING SPINNER */
        #loader-overlay {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(222, 239, 231, 0.9); z-index: 100000;
            flex-direction: column; justify-content: center; align-items: center;
        }
        .spinner {
            width: 50px; height: 50px; border: 5px solid var(--color-grey);
            border-top: 5px solid var(--color-teal); border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

        /* UNIFICACIÓN DE BOTONES ELITE */
        .btn-elite {
            background: var(--color-teal); color: white; border: none; padding: 10px 20px;
            border-radius: 12px; font-size: 0.8rem; font-weight: 700; cursor: pointer;
            transition: 0.3s; display: inline-flex; align-items: center; gap: 8px; text-decoration: none;
        }
        .btn-elite:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(21, 154, 156, 0.4); }
        .btn-danger { background: #e74c3c; }
        .btn-danger:hover { background: #c0392b; box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4); }
        .btn-edit { background: #f39c12; }
        .btn-success { background: #2ecc71; }
        .btn-success:hover { background: #27ae60; box-shadow: 0 5px 15px rgba(46, 204, 113, 0.4); }
    </style>
</head>
<body>

    <div id="loader-overlay">
        <div class="spinner"></div>
        <p style="margin-top: 15px; font-weight: 700; color: var(--color-navy);">Procesando datos...</p>
    </div>

    <div class="modal-overlay" id="addRecordModal">
        <div class="modal-content">
            <h3><i class="fa-solid fa-plus-circle"></i> Nuevo en <?php echo ucfirst($current_table); ?></h3>
            <form action="actions.php" method="POST" onsubmit="showLoader()">
                <input type="hidden" name="action" value="insert_generic">
                <input type="hidden" name="table" value="<?php echo $current_table; ?>">
                <div style="max-height: 400px; overflow-y: auto; padding-right: 10px; margin-top:15px;">
                    <?php 
                    $cols_desc = $pdo->query("DESCRIBE $current_table");
                    while($c = $cols_desc->fetch()): if($c['Extra'] == 'auto_increment') continue; ?>
                        <div class="form-group">
                            <label><?php echo $c['Field']; ?></label>
                            <input type="text" name="data[<?php echo $c['Field']; ?>]" class="form-control" required>
                        </div>
                    <?php endwhile; ?>
                </div>
                <div style="margin-top: 25px; display:flex; gap:10px;">
                    <button type="submit" class="btn-elite" style="flex:1;">Guardar</button>
                    <button type="button" class="btn-elite" style="background:#64748b; flex:1;" onclick="closeModal('addRecordModal')">Cancelar</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal-overlay" id="userModal">
        <div class="modal-content">
            <h3><i class="fa-solid fa-user-plus"></i> Registrar Usuario</h3>
            <form action="actions.php" method="POST" onsubmit="showLoader()">
                <input type="hidden" name="action" value="create_user">
                <div class="form-group"><label>Nombre Completo</label><input type="text" name="nombre_completo" class="form-control" required></div>
                <div class="form-group"><label>Email</label><input type="email" name="email" class="form-control" required></div>
                <div class="form-group"><label>Password</label><input type="password" name="password" class="form-control" required></div>
                <div class="form-group">
                    <label>Institución</label>
                    <select name="id_institucion" class="form-control">
                        <?php $inst = $pdo->query("SELECT id_institucion, nombre FROM institucion");
                        while($i = $inst->fetch()) echo "<option value='".$i['id_institucion']."'>".$i['nombre']."</option>"; ?>
                    </select>
                </div>
                <div style="margin-top: 25px; display:flex; gap:10px;">
                    <button type="submit" class="btn-elite" style="flex:1;">Confirmar</button>
                    <button type="button" class="btn-elite" style="background:#64748b; flex:1;" onclick="closeModal('userModal')">Cerrar</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal-overlay" id="editUserModal">
        <div class="modal-content">
            <h3><i class="fa-solid fa-user-pen"></i> Actualizar Usuario</h3>
            <form action="actions.php" method="POST" onsubmit="showLoader()">
                <input type="hidden" name="action" value="edit_user">
                <input type="hidden" name="id_usuario" id="edit_id">
                <div class="form-group"><label>Nombre Completo</label><input type="text" name="nombre_completo" id="edit_nombre" class="form-control" required></div>
                <div class="form-group"><label>Email</label><input type="email" name="email" id="edit_email" class="form-control" required></div>
                <div style="margin-top: 25px; display:flex; gap:10px;">
                    <button type="submit" class="btn-elite btn-edit" style="flex:1;">Guardar Cambios</button>
                    <button type="button" class="btn-elite" style="background:#64748b; flex:1;" onclick="closeModal('editUserModal')">Cancelar</button>
                </div>
            </form>
        </div>
    </div>

    <aside class="sidebar">
        <div class="sidebar-header"><h2>StreamEduXR</h2></div>
        <nav class="sidebar-nav" id="sidebar-scroll">
            <div class="mode-selector">
                <span class="nav-label">Panel de Control</span>
                <a href="?mode=db" class="mode-btn <?php echo ($mode == 'db') ? 'active' : ''; ?>"><i class="fa-solid fa-terminal"></i> <span>Consola y Tablas</span></a>
                <a href="?mode=master" class="mode-btn <?php echo ($mode == 'master') ? 'active' : ''; ?>"><i class="fa-solid fa-address-book"></i> <span>Maestro Usuarios</span></a>
            </div>

            <?php if($mode == 'db'): ?>
                <details class="nav-group" open><summary>Tablas Maestro <i class="fa-solid fa-chevron-down"></i></summary>
                    <?php $all_tables = $pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
                    foreach($all_tables as $t) if(strpos($t, 'vw_') === false): ?>
                        <a href="?mode=db&table=<?php echo $t; ?>#data-view" class="table-link <?php echo ($current_table == $t) ? 'active' : ''; ?>"><i class="fa-solid fa-table"></i> <?php echo ucfirst($t); ?></a>
                    <?php endif; ?>
                </details>
                <details class="nav-group"><summary>Vistas <i class="fa-solid fa-chevron-down"></i></summary>
                    <?php foreach($all_tables as $t) if(strpos($t, 'vw_') !== false): ?>
                        <a href="?mode=db&table=<?php echo $t; ?>#data-view" class="table-link <?php echo ($current_table == $t) ? 'active' : ''; ?>"><i class="fa-solid fa-chart-pie"></i> <?php echo str_replace('vw_', '', $t); ?></a>
                    <?php endif; ?>
                </details>
            <?php endif; ?>
            <div style="margin-top: 2rem; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 1rem;"><a href="../index.html" class="table-link"><i class="fa-solid fa-power-off"></i> Salir</a></div>
        </nav>
    </aside>

    <main class="main-content" id="main-scroll">
        
        <?php if(!empty($status)): 
            $alerts = array(
                'deleted'      => array('msg' => 'Registro eliminado.', 'type' => 'danger', 'icon' => 'fa-trash'),
                'inserted'     => array('msg' => 'Registro guardado.', 'type' => 'success', 'icon' => 'fa-check-circle'),
                'user_created' => array('msg' => 'Usuario registrado.', 'type' => 'success', 'icon' => 'fa-user-plus'),
                'user_updated' => array('msg' => 'Perfil actualizado.', 'type' => 'success', 'icon' => 'fa-user-check'),
                'user_deleted' => array('msg' => 'Usuario borrado.', 'type' => 'danger', 'icon' => 'fa-user-xmark')
            );
            if(isset($alerts[$status])): $a = $alerts[$status]; ?>
                <div class="alert-toast alert-<?php echo $a['type']; ?>" id="notification">
                    <i class="fa-solid <?php echo $a['icon']; ?>"></i> <?php echo $a['msg']; ?>
                </div>
            <?php endif; ?>
        <?php endif; ?>

        <?php if($mode == 'master'): ?>
            <div class="card">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
                    <h3 class="card-title" style="margin:0;"><i class="fa-solid fa-user-gear"></i> Gestión Humana 360°</h3>
                    <div style="display:flex; gap:10px;">
                        <button class="btn-elite" onclick="openModal('userModal')"><i class="fa-solid fa-user-plus"></i> Nuevo</button>
                        <a href="export.php?target=usuario" class="btn-elite btn-success"><i class="fa-solid fa-file-excel"></i> Exportar Lista</a>
                    </div>
                </div>
                <div class="master-container">
                    <div class="master-list" id="user-list-scroll">
                        <form method="GET" style="padding:10px; background:#f8fafb; position:sticky; top:0; z-index:5;">
                            <input type="hidden" name="mode" value="master">
                            <input type="text" name="search_user" placeholder="🔍 Buscar nombre..." class="form-control" value="<?php echo htmlspecialchars($search); ?>">
                        </form>
                        <?php 
                        $stmt_u = $pdo->prepare("SELECT id_usuario, nombre_completo, email FROM usuario WHERE nombre_completo LIKE ? ORDER BY nombre_completo ASC");
                        $stmt_u->execute(array("%$search%"));
                        while($u = $stmt_u->fetch()): ?>
                            <a href="?mode=master&explore_user=<?php echo $u['id_usuario']; ?>&search_user=<?php echo urlencode($search); ?>" class="user-card-link <?php echo ($explore_id == $u['id_usuario']) ? 'active' : ''; ?>">
                                <strong><?php echo htmlspecialchars($u['nombre_completo']); ?></strong><span>ID: <?php echo $u['id_usuario']; ?></span>
                                <input type="hidden" id="data_n_<?php echo $u['id_usuario']; ?>" value="<?php echo htmlspecialchars($u['nombre_completo']); ?>">
                                <input type="hidden" id="data_e_<?php echo $u['id_usuario']; ?>" value="<?php echo htmlspecialchars($u['email']); ?>">
                            </a>
                        <?php endwhile; ?>
                    </div>
                    <div class="master-detail" id="user-detail-scroll">
                        <?php if($explore_id): 
                            $udata = $pdo->prepare("SELECT u.*, i.nombre as inst FROM usuario u LEFT JOIN institucion i ON u.id_institucion = i.id_institucion WHERE id_usuario = ?");
                            $udata->execute(array($explore_id)); $u = $udata->fetch(); ?>
                            <div style="display:flex; justify-content:space-between; border-bottom:2px solid var(--color-teal); padding-bottom:1rem; margin-bottom:2rem;">
                                <div><h2><?php echo htmlspecialchars($u['nombre_completo']); ?></h2><p><?php echo $u['email']; ?> | <?php echo $u['inst']; ?></p></div>
                                <div style="display:flex; gap:10px; height:fit-content;">
                                    <button onclick="prepareEdit('<?php echo $u['id_usuario']; ?>')" class="btn-elite btn-edit"><i class="fa-solid fa-pen"></i> Editar</button>
                                    <a href="actions.php?action=delete_user&id=<?php echo $u['id_usuario']; ?>" class="btn-elite btn-danger" onclick="return confirm('¿Borrar usuario?')"><i class="fa-solid fa-trash"></i></a>
                                </div>
                            </div>
                            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px;">
                                <div class="info-panel">
                                    <h4 style="margin-bottom:10px;">Reseñas</h4>
                                    <?php $res = $pdo->prepare("SELECT r.*, c.titulo FROM resena r JOIN contenido c ON r.id_contenido = c.id_contenido WHERE r.id_usuario = ?");
                                    $res->execute(array($explore_id));
                                    while($r = $res->fetch()) echo "<div class='activity-item'><strong>".$r['titulo'].":</strong> ".$r['comentario']."</div>"; ?>
                                </div>
                                <div class="info-panel">
                                    <h4 style="margin-bottom:10px;">Compras</h4>
                                    <?php $com = $pdo->prepare("SELECT * FROM compra WHERE id_usuario = ?");
                                    $com->execute(array($explore_id));
                                    while($c = $com->fetch()) echo "<div class='activity-item'>Orden #".$c['id_compra']." | $".$c['monto_total']."</div>"; ?>
                                </div>
                            </div>
                        <?php else: ?><div style="text-align:center; color:grey; margin-top:5rem;"><i class="fa-solid fa-id-card" style="font-size:4rem; opacity:0.2;"></i><p>Selecciona un usuario.</p></div><?php endif; ?>
                    </div>
                </div>
            </div>

        <?php else: ?>
            <div class="card">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
                    <h3 class="card-title" style="margin:0;"><i class="fa-solid fa-bolt"></i> Consultas Inteligentes</h3>
                    <form action="export.php" method="POST">
                        <input type="hidden" name="query_to_export" value="<?php echo htmlspecialchars($sql); ?>">
                        <button type="submit" class="btn-elite btn-success"><i class="fa-solid fa-file-excel"></i> Exportar Resultado</button>
                    </form>
                </div>
                <div class="quick-grid">
                    <button class="q-btn" onclick="setQuery('SELECT i.nombre, MONTHNAME(c.fecha_hora) as mes, cont.titulo, SUM(c.tiempo_reproducido_seg)/60 as minutos FROM consumo c JOIN contenido cont ON c.id_contenido = cont.id_contenido JOIN usuario u ON c.id_usuario = u.id_usuario JOIN institucion i ON u.id_institucion = i.id_institucion GROUP BY i.nombre, mes, cont.titulo ORDER BY minutos DESC LIMIT 10;')">1. Top Contenido</button>
                    <button class="q-btn" onclick="setQuery('SELECT tc.nombre, AVG(c.progreso_pct) as tasa FROM consumo c JOIN contenido cont ON c.id_contenido = cont.id_contenido JOIN tipo_contenido tc ON cont.id_tipo_contenido = tc.id_tipo_contenido GROUP BY tc.nombre;')">2. Finalización</button>
                    <button class="q-btn" onclick="setQuery('SELECT i.nombre, SUM(p.monto)/COUNT(DISTINCT u.id_usuario) as arpu FROM institucion i JOIN usuario u ON i.id_institucion = u.id_institucion LEFT JOIN compra co ON u.id_usuario = co.id_usuario LEFT JOIN pago p ON co.id_compra = p.id_compra GROUP BY i.nombre;')">3. ARPU</button>
                    <button class="q-btn" onclick="setQuery('SELECT (COUNT(*) * 100 / (SELECT COUNT(*) FROM usuario)) as churn FROM suscripcion WHERE fecha_fin < NOW();')">4. Churn Rate</button>
                    <button class="q-btn" onclick="setQuery('SELECT titulo, rating_promedio, rating_count FROM contenido WHERE rating_promedio > 4.5 AND rating_count < 10;')">5. Gemas Ocultas</button>
                    <button class="q-btn" onclick="setQuery('SELECT dispositivo, COUNT(*) as total FROM consumo GROUP BY dispositivo;')">6. Dispositivos</button>
                    <button class="q-btn" onclick="setQuery('SELECT nombre_completo, COUNT(c.id_consumo) as total FROM usuario u JOIN consumo c ON u.id_usuario = c.id_usuario GROUP BY u.id_usuario ORDER BY total DESC LIMIT 5;')">7. Top Usuarios</button>
                    <button class="q-btn" onclick="setQuery('SELECT metodo_pago, SUM(monto) as total FROM pago GROUP BY metodo_pago;')">8. Eficiencia Pago</button>
                    <button class="q-btn" onclick="setQuery('SELECT titulo FROM contenido c LEFT JOIN consumo cn ON c.id_contenido = cn.id_contenido WHERE cn.id_consumo IS NULL;')">9. Inactivos</button>
                    <button class="q-btn" onclick="setQuery('SELECT i.pais, AVG(c.rating_promedio) as satisfaccion FROM institucion i JOIN usuario u ON i.id_institucion = u.id_institucion JOIN resena r ON u.id_usuario = r.id_usuario JOIN contenido c ON r.id_contenido = c.id_contenido GROUP BY i.pais;')">10. País/Rating</button>
                </div>
            </div>

            <details class="card" <?php echo $is_custom_query ? 'open' : ''; ?>>
                <summary class="card-title"><i class="fa-solid fa-terminal"></i> Consola SQL Directa</summary>
                <form method="POST" onsubmit="showLoader()">
                    <textarea name="query" id="sql_console"><?php echo $is_custom_query ? htmlspecialchars($sql) : ''; ?></textarea>
                    <button type="submit" class="btn-elite">Ejecutar Comando</button>
                </form>
            </details>

            <div class="card" id="data-view">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.2rem;">
                    <h3 class="card-title" style="margin:0;">Registros: <?php echo ucfirst($current_table); ?></h3>
                    
                    <div style="display:flex; gap:10px;">
                        <?php if(!$is_custom_query && strpos($current_table, 'vw_') === false): ?>
                            <button class="btn-elite" onclick="openModal('addRecordModal')"><i class="fa-solid fa-plus-circle"></i> Añadir Registro</button>
                        <?php endif; ?>
                        
                        <?php if(!$is_custom_query): ?>
                            <a href="export.php?target=<?php echo $current_table; ?>" class="btn-elite btn-success">
                                <i class="fa-solid fa-file-excel"></i> Exportar Tabla
                            </a>
                        <?php endif; ?>
                    </div>
                </div>

                <div class="table-container">
                    <?php try { $stmt = $pdo->query($sql); if ($stmt && $stmt->columnCount() > 0): ?>
                        <table class="data-table">
                            <thead><tr><?php $cols = array(); 
                                for($i=0; $i<$stmt->columnCount(); $i++) { $m=$stmt->getColumnMeta($i); $cols[]=$m['name']; echo "<th>".$m['name']."</th>"; } 
                                if(!$is_custom_query) echo "<th>Acción</th>"; ?></tr></thead>
                            <tbody><?php while($r = $stmt->fetch()): ?>
                                <tr><?php foreach($cols as $c) echo "<td>".htmlspecialchars($r[$c])."</td>"; 
                                if(!$is_custom_query): 
                                    $pk = reset($r); ?>
                                    <td><a href="actions.php?action=delete&table=<?php echo $current_table; ?>&id=<?php echo $pk; ?>" onclick="return confirm('¿Borrar?'); showLoader();" style="color:red;"><i class="fa-solid fa-trash"></i></a></td><?php endif; ?></tr>
                            <?php endwhile; ?></tbody>
                        </table>
                    <?php endif; } catch(Exception $e) { echo "<p style='color:red; padding:10px;'>Error SQL: ".$e->getMessage()."</p>"; } ?>
                </div>
            </div>
        <?php endif; ?>
    </main>

    <script src="scripts.js"></script>
    <script>
        function showLoader() { document.getElementById('loader-overlay').style.display = 'flex'; }
        function openModal(id) { document.getElementById(id).style.display = 'flex'; }
        function closeModal(id) { document.getElementById(id).style.display = 'none'; }
        
        function prepareEdit(id) {
            document.getElementById('edit_id').value = id;
            document.getElementById('edit_nombre').value = document.getElementById('data_n_'+id).value;
            document.getElementById('edit_email').value = document.getElementById('data_e_'+id).value;
            openModal('editUserModal');
        }

        window.onclick = function(event) {
            if (event.target.className === 'modal-overlay') { event.target.style.display = 'none'; }
        };
    </script>
</body>
</html>