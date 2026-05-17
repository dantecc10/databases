-- ============================================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS (SQL SERVER)
-- ============================================================

-- 1. Crear la tabla Universidad
CREATE TABLE Universidad (
    id_universidad INT IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Universidad PRIMARY KEY (id_universidad)
);

-- 2. Crear la tabla Equipo
CREATE TABLE Equipo (
    id_equipo INT IDENTITY(1,1),
    nombre_equipo VARCHAR(50) NOT NULL,
    id_universidad INT NOT NULL,
    CONSTRAINT PK_Equipo PRIMARY KEY (id_equipo),
    CONSTRAINT FK_Equipo_Universidad FOREIGN KEY (id_universidad) 
        REFERENCES Universidad(id_universidad)
);

-- 3. Crear la tabla Concursante
CREATE TABLE Concursante (
    id_concursante INT IDENTITY(1,1),
    nombre_completo VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    id_equipo INT NOT NULL,
    CONSTRAINT PK_Concursante PRIMARY KEY (id_concursante),
    CONSTRAINT FK_Concursante_Equipo FOREIGN KEY (id_equipo) 
        REFERENCES Equipo(id_equipo)
);

-- 4. Crear la tabla Concurso
CREATE TABLE Concurso (
    id_concurso INT IDENTITY(1,1),
    nombre_evento VARCHAR(100) NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    duracion_minutos INT NOT NULL DEFAULT 300, -- Por defecto las 5 horas del ICPC
    CONSTRAINT PK_Concurso PRIMARY KEY (id_concurso)
);

-- 5. Crear la tabla Problema
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

-- 6. Crear la tabla Lenguaje
CREATE TABLE Lenguaje (
    id_lenguaje INT IDENTITY(1,1),
    nombre VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Lenguaje PRIMARY KEY (id_lenguaje)
);

-- 7. Crear la tabla Veredicto
CREATE TABLE Veredicto (
    id_veredicto INT IDENTITY(1,1),
    acronimo VARCHAR(5) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Veredicto PRIMARY KEY (id_veredicto)
);

-- 8. Crear la tabla Envio
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