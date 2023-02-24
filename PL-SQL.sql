use tienda

--select * from categorias
--select * from productos
--select * from clientes
--select * from clientes
--select * from compras_productos


/* Traer las categorias 1 del producto 3 y estado activo*/


declare 
	@w_id_categoria int,
	@w_id_productos  int,
	@w_estado    tinyint,
	@w_precio_venta decimal(16,3),
	@w_nombreP varchar (45)

select @w_id_categoria = 1,
		@w_id_productos = 3,
		@w_estado = 1

select @w_precio_venta = precio_venta, @w_nombreP = nombre
from productos 
where id_categoria = @w_id_categoria
and id_producto = @w_id_categoria
and estado = @w_estado


select @w_precio_venta as precioFinal,@w_nombreP as producto


/* cantidad en stock de la categoria 2 */
declare
	@w_categoria int,
	@w_stock  int,
	@w_nombrePr varchar(45)

select @w_categoria = 2

select  @w_stock = sum(cantidad_stock) 
from productos
where productos.id_categoria = @w_categoria


select @w_stock as cantidad


select * from productos
where id_categoria = 2
