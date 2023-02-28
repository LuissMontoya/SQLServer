use tienda
go

if exists(select 1 from sysobjects where name = 'SPcrearCliente' and type = 'P')
   drop proc SPcrearCliente
go

create procedure SPcrearCliente(
	--@i_id_cliente          int,
	@i_nombre           varchar(40),
	@i_apellido         varchar(40),
	@i_celular             varchar(10),
	@i_direccion           varchar(80),
	@i_correo              varchar(20)
)
as
declare 
   @w_id_cliente   int

   select @w_id_cliente = max(id_cliente)+1
   from clientes

insert into clientes values(@w_id_cliente,upper(@i_nombre),upper(@i_apellido),upper(@i_celular),upper(@i_direccion),@i_correo)

-- select * from  clientes

-- delete from clientes where id_cliente>6

exec SPcrearCliente 'Juan Esteban','Morales','3112410587','calle 10 # 14-56 carrera 53 Barrio Ventilador','juan311@gmail.com'


