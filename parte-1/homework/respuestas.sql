--1
select * from stg.product_master
where categoria = 'Electro'

--2
select * from stg.product_master
where origen = 'China'
--3
Select * from stg.product_master
where categoria = 'Electro'
order by nombre
--4
Select * from stg.product_master
where subcategoria = 'TV'
and is_active = true
--5
Select * from stg.store_master
Order by fecha_apertura
--6
SELECT * FROM stg.order_line_sale
order by fecha desc
limit 5
--7
SELECT * FROM stg.super_store_count
Order by fecha
Limit 10
--8
Select * from stg.product_master
where categoria = 'Electro'
And subsubcategoria not in ('Soporte' , 'Control remoto')
--9
SELECT * FROM stg.order_line_sale
where moneda = 'ARS'
and venta + coalesce (descuento,0) + impuestos > 100000
--10
SELECT * FROM stg.order_line_sale
where fecha between '2022-10-1' and '2022-10-31'
--11
Select * from stg.product_master
where ean is not null
--12
SELECT * FROM stg.order_line_sale
where fecha between '2022-10-1' and '2022-11-10'

--Clase 2

--1
select distinct pais from stg.store_master
--2
Select count (codigo_producto),categoria from stg.product_master
group by categoria
--3
SELECT orden FROM stg.order_line_sale
where moneda = 'ARS'
and venta + descuento + impuestos > 100000
--4
Select  descuento, moneda FROM stg.order_line_sale
where descuento is not null
Order by moneda
--5
select sum(impuestos) as totimp from stg.order_line_sale
where moneda = 'EUR'
and cast (fecha as text) like '2022%'
--6
Select count (distinct orden) from stg.order_line_sale
Where creditos is not null

--7	
select  tienda, round(SUM(descuento)/SUM(Venta)*100,2) as descotorg from stg.order_line_sale
group by tienda
--8
select tienda, avg((inicial+final)/2) from stg.inventory
group by tienda
--9
select producto, sum(venta-coalesce(descuento,0)) as ventnet, sum(coalesce(descuento,0))*(-1)/sum(venta)*100 as porcdesc
from stg.order_line_sale
group by product
--10
select tienda, cast(fecha as varchar(10)),conteo from stg.market_count union all select tienda, cast(fecha as varchar(10)),conteo from stg.super_store_count
--11
select * from stg.product_master
where nombre like '%PHILIPS%'
and is_active = true
--12
select tienda, moneda, sum(venta) as ventas from stg.order_line_sale
group by tienda, moneda
order by ventas desc
--13
select  producto, moneda, AVG (venta+coalesce(descuento,0)+impuestos) as ventaprom  from stg.order_line_sale
group by producto,moneda
14
select orden, impuestos/venta*100 as tasa  from stg.order_line_sale

-- Clase 3

--1
select nombre, codigo_producto, categoria,  coalesce (color,'unknown') as color  from stg.product_master
where nombre like '%PHILIPS%' 
or nombre like '%Samsung%'
--2
select  sum(venta) as venta, sum(impuestos) as impuestos, moneda, provincia, pais from stg.order_line_sale o left join stg.store_master m
on o.tienda = m.codigo_tienda
group by m.pais, m.provincia, o.moneda	
--3
select  sum(venta+coalesce(descuento,0)+impuestos) as ventatotal,subcategoria, moneda from stg.order_line_sale o left join stg.product_master m 
on o.producto = m.codigo_producto
group by moneda, subcategoria

--4
select sum(cantidad) as sumcantidad, subcategoria, concat(pais,'-',provincia) as lugar from stg.order_line_sale o
left join stg.product_master m 
on o.producto = m.codigo_producto
left join stg.store_master s
on o.tienda = s.codigo_tienda
group by subcategoria, lugar
order by lugar
--5
select nombre, sum(coalesce(conteo,0)) as totconteo from stg.store_master m left join stg.super_store_count s
on m.codigo_tienda = s.tienda
group by m.nombre 
-- no hay datos con fecha anterior a la fecha de apertura
--6
select nombre, sku, (avg(inicial) + avg(final))/2 as invprom , substring (cast(fecha as text), 1, 7) mes from stg.inventory i left join stg.store_master s
on i.tienda = s.codigo_tienda
group by s.nombre, mes, i.sku
--7
with stg_material as (
select lower(coalesce (material, 'unknown')) materialhom, sum(cantidad) cantidad from stg.order_line_sale o left join stg.product_master p
on o.producto = p.codigo_producto
group by p.material)
Select materialhom, Sum(cantidad)
from stg_material
group by materialhom
 --8
