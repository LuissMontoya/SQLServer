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
    @w_total          decimal(16,3),
    @w_cantidad2      int,
    @w_cantidad_stock int,
	@w_fechaCompra    datetime,
	@w_descuentos       int

select @w_fechaCompra = GETDATE()

 select @w_descuentos=descuentos 
       from productos 
       where id_producto = @i_producto

	    select @w_total = (precio_venta * @i_cantidad) 
       from productos
       where id_producto = @i_producto

	    --select 'antes del if'
		select 'Total inicial]: ',@w_total  

	  if @w_descuentos is not null
	  begin 
		--select 'inicio'
	   select @w_total = (precio_venta - (precio_venta * @w_descuentos)/100) * @i_cantidad
	   from productos
	   where id_producto = @i_producto
	    
		select 'descuento: ',@w_descuentos
		select 'total con descuento ', @w_total

	   end
	 

       select @w_cantidad2 = (cantidad_stock - @i_cantidad) 
       from productos
       where id_producto = @i_producto
       
       select @w_cantidad_stock = cantidad_stock
       from productos
       where id_producto = @i_producto



if @w_cantidad_stock <= @i_cantidad
   begin 
       select 'cantidad no disponible' 
   end
else
    begin
       if not exists(select 1 from compras where id_compra = @i_id_compra)
        begin 
	     insert into compras 
              values (@i_id_compra, 
	                  @w_fechaCompra,
			          @i_medioPago,
			          @i_comentario,
			          @i_estado,
			          @i_cliente)
        end 

         insert into compras_productos 
             values (@i_id_compra,
                     @i_producto,
         		     @i_cantidad,
         		     @w_total,
         		     @i_estado)
         
       update productos
       set cantidad_stock = @w_cantidad2
       where id_producto = @i_producto

	   select 'Compra fue exitosa'
    end

	select * from productos
	alter table productos add descuentos int null


	update productos 
	set descuentos = 50
	where id_producto = 1

	exec dbo.SPcompras 6,2,'T','compra faiber',1,10,1

	select * from compras
	select * from compras_productos
	select * from productos

	delete from compras
	delete from compras_productos

	update productos
	set precio_venta = 100.000
	where id_producto = 1

	update productos
	set cantidad_stock = 100
	where id_producto = 1

