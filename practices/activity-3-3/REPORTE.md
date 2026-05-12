# Reporte de practica 3.3 - LinkServer

## Datos Generales

- Materia: Bases de Datos
- Actividad: 3.3
- Alumno: Dante Castelan Carpinteyro
- Fecha: [Completar fecha]

## Objetivo del reporte

Documentar la implementacion de la practica de LinkServer, mostrando configuraciones, pruebas de conectividad, migracion de datos y validacion de resultados entre motores.

## Consideraciones y portabilidad

La actividad involucra SQL Server (host y VM) y MySQL. Para mantener trazabilidad y portabilidad, se deben documentar:

- Diferencias de sintaxis entre T-SQL y MySQL.
- Proveedor/driver usado para conectar MySQL mediante LinkServer.
- Equivalencias aplicadas para CRUD y consultas de validacion.
- Supuestos de red, autenticacion y permisos requeridos.

## Instrucciones de la practica

Segun [practices/activity-3-3/instructions.md](instructions.md):

> 1. Instalar una maquina virtual con Windows y configurar la comunicacion de red con el host.
> 2. Instalar SQL Server en la maquina virtual.
> 3. Configurar acceso remoto al servidor.
> 4. Conectar por LinkServer el SQL Server de la VM al SQL Server host.
> 5. Instalar MySQL en la maquina host.
> 6. Configurar conexion de MySQL al SQL Server host mediante LinkServer.
> 7. Realizar pruebas CRUD de conectividad entre servidores.
> 8. Migrar la base de datos de la practica de Excel desde host hacia VM y MySQL.
> 9. Validar conteos para comprobar igualdad de volumen de datos entre motores.

## Implementacion

El script completo se puede encontrar en: [practices/activity-3-3/queries.sql](queries.sql)

### 1) Preparacion de entorno (VM + red + SQL Server)

```sql
-- Bloque principalmente documental (capturas de instalacion/configuracion)
```

Evidencia de ejecucion:
![Configuracion de VM y red](assets/img/exec1.png)

### 2) Configuracion de acceso remoto en SQL Server

```sql
-- Pegar aqui comandos de verificacion/configuracion remota que apliquen
```

Evidencia de ejecucion:
![Configuracion de acceso remoto](assets/img/exec2.png)

### 3) LinkServer SQL Server host -> SQL Server VM

```sql
-- Pegar aqui sp_addlinkedserver, sp_addlinkedsrvlogin y pruebas de conectividad
```

Evidencia de ejecucion:
![Prueba de LinkServer hacia SQL Server VM](assets/img/exec3.png)

### 4) LinkServer SQL Server host -> MySQL

```sql
-- Pegar aqui configuracion de linked server hacia MySQL y su prueba
```

Evidencia de ejecucion:
![Prueba de LinkServer hacia MySQL](assets/img/exec4.png)

### 5) Pruebas CRUD entre motores

```sql
-- Pegar aqui pruebas de crear, insertar, actualizar, consultar y eliminar
```

Evidencia de ejecucion:
![Pruebas CRUD por servidores enlazados](assets/img/exec5.png)

### 6) Migracion de datos (base de Excel)

```sql
-- Pegar aqui scripts de migracion host -> VM y host -> MySQL
```

Evidencia de ejecucion:
![Migracion de datos entre motores](assets/img/exec6.png)

### 7) Validacion de volumen de datos

```sql
-- Pegar aqui consultas de conteo en host, VM y MySQL
```

Evidencia de ejecucion:
![Validacion de conteos por tabla en cada servidor](assets/img/exec7.png)

## Resultados esperados

- Conexion funcional entre SQL Server host, SQL Server VM y MySQL.
- Evidencia de operaciones CRUD entre servidores enlazados.
- Migracion de la base de Excel completada en ambos destinos.
- Validacion de conteos consistente entre los tres motores.

## Conclusiones

[Redactar una conclusion personal sobre el aprendizaje de la actividad 3.3.]
