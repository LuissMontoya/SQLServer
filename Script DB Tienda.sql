--create database tienda
use tienda

CREATE TABLE categorias(
	id_categoria int not null primary key,
	descripcion varchar(45) not null,
	estado tinyint --1.ACTIVO 2.INACTIVO
)

CREATE TABLE productos(
	id_producto int not null primary key,
	nombre varchar(45) not null,
	codigo_barras varchar(150),
	precio_venta decimal(16,3),
	cantidad_stock int,
	estado tinyint, 
	id_categoria int not null
)

ALTER TABLE productos ADD FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria);


CREATE TABLE compras(
	id_compra int not null primary key,
	fecha datetime not null,
	medio_pago char(1),
	comentario varchar(300),
	estado char(1),
	id_cliente int not null
)

CREATE TABLE clientes(
	id_cliente int not null primary key,
	nombre varchar(40),
	apellido varchar(100),
	celular varchar(10),
	direccion varchar(80),
	correo varchar(70)
)

ALTER TABLE compras ADD FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente);



CREATE TABLE compras_productos(
	id_compra int not null,
	id_producto int not null,
	cantidad int,
	total decimal(16,3),
	estado tinyint
)

ALTER TABLE compras_productos ADD FOREIGN KEY (id_compra) REFERENCES compras(id_compra);
ALTER TABLE compras_productos ADD FOREIGN KEY (id_producto) REFERENCES productos(id_producto);


SELECT * FROM sysobjects WHERE xtype = 'U'

insert into categorias values(1,'ASEO',1)
insert into categorias values(2,'PERSONAL',2)
insert into categorias values(3,'CASA',1)
insert into categorias values(4,'PAPELERIA',2)

SELECT * FROM CATEGORIAS --WHERE estado = 1

insert into productos values(1,'FABULOSO FRESA LAVANDA','8414533058547',20.500,200,1,1)
insert into productos values(2,'FABULOSO AROMA BEBE','8414533058548',22.700,45,1,1)
insert into productos values(3,'FABULOSO MAR FRESCO','8414533058549',21.200,90,2,1)
insert into productos values(4,'FABULOSO FLORAL','8414533058540',19.800,35,1,1)
insert into productos values(5,'FABULOSO TRAP','8414533058541',20.100,15,1,1)
insert into productos values(6,'FABULOSO VIOLETA','8414533058542',17.400,20,2,1)

insert into productos values(7,'MAQUILLAJE','1214533058547',50.000,10,1,2)
insert into productos values(8,'COLONIA','1314533058547',78.900,3,1,2)
insert into productos values(9,'LACA','1410533058547',10.000,25,1,2)

insert into productos values(10,'SARTEN DESAYUNO','1210143058547',230.000,15,1,3)
insert into productos values(11,'MESA TV','9814533058547',362.900,25,1,3)
insert into productos values(12,'LICUADORA','5410533058547',156.000,13,1,3)

insert into productos values(13,'CUADERNO 100 HOJAS','1214103058547',3.000,100,1,4)
insert into productos values(14,'LAPICERO','9814101058547',1.000,250,1,4)
insert into productos values(15,'BLOCK RAYADO','5632533058547',3.000,98,1,4)

select top 5 * from productos
where precio_venta >= 15.000

update productos set precio_venta = 23.900
where id_producto = 5

insert into clientes values(1,'JUAN CAMILO','LOPEZ','3112451248','CAMILO1@GMAIL.COM','CARRERA 10 CALLE 12 B. CRISTO REY')
insert into clientes values(2,'MARIA ALEJANDRA','ROMERO','3141251248','CAMI@GMAIL.COM','CARRERA 31 CALLE 09 B. MARIN')
insert into clientes values(3,'JORGE','MORENO','3741451248','JORGE23@GMAIL.COM','CARRERA 05 CALLE 16 B. VILLA DEL MAR')
insert into clientes values(4,'LUIS ALEJANDRO','ROJAS','3102451248','ALEJO12@GMAIL.COM','CARRERA 1 CALLE 18 B. VILLA DEL MAR')

SELECT * FROM CLIENTES

SELECT * FROM PRODUCTOS --WHERE estado = 1

select * from categorias

select nombre,precio_venta,descripcion,categorias.estado, (precio_venta * categorias.estado) as total
from productos as p
inner join categorias on categorias.id_categoria = p.id_categoria
--where categorias.estado = 1 and precio_venta < 20.000
--and productos.nombre = lower('fabuloso floral')
--where productos.id_categoria = categorias.id_categoria
order by nombre,precio_venta asc

select categorias.descripcion,count(p.id_categoria) as cantidad
from productos as p
inner join categorias on categorias.id_categoria = p.id_categoria
group by categorias.descripcion