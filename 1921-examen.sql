DROP DATABASE IF EXISTS coworking;
CREATE DATABASE coworking;
USE coworking;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    fecha_registro DATE NOT NULL
);

CREATE TABLE membresias (
    id_membresia INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo_membresia VARCHAR(50) NOT NULL,
    estado ENUM('Activa', 'Inactiva', 'Cancelada') NOT NULL DEFAULT 'Activa',
    fecha_inicio DATE NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    espacio VARCHAR(100) NOT NULL,
    fecha_reserva DATETIME NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_pago DATETIME NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva) ON DELETE CASCADE
);





INSERT INTO usuarios (nombre, email, fecha_registro) VALUES
('Carlos Gómez', 'carlos@email.com', '2026-01-10'),
('Ana Martínez', 'ana@email.com', '2026-02-15'),
('Luis Rodríguez', 'luis@email.com', '2026-03-01'),
('Maria López', 'maria@email.com', '2026-03-10');

INSERT INTO membresias (id_usuario, tipo_membresia, estado, fecha_inicio) VALUES
(1, 'VIP', 'Activa', '2026-01-10'),
(2, 'Pro', 'Activa', '2026-02-15'),
(3, 'Básica', 'Inactiva', '2026-03-01'),
(4, 'VIP', 'Activa', '2026-03-10');

INSERT INTO reservas (id_usuario, espacio, fecha_reserva) VALUES
(1, 'Sala de Conferencias', '2026-03-15 10:00:00'),
(1, 'Escritorio Flexible', '2026-03-20 09:00:00'),
(2, 'Oficina Privada', '2026-03-18 14:00:00'),
(3, 'Escritorio Flexible', '2026-03-22 11:00:00'),
(4, 'Sala de Reuniones A', '2026-03-25 15:00:00');

INSERT INTO pagos (id_reserva, monto, fecha_pago, metodo_pago) VALUES
(1, 80.00, '2026-03-15 10:05:00', 'Tarjeta de Crédito'),
(2, 50.00, '2026-03-20 09:05:00', 'PayPal'),
(3, 150.00, '2026-03-18 14:10:00', 'Transferencia'),
(4, 200.00, '2026-03-22 11:05:00', 'Efectivo'),
(5, 40.00, '2026-03-25 15:05:00', 'Tarjeta de Crédito');

SELECT 
    u.nombre AS nombre_usuario,
    m.tipo_membresia,
    SUM(p.monto) AS total_pagado
FROM 
    usuarios u

-- Relacionamos los usuarios con sus membresías
INNER JOIN 
    membresias m ON u.id_usuario = m.id_usuario
-- Relacionamos los usuarios con las reservas que han realizado
INNER JOIN 
    reservas r ON u.id_usuario = r.id_usuario
-- Relacionamos cada reserva con el pago correspondiente
INNER JOIN 
    pagos p ON r.id_reserva = p.id_reserva


-- Conservamos únicamente los usuarios cuya membresía esté actualmente activa
WHERE 
    m.estado = 'Activa'


-- Agrupamos por id, nombre y tipo de membresía para calcular el total por cada usuario
GROUP BY 
    u.id_usuario, 
    u.nombre, 
    m.tipo_membresia


-- Muestra solo los usuarios cuyo acumulado total pagado sea estrictamente mayor a 100
HAVING 
    SUM(p.monto) > 100


-- Ordena los resultados de mayor a menor total pagado
ORDER BY 
    total_pagado DESC;