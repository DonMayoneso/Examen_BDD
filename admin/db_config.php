<?php
$host = 'localhost';
$db   = 'streameduxr_db';
$user = 'root'; 
$pass = ''; 
$charset = 'utf8';

try {
    // En PHP 5.6 usamos un array clásico para las opciones
    $options = array(
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    );
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=$charset", $user, $pass, $options);
} catch (PDOException $e) {
    die("Error de conexión: " . $e->getMessage());
}
?>