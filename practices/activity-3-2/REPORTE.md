# Reporte de práctica 3.2 - Usuarios y Permisos

## Datos Generales

- Materia: Bases de Datos
- Actividad: 3.2
- Alumno: Dante Castelán Carpinteyro
- Fecha: 8 de mayo de 2026

## Objetivo del reporte

Documentar la implementación de la actividad de usuarios y permisos, mostrando la ejecución del script y evidencias de cada bloque.

## Consideraciones y portabilidad

La guía de la actividad puede incluir ejemplos de sintaxis orientados a SQL Server. Como haré la implementación en MySQL, documentaré aquí los cambios de portabilidad aplicados (equivalencias de sintaxis, funciones y comandos de seguridad).

## Instrucciones de la práctica

Según [practices/activity-3-2/instructions.md](instructions.md):

> 1. Crear una base de datos con su nombre.
> 2. Crear un esquema con sus iniciales.
> 3. Crear una tabla Datos_Personales con los campos solicitados.
> 4. Crear inicios de sesión, usuarios y permisos según la guía.
> 5. Evidenciar pruebas de acceso, manipulación y restricciones.

## Implementación

El script completo se puede encontrar en: [practices/activity-3-2/queries.sql](queries.sql)

### Creación de base de datos y esquema

```sql
-- Pegar aquí el bloque SQL de creación de base de datos y esquema
```

Evidencia de ejecución:
![Ejecución en cliente SQL de la creación de base de datos y esquema](assets/img/exec1.png)

### Creación de tabla Datos_Personales

```sql
-- Pegar aquí el bloque SQL de creación de la tabla Datos_Personales
```

Evidencia de ejecución:
![Ejecución en cliente SQL de la creación de Datos_Personales](assets/img/exec2.png)

### Creación de login y usuario inicial

```sql
-- Pegar aquí el bloque SQL para crear login, usuario y esquema predeterminado
```

Evidencia de ejecución:
![Ejecución en cliente SQL de creación de login y usuario](assets/img/exec3.png)

### Verificación de permisos iniciales

```sql
-- Pegar aquí pruebas de INSERT, SELECT, UPDATE y DELETE para validar permisos iniciales
```

Evidencia de ejecución:
![Ejecución en cliente SQL de verificación de permisos iniciales](assets/img/exec4.png)

### Asignación de permisos para agregar y actualizar

```sql
-- Pegar aquí GRANT u operaciones equivalentes para permitir agregar y actualizar
```

Evidencia de ejecución:
![Ejecución en cliente SQL de asignación de permisos](assets/img/exec5.png)

### Creación de segundo login y usuario

```sql
-- Pegar aquí el bloque SQL de creación del segundo login y usuario
```

Evidencia de ejecución:
![Ejecución en cliente SQL del segundo login y usuario](assets/img/exec6.png)

### Permisos para crear, modificar y borrar tablas

```sql
-- Pegar aquí la asignación de permisos DDL (crear, alterar y borrar tablas)
```

Evidencia de ejecución:
![Ejecución en cliente SQL de permisos DDL](assets/img/exec7.png)

### Creación de tabla Direccion y carga de datos relacionados

```sql
-- Pegar aquí la creación de Direccion y las inserciones relacionadas con Datos_Personales
```

Evidencia de ejecución:
![Ejecución en cliente SQL de tabla Direccion e inserciones](assets/img/exec8.png)

### Modificación de Datos_Personales y actualización de fecha de nacimiento

```sql
-- Pegar aquí ALTER TABLE para fecha de nacimiento y UPDATE con el primer login
```

Evidencia de ejecución:
![Ejecución en cliente SQL de alteración y actualización](assets/img/exec9.png)

### Permiso de lectura sobre Direccion para el primer login

```sql
-- Pegar aquí el permiso de lectura sobre Direccion para el primer login y su prueba
```

Evidencia de ejecución:
![Ejecución en cliente SQL de permiso de lectura en Direccion](assets/img/exec10.png)

## Resultados esperados

- La base de datos, esquema y tablas deben crearse correctamente.
- Los usuarios y logins deben autenticarse según su configuración.
- Los permisos deben reflejarse en las pruebas de acceso permitidas y denegadas.
- Deben existir evidencias de cada punto solicitado por la actividad.

## Conclusiones

[Redactar una conclusión personal sobre el manejo de usuarios, seguridad y permisos en bases de datos.]
