# Reporte de práctica 3.3 - LinkServer

## Datos Generales

- Materia: Bases de Datos
- Actividad: 3.3
- Alumno: Dante Castelán Carpinteyro
- Fecha: 8 de mayo de 2026

## Objetivo del reporte

Documentar la implementacion de la práctica de LinkServer, mostrando configuraciones, pruebas de conectividad, migración de datos y validación de resultados entre motores.

## Consideraciones y portabilidad

La actividad involucra SQL Server (host y VM) y MySQL. Para mantener trazabilidad y portabilidad, se deben documentar:

- Diferencias de sintaxis entre T-SQL y MySQL.
- Proveedor/driver usado para conectar MySQL mediante LinkServer.
- Equivalencias aplicadas para CRUD y consultas de validación.
- Supuestos de red, autenticación y permisos requeridos.

## Instrucciones de la práctica

Segun [practices/activity-3-3/instructions.md](instructions.md):

> 1. Instalar una máquina virtual con Windows y configurar la comunicación de red con el host.
> 2. Instalar SQL Server en la máquina virtual.
> 3. Configurar acceso remoto al servidor.
> 4. Conectar por LinkServer el SQL Server de la VM al SQL Server host.
> 5. Instalar MySQL en la maquina host.
> 6. Configurar conexión de MySQL al SQL Server host mediante LinkServer.
> 7. Realizar pruebas CRUD de conectividad entre servidores.
> 8. Migrar la base de datos de la practica de Excel desde host hacia VM y MySQL.
> 9. Validar conteos para comprobar igualdad de volumen de datos entre motores.

## Implementacion

El script completo se puede encontrar en: [practices/activity-3-3/queries.sql](queries.sql)

### 1) Preparación de entorno (VM + red + SQL Server)

```sql
-- Bloque principalmente documental (capturas de instalacion/configuracion)
```

Evidencia de ejecución:
![Configuración de VM y red](assets/img/exec1.png)

### 2) Configuración de acceso remoto en SQL Server

```sql
-- Pegar aqui comandos de verificacion/configuracion remota que apliquen
```

Evidencia de ejecución:
![Configuracion de acceso remoto](assets/img/exec2.png)

### 3) LinkServer SQL Server host -> SQL Server VM

```sql
-- Pegar aqui sp_addlinkedserver, sp_addlinkedsrvlogin y pruebas de conectividad
```

Evidencia de ejecución:
![Prueba de LinkServer hacia SQL Server VM](assets/img/exec3.png)

### 4) LinkServer SQL Server host -> MySQL

```sql
-- Pegar aqui configuracion de linked server hacia MySQL y su prueba
```

Evidencia de ejecución:
![Prueba de LinkServer hacia MySQL](assets/img/exec4.png)

### 5) Pruebas CRUD entre motores

```sql
-- Pegar aqui pruebas de crear, insertar, actualizar, consultar y eliminar
```

Evidencia de ejecución:
![Pruebas CRUD por servidores enlazados](assets/img/exec5.png)

### 6) Migración de datos (base de Excel)

```sql
-- Pegar aqui scripts de migracion host -> VM y host -> MySQL
```

Evidencia de ejecución:
![Migracion de datos entre motores](assets/img/exec6.png)

### 7) Validación de volumen de datos

```sql
-- Pegar aqui consultas de conteo en host, VM y MySQL
```

Evidencia de ejecución:
![Validacion de conteos por tabla en cada servidor](assets/img/exec7.png)

## Resultados esperados

- Conexión funcional entre SQL Server host, SQL Server VM y MySQL.
- Evidencia de operaciones CRUD entre servidores enlazados.
- Migración de la base de Excel completada en ambos destinos.
- Validación de conteos consistente entre los tres motores.

## Conclusiones

[Redactar una conclusión personal sobre el aprendizaje de la actividad 3.3.]
