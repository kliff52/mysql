select * from catalogs;
select id, name, catalog_id from products p ;
select id, name, catalog_id from products p where catalog_id = 1;
select id,name, catalog_id from products where catalog_id = (select id from catalogs where name = "Процессоры"); 

-- Найдем максимальное значение столбца 
select MAX(price) from products;  
select id, name, catalog_id from products where price = (select MAX(price) from products);

-- Найдем товары чья цена, ниже среднего 
select id, name,  catalog_id from products where price < (select AVG(price) from products);

-- Из каждого товара извлечем название каталога
-- Выведим список товарных позиций 
select id, name, catalog_id from products p ;

-- выводим название каталога
select name from catalogs where id = 1;

-- Подстовляем в вложенный запрос
select 
	products.id, 
	products.name,
	(select catalogs.name from catalogs where catalogs.id = products.catalog_id) as catalos
from 
	products;
	
-- Если результатом запроса будет множество значений то применяем in
select
	id,
	name,
	catalog_id
from 
	products
where 
	catalog_id in (select id from catalogs);
	
-- Для реализации отношений вырожений (>< >= <=)
-- используют оператор any
-- Есть ли в разделе материнские платы дешевле любой тов позии раздела процессоры  
select
	id,
	name,
	catalog_id
from 
	products
where 
	catalog_id = 2 and price < any(select price from products p2 where catalog_id = 1);

-- Синоним SOME 

select
	id,
	name,
	catalog_id
from 
	products
where 
	catalog_id = 2 and price < some(select price from products p2 where catalog_id = 1);

-- Когда нужно что бы вырожение выполнилось когда все из условый былы истенны используют all 
-- Давайте найдем все товары из разделы материнские платы каторые дороже любого товара из католога процессоры 
select
	id,
	name,
	catalog_id
from 
	products
where 
	catalog_id = 2 and price > ALL(select price from products p2 where catalog_id = 1);

-- для проверки того что результирующая таблица не пуста  exist, not exits
-- излечем те разделы каталого для которых имееться одна хотябы товарная позиция. 
select * from catalogs where EXISTS (select * from products where catalog_id = catalogs.id);
-- Нет не одного товара в группе
select * from catalogs where not EXISTS (select * from products where catalog_id = catalogs.id);

-- Болеее одного запроса во вложенном 
-- Вырожение перед in - конструктор строки. 
select
	id,
	name,
	price,
	catalog_id
from 
	products 
where 
	(catalog_id, 5060.00) 
in 
	(select id, price from catalogs);

-- Получим товарные позиции из раздела процесоры 
select id,name,price, catalog_id from products where catalog_id = 1;
 -- Среднию цену по этому разделу
 -- Два способа где вложенный запрос не нужен
select AVG(price) from (select * from products where catalog_id = 1) as prod;
select AVG(price) from products where catalog_id = 1;

-- Вычислить минимальную цену в разделах и найти среднию минимальных ценах
-- минимальные цены раздела
select catalog_id, MIN(price) from products group by catalog_id;
select 
	AVG(price)
from 
	(select min(price) as price
	from 
		products
	group by catalog_id) as prod;

-- join 

create table tbl1 (value varchar(255));
insert into tbl1 values ('fst1'),('fst2'),('fst3')
create table tbl2 (value varchar(255));
insert into tbl2 values ('snd1'),('snd2'),('snd3')

-- содержимое таблиц
select * from tbl1, tbl2;
select * from tbl1 join tbl2;
select tbl1.value, tbl2.value from tbl1, tbl2;

-- Соединим таблицы catalogs b products 
select 
	p.name,
	p.price,
	c.name 
from
	catalogs as c 
join 
	products as p;

-- Ограничение результатирующей таблицы условием.
select 
	p.name,
	p.price,
	c.name 
from
	catalogs as c 
join 
	products as p
on  -- (where) разница в том что on работает в момент соединения 
	c.id = p.catalog_id;

-- Самообьединение таблиц
select
	*
from 
	catalogs as fst
join
	catalogs as snd;

-- избавимся от повторов
select
	*
from 
	catalogs as fst
join
	catalogs as snd
on 
	fst.id = snd.id;

-- left join
select 
	p.name,
	p.price,
	c.name 
from
	catalogs as c 
left join 
	products as p
on  
	c.id = p.catalog_id;
-- rigt 
select 
	p.name,
	p.price,
	c.name 
from
	catalogs as c 
right join 
	products as p
on  -- (where) разница в том что on работает в момент соединения 
	c.id = p.catalog_id;

