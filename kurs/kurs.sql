-- Количество друзей у пользователей
select p2.id, p2.nick , p2.login , fr.initiater_user_id , fr.target_user_id, COUNT(*) as total_friends
from profiles p2 
join friend_requests fr
	on (p2.id = fr.initiater_user_id or p2.id = fr.target_user_id)
	where fr.status = 'approved'
group by p2.id

-- ID друзей пользователя. 
select initiater_user_id from friend_requests where target_user_id = 35 and status = 'approved'
union
select target_user_id from friend_requests where initiater_user_id = 35 and  status = 'approved';

-- Имена друзей пользователя 
select 
	profiles.nick
from 
	profiles
where profiles.id in (select initiater_user_id from friend_requests where target_user_id = 35 and status = 'approved'
union
select target_user_id from friend_requests where initiater_user_id = 35 and  status = 'approved');

-- Сообщения, отправленные пользователю 1
select m.body, m.created_at 
from messages m
join profiles p2 
	on p2.id = m.to_user_id
where p2.id = 9;	

-- Сообщения, отправленные первым пользователем
select m.body, m.created_at 
from messages m
join profiles p2  
	on p2.id = m.from_user_id 
where p2.id =99;

-- Переписка пользователя 1
select  CONCAT(p3.nick,' ',p3.login) as recipent,
CONCAT(p4.nick,' ',p4.login) as sender,
m.body
from messages m
join profiles p2 
	on p2.id = m.to_user_id or p2.id = m.from_user_id
join profiles p3 
	on p3.id = m.to_user_id
join profiles p4 
	on p4.id = m.from_user_id
where p2.id = 99
order by created_at DESC;