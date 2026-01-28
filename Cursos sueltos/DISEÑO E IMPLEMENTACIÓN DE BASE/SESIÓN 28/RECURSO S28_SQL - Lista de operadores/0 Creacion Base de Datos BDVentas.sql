
-- Creación de la base de datos
drop database if exists BDVentas;
go
create database BDVentas
on
  (name=BDComprasVentas,
  filename='D:\KHIPU\SESIONES BASE DE DATOS\DB\BDVentas.mdf',
  size=10,
  maxsize=50,
  filegrowth=5
  )
log on
  (name=BDVentas_log,
  filename='D:\KHIPU\SESIONES BASE DE DATOS\log\BDVentas_log.ldf',
  size=5MB,
  maxsize=25MB,
  filegrowth=5MB
  );
use  BDVentas;

--Tabla categoría
create table categoria(
	idcategoria varchar(8),
	nombre varchar(50) not null unique,
	descripcion varchar(256) null,
	estado bit default(1),
	primary key(idcategoria)
);

--Tabla artículo
create table articulo(
	idarticulo varchar(8),
	idcategoria varchar(8) not null,
	nombre varchar(100) not null unique,
	precio_venta decimal(11,2) not null,
	stock integer not null,
	descripcion varchar(256) null,
	estado bit default(1),
	FOREIGN KEY (idcategoria) REFERENCES categoria(idcategoria),
	primary key(idarticulo)
);

--Tabla cliente

create table cliente(
    idCliente varchar(8),
	nombre varchar(100) not null,
	tipo_documento varchar(20) null,
	num_documento varchar(20) null,
	direccion varchar(70) null,
	telefono varchar(20) null,
	email varchar(50) null,
	primary key(idCliente)
);
select * from cliente
--Tabla rol
create table rol(
	idrol varchar(4),
	nombre varchar(30) not null,
	descripcion varchar(250) null,
	estado bit default(1),
	primary key(idrol)
);

--Tabla usuario
create table usuario(
	idusuario varchar(6),
	idrol varchar(4) not null,
	nombre varchar(100) not null,
	tipo_documento varchar(20) null,
	num_documento varchar(20) null,
	direccion varchar(70) null,
	telefono varchar(20) null,
	email varchar(50) not null,
	password varbinary not null,
	estado bit default(1),
	primary key(idusuario),
	FOREIGN KEY (idrol) REFERENCES rol (idrol)
);

--Tabla venta
create table venta(
	idventa integer primary key identity,
	idcliente varchar(8) not null,
	idusuario varchar(6) not null,
	tipo_comprobante varchar(20) not null,
	serie_comprobante varchar(7) null,
	num_comprobante varchar (10) not null,
	fecha_hora datetime not null,
	impuesto decimal (4,2) not null,
	total decimal (11,2) not null,
	estado varchar(20) not null,
	FOREIGN KEY (idcliente) REFERENCES cliente (idcliente),
	FOREIGN KEY (idusuario) REFERENCES usuario (idusuario)
);


create table detalle_venta(
	iddetalle_venta integer primary key identity,
	idventa integer not null,
	idarticulo varchar(8) not null,
	cantidad integer not null,
	precio decimal(11,2) not null,
	descuento decimal(11,2) not null,
	FOREIGN KEY (idventa) REFERENCES venta (idventa),
	FOREIGN KEY (idarticulo) REFERENCES articulo (idarticulo)
);
