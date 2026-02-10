CREATE DATABASE IF NOT EXISTS proyecto_geovan;
USE proyecto_geovan;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS T_Facturas_Detalle, T_Facturas, T_Citas_Servicios, T_Citas, 
                     T_Excepciones_Horario, T_Horarios_Disponibles, T_Servicios_Empleados, 
                     T_Servicios, T_Contactos, T_Empleados, T_Negocios, T_Estilistas, 
                     T_Roles_Permisos, T_Clientes_Roles, T_Clientes, T_Roles, T_Permisos;
SET FOREIGN_KEY_CHECKS = 1;

-- SEGURIDAD Y ROLES
CREATE TABLE T_Permisos (
    Permisos_id INT PRIMARY KEY AUTO_INCREMENT,
    Permisos_nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE T_Roles (
    Roles_id INT PRIMARY KEY AUTO_INCREMENT,
    Roles_nombre VARCHAR(50) NOT NULL UNIQUE
);

-- USUARIOS
CREATE TABLE T_Clientes (
    Clientes_id INT PRIMARY KEY AUTO_INCREMENT,
    Clientes_email VARCHAR(100) NOT NULL UNIQUE,
    Clientes_password_hash VARCHAR(255) NOT NULL,
    Clientes_nombre_completo VARCHAR(150) NOT NULL,
    Clientes_telefono VARCHAR(20)
);

CREATE TABLE T_Clientes_Roles (
    Clientes_Roles_id_cliente INT,
    Clientes_Roles_id_rol INT,
    PRIMARY KEY (Clientes_Roles_id_cliente, Clientes_Roles_id_rol),
    FOREIGN KEY (Clientes_Roles_id_cliente) REFERENCES T_Clientes(Clientes_id),
    FOREIGN KEY (Clientes_Roles_id_rol) REFERENCES T_Roles(Roles_id)
);

CREATE TABLE T_Roles_Permisos (
    Roles_Permisos_id_rol INT,
    Roles_Permisos_id_permiso INT,
    PRIMARY KEY (Roles_Permisos_id_rol, Roles_Permisos_id_permiso),
    FOREIGN KEY (Roles_Permisos_id_rol) REFERENCES T_Roles(Roles_id),
    FOREIGN KEY (Roles_Permisos_id_permiso) REFERENCES T_Permisos(Permisos_id)
);

-- ESTRUCTURA DEL NEGOCIO
CREATE TABLE T_Estilistas (
    Estilistas_id INT PRIMARY KEY AUTO_INCREMENT,
    Estilistas_id_cliente INT NOT NULL UNIQUE,
    Estilistas_numero_documento VARCHAR(50),
    Estilistas_foto_perfil_url VARCHAR(255),
    FOREIGN KEY (Estilistas_id_cliente) REFERENCES T_Clientes(Clientes_id)
);

CREATE TABLE T_Negocios (
    Negocios_id INT PRIMARY KEY AUTO_INCREMENT,
    Negocios_id_estilista INT NOT NULL,
    Negocios_nombre VARCHAR(150) NOT NULL,
    Negocios_direccion_texto VARCHAR(255) NOT NULL,
    Negocios_latitud DECIMAL(10, 8),
    Negocios_longitud DECIMAL(11, 8),
    FOREIGN KEY (Negocios_id_estilista) REFERENCES T_Estilistas(Estilistas_id)
);

CREATE TABLE T_Empleados (
    Empleados_id INT PRIMARY KEY AUTO_INCREMENT,
    Empleados_id_negocio INT NOT NULL,
    Empleados_nombre_completo VARCHAR(150) NOT NULL,
    Empleados_numero_documento VARCHAR(50),
    Empleados_foto_perfil_url VARCHAR(255),
    FOREIGN KEY (Empleados_id_negocio) REFERENCES T_Negocios(Negocios_id)
);

CREATE TABLE T_Contactos (
    Contactos_id INT PRIMARY KEY AUTO_INCREMENT,
    Contactos_id_empleado INT NOT NULL,
    Contactos_tipo VARCHAR(50) NOT NULL,
    Contactos_valor VARCHAR(100) NOT NULL,
    FOREIGN KEY (Contactos_id_empleado) REFERENCES T_Empleados(Empleados_id)
);

-- SERVICIOS Y HORARIOS
CREATE TABLE T_Servicios (
    Servicios_id INT PRIMARY KEY AUTO_INCREMENT,
    Servicios_nombre VARCHAR(100) NOT NULL,
    Servicios_precio DECIMAL(10, 2) NOT NULL,
    Servicios_duracion_minutos INT NOT NULL
);

CREATE TABLE T_Servicios_Empleados (
    Servicios_Empleados_id_empleado INT,
    Servicios_Empleados_id_servicio INT,
    PRIMARY KEY (Servicios_Empleados_id_empleado, Servicios_Empleados_id_servicio),
    FOREIGN KEY (Servicios_Empleados_id_empleado) REFERENCES T_Empleados(Empleados_id),
    FOREIGN KEY (Servicios_Empleados_id_servicio) REFERENCES T_Servicios(Servicios_id)
);

CREATE TABLE T_Horarios_Disponibles (
    Horarios_Disponibles_id INT PRIMARY KEY AUTO_INCREMENT,
    Horarios_Disponibles_id_empleado INT NOT NULL,
    Horarios_Disponibles_dia_semana INT NOT NULL,
    Horarios_Disponibles_hora_apertura TIME NOT NULL,
    Horarios_Disponibles_hora_cierre TIME NOT NULL,
    FOREIGN KEY (Horarios_Disponibles_id_empleado) REFERENCES T_Empleados(Empleados_id)
);

CREATE TABLE T_Excepciones_Horario (
    Excepciones_id INT PRIMARY KEY AUTO_INCREMENT,
    Excepciones_id_empleado INT NOT NULL,
    Excepciones_fecha DATE NOT NULL,
    Excepciones_hora_inicio TIME,
    Excepciones_hora_fin TIME,
    Excepciones_motivo VARCHAR(255),
    FOREIGN KEY (Excepciones_id_empleado) REFERENCES T_Empleados(Empleados_id)
);

-- MANEJO DE CITAS
CREATE TABLE T_Citas (
    Citas_id INT PRIMARY KEY AUTO_INCREMENT,
    Citas_id_cliente INT NOT NULL,
    Citas_id_negocio INT NOT NULL,
    Citas_id_empleado INT NOT NULL,
    Citas_fecha_hora_inicio DATETIME NOT NULL,
    Citas_fecha_hora_fin DATETIME NOT NULL,
    Citas_estado VARCHAR(50) NOT NULL,
    FOREIGN KEY (Citas_id_cliente) REFERENCES T_Clientes(Clientes_id),
    FOREIGN KEY (Citas_id_negocio) REFERENCES T_Negocios(Negocios_id),
    FOREIGN KEY (Citas_id_empleado) REFERENCES T_Empleados(Empleados_id)
);

CREATE TABLE T_Citas_Servicios (
    Citas_Servicios_id_cita INT,
    Citas_Servicios_id_servicio INT,
    PRIMARY KEY (Citas_Servicios_id_cita, Citas_Servicios_id_servicio),
    FOREIGN KEY (Citas_Servicios_id_cita) REFERENCES T_Citas(Citas_id),
    FOREIGN KEY (Citas_Servicios_id_servicio) REFERENCES T_Servicios(Servicios_id)
);

-- FACTURACIÓN
CREATE TABLE T_Facturas (
    Facturas_id INT PRIMARY KEY AUTO_INCREMENT,
    Facturas_id_cita INT UNIQUE NOT NULL,
    Facturas_fecha_emision DATETIME NOT NULL,
    Facturas_subtotal DECIMAL(10, 2) NOT NULL,
    Facturas_impuesto DECIMAL(10, 2) NOT NULL,
    Facturas_total_pagado DECIMAL(10, 2) NOT NULL,
    Facturas_metodo_pago VARCHAR(50) NOT NULL,
    FOREIGN KEY (Facturas_id_cita) REFERENCES T_Citas(Citas_id)
);

CREATE TABLE T_Facturas_Detalle (
    Facturas_Detalle_id INT PRIMARY KEY AUTO_INCREMENT,
    Facturas_Detalle_id_factura INT NOT NULL,
    Facturas_Detalle_id_servicio INT,
    Facturas_Detalle_nombre_servicio_fijo VARCHAR(100) NOT NULL,
    Facturas_Detalle_precio_unitario_fijo DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Facturas_Detalle_id_factura) REFERENCES T_Facturas(Facturas_id),
    FOREIGN KEY (Facturas_Detalle_id_servicio) REFERENCES T_Servicios(Servicios_id)
);

-- INSERT BÁSICOS PARA QUE EL SISTEMA FUNCIONE
INSERT INTO T_Roles (Roles_nombre) VALUES ('Administrador'), ('Empleado'), ('Cliente');

INSERT INTO T_Permisos (Permisos_nombre) VALUES 
('Gestionar_Usuarios'), ('Gestionar_Citas'), ('Ver_Reportes');

-- Ejemplo de un servicio inicial
INSERT INTO T_Servicios (Servicios_nombre, Servicios_precio, Servicios_duracion_minutos) 
VALUES ('Keratina', 200000, 150);
