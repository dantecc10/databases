# Especificaciones del Proyecto: "Diseño de Base de Datos (Diseño Libre)"
## Benemérita Universidad Autónoma de Puebla

Este documento contiene las instrucciones exactas y los criterios de evaluación para el proyecto final de la materia.

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
