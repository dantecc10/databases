# Ejercicio 3.1 (Actividad 10)
# Tabla de empleados
CREATE TABLE `personal`.`employees` (
  `id_employee` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name_employee` varchar(255) NOT NULL,
  `last_name_1_employee` varchar(255) NOT NULL,
  `last_name_2_employee` varchar(255) NOT NULL,
  `id_job` int UNSIGNED NOT NULL,
  `id_area` int UNSIGNED NOT NULL,
  PRIMARY KEY (`id_employee`)
);
# Tabla de puestos
CREATE TABLE `personal`.`jobs` (
  `id_job` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `description_job` varchar(255) NULL,
  PRIMARY KEY (`id_job`)
);
# Tabla de áreas
CREATE TABLE `personal`.`areas` (
  `id_area` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description_area` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_area`)
);
# Añadir claves foráneas
# Claves foráneas para el trabajo de los empleados.
ALTER TABLE `personal`.`employees`
ADD CONSTRAINT `fk_employee_job` FOREIGN KEY (`id_job`) REFERENCES `personal`.`jobs` (`id_job`) ON DELETE CASCADE ON UPDATE CASCADE;
# Claves foráneas para el área de los empleados.
ALTER TABLE `personal`.`employees`
ADD CONSTRAINT `fk_employee_area` FOREIGN KEY (`id_area`) REFERENCES `personal`.`areas` (`id_area`) ON DELETE CASCADE ON UPDATE CASCADE;
# Tabla de registro de ejecuciones
CREATE TABLE `personal`.`logs` (
  `id_log` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `date_log` datetime NOT NULL,
  `user_log` varchar(255) NOT NULL,
  `host_log` varchar(255) NOT NULL,
  `type_log` varchar(20) NOT NULL,
  `query_log` text NOT NULL,
  `affected_table_row_log` varchar(50) NOT NULL,
  PRIMARY KEY (`id_log`)
);
# Triggers
DELIMITER // # Registros para la tabla de empleados
-- Registro de inserciones
CREATE TRIGGER `employees_insert_trg`
AFTER
INSERT ON `personal`.`employees` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    date_log,
    user_log,
    host_log,
    type_log,
    query_log,
    affected_table_row_log
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'INSERT',
    CONCAT(
      'INSERT INTO `personal`.`employees` (`name_employee`, `last_name_1_employee`, `last_name_2_employee`, `id_job`, `id_area`) VALUES (',
      QUOTE(NEW.name_employee),
      ', ',
      QUOTE(NEW.last_name_1_employee),
      ', ',
      QUOTE(NEW.last_name_2_employee),
      ', ',
      NEW.id_job,
      ', ',
      NEW.id_area,
      ');'
    ),
    'employees'
  );
END // # Registro de actualizaciones
CREATE TRIGGER `employees_update_trg`
AFTER
UPDATE ON `personal`.`employees` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    date_log,
    user_log,
    host_log,
    type_log,
    query_log,
    affected_table_row_log
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'UPDATE',
    CONCAT(
      'UPDATE `personal`.`employees` SET `name_employee` = ',
      QUOTE(NEW.name_employee),
      ', `last_name_1_employee` = ',
      QUOTE(NEW.last_name_1_employee),
      ', `last_name_2_employee` = ',
      QUOTE(NEW.last_name_2_employee),
      ', `id_job` = ',
      NEW.id_job,
      ', `id_area` = ',
      NEW.id_area,
      ' WHERE `id_employee` = ',
      OLD.id_employee,
      ';'
    ),
    'employees'
  );
END // # Registro de eliminaciones
CREATE TRIGGER `employees_delete_trg`
AFTER DELETE ON `personal`.`employees` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    date_log,
    user_log,
    host_log,
    type_log,
    query_log,
    affected_table_row_log
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'DELETE',
    CONCAT(
      'DELETE FROM `personal`.`employees` WHERE `id_employee` = ',
      OLD.id_employee,
      ';'
    ),
    'employees'
  );
END // # Registros para la tabla de puestos
-- Registro de inserciones
CREATE TRIGGER `jobs_insert_trg`
AFTER
INSERT ON `personal`.`jobs` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    date_log,
    user_log,
    host_log,
    type_log,
    query_log,
    affected_table_row_log
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'INSERT',
    CONCAT(
      'INSERT INTO `personal`.`jobs` (`description_job`) VALUES (',
      QUOTE(NEW.description_job),
      ');'
    ),
    'jobs'
  );
END // -- Registro de actualizaciones
CREATE TRIGGER `jobs_update_trg`
AFTER
UPDATE ON `personal`.`jobs` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    date_log,
    user_log,
    host_log,
    type_log,
    query_log,
    affected_table_row_log
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'UPDATE',
    CONCAT(
      'UPDATE `personal`.`jobs` SET `description_job` = ',
      QUOTE(NEW.description_job),
      ' WHERE `id_job` = ',
      OLD.id_job,
      ';'
    ),
    'jobs'
  );
END // -- Registro de eliminaciones
CREATE TRIGGER `jobs_delete_trg`
AFTER DELETE ON `personal`.`jobs` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    date_log,
    user_log,
    host_log,
    type_log,
    query_log,
    affected_table_row_log
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'DELETE',
    CONCAT(
      'DELETE FROM `personal`.`jobs` WHERE `id_job` = ',
      OLD.id_job,
      ';'
    ),
    'jobs'
  );
END // # Registros para la tabla de áreas
-- Registro de inserciones
CREATE TRIGGER `areas_insert_trg`
AFTER
INSERT ON `personal`.`areas` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    date_log,
    user_log,
    host_log,
    type_log,
    query_log,
    affected_table_row_log
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'INSERT',
    CONCAT(
      'INSERT INTO `personal`.`areas` (`description_area`) VALUES (',
      QUOTE(NEW.description_area),
      ');'
    ),
    'areas'
  );
END // -- Registro de actualizaciones
CREATE TRIGGER `areas_update_trg`
AFTER
UPDATE ON `personal`.`areas` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    date_log,
    user_log,
    host_log,
    type_log,
    query_log,
    affected_table_row_log
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'UPDATE',
    CONCAT(
      'UPDATE `personal`.`areas` SET `description_area` = ',
      QUOTE(NEW.description_area),
      ' WHERE `id_area` = ',
      OLD.id_area,
      ';'
    ),
    'areas'
  );
END // -- Registro de eliminaciones
CREATE TRIGGER `areas_delete_trg`
AFTER DELETE ON `personal`.`areas` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    date_log,
    user_log,
    host_log,
    type_log,
    query_log,
    affected_table_row_log
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'DELETE',
    CONCAT(
      'DELETE FROM `personal`.`areas` WHERE `id_area` = ',
      OLD.id_area,
      ';'
    ),
    'areas'
  );
END // DELIMITER;
# Datos de ejemplo
# Inserciones en tabla de puestos
INSERT INTO `personal`.`jobs` (`description_job`)
VALUES ('Software Engineer'),
  ('Database Administrator'),
  ('Systems Analyst'),
  ('QA Engineer'),
  ('Project Manager'),
  ('UX Designer'),
  ('DevOps Engineer'),
  ('Backend Developer'),
  ('Frontend Developer'),
  ('Support Engineer'),
  ('Data Analyst');
# Inserciones en tabla de áreas
INSERT INTO `personal`.`areas` (`description_area`)
VALUES ('Technology'),
  ('Human Resources'),
  ('Finance'),
  ('Operations'),
  ('Marketing'),
  ('Sales'),
  ('Customer Service'),
  ('Logistics'),
  ('Security'),
  ('Legal'),
  ('Research and Development');
# Inserciones en tabla de empleados
INSERT INTO `personal`.`employees` (
    `name_employee`,
    `last_name_1_employee`,
    `last_name_2_employee`,
    `id_job`,
    `id_area`
  )
VALUES ('Dante', 'Castelán', 'Carpinteyro', 1, 1),
  ('Emiliano', 'Castelán', 'Carpinteyro', 2, 3),
  ('Andrea', 'Castelán', 'Carpinteyro', 3, 4),
  ('Luis', 'Ramirez', 'Torres', 4, 1),
  ('Valeria', 'Flores', 'Mendez', 5, 5),
  ('Diego', 'Castro', 'Nunez', 6, 5),
  ('Elena', 'Vargas', 'Pineda', 7, 4),
  ('Jorge', 'Santos', 'Morales', 8, 1),
  ('Fernanda', 'Ortega', 'Vega', 9, 6),
  ('Ricardo', 'Navarro', 'Silva', 10, 7),
  ('Paula', 'Ibarra', 'Rios', 11, 11);
# SELECT para ver los datos que se insertaron
SELECT 'jobs' AS table_name,
  COUNT(*) AS total_rows
FROM `personal`.`jobs`
UNION ALL
SELECT 'areas' AS table_name,
  COUNT(*) AS total_rows
FROM `personal`.`areas`
UNION ALL
SELECT 'employees' AS table_name,
  COUNT(*) AS total_rows
FROM `personal`.`employees`;
SELECT *
FROM `personal`.`logs`
ORDER BY `id_log`;
# UPDATE
# Puestos
UPDATE `personal`.`jobs`
SET `description_job` = 'Senior Software Engineer'
WHERE `id_job` = 1;
UPDATE `personal`.`jobs`
SET `description_job` = 'Lead Database Administrator'
WHERE `id_job` = 2;
# Áreas
UPDATE `personal`.`areas`
SET `description_area` = 'Information Technology'
WHERE `id_area` = 1;
UPDATE `personal`.`areas`
SET `description_area` = 'Corporate Finance'
WHERE `id_area` = 3;
# Employees
UPDATE `personal`.`employees`
SET `name_employee` = 'Ana Maria'
WHERE `id_employee` = 1;
UPDATE `personal`.`employees`
SET `last_name_2_employee` = 'Delgado'
WHERE `id_employee` = 2;
# SELECT de verificación después de la actualización
SELECT `id_job`,
  `description_job`
FROM `personal`.`jobs`
WHERE `id_job` IN (1, 2);
SELECT `id_area`,
  `description_area`
FROM `personal`.`areas`
WHERE `id_area` IN (1, 3);
SELECT `id_employee`,
  `name_employee`,
  `last_name_2_employee`
FROM `personal`.`employees`
WHERE `id_employee` IN (1, 2);
SELECT *
FROM `personal`.`logs`
ORDER BY `id_log`;
# DELETE del último registro en cada tabla, respetando las relaciones
# 1) employees, 2) jobs, 3) areas
DELETE FROM `personal`.`employees`
WHERE `id_employee` = (
    SELECT MAX(id_employee)
    FROM (
        SELECT `id_employee`
        FROM `personal`.`employees`
      ) AS e
  );
DELETE FROM `personal`.`jobs`
WHERE `id_job` = (
    SELECT MAX(id_job)
    FROM (
        SELECT `id_job`
        FROM `personal`.`jobs`
      ) AS j
  );
DELETE FROM `personal`.`areas`
WHERE `id_area` = (
    SELECT MAX(id_area)
    FROM (
        SELECT `id_area`
        FROM `personal`.`areas`
      ) AS a
  );
# SELECT de verificación post-delete
SELECT 'jobs' AS table_name,
  COUNT(*) AS total_rows
FROM `personal`.`jobs`
UNION ALL
SELECT 'areas' AS table_name,
  COUNT(*) AS total_rows
FROM `personal`.`areas`
UNION ALL
SELECT 'employees' AS table_name,
  COUNT(*) AS total_rows
FROM `personal`.`employees`;
SELECT *
FROM `personal`.`logs`
ORDER BY `id_log`;
SELECT *
FROM `logs`;
# ---------------------------------------------------------
# Corrección final: ajustar logs y recrear triggers de auditoría
# ---------------------------------------------------------
SET @add_type_log = (
    SELECT IF(
        EXISTS (
          SELECT 1
          FROM information_schema.COLUMNS
          WHERE TABLE_SCHEMA = 'personal'
            AND TABLE_NAME = 'logs'
            AND COLUMN_NAME = 'type_log'
        ),
        'SELECT 1',
        'ALTER TABLE `personal`.`logs` ADD COLUMN `type_log` varchar(20) NOT NULL AFTER `host_log`'
      )
  );
PREPARE stmt_add_type_log
FROM @add_type_log;
EXECUTE stmt_add_type_log;
DEALLOCATE PREPARE stmt_add_type_log;
ALTER TABLE `personal`.`logs`
MODIFY COLUMN `type_log` varchar(20) NOT NULL
AFTER `host_log`,
  MODIFY COLUMN `query_log` text NOT NULL
AFTER `type_log`;
DROP TRIGGER IF EXISTS `employees_insert_trg`;
DROP TRIGGER IF EXISTS `employees_update_trg`;
DROP TRIGGER IF EXISTS `employees_delete_trg`;
DROP TRIGGER IF EXISTS `jobs_insert_trg`;
DROP TRIGGER IF EXISTS `jobs_update_trg`;
DROP TRIGGER IF EXISTS `jobs_delete_trg`;
DROP TRIGGER IF EXISTS `areas_insert_trg`;
DROP TRIGGER IF EXISTS `areas_update_trg`;
DROP TRIGGER IF EXISTS `areas_delete_trg`;
DELIMITER //

CREATE TRIGGER `employees_insert_trg`
AFTER
INSERT ON `personal`.`employees` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    `date_log`,
    `user_log`,
    `host_log`,
    `type_log`,
    `query_log`,
    `affected_table_row_log`
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'INSERT',
    CONCAT(
      'INSERT INTO `personal`.`employees` (`name_employee`, `last_name_1_employee`, `last_name_2_employee`, `id_job`, `id_area`) VALUES (',
      QUOTE(NEW.`name_employee`),
      ', ',
      QUOTE(NEW.`last_name_1_employee`),
      ', ',
      QUOTE(NEW.`last_name_2_employee`),
      ', ',
      NEW.`id_job`,
      ', ',
      NEW.`id_area`,
      ');'
    ),
    'employees'
  );
END // CREATE TRIGGER `employees_update_trg`
AFTER
UPDATE ON `personal`.`employees` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    `date_log`,
    `user_log`,
    `host_log`,
    `type_log`,
    `query_log`,
    `affected_table_row_log`
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'UPDATE',
    CONCAT(
      'UPDATE `personal`.`employees` SET `name_employee` = ',
      QUOTE(NEW.`name_employee`),
      ', `last_name_1_employee` = ',
      QUOTE(NEW.`last_name_1_employee`),
      ', `last_name_2_employee` = ',
      QUOTE(NEW.`last_name_2_employee`),
      ', `id_job` = ',
      NEW.`id_job`,
      ', `id_area` = ',
      NEW.`id_area`,
      ' WHERE `id_employee` = ',
      OLD.`id_employee`,
      ';'
    ),
    'employees'
  );
END //

CREATE TRIGGER `employees_delete_trg`
AFTER DELETE ON `personal`.`employees` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    `date_log`,
    `user_log`,
    `host_log`,
    `type_log`,
    `query_log`,
    `affected_table_row_log`
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'DELETE',
    CONCAT(
      'DELETE FROM `personal`.`employees` WHERE `id_employee` = ',
      OLD.`id_employee`,
      ';'
    ),
    'employees'
  );
END //

CREATE TRIGGER `jobs_insert_trg`
AFTER
INSERT ON `personal`.`jobs` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    `date_log`,
    `user_log`,
    `host_log`,
    `type_log`,
    `query_log`,
    `affected_table_row_log`
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'INSERT',
    CONCAT(
      'INSERT INTO `personal`.`jobs` (`description_job`) VALUES (',
      QUOTE(NEW.`description_job`),
      ');'
    ),
    'jobs'
  );
END //

CREATE TRIGGER `jobs_update_trg`
AFTER
UPDATE ON `personal`.`jobs` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    `date_log`,
    `user_log`,
    `host_log`,
    `type_log`,
    `query_log`,
    `affected_table_row_log`
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'UPDATE',
    CONCAT(
      'UPDATE `personal`.`jobs` SET `description_job` = ',
      QUOTE(NEW.`description_job`),
      ' WHERE `id_job` = ',
      OLD.`id_job`,
      ';'
    ),
    'jobs'
  );
END //

CREATE TRIGGER `jobs_delete_trg`
AFTER DELETE ON `personal`.`jobs` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    `date_log`,
    `user_log`,
    `host_log`,
    `type_log`,
    `query_log`,
    `affected_table_row_log`
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'DELETE',
    CONCAT(
      'DELETE FROM `personal`.`jobs` WHERE `id_job` = ',
      OLD.`id_job`,
      ';'
    ),
    'jobs'
  );
END //

CREATE TRIGGER `areas_insert_trg`
AFTER
INSERT ON `personal`.`areas` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    `date_log`,
    `user_log`,
    `host_log`,
    `type_log`,
    `query_log`,
    `affected_table_row_log`
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'INSERT',
    CONCAT(
      'INSERT INTO `personal`.`areas` (`description_area`) VALUES (',
      QUOTE(NEW.`description_area`),
      ');'
    ),
    'areas'
  );
END //

CREATE TRIGGER `areas_update_trg`
AFTER
UPDATE ON `personal`.`areas` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    `date_log`,
    `user_log`,
    `host_log`,
    `type_log`,
    `query_log`,
    `affected_table_row_log`
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'UPDATE',
    CONCAT(
      'UPDATE `personal`.`areas` SET `description_area` = ',
      QUOTE(NEW.`description_area`),
      ' WHERE `id_area` = ',
      OLD.`id_area`,
      ';'
    ),
    'areas'
  );
END //


CREATE TRIGGER `areas_delete_trg`
AFTER DELETE ON `personal`.`areas` FOR EACH ROW BEGIN
INSERT INTO `personal`.`logs` (
    `date_log`,
    `user_log`,
    `host_log`,
    `type_log`,
    `query_log`,
    `affected_table_row_log`
  )
VALUES (
    NOW(),
    USER(),
    @@hostname,
    'DELETE',
    CONCAT(
      'DELETE FROM `personal`.`areas` WHERE `id_area` = ',
      OLD.`id_area`,
      ';'
    ),
    'areas'
  );
END //
DELIMITER;