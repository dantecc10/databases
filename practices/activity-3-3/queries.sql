-- Actividad 3.3 - LinkServer
-- Base de trabajo guiada por instructions.md
--
-- Nota:
-- 1) Este archivo esta enfocado a comandos SQL/T-SQL.
-- 2) La instalacion de VM/red/servicios se documenta en REPORTE.md con evidencia.
-- 3) Ajusta nombres de servidor, usuarios, rutas y credenciales a tu entorno.
/* =====================================================
 1) SQL Server Host - Habilitar opciones necesarias
 ===================================================== */
-- Ejecutar en SQL Server del host (instancia principal)
EXEC sp_configure 'show advanced options',
1;
RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries',
1;
RECONFIGURE;
/* =====================================================
 2) LinkServer: Host -> SQL Server VM
 ===================================================== */
-- Crear linked server (ajusta @server y @datasrc)
-- EXEC sp_addlinkedserver
--   @server = N'LS_VM_SQLSERVER',
--   @srvproduct = N'SQL Server',
--   @provider = N'MSOLEDBSQL',
--   @datasrc = N'IP_O_HOST_VM\\INSTANCIA';
-- Mapear login local a remoto
-- EXEC sp_addlinkedsrvlogin
--   @rmtsrvname = N'LS_VM_SQLSERVER',
--   @useself = N'False',
--   @locallogin = NULL,
--   @rmtuser = N'USUARIO_VM',
--   @rmtpassword = N'PASSWORD_VM';
-- Probar conectividad
-- EXEC sp_testlinkedserver N'LS_VM_SQLSERVER';
/* =====================================================
 3) LinkServer: Host SQL Server -> MySQL (OLE DB/ODBC)
 ===================================================== */
-- Requiere driver ODBC/OLE DB configurado previamente en el host.
-- Ejemplo de registro de linked server via proveedor OLE DB para ODBC (MSDASQL):
-- EXEC sp_addlinkedserver
--   @server = N'LS_MYSQL',
--   @srvproduct = N'MySQL',
--   @provider = N'MSDASQL',
--   @provstr = N'Driver={MySQL ODBC 8.0 Unicode Driver};Server=127.0.0.1;Port=3306;Database=NOMBRE_DB;User=USUARIO;Password=PASSWORD;Option=3;';
-- EXEC sp_addlinkedsrvlogin
--   @rmtsrvname = N'LS_MYSQL',
--   @useself = N'False',
--   @locallogin = NULL,
--   @rmtuser = N'USUARIO_MYSQL',
--   @rmtpassword = N'PASSWORD_MYSQL';
-- Probar conectividad
-- EXEC sp_testlinkedserver N'LS_MYSQL';
/* =====================================================
 4) Pruebas CRUD por linked server
 ===================================================== */
-- Crear tabla de prueba en servidor VM (cuatro-part naming)
-- CREATE TABLE [LS_VM_SQLSERVER].[master].[dbo].[ls_test] (
--   id INT PRIMARY KEY,
--   descripcion NVARCHAR(100)
-- );
-- Insertar en VM desde host
-- INSERT INTO [LS_VM_SQLSERVER].[master].[dbo].[ls_test] (id, descripcion)
-- VALUES (1, N'Prueba desde host');
-- Leer desde VM
-- SELECT *
-- FROM [LS_VM_SQLSERVER].[master].[dbo].[ls_test];
-- Actualizar y eliminar en VM
-- UPDATE [LS_VM_SQLSERVER].[master].[dbo].[ls_test]
-- SET descripcion = N'Actualizado desde host'
-- WHERE id = 1;
-- DELETE FROM [LS_VM_SQLSERVER].[master].[dbo].[ls_test]
-- WHERE id = 1;
-- Ejemplo lectura en MySQL via OPENQUERY
-- SELECT * FROM OPENQUERY(LS_MYSQL, 'SELECT 1 AS ok');
/* =====================================================
 5) Migracion de base Excel: Host -> VM SQL Server
 ===================================================== */
-- Opcion A: Backup/Restore (fuera de este script)
-- Opcion B: Scriptado + ejecucion remota
-- Opcion C: INSERT SELECT por tablas (ejemplo)
-- INSERT INTO [LS_VM_SQLSERVER].[NOMBRE_DB].[dbo].[tabla_destino] (col1, col2, col3)
-- SELECT col1, col2, col3
-- FROM [NOMBRE_DB_HOST].[dbo].[tabla_origen];
/* =====================================================
 6) Migracion de base Excel: Host SQL Server -> MySQL
 ===================================================== */
-- Ejemplo de migracion por tabla con OPENQUERY
-- INSERT INTO OPENQUERY(LS_MYSQL,
--   'SELECT col1, col2, col3 FROM tabla_destino')
-- SELECT col1, col2, col3
-- FROM [NOMBRE_DB_HOST].[dbo].[tabla_origen];
/* =====================================================
 7) Validacion de volumen de datos
 ===================================================== */
-- Conteos en host (ajusta tablas reales de la practica de Excel)
-- SELECT 'tabla_origen' AS tabla, COUNT(*) AS total FROM [NOMBRE_DB_HOST].[dbo].[tabla_origen];
-- Conteos en VM
-- SELECT *
-- FROM OPENQUERY(LS_VM_SQLSERVER,
--   'SELECT ''tabla_origen'' AS tabla, COUNT(*) AS total FROM NOMBRE_DB.dbo.tabla_origen');
-- Conteos en MySQL
-- SELECT *
-- FROM OPENQUERY(LS_MYSQL,
--   'SELECT ''tabla_origen'' AS tabla, COUNT(*) AS total FROM tabla_origen');
/* =====================================================
 8) Limpieza opcional
 ===================================================== */
-- Eliminar linked servers si es necesario
-- EXEC sp_dropserver @server = N'LS_VM_SQLSERVER', @droplogins = 'droplogins';
-- EXEC sp_dropserver @server = N'LS_MYSQL', @droplogins = 'droplogins';