# Reporte de Practica 3.1 - Disparadores (Triggers)

## Datos Generales

- Materia: Bases de Datos
- Actividad: 3.1 (Actividad 10)
- Alumno: Dante Castelán Carpinteyro
- Fecha: 8 de mayo de 2026

## Objetivo del Reporte

Documentar la implementación del ejercicio de disparadores, mostrando la ejecución del script y evidencias de cada bloque.

## Instrucciones de la práctica

Según [practices/activity-3-1/instructions.md](instructions.md):

> 1. Crear una base de datos que se llame "personal".
> 2. Dentro de la base de datos creada, crear 3 tablas con las estructuras solicitadas (Empleados, Puestos y Areas).
> 3. Crear una tabla de auditoría para registrar operaciones sobre AREAS, EMPLEADOS y PUESTOS.
> 4. Insertar mínimo 11 registros por tabla, actualizar al menos 2 por tabla y eliminar el ultimo registro para dejar 10.

## Implementación

El script completo se puede encontrar en: [practices/activity-3-1/source_query.sql](source_query.sql)

### Creación de las tablas

```sql
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
```

```sql
# Tabla de puestos
CREATE TABLE `personal`.`jobs` (
  `id_job` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `description_job` varchar(255) NULL,
  PRIMARY KEY (`id_job`)
);
```

```sql
# Tabla de áreas
CREATE TABLE `personal`.`areas` (
  `id_area` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description_area` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_area`)
);
```

La ejecución es correcta:
![Ejecución en Navicat de la creación de tablas](assets/img/exec1.png)

### Creación de claves foráneas

Añado las llaves foráneas a las tablas para mantener la integridad referencial:

```sql
# Añadir claves foráneas
# Claves foráneas para el trabajo de los empleados.
ALTER TABLE `personal`.`employees`
ADD CONSTRAINT `fk_employee_job` FOREIGN KEY (`id_job`) REFERENCES `personal`.`jobs` (`id_job`) ON DELETE CASCADE ON UPDATE CASCADE;
# Claves foráneas para el área de los empleados.
ALTER TABLE `personal`.`employees`
ADD CONSTRAINT `fk_employee_area` FOREIGN KEY (`id_area`) REFERENCES `personal`.`areas` (`id_area`) ON DELETE CASCADE ON UPDATE CASCADE;
```

La ejecución es correcta:
![Ejecución en Navicat de la creación de llaves foráneas](assets/img/exec2.png)

### Creación de la tabla de auditoría

```sql
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
```

La ejecución es correcta:
![Ejecución en Navicat de la creación de la talba de logs](assets/img/exec3.png)

### Creación de triggers

Añado triggers para que en la tabla de logs se registre cada acción realizada, aún cuando se lleve a cabo una operación CRUD que afecte a varias filas:

```sql
# Triggers
DELIMITER //
```

Establezco el delimitador:
![Ejecución en Navicat del delimitador](assets/img/exec4.png)

```sql
# Registros para la tabla de empleados
-- Registro de inserciones
CREATE TRIGGER `employees_insert_trg`
AFTER INSERT ON `personal`.`employees`
FOR EACH ROW
BEGIN
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
      QUOTE(NEW.name_employee), ', ',
      QUOTE(NEW.last_name_1_employee), ', ',
      QUOTE(NEW.last_name_2_employee), ', ',
      NEW.id_job, ', ',
      NEW.id_area,
      ');'
    ),
    'employees'
  );
END //
 
-- Registro de actualizaciones
CREATE TRIGGER `employees_update_trg`
AFTER UPDATE ON `personal`.`employees`
FOR EACH ROW
BEGIN
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
      'UPDATE `personal`.`employees` SET `name_employee` = ', QUOTE(NEW.name_employee),
      ', `last_name_1_employee` = ', QUOTE(NEW.last_name_1_employee),
      ', `last_name_2_employee` = ', QUOTE(NEW.last_name_2_employee),
      ', `id_job` = ', NEW.id_job,
      ', `id_area` = ', NEW.id_area,
      ' WHERE `id_employee` = ', OLD.id_employee,
      ';'
    ),
    'employees'
  );
END //
 
-- Registro de eliminaciones
CREATE TRIGGER `employees_delete_trg`
AFTER DELETE ON `personal`.`employees`
FOR EACH ROW
BEGIN
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
END //
```

