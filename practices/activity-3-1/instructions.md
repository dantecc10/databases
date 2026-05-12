# Actividad 3.1: Disparadores (Triggers)

**Fecha de entrega:** 8 de mayo de 2026, 23:59

**Instrucciones:** Realizar el siguiente ejercicio de Disparadores.

---

## Actividad 10 (Ejercicio)

1. **Crear una base de datos** que se llame `Personal`.
2. **Dentro de la base de datos creada** , crear 3 tablas con las siguientes estructuras:

### Estructura de Tablas

| **Empleados**      | **Puestos**         | **Areas**           |
| ------------------------ | ------------------------- | ------------------------- |
| `Id_Emp`(INT)          | `Id_Puesto`(INT)        | `Id_Area`(INT)          |
| `Nombre`(NVARCHAR)     | `Descripcion`(NVARCHAR) | `Descripcion`(NVARCHAR) |
| `Apellido_1`(NVARCHAR) |                           |                           |
| `Apellido_2`(NVARCHAR) |                           |                           |
| `Id_puesto`(INT)       |                           |                           |
| `Id_Area`(INT)         |                           |                           |

* **Consulta de Metadatos solicitada:**
  `SELECT GETDATE(), USER_NAME(), HOST_NAME(), SYSTEM_USER`

---

## Actividad 10 (Ejercicio) -- Continuación

* **Tabla de Auditoría:** Crear una tabla dentro de la base de datos `PERSONAL` que se llame `LOG_USUARIO`, la cual tendrá los siguientes campos:
  * `FECHA`
  * `USUARIO`
  * `HOST`
  * `INSTRUCCIÓN REALIZADA`
  * `TABLA AFECTADA`
* **Objetivo de los Triggers:** La finalidad de esta tabla es que mediante **Triggers** se controle la operación de las tablas: `AREAS`, `EMPLEADOS` y `PUESTOS`.
* **Tareas de manipulación de datos:**
  * Insertar un mínimo de **11 registros** en cada tabla.
  * Realizar la **actualización** de por lo menos 2 registros de cada tabla en alguno de sus campos.
  * Realizar la **eliminación** del último registro de cada tabla, para dejar solo 10 registros.

> **Nota:** Recuerda que debes **justificar cada uno de los puntos** que evidencies en tu entrega.
>
