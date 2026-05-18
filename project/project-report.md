# Reporte de Proyecto: Sistema de Gestión de Concursos ICPC

## Datos Generales

- Materia: Bases de Datos
- Tipo: Proyecto Final (Diseño de Base de Datos Libre)
- Alumnos:
  - Dante Castelán Carpinteyro
  - José Miguel Matrínez Martínez
  - Osmar Javier Hernandez Prado
- Fecha: 18 de mayo de 2026
- Institución: Benemérita Universidad Autónoma de Puebla

## Objetivo del Reporte

Documentar el diseño e implementación de un sistema de base de datos relacional para la gestión de concursos de programación tipo ICPC (International Collegiate Programming Contest), mostrando la estructura de tablas, relaciones, restricciones de integridad y operaciones CRUD implementadas.

## Descripción del Problema y Justificación

### Contexto y Objetivos del Sistema
En nuestra experiencia participando en concursos y clasificatorios en la BUAP, observamos que la gestión del scoreboard se hace muchas veces de forma manual. Esto ocurre especialmente en sedes donde compiten equipos de la BUAP junto con otras universidades: se usaban hojas, listas y varios archivos para llevar el conteo de envíos y resultados.

El sistema busca facilitar al organizador la logística completa de un concurso de programación estilo ICPC, permitiendo administrar con orden:
- universidades y equipos participantes,
- integrantes de cada equipo,
- concursos y su catálogo de problemas,
- envíos de código en vivo con su tiempo y veredicto.

### Planteamiento del Problema
En el ámbito de la programación competitiva universitaria, organizar concursos y clasificatorios internos exige un control estricto de datos interconectados. Cuando la información se lleva de forma manual o dispersa, es común que se pierdan registros, se mezclen envíos y se compliquen las validaciones.

Sin un sistema centralizado es difícil:
- asegurar que cada equipo tenga exactamente tres integrantes,
- ligar cada envío con su equipo, problema y lenguaje correctos,
- mantener un historial claro de concursos y evitar envíos huérfanos,
- calcular el scoreboard en vivo y aplicar el congelamiento en el minuto 240.

### Solución Propuesta
Se propone el diseño de una Base de Datos Relacional normalizada hasta la Tercera Forma Normal (3FN), con al menos ocho entidades principales, que permita gestionar el ecosistema completo de un concurso ICPC.

El modelo permitirá:
- vincular de forma unívoca a los estudiantes con sus equipos y universidades,
- llevar un catálogo histórico de concursos y problemas algorítmicos,
- registrar cada envío de código y asociarlo con el equipo autor, el problema, el lenguaje y el veredicto del juez virtual (AC, WA, TLE, etc.),
- proveer la infraestructura necesaria para automatizar el cálculo del scoreboard en vivo mediante vistas y funciones.

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

El diseño relacional mostrado es normalizado y refleja claramente la jerarquía del modelo de datos. La tabla transaccional central es `Envio`, y todas las relaciones son de tipo uno a muchos (1:N). Por ejemplo, una `Universidad` puede tener varios `Equipos`, y un `Equipo` puede tener varios `Concursantes`. El catálogo de `Concurso` agrupa sus respectivos `Problemas`, lo que evita que existan envíos huérfanos sin una relación válida.

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

## Diccionario de Datos
A continuación se detallan las estructuras, tipos de datos y restricciones de cada entidad del sistema:

- **Universidad**
  - `id_universidad` INT IDENTITY(1,1) — PK
  - `nombre` VARCHAR(100) NOT NULL
  - `pais` VARCHAR(50) NOT NULL

- **Equipo**
  - `id_equipo` INT IDENTITY(1,1) — PK
  - `nombre_equipo` VARCHAR(50) NOT NULL
  - `id_universidad` INT NOT NULL — FK → Universidad(id_universidad)

- **Concursante**
  - `id_concursante` INT IDENTITY(1,1) — PK
  - `nombre_completo` VARCHAR(100) NOT NULL
  - `correo` VARCHAR(100) NOT NULL
  - `id_equipo` INT NOT NULL — FK → Equipo(id_equipo)

- **Concurso**
  - `id_concurso` INT IDENTITY(1,1) — PK
  - `nombre_evento` VARCHAR(100) NOT NULL
  - `fecha_inicio` DATETIME NOT NULL
  - `duracion_minutos` INT NOT NULL DEFAULT 300

- **Problema**
  - `id_problema` INT IDENTITY(1,1) — PK
  - `id_concurso` INT NOT NULL — FK → Concurso(id_concurso)
  - `letra` CHAR(1) NOT NULL
  - `titulo` VARCHAR(100) NOT NULL
  - `tiempo_limite` DECIMAL(5,2) NOT NULL

- **Lenguaje**
  - `id_lenguaje` INT IDENTITY(1,1) — PK
  - `nombre` VARCHAR(20) NOT NULL

- **Veredicto**
  - `id_veredicto` INT IDENTITY(1,1) — PK
  - `acronimo` VARCHAR(5) NOT NULL
  - `descripcion` VARCHAR(50) NOT NULL

- **Envio**
  - `id_envio` INT IDENTITY(1,1) — PK
  - `id_equipo` INT NOT NULL — FK → Equipo(id_equipo)
  - `id_problema` INT NOT NULL — FK → Problema(id_problema)
  - `id_lenguaje` INT NOT NULL — FK → Lenguaje(id_lenguaje)
  - `id_veredicto` INT NOT NULL — FK → Veredicto(id_veredicto)
  - `hora_envio` DATETIME NOT NULL
  - `tiempo_concurso` INT NOT NULL

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
El diseño cumple con 1FN porque todos los atributos son atómicos y no hay grupos repetitivos. Por ejemplo, en la tabla `Concursante` no se guarda la lista de los tres integrantes de un equipo en un solo campo como "Juan, María, Pedro"; cada concursante es un registro independiente con su propia llave primaria `id_concursante`.

### Segunda Forma Normal (2FN)
El diseño cumple con 2FN porque ya está en 1FN y todos los atributos no clave dependen completamente de la clave primaria de su tabla. En este modelo no usamos claves primarias compuestas: cada entidad tiene un identificador único simple e autoincremental (INT). Por ejemplo, `nombre_evento` en la tabla `Concurso` depende únicamente de `id_concurso`.

### Tercera Forma Normal (3FN)
El diseño cumple con 3FN porque, además de estar en 2FN, ningún atributo no clave depende de otro atributo no clave.

Un ejemplo claro es la tabla `Envio`: no se almacena el nombre del lenguaje ni el acrónimo del veredicto directamente. En lugar de ello, `Envio` usa las llaves foráneas `id_lenguaje` y `id_veredicto`, lo que evita redundancia y facilita mantener los catálogos actualizados.

Otro ejemplo es que `Envio` no incluye `id_concurso` como columna directa. Esta información se infiere a través de la relación con `Problema`: un envío pertenece a un problema, y ese problema pertenece a un concurso. Añadir `id_concurso` en `Envio` habría generado una dependencia transitiva y una forma de desnormalización que no es necesaria para el propósito académico de este proyecto.

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

## Próximos Pasos

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
