<?php
include 'db_config.php';

// Nombre del archivo con fecha
$filename = "Export_StreamEdu_" . date('Y-m-d') . ".csv";

// Headers para descarga
header("Content-Type: text/csv; charset=utf-8");
header("Content-Disposition: attachment; filename=$filename");

$output = fopen("php://output", "w");

// Caso 1: Exportar resultado de una consulta personalizada
if (isset($_POST['query_to_export'])) {
    $sql = $_POST['query_to_export'];
} 
// Caso 2: Exportar una tabla completa
else if (isset($_GET['target'])) {
    $sql = "SELECT * FROM " . $_GET['target'];
} else {
    die("Nada que exportar.");
}

try {
    $stmt = $pdo->query($sql);
    // Cabeceras
    $headers = array();
    for ($i = 0; $i < $stmt->columnCount(); $i++) {
        $meta = $stmt->getColumnMeta($i);
        $headers[] = $meta['name'];
    }
    fputcsv($output, $headers);

    // Datos
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        fputcsv($output, $row);
    }
} catch (Exception $e) {
    die("Error al exportar.");
}

fclose($output);
exit;
?>  