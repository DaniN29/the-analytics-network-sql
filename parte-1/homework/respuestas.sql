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
and venta + descuento + impuestos > 100000
--10
SELECT * FROM stg.order_line_sale
where fecha between '2022-10-1' and '2022-10-31'
--11
Select * from stg.product_master
where ean is not null
--12
SELECT * FROM stg.order_line_sale
where fecha between '2022-10-1' and '2022-11-10'
