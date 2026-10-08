#1921 Consulta SQL  Exame_MYSQL2

# Examen de Consultas SQL - Sistema de Coworking

## 📌 Objetivo del Proyecto
Comprobar la capacidad de escribir consultas SQL relacionales e interpretar datos utilizando el modelo de base de datos de un sistema de administración de coworking.

---

## 📄 Enunciado del Examen
Crear una consulta SQL que muestre el **nombre del usuario**, el **tipo de membresía** y el **total pagado por reservas** de todos los usuarios que tengan una **membresía activa**.

### Requisitos Técnicos:
* La consulta debe incluir al menos una unión (`JOIN`) entre las tablas de `usuarios`, `membresias`, `pagos` y `reservas`.
* Muestra solo a los usuarios cuyo total pagado por reservas sea **mayor a 100 dólares** (o la moneda manejada en los registros).
* Ordena los resultados del **mayor al menor** total pagado.

---

## 🛠️ Estructura de la Base de Datos

El script del esquema relacional crea y utiliza las siguientes 4 tablas principales:

1. **`usuarios`**: Almacena los datos personales de los clientes.
2. **`membresias`**: Contiene la información sobre el tipo de suscripción y su estado (`Activa`, `Inactiva`, `Cancelada`).
3. **`reservas`**: Registra las reservas de espacios hechas por los usuarios.
4. **`pagos`**: Almacena las transacciones económicas asociadas a cada reserva.

---

## 💻 Consulta SQL Resuelta

```sql
SELECT 
    u.nombre AS nombre_usuario,
    m.tipo_membresia,
    SUM(p.monto) AS total_pagado
FROM 
    usuarios u
-- 1. UNIÓN DE TABLAS (JOINs)
-- Relacionamos a los usuarios con sus membresías
INNER JOIN 
    membresias m ON u.id_usuario = m.id_usuario
-- Relacionamos a los usuarios con las reservas efectuadas
INNER JOIN 
    reservas r ON u.id_usuario = r.id_usuario
-- Relacionamos cada reserva con su registro de pago correspondiente
INNER JOIN 
    pagos p ON r.id_reserva = p.id_reserva

-- 2. FILTRADO INICIAL
-- Filtra exclusivamente a los usuarios con membresía en estado 'Activa'
WHERE 
    m.estado = 'Activa'

-- 3. AGRUPAMIENTO
-- Agrupa la información por usuario y tipo de membresía para acumular el total de sus pagos
GROUP BY 
    u.id_usuario, 
    u.nombre, 
    m.tipo_membresia

-- 4. FILTRADO SOBRE LA AGREGACIÓN
-- Filtra para mostrar únicamente a aquellos cuyo total pagado por reservas supere los 100
HAVING 
    SUM(p.monto) > 100

-- 5. ORDENAMIENTO
-- Muestra los resultados ordenados de mayor a menor según el monto total acumulado
ORDER BY 
    total_pagado DESC;
