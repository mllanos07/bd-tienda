CREATE DATABASE IF NOT EXISTS Tienda;
USE Tienda;

CREATE TABLE IF NOT EXISTS Clientes (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre_contacto VARCHAR(255) NOT NULL,
  direccion VARCHAR(255),
  ciudad VARCHAR(255),
  pais VARCHAR(255),
  telefono VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS Categorias (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre_categoria VARCHAR(255) NOT NULL,
  descripcion TEXT
);

CREATE TABLE IF NOT EXISTS Empleados (
  id INT PRIMARY KEY AUTO_INCREMENT,
  apellido VARCHAR(255) NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  cargo VARCHAR(255),
  fecha_nacimiento DATE,
  pais VARCHAR(255),
  telefono VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS Transportistas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre_empresa VARCHAR(255) NOT NULL,
  telefono VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS Proveedores (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre_empresa VARCHAR(255) NOT NULL,
  direccion VARCHAR(255),
  ciudad VARCHAR(255),
  pais VARCHAR(255),
  telefono VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS Productos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre_producto VARCHAR(255) NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
  unidades_en_stock INT NOT NULL DEFAULT 0 CHECK (unidades_en_stock >= 0),
  unidades_en_pedido INT NOT NULL DEFAULT 0 CHECK (unidades_en_pedido >= 0)
);

CREATE TABLE IF NOT EXISTS Pedidos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  cliente_id INT NOT NULL,
  empleado_id INT,
  fecha_envio DATE,
  envio_por INT,
  direccion_envio VARCHAR(255),
  CONSTRAINT fk_pedidos_clientes FOREIGN KEY (cliente_id) REFERENCES Clientes(id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pedidos_empleados FOREIGN KEY (empleado_id) REFERENCES Empleados(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_pedidos_transportistas FOREIGN KEY (envio_por) REFERENCES Transportistas(id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS DetallesPedidos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  pedido_id INT NOT NULL,
  producto_id INT NOT NULL,
  cantidad INT NOT NULL CHECK (cantidad > 0),
  precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
  descuento DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (descuento BETWEEN 0 AND 1),
  CONSTRAINT fk_detalles_pedidos FOREIGN KEY (pedido_id) REFERENCES Pedidos(id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_detalles_productos FOREIGN KEY (producto_id) REFERENCES Productos(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Registros (
  id INT PRIMARY KEY AUTO_INCREMENT,
  pedido_id INT,
  producto_id INT,
  cantidad INT,
  precio_unitario DECIMAL(10,2),
  CONSTRAINT fk_registros_pedidos FOREIGN KEY (pedido_id) REFERENCES Pedidos(id) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_registros_productos FOREIGN KEY (producto_id) REFERENCES Productos(id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE INDEX idx_pedidos_cliente ON Pedidos(cliente_id);
CREATE INDEX idx_pedidos_empleado ON Pedidos(empleado_id);
CREATE INDEX idx_pedidos_envio_por ON Pedidos(envio_por);
CREATE INDEX idx_detalles_pedido ON DetallesPedidos(pedido_id);
CREATE INDEX idx_detalles_producto ON DetallesPedidos(producto_id);
CREATE INDEX idx_registros_pedido ON Registros(pedido_id);
CREATE INDEX idx_registros_producto ON Registros(producto_id);
CREATE INDEX idx_productos_nombre ON Productos(nombre_producto);

INSERT INTO Clientes (nombre_contacto, direccion, ciudad, pais, telefono) VALUES
  ('Maria Suarez', 'Colon 123', 'Cordoba', 'Argentina', '+54 351 7001111'),
  ('Lucas Perez', 'San Martin 456', 'Villa Maria', 'Argentina', '+54 353 7002222'),
  ('Ana Gomez', '9 de Julio 789', 'Rio Cuarto', 'Argentina', '+54 358 7003333'),
  ('Diego Lopez', 'Ituzaingo 50', 'Cordoba', 'Argentina', '+54 351 7004444'),
  ('Carla Diaz', 'Laprida 210', 'Alta Gracia', 'Argentina', '+54 3547 7005555');

INSERT INTO Categorias (nombre_categoria, descripcion) VALUES
  ('Bebidas', 'Gaseosas y jugos'),
  ('Snacks', 'Aperitivos salados'),
  ('Lacteos', 'Leche y derivados'),
  ('Panificados', 'Pan y similares'),
  ('Higiene', 'Cuidado personal');

INSERT INTO Empleados (apellido, nombre, cargo, fecha_nacimiento, pais, telefono) VALUES
  ('Ferreyra', 'Sofia', 'Vendedora', '1997-05-12', 'Argentina', '+54 351 6001111'),
  ('Gaitan', 'Tomas', 'Vendedor', '1993-10-03', 'Argentina', '+54 351 6002222'),
  ('Martinez', 'Julieta', 'Atencion', '1999-01-21', 'Argentina', '+54 351 6003333'),
  ('Quiroga', 'Bruno', 'Supervisor', '1990-08-08', 'Argentina', '+54 351 6004444'),
  ('Romero', 'Paula', 'Deposito', '1995-12-15', 'Argentina', '+54 351 6005555');

INSERT INTO Transportistas (nombre_empresa, telefono) VALUES
  ('Rapido Express', '+54 11 40001000'),
  ('LogiPack', '+54 11 40002000'),
  ('Andes Cargo', '+54 11 40003000'),
  ('TransSur', '+54 11 40004000'),
  ('eShip', '+54 11 40005000');

INSERT INTO Proveedores (nombre_empresa, direccion, ciudad, pais, telefono) VALUES
  ('Alimentos Rio SA', 'Av Siempre Viva 742', 'Cordoba', 'Argentina', '+54 351 5550001'),
  ('Delicias SRL', 'Mitre 120', 'Rosario', 'Argentina', '+54 341 5550002'),
  ('La Serena', 'Rivadavia 200', 'Mendoza', 'Argentina', '+54 261 5550003'),
  ('Norte Distribuciones', 'Belgrano 450', 'Salta', 'Argentina', '+54 387 5550004'),
  ('EcoHigiene', 'Sarmiento 980', 'Bahia Blanca', 'Argentina', '+54 291 5550005');

INSERT INTO Productos (nombre_producto, precio_unitario, unidades_en_stock, unidades_en_pedido) VALUES
  ('Cola 1.5L', 1200.00, 50, 5),
  ('Papas clasicas 100g', 900.00, 80, 0),
  ('Yogur natural 200g', 650.00, 100, 10),
  ('Pan lactal', 1500.00, 40, 2),
  ('Jabon liquido 500ml', 2200.00, 35, 0);

INSERT INTO Pedidos (cliente_id, empleado_id, fecha_envio, envio_por, direccion_envio) VALUES
  (1, 1, '2025-08-21', 1, 'Colon 123, Cordoba'),
  (2, 2, '2025-08-22', 2, 'San Martin 456, Villa Maria'),
  (3, 3, '2025-08-23', 3, '9 de Julio 789, Rio Cuarto'),
  (4, 4, '2025-08-24', 4, 'Ituzaingo 50, Cordoba'),
  (5, 5, '2025-08-25', 5, 'Laprida 210, Alta Gracia');

INSERT INTO DetallesPedidos (pedido_id, producto_id, cantidad, precio_unitario, descuento) VALUES
  (1, 1, 2, 1200.00, 0.05),
  (2, 2, 3, 900.00, 0.00),
  (3, 3, 4, 650.00, 0.10),
  (4, 4, 1, 1500.00, 0.00),
  (5, 5, 2, 2200.00, 0.025);

INSERT INTO Registros (pedido_id, producto_id, cantidad, precio_unitario) VALUES
  (1, 1, 2, 1200.00),
  (2, 2, 3, 900.00),
  (3, 3, 4, 650.00),
  (4, 4, 1, 1500.00),
  (5, 5, 2, 2200.00);

---------------------------------------------------------------------------------------

SELECT c.nombre_contacto AS Cliente, p.id AS Pedido
FROM Clientes c
INNER JOIN Pedidos p ON c.id = p.cliente_id
ORDER BY c.nombre_contacto;

SELECT pr.nombre_producto AS Producto, pr.precio_unitario AS Precio, dp.cantidad AS Cantidad
FROM
    DetallesPedidos dp
    INNER JOIN Productos pr ON dp.producto_id = pr.id
ORDER BY pr.nombre_producto;

SELECT
    c.nombre_contacto AS Cliente,
    p.id AS Pedido,
    p.fecha_envio AS Fecha_Envio
FROM Pedidos p
    INNER JOIN Clientes c ON p.cliente_id = c.id
ORDER BY c.nombre_contacto, p.fecha_envio;

SELECT DISTINCT
    c.nombre_contacto AS Cliente
FROM Clientes c
    INNER JOIN Pedidos p ON c.id = p.cliente_id;

SELECT pr.nombre_producto AS Producto, p.id AS Pedido, c.nombre_contacto AS Cliente
FROM
    DetallesPedidos dp
    INNER JOIN Productos pr ON dp.producto_id = pr.id
    INNER JOIN Pedidos p ON dp.pedido_id = p.id
    INNER JOIN Clientes c ON p.cliente_id = c.id
WHERE
    pr.nombre_producto = 'CCC';

SELECT
    c.nombre_contacto AS Cliente,
    p.id AS Pedido,
    SUM(
        dp.cantidad * dp.precio_unitario
    ) AS Monto_Total
FROM
    Pedidos p
    INNER JOIN Clientes c ON p.cliente_id = c.id
    INNER JOIN DetallesPedidos dp ON p.id = dp.pedido_id
GROUP BY
    c.nombre_contacto,
    p.id
ORDER BY c.nombre_contacto;
