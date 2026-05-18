# Especificaciones del Proyecto: "Diseño de Base de Datos (Diseño Libre)"
## Benemérita Universidad Autónoma de Puebla

Este documento contiene las instrucciones exactas y los criterios de evaluación para el proyecto final de la materia.

---

## 📌 Justificación del Problema: Sistema de Gestión de Concursos ICPC

### Contexto del Dominio
El sistema está diseñado para gestionar la logística completa de concursos de programación competitiva bajo el modelo del **ICPC (International Collegiate Programming Contest)**. Este es un contexto real y complejo que requiere una estructura de base de datos robusta.

### Características Clave de la Competencia

#### Estructura Temporal
- **Duración estándar:** Cada concurso dura exactamente **5 horas (300 minutos)**.
- **Catálogo de problemas:** Entre **12 a 14 problemas** en una plataforma de juez automático.
- **Múltiples fechas:** El ICPC no es un evento único, sino un conjunto de competencias consecutivas durante el año:
  - Primera Fecha
  - Segunda Fecha
  - Tercera Fecha
  - Repechaje
  - Final Mexicana
  - Final Latinoamericana
  - Final Mundial

#### Estructura de Equipos
- Los participantes compiten en **equipos de 3 personas**.
- **Sin acceso a internet ni IA**, únicamente con apuntes impresos.
- Los equipos representan a **universidades específicas** (vínculo institucional crítico).

#### Importancia Crítica de la Tabla de Envíos
La tabla `Envio` es fundamental por dos razones técnicas:

1. **Procesamiento secuencial (FIFO)**: Registra cada envío en tiempo real, permitiendo procesar y calificar soluciones en el orden exacto en que llegan.

2. **Congelamiento del Scoreboard (Freeze)**: A la hora 4 del concurso (minuto 240 de 300), la tabla de posiciones pública se **pausa o congela**. Los equipos siguen enviando, pero nadie sabe si sus envíos fueron aceptados hasta la ceremonia de premiación. La tabla de envíos con `hora_envio` y `tiempo_concurso` permite:
   - Identificar qué envíos ocurrieron antes del minuto 240 (visibles).
   - Identificar cuáles ocurrieron después (ocultos en el scoreboard público).
   - Simular o calcular este comportamiento en reportes post-competencia.

### Requerimiento Mínimo
* **Estructura:** El diseño debe contar con un **mínimo de 8 tablas**.

---

## 📋 Puntos a Evaluar

| # | Componente / Entregable | Puntaje |
| :-: | :--- | :-: |
| **1** | **Diseño**<br>• Justificación del Problema<br>• Diagrama Entidad-Relación (E-R)<br>• Diccionario de Datos | **5 ptos** |
| **2** | **Normalización** | **5 ptos** |
| **3** | **Construcción de Tablas con Restricciones y Operaciones (CRUD)** | **10 ptos** |
| **4** | **Construcción de Procedimientos Almacenados (SP)** | **10 ptos** |
| **5** | **Construcción de Funciones** | **10 ptos** |
| **6** | **Construcción de Vistas** | **10 ptos** |
| **7** | **Implementación y Justificación de Índices** | **5 ptos** |
| **8** | **Consultas avanzadas** | **10 ptos** |
| | **Puntaje Total Máximo** | **65 ptos** |

---

## 👥 Reglas de Entrega e Integración del Equipo

* **Pertenencia:** El proyecto puede ser desarrollado en equipos de **máximo 3 personas**.
* **Condición de Entrega:** Para su entrega, **deben de estar presentes todos los integrantes** del equipo.

---

## 💡 Consideraciones Técnicas Generales para la Evaluación

Para asegurar el puntaje máximo en cada sección sin alterar los requisitos base, se recomienda vigilar los siguientes aspectos durante el desarrollo:

### 1. Fase de Documentación y Diseño (Puntos 1 y 2)
* **Consistencia:** Las entidades, llaves primarias ($PK$) y foráneas ($FK$) definidas en el *Diagrama E-R* deben coincidir exactamente con los nombres de las tablas y columnas descritas en el *Diccionario de Datos*.
* **Normalización:** Documentar explícitamente el paso a paso de la **1FN, 2FN y 3FN**. Si una tabla no requiere modificaciones en una fase, detallar la justificación teórica de por qué ya cumple con dicha forma normal.

### 2. Integridad de Datos y Operaciones (Punto 3)
* **Restricciones de Integridad:** No omitir las declaraciones explícitas de integridad referencial (`ON DELETE / ON UPDATE`), restricciones de verificación (`CHECK`), unicidad (`UNIQUE`) y valores por defecto (`DEFAULT`).
* **Demostración CRUD:** Preparar un script secuencial limpio donde se ejecuten en orden las inserciones ($C$), consultas ($R$), modificaciones ($U$) y eliminaciones ($D$), asegurando que las pruebas no rompan las restricciones de llave foránea de manera accidental.

### 3. Lógica Programable (Puntos 4, 5 y 6)
* **Procedimientos Almacenados:** Diseñar SPs funcionales orientados a tareas operativas (por ejemplo: inserciones complejas que involucren validaciones lógicas previas o transacciones).
* **Funciones:** Recordar las limitantes de las funciones en SQL (no deben modificar el estado de la base de datos, solo procesar parámetros y retornar valores o tablas calculadas).
* **Vistas:** Crear vistas que resuelvan la abstracción de consultas complejas (uniones de más de 3 tablas) para simplificar la lectura final de datos por parte del usuario o reportes.

### 4. Rendimiento y Consultas Avanzadas (Puntos 7 y 8)
* **Justificación de Índices:** Un índice sin justificar puede restar puntos. Anexar una breve explicación técnica de qué columnas se eligieron (comúnmente columnas muy utilizadas bajo sentencias `WHERE`, `JOIN` o cláusulas `ORDER BY`) y el impacto en la velocidad de búsqueda.
* **Consultas Avanzadas:** Diseñar *queries* que demuestren un dominio alto de SQL incorporando múltiples `INNER/LEFT JOIN`, funciones agregadas (`SUM`, `COUNT`, `AVG`), ordenamientos (`ORDER BY`) y filtros grupales (`GROUP BY` combinados con `HAVING`).