select  ols.*, case when moneda = 'EUR' then venta / cotizacion_usd_eur when moneda = 'ARS' then venta / cotizacion_usd_peso when moneda = 'URU' then venta / cotizacion_usd_uru else venta  end as ventausd
from stg.order_line_sale as ols
left join stg.monthly_average_fx_rate as mafr 
on date_part('month',ols.fecha) = date_part('month',mafr.mes)  
--9
with stg_ventasusd as (
select  ols.*, case when moneda = 'EUR' then venta / cotizacion_usd_eur when moneda = 'ARS' then venta / cotizacion_usd_peso when moneda = 'URU' then venta / cotizacion_usd_uru else venta  end as ventausd
from stg.order_line_sale as ols
left join stg.monthly_average_fx_rate as mafr 
on date_part('month',ols.fecha) = date_part('month',mafr.mes)  )
Select sum (ventausd) from stg_ventasusd
--10
with stg_ventasusd as (
select  ols.*, case when moneda = 'EUR' then venta-coalesce(descuento,0) / cotizacion_usd_eur when moneda = 'ARS' then venta-coalesce(descuento,0) / cotizacion_usd_peso when moneda = 'URU' then venta-coalesce(descuento,0) / cotizacion_usd_uru else venta-coalesce(descuento,0)  end as ventausd
from stg.order_line_sale as ols
left join stg.monthly_average_fx_rate as mafr 
on date_part('month',ols.fecha) = date_part('month',mafr.mes)  )
Select v.*, ventausd-coalesce(costo_promedio_usd,0) as margen from stg_ventasusd v
left join stg.cost c
on v.producto = c.codigo_producto
--11
select orden, subcategoria, count (distinct producto) from stg.order_line_sale o left join stg.product_master p
 on o.producto = p.codigo_producto
 group by orden, subcategoria
 
 -- Clase 4
 
 --1

create schema bkp;
select * into bkp.product_master_09042023
from stg.product_master
--2
Update bkp.product_master_09042023 set material = 'N/A' where material is null
Update bkp.product_master_09042023 set color = 'N/A' where color is null
--3
Update bkp.product_master_09042023 set is_active = false where subsubcategoria = 
'Control remoto'
--4
Alter table  bkp.product_master_09042023 add is_local boolean;
update bkp.product_master_09042023 set is_local = true where origen = ‘Argentina’
--5
Alter table stg.order_line_sale add line_key varchar(255);
update stg.order_line_sale set line_key = concat_ws ('-',orden,producto);
--6
delete from stg.order_line_sale where pos = 1;
--7
CREATE  TABLE stg.employees (
                        id serial primary key,
                        nombre VARCHAR,
                        apellido VARCHAR,
                        fecha_entrada DATE,
                        fecha_salida DATE,
                        telefono VARCHAR,
                        pais VARCHAR,
                        provincia VARCHAR,
                        codigo_tienda INt,
                        posicion VARCHAR);
--8
insert into stg.employees 
                       ( nombre ,
                        apellido,
                        fecha_entrada ,
                        fecha_salida ,
                        telefono ,
                        pais,
                        provincia,
                        codigo_tienda,
                        posicion)
						VALUES
						('Juan', 'Perez', '2022-01-01',null,541113869867, 'Argentina', 'Santa Fe', 2, 'Vendedor');
Luego lo corri también con VALUES						(‘Ana', 'Valdez', '2022-03-01','2022-03-01',null, 'Espania', 'Madrid', 8, 'Jefe Logistica'),('Catalina', 'Garcia', '2020-02-21',null,null, 'Argentina', 'Buenos Aires', 2, 'Representante Comercial'), ('Fernando', 'Moralez', '2022-04-04',null,null, 'Espania', 'Valencia', 9, 'Vendedor');
--9
select *,  -- selecciona todo desde la tabla stg.cost
now() as last_updated_ts  -- agrega fecha y hora en la nueva columna last_updated_ts
INTO bkp.cost_20231104
FROM stg.cost






