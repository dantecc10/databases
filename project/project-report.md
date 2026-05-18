# Reporte de Proyecto: Sistema de Gestión de Concursos ICPC

## Datos Generales

- Materia: Bases de Datos
- Tipo: Proyecto Final (Diseño de Base de Datos Libre)
- Alumno: Dante Castelán Carpinteyro
- Fecha: 18 de mayo de 2026
- Institución: Benemérita Universidad Autónoma de Puebla

## Objetivo del Reporte

Documentar el diseño e implementación de un sistema de base de datos relacional para la gestión de concursos de programación tipo ICPC (International Collegiate Programming Contest), mostrando la estructura de tablas, relaciones, restricciones de integridad y operaciones CRUD implementadas.

## Descripción del Problema y Justificación

### Contexto y Objetivos del Sistema
Los concursos de programación competitiva bajo el modelo **ICPC (International Collegiate Programming Contest)** requieren un sistema robusto y confiable para gestionar la logística completa de la competencia. El sistema está diseñado para que un organizador o gestor pueda administrar de manera eficiente todos los aspectos de estas competencias.

### Características Clave de la Competencia

#### Estructura Temporal y de Contenido
- **Duración estándar:** Cada concurso dura exactamente **5 horas (300 minutos)**.
- **Catálogo de problemas:** Entre **12 a 14 problemas** alojados en una plataforma de juez automático, cada uno con sus propias especificaciones y límites de tiempo.
- **Múltiples fechas competitivas:** El ICPC no es un evento único, sino un conjunto de competencias consecutivas durante el año:
  - Primera, Segunda y Tercera Fechas (clasificatorios)
  - Repechaje (segunda oportunidad)
  - Final Mexicana
  - Final Latinoamericana
  - Final Mundial

#### Estructura de Equipos y Participantes
- Los participantes compiten en **equipos de 3 personas** sin acceso a internet ni herramientas de IA.
- Cuentan únicamente con apuntes impresos durante la competencia.
- Los equipos representan a **universidades específicas**, lo que hace crítico mantener vínculos institucionales para segmentar resultados y reconocimiento.

#### Importancia Crítica de la Tabla Envio (Submissions)
La tabla `Envio` es **fundamental** por razones funcionales y técnicas:

**1. Procesamiento Secuencial (FIFO - First In, First Out)**
- Cada envío se registra con la hora exacta (`hora_envio`) y el tiempo transcurrido desde el inicio del concurso (`tiempo_concurso`).
- Esto permite procesar y calificar soluciones en el orden exacto en que fueron recibidas, manteniendo la integridad del proceso competitivo.

**2. Congelamiento del Scoreboard (Freeze)**
- A la hora 4 del concurso (minuto **240 de 300**), la tabla de posiciones pública se **pausa o congela**.
- Los equipos continúan enviando soluciones, pero el scoreboard público no se actualiza.
- Los equipos y público desconocen si los envíos posteriores fueron aceptados o rechazados hasta la ceremonia de premiación.
- La tabla de envíos con campos `hora_envio` y `tiempo_concurso` permite:
  - Identificar qué envíos ocurrieron antes del minuto 240 (visibles en scoreboard público).
  - Identificar cuáles ocurrieron después (ocultos hasta la ceremonia).
  - Simular o calcular dinámicamente este comportamiento en reportes post-competencia.
  - Mantener un registro íntegro de todos los intentos para auditoría y análisis.

### Requerimiento Mínimo
El proyecto cumple con el requerimiento mínimo de **8 tablas** relacionales, diseñadas para modelar completamente el dominio del problema.

## Diseño de la Base de Datos

### Modelo Entidad-Relación (Diagrama Conceptual)

El sistema está compuesto por las siguientes entidades y relaciones:

```
Universidad 1 ──→ N Equipo
                     │
                     ├──→ N Concursante
                     │
                     └──→ N Envio

Concurso 1 ──→ N Problema ──→ N Envio
                               │
                               ├─ N Lenguaje
                               │
                               └─ N Veredicto
```

