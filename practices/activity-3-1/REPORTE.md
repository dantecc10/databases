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

## Creación de las tablas

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

## Creación de claves foráneas

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

## Creación de la tabla de auditoría

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

## Creación de triggers

Añado triggers para que en la tabla de logs se registre cada acción realizada, aún cuando se lleve a cabo una operación CRUD que afecte a varias filas:

```sql
# Triggers
DELIMITER //
```

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

### Evidencia de ejecucion - Bloque 1

Inserta aqui la captura de pantalla de la ejecucion del Bloque 1.

![Evidencia Bloque 1](assets/evidencia-bloque-1.png)

---

## Bloque 2 - Creacion de tabla jobs

```sql
CREATE TABLE `personal`.`jobs` (
  `id_job` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `description_job` varchar(255) NULL,
  PRIMARY KEY (`id_job`)
);
```

### Evidencia de ejecucion - Bloque 2

Inserta aqui la captura de pantalla de la ejecucion del Bloque 2.

![Evidencia Bloque 2](assets/evidencia-bloque-2.png)

---

## Espacios para Bloques Siguientes

Copia esta estructura para cada bloque adicional del script.

### [Titulo del bloque]

```sql
-- Pega aqui el bloque de codigo correspondiente
```

### Evidencia de ejecucion - Bloque N

Inserta aqui la captura de pantalla de la ejecucion del bloque.

![Evidencia Bloque N](assets/evidencia-bloque-n.png)

---

## Resultados Esperados

- Las tablas principales deben crearse correctamente.
- Los triggers deben registrar INSERT, UPDATE y DELETE en logs.
- Deben existir evidencias de inserciones, actualizaciones y eliminaciones segun la practica.

## Conclusiones

[Escribe aqui tus conclusiones finales de la practica.]
