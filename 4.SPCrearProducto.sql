use tienda
go

if exists(select 1 from sysobjects where name = 'SPcrearProducto' and type = 'P')
   drop proc SPcrearProducto
go
 

create procedure SPcrearProducto(
	@i_id_producto            int,
	@i_nombre                 varchar(30),
	@i_precio_venta           money,
	@i_cantidad_stock         int,
	@i_estado                 tinyint,
	@i_id_categoria           int
)
as
declare 
	@w_descuento         int,
	@w_cantidad_stock    int,
	@w_codigo_barras     varchar(30),
    @w_numero_desde       int ,
    @w_numero_hasta       int  

	select @w_numero_desde = 100000,
	       @w_numero_hasta = 999999
	SELECT @w_codigo_barras = ROUND(((@w_numero_hasta - @w_numero_desde) * RAND() + @w_numero_desde), 0)

-- Validar si existe el producto --
if not exists (select 1 from productos where id_producto = @i_id_producto)
begin
	-- validar si existe la categoria --
	if exists(select 1 from categorias where id_categoria = @i_id_categoria)
	begin
		print 'Existe la categoria'

		--insertar el producto --
			INSERT INTO PRODUCTOS 
			VALUES(
			@i_id_producto,
			UPPER(@i_nombre),
			@w_codigo_barras,
			@i_precio_venta,
			@i_cantidad_stock,
			@i_estado,
			@i_id_categoria,
			null)
	end
	else
	begin
		print 'No Existe la categoria'
	end	
end
else
begin
	--Obtener la cantidad en stock del producto --
	select @w_cantidad_stock = cantidad_stock 
	from productos 
	where id_producto = @i_id_producto

	-- crear la nueva cantidad en stock del producto --
	select @w_cantidad_stock = @w_cantidad_stock + @i_cantidad_stock

	--agregar la cantidad en stock del producto --
	update productos
	set cantidad_stock = @w_cantidad_stock
	where id_producto =  @i_id_producto

	-- actualizar el precio de venta del producto --
	update productos
	set precio_venta = @i_precio_venta
	where id_producto =  @i_id_producto

	-- actualizar el nombre del producto --
	update productos
	set nombre = @i_nombre
	where id_producto =  @i_id_producto

	-- actualizar el codigo de barras del producto --
	update productos
	set codigo_barras = @w_codigo_barras 
	where id_producto =  @i_id_producto
	
	-- validar si hay m�s de 200 unidades para aplicar el 50% de descuento --
	if @w_cantidad_stock >= 200 
	begin
		update productos
		set descuento = 50
		where id_producto =  @i_id_producto
	end
end


exec SPcrearProducto 16,'fabuloso color rosa',22.500,100,1,1

select * from productos

alter table productos alter column descuento int null