### Entidades y Atributos

| Entidad | Descripción | Atributos Clave |
|---------|-------------|-----------------|
| **Universidad** | Instituciones participantes | id_universidad, nombre, país |
| **Equipo** | Grupos de participantes de una universidad | id_equipo, nombre_equipo, id_universidad |
| **Concursante** | Miembros individuales de un equipo | id_concursante, nombre_completo, correo, id_equipo |
| **Concurso** | Evento de competencia | id_concurso, nombre_evento, fecha_inicio, duracion_minutos |
| **Problema** | Retos a resolver durante el concurso | id_problema, id_concurso, letra, titulo, tiempo_limite |
| **Lenguaje** | Lenguajes de programación permitidos | id_lenguaje, nombre |
| **Veredicto** | Tipos de resultado posibles para un envío | id_veredicto, acronimo, descripcion |
| **Envio** | Registro de cada intento de solución | id_envio, id_equipo, id_problema, id_lenguaje, id_veredicto, hora_envio, tiempo_concurso |

## Implementación

El script completo de creación de la base de datos se encuentra en: [project/base-query.sql](base-query.sql)

### Consideraciones Técnicas

#### 1. **Identidad y Claves Primarias**
Todas las tablas utilizan `IDENTITY(1,1)` para las claves primarias, siguiendo las convenciones de SQL Server, garantizando un identificador único y secuencial para cada registro.

#### 2. **Integridad Referencial**
Las claves foráneas (`FOREIGN KEY`) se declaran explícitamente con restricciones:
- `Equipo.id_universidad` → `Universidad.id_universidad`
- `Concursante.id_equipo` → `Equipo.id_equipo`
- `Problema.id_concurso` → `Concurso.id_concurso`
- `Envio.id_equipo` → `Equipo.id_equipo`
- `Envio.id_problema` → `Problema.id_problema`
- `Envio.id_lenguaje` → `Lenguaje.id_lenguaje`
- `Envio.id_veredicto` → `Veredicto.id_veredicto`

#### 3. **Valores por Defecto**
- La tabla `Concurso` define `duracion_minutos INT NOT NULL DEFAULT 300` para representar las 5 horas estándar del ICPC.
- Esto simplifica la gestión de nuevos concursos, permitiendo que se especifique solo si difiere de lo habitual.

#### 4. **Tipos de Datos**
- **VARCHAR**: Utilizado para campos de texto variable (nombres, descripciones, correos).
- **INT**: Utilizado para identificadores, duraciones y límites de tiempo.
- **CHAR(1)**: Utilizado para la letra del problema (A, B, C, ...).
- **DECIMAL(5,2)**: Utilizado para tiempos límite de problemas (permite precisión de segundos).
- **DATETIME**: Utilizado para timestamp del concurso y hora de envíos.

### Estructura de Tablas

#### Tabla: Universidad
```sql
CREATE TABLE Universidad (
    id_universidad INT IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Universidad PRIMARY KEY (id_universidad)
);
```
**Propósito**: Registra las instituciones educativas participantes.

#### Tabla: Equipo
```sql
CREATE TABLE Equipo (
    id_equipo INT IDENTITY(1,1),
    nombre_equipo VARCHAR(50) NOT NULL,
    id_universidad INT NOT NULL,
    CONSTRAINT PK_Equipo PRIMARY KEY (id_equipo),
    CONSTRAINT FK_Equipo_Universidad FOREIGN KEY (id_universidad) 
        REFERENCES Universidad(id_universidad)
);
```
**Propósito**: Agrupa a concursantes por institución, permite seguimiento de desempeño por equipo.

