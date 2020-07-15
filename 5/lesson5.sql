-- 1 Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
ALTER TABLE vk.users ADD created_at DATETIME NOT NULL;
alter table vk.users add update_at DATETIME not null:
UPDATE vk.users SET  created_at = NOW();
update vk.users set update_at = NOW();

-- 2 Таблица users была неудачно спроектирована. Записи created_at и updated_at 
-- были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10.
--  Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.

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

-- 3 В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля,
-- если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
-- Однако нулевые запасы должны выводиться в конце, после всех записей.
use test;
create table storehouses_products(
	id serial primary key,
	value int
);

insert into storehouses_products(value) values 
	('0'),('1'),('2'),('3'),('4'),('5'),('5'),('0');

select * from storehouses_products 
select id, value, if(value > 0 , 0 , 1) as sort from storehouses_products order by value;
select * from storehouses_products order by if(value > 0 , 0 , 1), value;  -- сортировать по (таблица sorted) , таблица value

-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
-- Месяцы заданы в виде списка английских названий (may, august)
-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
use test;
select student_id, surname, name, birthday from student2; 
-- Изменил формат записи дня рождения
update student2 
set
	birthday = str_to_date(birthday, '%d-%m-%Y');
-- Изминил тип таблицы
ALTER TABLE test.student2 MODIFY COLUMN birthday DATETIME
-- Вывел месяцы рождения
select name, surname, date_format(birthday , '%M') from student2;
-- Вывести имена тех кто родился в мае или августе. 
select name, surname, date_format(birthday , '%M')as DR from student2 where date_format(birthday , '%M') in ('may', 'august');

select student_id, name, FIELD (student_id, 5, 1, 2) as pos from student2 where student_id in (5,1,2);
select * from student2 where student_id  in (5,1,2) order by FIELD (student_id, 5,1,2); 

-- 4 Подсчитайте средний возраст пользователей в таблице users
select * from vk.users;
-- select * from test.student2 where DATE_FORMAT(FROM_DAYS(TO_DAYS(NOW())-TO_DAYS(`birthday`)), '%Y') AS age
select name, surname, timestampdiff(YEAR,birthday,now()) as TEST from test.student2;  -- Выбираем год, от даты рождения отнимаем сейчас.
select AVG(timestampdiff(year,birthday,now())) as valuess from test.student2;  -- Среднее значение по всем возростам студентов. 

-- 5 Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения
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

-- 6 (по желанию) Подсчитайте произведение чисел в столбце таблицы.
select id from test.users limit 5;
select round(exp(sum(ln(id)))) from test.users limit 1, 5;


