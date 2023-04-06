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
Select distinct count (codigo_producto),categoria from stg.product_master
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
Select count (creditos) as cantcred from stg.order_line_sale
Where creditos is not null
--7	
select  tienda, round(SUM(descuento)/SUM(Venta)*100,2) as descotorg from stg.order_line_sale
group by tienda
--8
select avg(inicial+final)/2 from stg.inventory
group by tienda
--9
select producto, sum(venta-coalesce(descuento,0)) as ventnet, sum(coalesce(descuento,0))*(-1)/sum(venta)*100 as porcdesc
from stg.order_line_sale
group by product
--10
select * from stg.market_count as latam  full outer join stg.super_store_count as europe
on latam.tienda = europe.tienda
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