#### Tabla: Concursante
```sql
CREATE TABLE Concursante (
    id_concursante INT IDENTITY(1,1),
    nombre_completo VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    id_equipo INT NOT NULL,
    CONSTRAINT PK_Concursante PRIMARY KEY (id_concursante),
    CONSTRAINT FK_Concursante_Equipo FOREIGN KEY (id_equipo) 
        REFERENCES Equipo(id_equipo)
);
```
**Propósito**: Registra miembros individuales del equipo con información de contacto.

#### Tabla: Concurso
```sql
CREATE TABLE Concurso (
    id_concurso INT IDENTITY(1,1),
    nombre_evento VARCHAR(100) NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    duracion_minutos INT NOT NULL DEFAULT 300,
    CONSTRAINT PK_Concurso PRIMARY KEY (id_concurso)
);
```
**Propósito**: Define eventos de concursos con metadatos temporales.

#### Tabla: Problema
```sql
CREATE TABLE Problema (
    id_problema INT IDENTITY(1,1),
    id_concurso INT NOT NULL,
    letra CHAR(1) NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    tiempo_limite DECIMAL(5,2) NOT NULL,
    CONSTRAINT PK_Problema PRIMARY KEY (id_problema),
    CONSTRAINT FK_Problema_Concurso FOREIGN KEY (id_concurso) 
        REFERENCES Concurso(id_concurso)
);
```
**Propósito**: Cataloga los problemas específicos de cada concurso con límites de tiempo individuales.

#### Tabla: Lenguaje
```sql
CREATE TABLE Lenguaje (
    id_lenguaje INT IDENTITY(1,1),
    nombre VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Lenguaje PRIMARY KEY (id_lenguaje)
);
```
**Propósito**: Define los lenguajes de programación permitidos (C++, Java, Python, etc.).

#### Tabla: Veredicto
```sql
CREATE TABLE Veredicto (
    id_veredicto INT IDENTITY(1,1),
    acronimo VARCHAR(5) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Veredicto PRIMARY KEY (id_veredicto)
);
```
**Propósito**: Cataloga los posibles veredictos de ejecución (AC, WA, TLE, RTE, etc.).

#### Tabla: Envio
```sql
CREATE TABLE Envio (
    id_envio INT IDENTITY(1,1),
    id_equipo INT NOT NULL,
    id_problema INT NOT NULL,
    id_lenguaje INT NOT NULL,
    id_veredicto INT NOT NULL,
    hora_envio DATETIME NOT NULL,
    tiempo_concurso INT NOT NULL,
    CONSTRAINT PK_Envio PRIMARY KEY (id_envio),
    CONSTRAINT FK_Envio_Equipo FOREIGN KEY (id_equipo) 
        REFERENCES Equipo(id_equipo),
    CONSTRAINT FK_Envio_Problema FOREIGN KEY (id_problema) 
        REFERENCES Problema(id_problema),
    CONSTRAINT FK_Envio_Lenguaje FOREIGN KEY (id_lenguaje) 
        REFERENCES Lenguaje(id_lenguaje),
    CONSTRAINT FK_Envio_Veredicto FOREIGN KEY (id_veredicto) 
        REFERENCES Veredicto(id_veredicto)
);
```
**Propósito**: Registra cada intento de solución enviado, con timestamp y resultado. Esta es la tabla más crítica del sistema.

**Campos importantes**:
- `tiempo_concurso`: Minutos transcurridos desde el inicio del concurso (0-300), crucial para implementar el congelamiento del scoreboard. Permite filtrar dinámicamente qué envíos son visibles (< 240) y cuáles están congelados (≥ 240).
- `hora_envio`: Timestamp exacto del envío en el servidor, proporcionando auditoría completa e información para la ceremonia de premiación.

**Importancia Técnica para el ICPC**:
- El campo `tiempo_concurso < 240` es la clave para implementar el congelamiento del scoreboard público.
- Permite que el sistema distinga entre envíos visibles públicamente durante la competencia y envíos ocultos hasta la ceremonia de premiación.
- Junto con `id_veredicto`, facilita la generación de rankings en tiempo real (durante concurso) y finales (post-concurso con todos los envíos).

