# Reporte de Practica 3.1 - Disparadores (Triggers)

## Datos Generales
- Materia: Bases de Datos
- Actividad: 3.1 (Actividad 10)
- Alumno: [Tu nombre]
- Fecha: [Completar]

## Objetivo del Reporte
Documentar la implementacion del ejercicio de disparadores, mostrando la ejecucion del script y evidencias de cada bloque.

## Instrucciones de la Practica (Cita)
Segun [practices/activity-3-1/instructions.md](practices/activity-3-1/instructions.md):

> 1. Crear una base de datos que se llame Personal.
>
> 2. Dentro de la base de datos creada, crear 3 tablas con las estructuras solicitadas (Empleados, Puestos y Areas).
>
> 3. Crear una tabla de auditoria para registrar operaciones sobre AREAS, EMPLEADOS y PUESTOS.
>
> 4. Insertar minimo 11 registros por tabla, actualizar al menos 2 por tabla y eliminar el ultimo registro para dejar 10.

## Script Implementado
Archivo base utilizado: [practices/activity-3-1/source_query.sql](practices/activity-3-1/source_query.sql)

## Bloque 1 - Creacion de tabla employees
```sql
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

### Bloque N - [Titulo del bloque]
```sql
-- Pega aqui el bloque de codigo correspondiente
```

### Evidencia de ejecucion - Bloque N
Inserta aqui la captura de pantalla de la ejecucion del bloque.

![Evidencia Bloque N](assets/evidencia-bloque-n.png)

---

## Explicacion del Codigo
[En esta seccion explicare el funcionamiento de cada bloque del script, su objetivo, su resultado esperado y su relacion con las instrucciones de la practica.]

## Resultados Esperados
- Las tablas principales deben crearse correctamente.
- Los triggers deben registrar INSERT, UPDATE y DELETE en logs.
- Deben existir evidencias de inserciones, actualizaciones y eliminaciones segun la practica.

## Conclusiones
[Escribe aqui tus conclusiones finales de la practica.]
