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
CREATE TABLE IF NOT EXISTS users (
    id_user INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_user VARCHAR(100) NOT NULL,
    last_name_1_user VARCHAR(100) NOT NULL,
    last_name_2_user VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_user)
);
-- Verificacion rapida
SHOW TABLES;
DESCRIBE users;
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
-- Permitir lectura, insercion y actualizacion en users
GRANT SELECT,
    INSERT,
    UPDATE ON dc.users TO 'usr_dc_app' @'%';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'usr_dc_app' @'%';
-- =====================================================
-- 5) Pruebas de acceso esperadas para usuario 1
-- =====================================================
-- Estas pruebas debes ejecutarlas iniciando sesion como usr_dc_app.
-- Debe funcionar:
-- USE dc;
-- INSERT INTO users (name_user, last_name_1_user, last_name_2_user)
-- VALUES ('Dante', 'Castelán', 'Carpinteyro');
-- Debe funcionar:
-- SELECT * FROM users;
-- Debe funcionar:
-- UPDATE users
-- SET name_user = 'Dante A.'
-- WHERE id_user = 1;
-- Debe fallar (no tiene DELETE):
-- DELETE FROM users WHERE id_user = 1;
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
CREATE TABLE IF NOT EXISTS addresses (
    id_address INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_user INT UNSIGNED NOT NULL,
    street_address VARCHAR(150) NOT NULL,
    number_address VARCHAR(20) NOT NULL,
    neighborhood_address VARCHAR(120) NOT NULL,
    city_address VARCHAR(120) NOT NULL,
    state_address VARCHAR(120) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    PRIMARY KEY (id_address),
    CONSTRAINT fk_address_user FOREIGN KEY (id_user) REFERENCES users(id_user) ON UPDATE CASCADE ON DELETE RESTRICT
);
-- Datos de ejemplo
INSERT INTO users (name_user, last_name_1_user, last_name_2_user)
VALUES ('Ana', 'Lopez', 'Diaz'),
    ('Luis', 'Perez', 'Mora');
INSERT INTO addresses (
        id_user,
        street_address,
        number_address,
        neighborhood_address,
        city_address,
        state_address,
        postal_code
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
FROM users;
SELECT *
FROM addresses;
-- =====================================================
-- 8) Modificar users y actualizar fecha_nacimiento
-- =====================================================
ALTER TABLE users
ADD COLUMN birthday DATE NULL;
-- Este UPDATE debe ejecutarse con el usuario 1 (usr_dc_app),
-- ya que se pidio actualizar con el primer login creado.
-- Si no tiene permiso UPDATE en esta tabla, ajusta GRANT en bloque 4.
UPDATE users
SET birthday = '2000-01-01'
WHERE id_user = 1;
UPDATE users
SET birthday = '1999-08-20'
WHERE id_user = 2;
SELECT id_user,
    name_user,
    birthday
FROM users;
-- =====================================================
-- 9) Asignar lectura sobre direccion al primer login
-- =====================================================
GRANT SELECT ON dc.addresses TO 'usr_dc_app' @'%';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'usr_dc_app' @'%';
-- Prueba final (con usr_dc_app):
-- USE dc;
-- SELECT * FROM addresses;
-- =====================================================
-- 10) Consultas de evidencia sugeridas
-- =====================================================
SELECT 'users' AS table_name,
    COUNT(*) AS total
FROM dc.users
UNION ALL
SELECT 'addresses' AS table_name,
    COUNT(*) AS total
FROM dc.addresses;
-- Metadatos de usuarios
SELECT user,
    host
FROM mysql.user
WHERE user IN ('usr_dc_app', 'usr_dc_admin');