## Análisis de Normalización

### Primera Forma Normal (1FN)
Todas las tablas cumplen con 1FN:
- ✅ Cada atributo contiene únicamente valores atómicos (no hay grupos repetitivos).
- ✅ No existen atributos multivaluados.

### Segunda Forma Normal (2FN)
Todas las tablas cumplen con 2FN:
- ✅ Todas las tablas están en 1FN.
- ✅ Todos los atributos no clave dependen completamente de la clave primaria (no hay dependencias parciales).

### Tercera Forma Normal (3FN)
Todas las tablas cumplen con 3FN:
- ✅ Todas las tablas están en 2FN.
- ✅ No existen dependencias transitivas entre atributos no clave.

## Decisiones de Diseño

### 1. Separación de Conceptos
- **Lenguaje** y **Veredicto** se modelan como catálogos independientes, permitiendo agregar nuevos lenguajes o veredictos sin modificar la estructura de `Envio`.

### 2. Temporalidad Dual: Soporte para el Congelamiento del Scoreboard
La tabla `Envio` implementa un sistema de temporalidad dual que es fundamental para el ICPC:

**`hora_envio` (timestamp absoluto)**
- Registra la fecha y hora exacta del envío en el servidor.
- Proporciona auditoría e información para investigaciones de integridad.

**`tiempo_concurso` (tiempo relativo en minutos)**
- Registra los minutos transcurridos desde el inicio del concurso (0 a 300).
- Permite identificar automáticamente qué envíos ocurrieron antes del minuto 240 (visibles en el scoreboard público) y cuáles después (congelados).
- Facilita la implementación de lógica FREEZE mediante una simple cláusula `WHERE tiempo_concurso < 240`.
- Ejemplo de consulta para scoreboard público:
  ```sql
  SELECT * FROM Envio 
  WHERE id_concurso = @concurso_id 
    AND tiempo_concurso < 240  -- Antes del congelamiento
    AND id_veredicto = (SELECT id_veredicto FROM Veredicto WHERE acronimo = 'AC');
  ```

### 3. Escalabilidad
- El modelo soporta múltiples concursos, equipos y universidades sin limitaciones estructurales.
- Las claves foráneas garantizan que un concurso solo puede referenciar sus propios problemas.
- La estructura permite registrar miles de envíos sin degradación de rendimiento.

### 4. Auditoría y Trazabilidad
- Todos los envíos son inmutables (se espera que sean insertados una sola vez), lo que proporciona un registro completo y verificable del concurso.
- La combinación de `id_equipo`, `id_problema`, `id_lenguaje`, `hora_envio` permite identificar unívocamente cada intento.
- La estructura permite reconstruir completamente el estado del concurso en cualquier punto del tiempo.

### 5. Vínculos Institucionales
- La tabla `Universidad` es crítica para segmentar resultados por institución.
- La relación `Equipo.id_universidad → Universidad.id_universidad` permite generar reportes institucionales y rankings por universidad.
- Facilita la identificación de ganadores a nivel de institución, no solo individual.

## Próximos Pasos (Fuera del Alcance Actual)

Para completar el proyecto según la rúbrica:
1. **Procedimientos Almacenados**: Funciones operativas para calcular ranking, validar envíos, etc.
2. **Funciones**: Funciones escalares para cálculos de puntuación y agregaciones.
3. **Vistas**: Vistas para generar reportes de clasificación, estadísticas por equipo, etc.
4. **Índices**: Índices en columnas de búsqueda frecuente (`id_concurso`, `hora_envio`, `id_equipo`).
5. **Consultas Avanzadas**: Queries complejas para análisis de desempeño y estadísticas.

## Referencias

- [Especificaciones del Proyecto](project-instructions.md)
- [Script de Creación de Base de Datos](base-query.sql)
- Norma de Concursos Internacionales de Programación: [ICPC](https://icpc.global/)
