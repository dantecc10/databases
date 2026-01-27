# Bases de Datos

### Mtro. Roberto Elvira Enríquez
## roberto.elvira@correo.buap.mx
## [Teléfono: 2221561552](https://wa.me/522221561552 "WhatsApp")

## Criterios de evaluación
| Concepto | Comentarios | Porcentaje |
|:---:|---|:---:|
| Evaluación 1 | (Examen y/o Trabajo y/o Programas) | 10% |
| Evaluación 2 | (Examen y/o Trabajo y/o Programas) | 10% |
| Evaluación 3 | (Examen y/o Trabajo y/o Programas) | 10% |
| Actividades de clase | | 5% |
| Proyecto | Es obligatorio para aprobar la materia | 65% |

## Objetivo
### Contenido
#### Unidad 1: Conceptos Básicos de Bases de Datos
- Concepto de Bases de Datos
- Funciones de un SGBD
- Usuarios de un SGBD: DBA, desarrolladores, usuarios finales
- Componentes de un SGBD
- Arquitectura de Niveles de un  SGBD

#### Unidad 2: Modelado de datos
- Modelado de datos y concepto de metadatos
- lógicos basados en objetos
#### Unidad 3: Modelo Entidad-Relación
- Conceptos básicos
- Entidad-relación
- Cardinalidad, correlación de datos
Representaciones gráficas
Aplicaciones
Normalización: 1NF, 2NF, 3NF, BCNF, 4FN
#### UNidad 4: Aplicaciones de bases de datos
- Lenguajes de manipulación de datos
Diseño de la aplicación de bases de datos
Funciones

### Tecnologías
- SQL Server (Motor de base de datos "SMSS")
- MySQL

Se recomienda descargar la versión SQL Enterprise Dev, así como XAMPP para MySQL.

Se recomienda instalar Docker en Linux y usar SQL Server como componente.

- [Descargar para Windows](https://www.microsoft.com/en-us/sql-server/sql-server-downloads "Descarga desde sitio oficial")
- [Descargar para Linux](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-overview?view=sql-server-ver16&culture=en-us&country=us "Descarga desde sitio oficial")

## Proyecto
### Puntos a evaluar
| Requisito | Descripción | Valor |
|---|---|---|
| Diseño | Justificación del Problema, Diagrama E-R, Diccionario de Datos | 5 puntos |
| Normalización |  | 5 puntos |
| Construcción de Tablas con Restricciones y Operaciones | (CRUD) | 10 puntos |
| Construcción de Procedimientos Almacenados | (SP) | 10 puntos |
| Construcción de Funciones | | 10 puntos |
| Construcción de Vistas | | 10 puntos |
| Implementación y Justificación de índices | | 5 puntos |
| Consultas avanzadas | | 10 puntos |

### Características de los Entregables
- Portada
- Índice del contenido
- Introducción (Redacción Propia)
- Contenido
- Conclusión del documento (Redacción Propia)

### Sesiones
#### Sesión lunes 12 de enero

Un sistema gestor de bases de datos (*SGBD*) es el intermediario entre el usuario y la base de datos.

La gran diferencia entre las bases de datos SQL y NoSQL es que las primeras se basan en formatos estandarizados y ordenadas (tablas), mientras que las NoSQL se sirven de nodos (listas ligadas).
##### ¿Qué es una base de datos?
Una **base de datos** es una colección organizada y estructurada de datos que pertenencen a un mismo contexto y que están almacenados electrónicamente en un sistema de computadora. Son el producto de la necesidad humana de almacenar información.

Antes de existir las bases de datos se trabajaba con sistemas de archivos descentralizados.

Para la primera evaluación realizaremos un programa cuya fecha de entrega será el jueves.

Hacer un programa en el lenguaje que nosotros consideremos con línea de comandos.

Hacer un sistema de control de empleados.

Habremos de mostrar un menú con las opciones:

1. Alta
2. Baja
3. Consulta
4. Modificación
5. Salir


Alta debería llevar a ingresar datos como nombre, apellido materno, paterno, fecha de nacimiento y dirección.

Esta actividad se revisará del 9 al 13 de febrero.

### Sesión Lunes 19 de enero de 2026

Se habla de los esquemas de una base de datos, y de algunos elementos presentes en las bases de datos como:

- Bases de datos
- Funciones
- Tablas
- Operaciones

Para trabajar, requerims físicamente una base de datos en la que existirán tablas, conformadas por columnas (campos), y filas (registros).

Por ejemplo:

| ID | Nombre | Matrícula |
|:-:|:-:|:-:|
| 1 | Dante | 202320271 | 
| 2 | Migue | 202345672 |

Por ejemplo, para crear la tabla anterior se usaría el siguiente código:

``` mysql

CREATE DATABASE ESCUELA.DBO.ALUMNOS (
	ID INT,
	NOMBRE CHAR(50),
	MATRICULA BIGINT
);

```
Si quisiéramos agregar un campo, hay dos formas:
- Borrar la tabla y crear nuevamente incluyendo el nuevo campo.
- Alterar la estructura.

``` mysql

ALTER TABLE ESCUELA.DBO.ALUMNOS ADD TELEFONO VARCHAR(10);

```

Y para eliminar un campo:

``` mysql
ALTER TABLE ESCUELA-DBO-ALUMNOS DROP COLUMN TELEFONO;
```

### Sesión lunes 26 de enero

El código que se usó en la sesión anterior es:

```mysql
USE escuela;

CREATE TABLE alumnos (
	MATRICULA BIGINT,
    NOMBRE VARCHAR(100)
);

INSERT INTO alumnos (MATRICULA, NOMBRE) VALUES(202320271, 'Dante Castelán Carpinteyro');

SELECT * FROM alumnos;
```

#### Instrucciones DDLM DML, DCL y TCL

**DDL**

Se encarga de la estructura de:
- Bases de datos
- Tablas
- Campos
- Índices
- Restricciones
- Código

Consta de operaciones básicas como `CREATE`, `DROP`, y `ALTER`.

**DML**

Se encarga del registro de datos:
- Añadir registros
- Modificar registros
- Borrar registros
- Consultarlos

**DCL**

Se encarga -básicamente- de gestionar los permisos de los usuarios.

- *Grant*
- *Revoke*


**TCL**

Es el lenguaje de control de transacciones.

- TRANSACTION
- COMMIT
- ROLLBACK

#### Explicaciones

Todas las bases de datos relacionales se basan en tablas. Las tablas se componen por registros, campos, y la tabla en sí misma.

Por ejemplo, si tenemos la tabla alumnos, con los siguientes campos:

| ID (`INT`) | NOM (`VARCHAR`) | TEL (`INT`) | DIR (`VARCHAR`) |
|:-:|:-:|:-:|:-:|
| -> | Todo esto | es un | registro |
