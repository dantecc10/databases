-- Actividad 3.2 - Usuarios y Permisos (esbozo)
-- Motor objetivo: MySQL 8+
--
-- Nota de portabilidad:
-- En MySQL, SCHEMA es sinonimo de DATABASE.
-- Para reflejar la practica, se crean:
-- 1) una base de datos con tu nombre
-- 2) una base de datos con tus iniciales (equivalente al esquema solicitado)
-- =====================================================
-- 0) Parametros (editar antes de ejecutar)
-- =====================================================
-- Reemplaza estos valores por los tuyos:
--   NOMBRE_DB: base con tu nombre
--   INICIALES_DB: esquema (en MySQL se implementa como otra base)
--   LOGIN1 / LOGIN2: usuarios MySQL
--   PASSWORD1 / PASSWORD2: contrasenas
-- Ejemplo de nombres usados en este esbozo:
--   NOMBRE_DB   = dante_db
--   INICIALES_DB = dc
--   LOGIN1      = usr_dc_app
--   LOGIN2      = usr_dc_admin
-- =====================================================
-- 1) Crear base de datos y "esquema" (db de iniciales)
-- =====================================================
CREATE DATABASE IF NOT EXISTS dante_db;
CREATE DATABASE IF NOT EXISTS dc;
-- Usar la base equivalente al esquema para objetos de la practica
USE dc;
-- =====================================================
-- 2) Crear tabla Datos_Personales
-- =====================================================
CREATE TABLE IF NOT EXISTS datos_personales (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido_p VARCHAR(100) NOT NULL,
    apellido_m VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);
-- Verificacion rapida
SHOW TABLES;
DESCRIBE datos_personales;
-- =====================================================
-- 3) Crear login/usuario inicial y probar permisos
-- =====================================================
-- Crea el usuario de aplicacion (equivale a login + user en SQL Server)
CREATE USER IF NOT EXISTS 'usr_dc_app' @'%' IDENTIFIED BY 'Cambiar_123!';
-- Sin permisos al inicio (solo USAGE).
SHOW GRANTS FOR 'usr_dc_app' @'%';
-- =====================================================
-- 4) Asignar permisos para agregar y actualizar
-- =====================================================
-- Permitir lectura, insercion y actualizacion en datos_personales
GRANT SELECT,
    INSERT,
    UPDATE ON dc.datos_personales TO 'usr_dc_app' @'%';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'usr_dc_app' @'%';
-- =====================================================
-- 5) Pruebas de acceso esperadas para usuario 1
-- =====================================================
-- Estas pruebas debes ejecutarlas iniciando sesion como usr_dc_app.
-- Debe funcionar:
-- USE dc;
-- INSERT INTO datos_personales (nombre, apellido_p, apellido_m)
-- VALUES ('Dante', 'Castelan', 'Carpinteyro');
-- Debe funcionar:
-- SELECT * FROM datos_personales;
-- Debe funcionar:
-- UPDATE datos_personales
-- SET nombre = 'Dante A.'
-- WHERE id = 1;
-- Debe fallar (no tiene DELETE):
-- DELETE FROM datos_personales WHERE id = 1;
-- =====================================================
-- 6) Crear segundo login/usuario y permisos DDL
-- =====================================================
CREATE USER IF NOT EXISTS 'usr_dc_admin' @'%' IDENTIFIED BY 'Cambiar_456!';
-- Permisos para crear, modificar y borrar tablas en el "esquema" (db)
GRANT CREATE,
    ALTER,
    DROP ON dc.* TO 'usr_dc_admin' @'%';
-- Agregamos permisos DML para poder poblar/consultar la tabla Direccion
GRANT SELECT,
    INSERT,
    UPDATE,
    DELETE ON dc.* TO 'usr_dc_admin' @'%';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'usr_dc_admin' @'%';
-- =====================================================
-- 7) Crear tabla direccion y registrar datos relacionados
-- =====================================================
-- Ejecutar con usuario admin (o con un usuario con permisos equivalentes)
USE dc;
CREATE TABLE IF NOT EXISTS direccion (
    id_direccion INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_persona INT UNSIGNED NOT NULL,
    calle VARCHAR(150) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    colonia VARCHAR(120) NOT NULL,
    ciudad VARCHAR(120) NOT NULL,
    estado VARCHAR(120) NOT NULL,
    cp VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_direccion),
    CONSTRAINT fk_direccion_persona FOREIGN KEY (id_persona) REFERENCES datos_personales(id) ON UPDATE CASCADE ON DELETE RESTRICT
);
-- Datos de ejemplo
INSERT INTO datos_personales (nombre, apellido_p, apellido_m)
VALUES ('Ana', 'Lopez', 'Diaz'),
    ('Luis', 'Perez', 'Mora');
INSERT INTO direccion (
        id_persona,
        calle,
        numero,
        colonia,
        ciudad,
        estado,
        cp
    )
VALUES (
        1,
        'Av Reforma',
        '100',
        'Centro',
        'CDMX',
        'CDMX',
        '06000'
    ),
    (
        2,
        'Calle Norte',
        '245',
        'Industrial',
        'Puebla',
        'Puebla',
        '72000'
    );
SELECT *
FROM datos_personales;
SELECT *
FROM direccion;
-- =====================================================
-- 8) Modificar Datos_Personales y actualizar fecha_nacimiento
-- =====================================================
ALTER TABLE datos_personales
ADD COLUMN fecha_nacimiento DATE NULL;
-- Este UPDATE debe ejecutarse con el usuario 1 (usr_dc_app),
-- ya que se pidio actualizar con el primer login creado.
-- Si no tiene permiso UPDATE en esta tabla, ajusta GRANT en bloque 4.
UPDATE datos_personales
SET fecha_nacimiento = '2000-01-01'
WHERE id = 1;
UPDATE datos_personales
SET fecha_nacimiento = '1999-08-20'
WHERE id = 2;
SELECT id,
    nombre,
    fecha_nacimiento
FROM datos_personales;
-- =====================================================
-- 9) Asignar lectura sobre direccion al primer login
-- =====================================================
GRANT SELECT ON dc.direccion TO 'usr_dc_app' @'%';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'usr_dc_app' @'%';
-- Prueba final (con usr_dc_app):
-- USE dc;
-- SELECT * FROM direccion;
-- =====================================================
-- 10) Consultas de evidencia sugeridas
-- =====================================================
SELECT 'datos_personales' AS tabla,
    COUNT(*) AS total
FROM dc.datos_personales
UNION ALL
SELECT 'direccion' AS tabla,
    COUNT(*) AS total
FROM dc.direccion;
-- Metadatos de usuarios
SELECT user,
    host
FROM mysql.user
WHERE user IN ('usr_dc_app', 'usr_dc_admin');