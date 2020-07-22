select * from catalogs;
select id, name, catalog_id from products p ;
select id, name, catalog_id from products p where catalog_id = 1;
select id,name, catalog_id from products where catalog_id = (select id from catalogs where name = "����������"); 

-- ������ ������������ �������� ������� 
select MAX(price) from products;  
select id, name, catalog_id from products where price = (select MAX(price) from products);

-- ������ ������ ��� ����, ���� �������� 
select id, name,  catalog_id from products where price < (select AVG(price) from products);

-- �� ������� ������ �������� �������� ��������
-- ������� ������ �������� ������� 
select id, name, catalog_id from products p ;

-- ������� �������� ��������
select name from catalogs where id = 1;

-- ����������� � ��������� ������
select 
	products.id, 
	products.name,
	(select catalogs.name from catalogs where catalogs.id = products.catalog_id) as catalos
from 
	products;
	
-- ���� ����������� ������� ����� ��������� �������� �� ��������� in
select
	id,
	name,
	catalog_id
from 
	products
where 
	catalog_id in (select id from catalogs);
	
-- ��� ���������� ��������� ��������� (>< >= <=)
-- ���������� �������� any
-- ���� �� � ������� ����������� ����� ������� ����� ��� ����� ������� ����������  
select
	id,
	name,
	catalog_id
from 
	products
where 
	catalog_id = 2 and price < any(select price from products p2 where catalog_id = 1);

-- ������� SOME 

select
	id,
	name,
	catalog_id
from 
	products
where 
	catalog_id = 2 and price < some(select price from products p2 where catalog_id = 1);

-- ����� ����� ��� �� ��������� ����������� ����� ��� �� ������� ���� ������� ���������� all 
-- ������� ������ ��� ������ �� ������� ����������� ����� ������� ������ ������ ������ �� �������� ���������� 
select
	id,
	name,
	catalog_id
from 
	products
where 
	catalog_id = 2 and price > ALL(select price from products p2 where catalog_id = 1);

-- ��� �������� ���� ��� �������������� ������� �� �����  exist, not exits
-- ������� �� ������� �������� ��� ������� �������� ���� ������ �������� �������. 
select * from catalogs where EXISTS (select * from products where catalog_id = catalogs.id);
-- ��� �� ������ ������ � ������
select * from catalogs where not EXISTS (select * from products where catalog_id = catalogs.id);

-- ������ ������ ������� �� ��������� 
-- ��������� ����� in - ����������� ������. 
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

-- ������� �������� ������� �� ������� ��������� 
select id,name,price, catalog_id from products where catalog_id = 1;
 -- ������� ���� �� ����� �������
 -- ��� ������� ��� ��������� ������ �� �����
select AVG(price) from (select * from products where catalog_id = 1) as prod;
select AVG(price) from products where catalog_id = 1;

-- ��������� ����������� ���� � �������� � ����� ������� ����������� �����
-- ����������� ���� �������
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

-- ���������� ������
select * from tbl1, tbl2;
select * from tbl1 join tbl2;
select tbl1.value, tbl2.value from tbl1, tbl2;

-- �������� ������� catalogs b products 
select 
	p.name,
	p.price,
	c.name 
from
	catalogs as c 
join 
	products as p;

-- ����������� ���������������� ������� ��������.
select 
	p.name,
	p.price,
	c.name 
from
	catalogs as c 
join 
	products as p
on  -- (where) ������� � ��� ��� on �������� � ������ ���������� 
	c.id = p.catalog_id;

-- ��������������� ������
select
	*
from 
	catalogs as fst
join
	catalogs as snd;

-- ��������� �� ��������
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
on  -- (where) ������� � ��� ��� on �������� � ������ ���������� 
	c.id = p.catalog_id;

-- ������� ���� �� 10% ��� ����������� ���� 
update 
	catalogs 
join
	products 
on 
	catalogs.id = products.catalog_id 
set 
	price = price * 0.9
where 
	catalogs.name = '���.�����';
 -- ��������� ���������� �� ����
 select 
	p.name,
	p.price,
	c.name 
from
	catalogs as c 
join 
	products as p
on  -- (where) ������� � ��� ��� on �������� � ������ ���������� 
	c.id = p.catalog_id;

-- ������� ������ � ������� ���. �����
delete 
	products, catalogs
from 
	catalogs 
join 
	products 
on
	catalogs.id = products.catalog_id 
where 
	catalogs.name = '���.�����'; 

-- �������� ��� ���������� ����������� �����.
show create table catalogs
-- �������� ��� ������� �������� 
alter table products change catalog_id BIGINT unsigned default null;
-- ��������� ������� ����
alter table products 
add foreign key (catalog_id)
references catalogs (id)
on delete no action
on update no action;
-- ������� ����������� ����
alter table products drop foreign key products_ibfk_1;
-- �������� ����� ����������� �����
alter table products 
add constraint fk_catalog_id 
foreign key (catalog_id)
references catalogs (id)
on delete no action
on update no action;
-- ������� ����������� ������ 
alter table products 
add constraint fk_catalog_id 
foreign key (catalog_id)
references catalogs (id)
on delete cascade 
on update cascade;
-- ���������.
select* from catalogs;
select * from products;
-- ������ �������������� ������� �������
update catalogs set id = 6 where name = '����������';


-- �� 

-- 1 ��������� ������ ������������� users, ������� ����������� ���� �� ���� ����� orders � �������� ��������.
select * from orders;
select * from users;
select name from users where id in (select user_id from orders);
-- ���������� ������� 
-- ������ ������������� ���������� �����

insert into orders (user_id)
select id from users where name = '�������';

insert into orders_products (order_id, product_id, total)
select last_insert_id(), id, 2 from products 
where name = 'Intel Core i5-7400';

insert into orders (user_id)
select id from users where name = '�������';
insert into orders_products (order_id, product_id, total)
select last_insert_id(), id, 1 from products 
where name in ('Intel Core i5-7400','Gigabyte H310M S2h');

insert into orders (user_id)
select id from users where name = '����';
insert into orders_products (order_id, product_id, total)
select last_insert_id(), id, 1 from products 
where name in ('AMD FX-8320','ASUS ROG MAXIMUS X HERO');
-- �������� ������ �� ���� ������������� ������� ������ �����
select distinct user_id from orders;
-- ��������� �������� ������ 
select id, name, birthday_at 
from users 
where 
id in (select distinct user_id from orders);
-- ��� ������� � join
select 
u.id, u.name, u.birthday_at
from 
users as u
join
orders as o 
on 
u.id = o.user_id;

-- 2  �������� ������ ������� products � �������� catalogs, ������� ������������� ������.
select id, name, price  catalog_id, price from products;
select id from catalogs

select 
	products.id, 
	products.name,
	(select catalogs.name from catalogs where catalogs.id = products.catalog_id) as catalos
from 
	products;
-- �� ������� � ��� �������? 
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
	
-- 3 ����� ������� ������� ������ flights (id, from, to) � ������� ������� cities (label, name).
--  ���� from, to � label �������� ���������� �������� �������, ���� name � �������.
-- �������� ������ ������ flights � �������� ���������� �������.
create table flights (
	id SERIAL PRIMARY key,
	from_in VARCHAR(255),
	to_in VARCHAR(255));
	
create table cities (
	id SERIAL PRIMARY key,
	label VARCHAR(255),
	name VARCHAR(255));

-- �������� ������ ������ flights � �������� ���������� �������.
select * from flights;
-- ������� ��������������� ���
select name from cities where label = 'Chelyabinsk'
-- ������������� �� �������
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

	
-- ���� join ����������� 
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