Los triggers para los empleados se crean correctamente:
![Ejecución en Navicat de los triggers para empleados](assets/img/exec5.png)

```sql
# Registros para la tabla de puestos
-- Registro de inserciones
CREATE TRIGGER `jobs_insert_trg`
AFTER INSERT ON `personal`.`jobs`
FOR EACH ROW
BEGIN
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
END //

-- Registro de actualizaciones
CREATE TRIGGER `jobs_update_trg`
AFTER UPDATE ON `personal`.`jobs`
FOR EACH ROW
BEGIN
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
END //

-- Registro de eliminaciones
CREATE TRIGGER `jobs_delete_trg`
AFTER DELETE ON `personal`.`jobs`
FOR EACH ROW
BEGIN
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
END //
```

Los triggers para los puestos se crean correctamente:
![Ejecución en Navicat de los triggers para puestos](assets/img/exec6.png)

```sql
# Registros para la tabla de áreas
-- Registro de inserciones
CREATE TRIGGER `areas_insert_trg`
AFTER INSERT ON `personal`.`areas`
FOR EACH ROW
BEGIN
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
END //

-- Registro de actualizaciones
CREATE TRIGGER `areas_update_trg`
AFTER UPDATE ON `personal`.`areas`
FOR EACH ROW
BEGIN
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
END //

-- Registro de eliminaciones
CREATE TRIGGER `areas_delete_trg`
AFTER DELETE ON `personal`.`areas`
FOR EACH ROW
BEGIN
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
END //
```

```sql
DELIMITER ;
```

Los triggers para las áreas se crean correctamente:
![Ejecución en Navicat de los triggers para áreas](assets/img/exec7.png)

### Inserción de datos
Inserto datos de ejemplo a las tres tablas: 11 registros a cada una.

```sql
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
```

```sql
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
```

```sql
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
```

Realizo las inserciones y verifico que se hayan reflejado en sus respectivas tablas, así como en la de logs (2 imágenes):
![Ejecución en Navicat de las inserciones](assets/img/exec8.png)
![Ejecución en Navicat de las inserciones en logs](assets/img/exec9.png)

Luego, hago la actualización de dos registros a cada tabla:

```sql
# Puestos
UPDATE `personal`.`jobs`
SET `description_job` = 'Senior Software Engineer'
WHERE `id_job` = 1;
UPDATE `personal`.`jobs`
SET `description_job` = 'Lead Database Administrator'
WHERE `id_job` = 2;
```

```sql
# Áreas
UPDATE `personal`.`areas`
SET `description_area` = 'Information Technology'
WHERE `id_area` = 1;
UPDATE `personal`.`areas`
SET `description_area` = 'Corporate Finance'
WHERE `id_area` = 3;
```

```sql
# Empleados
UPDATE `personal`.`employees`
SET `name_employee` = 'Ana Maria'
WHERE `id_employee` = 1;
UPDATE `personal`.`employees`
SET `last_name_2_employee` = 'Delgado'
WHERE `id_employee` = 2;
```

Ejecución de las actualizaciones:
![Ejecución en Navicat de las actualizaciones](assets/img/exec10.png)

## Resultados Esperados

- Las tablas principales deben crearse correctamente.
- Los triggers deben registrar INSERT, UPDATE y DELETE en logs.
- Deben existir evidencias de inserciones, actualizaciones y eliminaciones segun la practica.

## Conclusiones

[Escribe aqui tus conclusiones finales de la practica.]
