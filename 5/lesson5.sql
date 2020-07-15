-- 1 ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.
ALTER TABLE vk.users ADD created_at DATETIME NOT NULL;
alter table vk.users add update_at DATETIME not null:
UPDATE vk.users SET  created_at = NOW();
update vk.users set update_at = NOW();

-- 2 ������� users ���� �������� ��������������. ������ created_at � updated_at 
-- ���� ������ ����� VARCHAR � � ��� ������ ����� ���������� �������� � ������� 20.10.2017 8:10.
--  ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.

ALTER TABLE vk.users MODIFY COLUMN created_at VARCHAR(255)
ALTER TABLE vk.users MODIFY COLUMN update_at VARCHAR(255)
ALTER TABLE vk.users MODIFY COLUMN created_at DATETIME
ALTER TABLE vk.users MODIFY COLUMN update_at DATETIME
-- 2.1 
select str_to_date(created_at, '%Y-%m-%d %k:%i') from users;
update 
	users 
set
	created_at= str_to_date(created_at, '%Y-%m-%d %k:%i:%s'),
	update_at = str_to_date(update_at, '%Y-%m-%d %k:%i:%s');

select * from users;
describe users;
ALTER TABLE vk.users MODIFY COLUMN created_at DATETIME
ALTER TABLE vk.users MODIFY COLUMN update_at DATETIME 
update vk.users set update_at = NOW();

-- 3 � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 0, ���� ����� ���������� � ���� ����,
-- ���� �� ������ ������� ������. ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value.
-- ������ ������� ������ ������ ���������� � �����, ����� ���� �������.
use test;
create table storehouses_products(
	id serial primary key,
	value int
);

insert into storehouses_products(value) values 
	('0'),('1'),('2'),('3'),('4'),('5'),('5'),('0');

select * from storehouses_products 
select id, value, if(value > 0 , 0 , 1) as sort from storehouses_products order by value;
select * from storehouses_products order by if(value > 0 , 0 , 1), value;  -- ����������� �� (������� sorted) , ������� value

-- (�� �������) �� ������� users ���������� ������� �������������, ���������� � ������� � ���. 
-- ������ ������ � ���� ������ ���������� �������� (may, august)
-- (�� �������) �� ������� catalogs ����������� ������ ��� ������ �������.
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); ������������ ������ � �������, �������� � ������ IN.
use test;
select student_id, surname, name, birthday from student2; 
-- ������� ������ ������ ��� ��������
update student2 
set
	birthday = str_to_date(birthday, '%d-%m-%Y');
-- ������� ��� �������
ALTER TABLE test.student2 MODIFY COLUMN birthday DATETIME
-- ����� ������ ��������
select name, surname, date_format(birthday , '%M') from student2;
-- ������� ����� ��� ��� ������� � ��� ��� �������. 
select name, surname, date_format(birthday , '%M')as DR from student2 where date_format(birthday , '%M') in ('may', 'august');

select student_id, name, FIELD (student_id, 5, 1, 2) as pos from student2 where student_id in (5,1,2);
select * from student2 where student_id  in (5,1,2) order by FIELD (student_id, 5,1,2); 

-- 4 ����������� ������� ������� ������������� � ������� users
select * from vk.users;
-- select * from test.student2 where DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(`birthday`)), '%Y') AS age
select name, surname, timestampdiff(YEAR,birthday,now()) as TEST from test.student2;  -- �������� ���, �� ���� �������� �������� ������.
select AVG(timestampdiff(year,birthday,now())) as valuess from test.student2;  -- ������� �������� �� ���� ��������� ���������. 

-- 5 ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������.
-- ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������
select name, surname, birthday from test.student2;
select year(now()), MONTH(birthday), DAY(birthday) from student2; 
select 
date_format(DATE(concat_ws('-',year(now()), MONTH(birthday), DAY(birthday))), '%W') as day,
COUNT(*) as total 
from 
	student2 
group by 
	day
order by
	total desc;

-- 6 (�� �������) ����������� ������������ ����� � ������� �������.
select id from test.users limit 5;
select round(exp(sum(ln(id)))) from test.users limit 1, 5;


