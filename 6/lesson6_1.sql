-- Вложенные запросы
-- получение информкации о пользователе: имя, фамилия, город, фото
select 
	firstname, lastname, (select hometown from profiles where user_id = users.id) 'city' ,
(select filename from media where id = (select photo_id from profiles where user_id = users.id)) 'main_photo'
from 
	users
where
	id = 3;

select hometown from profiles where user_id = 1; -- Вложенное вырожение отдельно. От самого вложенного 
select * from profiles where user_id in (1,2,3,4,5); -- Для множества 


-- Выбираем фотографии пользователя
select filename from media where user_id = 3 and media_type_id = (select id from media_types where name like 'photO');
select id from media_types where name like 'photO';

-- Выбираем фотографии пользователя, зная email пользователя
select filename from media where user_id = 1;
select filename from media where user_id = (select id from users where email = 'arlo50@example.org')
and media_type_id = (select id from media_types where name like 'photo');


-- Выбираем видео, которые есть в новостях

select filename from media where user_id = 1 
and media_type_id = (select id from media_types where name like 'video');
select media_type_id from media where user_id = 1;

-- количество типов новостей, которые опубликовал пользователь
select COUNT(*) as numb, (select name from media_types mt where mt.id = media_type_id) as media
from media where user_id = 1 group by media_type_id;

-- Архив новостей: сколько новостей в каждом месяце было создано

select count(filename) as total_news, monthname(created_at) as `month` 
from media m group by `month`
order by total_news desc

-- Среднее количество новостей у пользователя

select avg(total_news) from (select count(filename) as total_news from media group by user_id) l

-- Выбираем друзей пользователя

select * from friend_requests 
where (target_user_id = 1 or target_user_id = 1) and status = 'approved';

-- Новости друзей

-- 1) получить идентификаторы друзей, чтобы использоывть в in
select * from media where user_id 
in (
-- идентификаторы друзей--
);
-- 2) id друзей которые отправили приглашения
select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved';
-- 3) id друзей которым 1 пользователь отправил приглашение
select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved';

-- 4) итог
select * from media where user_id = 1
union
select * from media where user_id 
in (
select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved'
union
select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved'
)
order by created_at DESC;

-- Подсчитываем лайки публикаций пользователя с id = 1

select count(media_id), media_id from likes 
where media_id in (select id from media where user_id = 1) group by media_id;

-- Выводим информацию о количестве непрочитанных сообщений

select * from messages where from_user_id = 1 or to_user_id =1;
-- добавим колонку is_read DEFAULT FALSE
ALTER TABLE messages ADD COLUMN is_read BOOL default false;

update messages
set is_read = 1
where created_at < DATE_SUB(NOW(),interval 1 YEAR);
select date_sub(now(), interval 1 hour);
select COUNT(*) from messages where (from_user_id = 1 or to_user_id =1) and is_read = 0;

-- Информация о друзьях с преобразованием пола и возраста
select 
	user_id,
	case (gender)
	when 'm' then 'мужчина'
	when 'f' then 'женщина'
	end as gender,
	timestampdiff(year, birthday, NOW()) as age,
	(select firstname from users where id = user_id) as name,
	(select lastname from users where id = user_id) as surname 
from profiles where user_id 
in (
select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved'
union
select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved'
)

-- уникальные имена из 100 первых

select distinct firstname from (select firstname from users order by id limit 100) as un;

--                                  Домашняя работа
-- 											1.
-- Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения
-- 1 получение информкации о пользователе: имя, фамилия, город, фото. (Интересней посмотреть побольше пользователей) 
select 
	firstname, lastname, (select hometown from profiles where user_id = users.id) 'city' ,
(select filename from media where id = (select photo_id from profiles where user_id = users.id)) 'main_photo'
from 
	users
where id in (1,3,5,7,12,14,16,18,32,42,12);
-- Выбираем фото и видео
select filename from media where user_id = 1
and media_type_id = (select id from media_types where name like 'photo')
or media_type_id = (select id from media_types where name like 'video');

-- Выбираем фотографии пользователя, зная email пользователя \ Добавим всякой фигни (Не получилось добавить когда id было больше двух
-- хотя испольщовал in. 
select filename from media where user_id in (select id from users where phone = '9546163253' 
or email = ('bosco.sage@example.net'))
and media_type_id = (select id from media_types where name like 'photo');

-- Выбираем друзей пользователя  \  Ошибка. условие OR работает на два одинаковых условия. 
select * from friend_requests 
where (target_user_id = 1 or target_user_id = 1) and status = 'approved';


-- 											2.
-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
select initiator_user_id, target_user_id from friend_requests 
where (initiator_user_id = 1 or target_user_id = 1) and status = 'approved';
