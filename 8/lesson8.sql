-- Выборка данных по пользователю
select firstname, lastname, email, phone, gender, birthday, hometown
from users
join profiles
on users.id = profiles.user_id
where id = 1;

-- Выборка новостей пользователя
select m.user_id, m.body, m.created_at, u.firstname, u.lastname 
from media m
join users u
	on m.user_id = u.id
where u.id = 1;

-- Сообщения, отправленные пользователю 1

select m.body, m.created_at 
from messages m
join users u 
	on u.id = m.to_user_id
where u.id = 1;	

-- Сообщения, отправленные первым пользователем

select m.body, m.created_at 
from messages m
join users u 
	on u.id = m.from_user_id 
where u.id = 1;

-- Переписка пользователя 1
select m.body, m.created_at, m.from_user_id, m.to_user_id, CONCAT(u2.firstname,' ',u2.lastname) as recipent,
CONCAT(u3.firstname,' ',u3.lastname) as sender
from messages m
join users u 
	on u.id = m.to_user_id or u.id = m.from_user_id
join users u2 
	on u2.id = m.to_user_id
join users u3 
	on u3.id = m.from_user_id
where u.id = 1
order by created_at DESC;

-- Количество друзей у пользователей

select u.id, u.firstname, u.lastname, COUNT(*) as total_friends from users u
join friend_requests fr
	on (u.id = fr.initiator_user_id or u.id = fr.target_user_id)
	where fr.status = 'approved'
group by u.id

-- Новости друзей (лента новостей)
select media.* 
from media where user_id = 1
union
select m.* from media m
join friend_requests fr 
	on m.user_id = fr.target_user_id
join users u
	on fr.initiator_user_id = u.id
where u.id = 1 and fr.status = 'approved'
UNION
select m.* from media m
join friend_requests fr 
	on m.user_id = fr.initiator_user_id
join users u
	on fr.target_user_id = u.id
where u.id = 1 and fr.status = 'approved';


-- Публикации пользователя 1 с кол-вом лайков

select m.filename, mt.name, count(*) as total_likes  from media m
join media_types mt 
	on m.media_type_id = mt.id
join likes l 
	on m.id = l.media_id
where m.user_id = 1
group by m.id;

-- Публикации пользователей с кол-вом лайков
select m.filename, mt.name, count(*) as total_likes, concat(u.firstname, ' ', u.lastname ) as owner from media m
join media_types mt 
	on m.media_type_id = mt.id
join likes l 
	on m.id = l.media_id
join users u
	on u.id = m.user_id 
group by m.id;

-- Количество групп у пользователей
select u.firstname, u.lastname, count(*) as total_communities from users_communities uc
join users u
	on u.id = uc.user_id 
group by u.id;

-- Среднее количество групп у всех пользователей
select AVG(total_communities) from
(select u.firstname, u.lastname, count(*) as total_communities from users_communities uc
join users u
	on u.id = uc.user_id 
group by u.id) as count_communities

-- 3 пользователей с наибольшим количеством лайков за медиафайлы
select count(*) as total_likes, concat(u.firstname, ' ', u.lastname ) as owner from media m
join likes l 
	on m.id = l.media_id
join users u
	on u.id = m.user_id 
group by u.id
order by total_likes DESC
limit 3;

-- количество пользователей в сообществах
select c.name, count(*) as total_users from users_communities uc
join communities c
	on c.id = uc.community_id
group by c.id