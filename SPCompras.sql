use tienda
go

if exists(select 1 from sysobjects where name = 'SPcompras' and type = 'P')
   drop proc SPcompras
go
 
create procedure SPcompras(
	@i_id_compra        int,
	@i_cliente          int,
	@i_medioPago        char(1),
	@i_comentario       varchar(255),
	@i_producto         int,
	@i_cantidad         int,
	@i_estado           tinyint

)
as
declare 
  @w_id_compra   int,
  @w_fechaCompra datetime,
  @w_medioDePago char(1),
  @w_comentario  varchar(255),
  @w_estado      tinyint,
  @w_id_cliente  int,
  @w_id_producto int,
  @w_cantidad    int,
  @w_total       decimal(16,3),
  @w_cantidad2       int,
  @w_cantidad_stock   int,
  @w_descuento        decimal(16,2)


select @w_fechaCompra = GETDATE(),
	   @w_medioDePago = @i_medioPago,
	   @w_comentario  = @i_comentario,
	   @w_cantidad    = @i_cantidad,
	   @w_estado      = @i_estado,
	   @w_id_cliente  = @i_cliente,
	   @w_id_producto = @i_producto,
	   @w_id_compra   = @i_id_compra

	  

select @w_total = (precio_venta * @w_cantidad) 
from productos
where id_producto = @w_id_producto

select @w_cantidad_stock = cantidad_stock  
from productos
where id_producto = @w_id_producto

select @w_cantidad2 = @w_cantidad_stock - @w_cantidad

select @w_descuento = descuento * precio_venta
from productos
where id_producto = @w_id_producto

--select @w_descuento = @w_descuento /100

print 'descuento: '
print @w_descuento

print @w_total

if @w_descuento is not null
begin
	print @w_total
	select @w_total = @w_total - @w_descuento
	print @w_total
end


if @w_cantidad_stock < @w_cantidad
begin
	print 'Cantidad en stock no Disponible'
end
else
begin
if not exists(select 1 from compras where id_compra = @w_id_compra)
begin 
	insert into compras 
      values (@w_id_compra, 
	          @w_fechaCompra,
			  @w_medioDePago,
			  @w_comentario,
			  @w_estado,
			  @w_id_cliente)
end 

insert into compras_productos 
      values (@w_id_compra,
              @w_id_producto,
			  @w_cantidad,
			  @w_total,
			  @w_estado)


	update productos set cantidad_stock = @w_cantidad2
	where id_producto = @w_id_producto

	print 'COMPRA EXITOSA'

end

/*--- */
	@i_id_compra        int,
	@i_cliente          int,
	@i_medioPago        char(1),
	@i_comentario       varchar(255),
	@i_producto         int,
	@i_cantidad         int,
	@i_estado           tinyint

exec dbo.SPcompras 2,1,'T','Comentario 1',14,3,1

select * from categorias
select * from compras
select * from compras_productos
select * from productos
select * from clientes

delete from compras_productos
delete from compras

select * from compras as c
inner join compras_productos as cp on cp.id_compra  = c.id_compra
where cp.cantidad between 2 and 4

select * from compras as c
inner join compras_productos as cp on cp.id_compra  = c.id_compra
where cp.cantidad >= 2 and cp.cantidad <= 4

select * from compras as c
inner join compras_productos as cp on cp.id_compra  = c.id_compra
where comentario like '%t%'

--Descuentos a las compras -- 
alter table productos add descuento int null
alter table productos alter column descuento decimal(2,2) null

update productos set descuento =0.15
where id_producto in (4,6,8)


select *,descuento
from productos
where id_producto = 1