-- снизить цену на 10% для материнских плат 
update 
	catalogs 
join
	products 
on 
	catalogs.id = products.catalog_id 
set 
	price = price * 0.9
where 
	catalogs.name = 'Мат.платы';
 -- Посмотрим изменилась ли цена
 select 
	p.name,
	p.price,
	c.name 
from
	catalogs as c 
join 
	products as p
on  -- (where) разница в том что on работает в момент соединения 
	c.id = p.catalog_id;

-- Удалить товары и каталог мат. платы
delete 
	products, catalogs
from 
	catalogs 
join 
	products 
on
	catalogs.id = products.catalog_id 
where 
	catalogs.name = 'Мат.платы'; 

-- Удоление или обновление первиччного ключа.
show create table catalogs
-- Исправим тип таблицы продукст 
alter table products change catalog_id BIGINT unsigned default null;
-- Добовляем внешний ключ
alter table products 
add foreign key (catalog_id)
references catalogs (id)
on delete no action
on update no action;
-- Удалить ограничение клча
alter table products drop foreign key products_ibfk_1;
-- Указание имени огранечения ключа
alter table products 
add constraint fk_catalog_id 
foreign key (catalog_id)
references catalogs (id)
on delete no action
on update no action;
-- Добавим ограничение каскад 
alter table products 
add constraint fk_catalog_id 
foreign key (catalog_id)
references catalogs (id)
on delete cascade 
on update cascade;
-- Проверяем.
select* from catalogs;
select * from products;
-- Меняем индентификатор таблицы каталог
update catalogs set id = 6 where name = 'Процессоры';


-- ДЗ 

-- 1 Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
select * from orders;
select * from users;
select name from users where id in (select user_id from orders);
-- Правельное решение 
-- Вводим пользователей заказавших товар

insert into orders (user_id)
select id from users where name = 'Генадий';

insert into orders_products (order_id, product_id, total)
select last_insert_id(), id, 2 from products 
where name = 'Intel Core i5-7400';

insert into orders (user_id)
select id from users where name = 'Наталия';
insert into orders_products (order_id, product_id, total)
select last_insert_id(), id, 1 from products 
where name in ('Intel Core i5-7400','Gigabyte H310M S2h');

insert into orders (user_id)
select id from users where name = 'Иван';
insert into orders_products (order_id, product_id, total)
select last_insert_id(), id, 1 from products 
where name in ('AMD FX-8320','ASUS ROG MAXIMUS X HERO');
-- Извлечем список ИД всех пользователей которые делали заказ
select distinct user_id from orders;
-- формируем конечный запрос 
select id, name, birthday_at 
from users 
where 
id in (select distinct user_id from orders);
-- Еше вариант с join
select 
u.id, u.name, u.birthday_at
from 
users as u
join
orders as o 
on 
u.id = o.user_id;

-- 2  Выведите список товаров products и разделов catalogs, который соответствует товару.
select id, name, price  catalog_id, price from products;
select id from catalogs

select 
	products.id, 
	products.name,
	(select catalogs.name from catalogs where catalogs.id = products.catalog_id) as catalos
from 
	products;
-- Не понятно в чем отличее? 
select 
	p.id, 
	p.name,
	p.price,
	c.name as catalog 
from
	products as p  
left join 
	catalogs as c
on 
	p.catalog_id = c.id;
	
-- 3 Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
--  Поля from, to и label содержат английские названия городов, поле name — русское.
-- Выведите список рейсов flights с русскими названиями городов.
create table flights (
	id SERIAL PRIMARY key,
	from_in VARCHAR(255),
	to_in VARCHAR(255));
	
create table cities (
	id SERIAL PRIMARY key,
	label VARCHAR(255),
	name VARCHAR(255));

-- Выведите список рейсов flights с русскими названиями городов.
select * from flights;
-- Выводим преобразованное имя
select name from cities where label = 'Chelyabinsk'
-- Преоброзовали по столбцу
select name from cities where label in (select from_in from flights);
select name from cities where label in (select to_in from flights);
select id, from_in , to_in from flights;
select id, from_in in (select name from cities where label in (select from_in from flights)), to_in from flights; 
select 
	id,
	(select name from cities where label = flights.from_in) as `from`,
	(select name from cities where label = flights.to_in) as `to`
from 
	flights;

	
-- Либо join соединением 
select 
f.id,
cities_from.name as `from`,
cities_to as `to`
from 
flights as f
left join 
cities as cities_from
on 
f.from_in = cities_from.label
left join 
cities as cities_to
on 
f.to = cities_to.label;