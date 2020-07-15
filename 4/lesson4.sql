-- Äîáîâëÿåì ïîëå äëÿ ïàğîëÿ
ALTER TABLE vk.users ADD pass varchar(255) NOT NULL;
-- Ìåíÿåì ïîëå äëÿ ââîäà 
ALTER TABLE vk.users MODIFY COLUMN pass varchar(50)  NOT NULL;
ALTER TABLE vk.users MODIFY COLUMN phone VARCHAR(12) NULL;
ALTER TABLE vk.users MODIFY COLUMN phone VARCHAR(20) NULL;
alter table profiles add pass varchar (255) not null;


-- insert 1 
insert into users (id ,email, phone, pass)
values (1,'asdasd@asdas.ew','123-123-123','ASDweqe2'); 

insert into users (id,email, phone, pass,login)
values (2, 'asdasd@dsadassdas.ew','123-123-123','ASDqwd2222','Chikita banana'); 

insert into users (email, phone, pass,login)
values ('asasdsd@dqqdassdas.ew','123-123-123','Awe121212222','Chikita banana2'); 

insert into users (login,pass,email,phone) values
('Ruben','asdasd','asd@sdda.ru',123-321-123),
('Ruben','asdasd','asd@sdde2a.ru',153-321-163),
('Ruben','asdasd','asd@sddweqa.ru',113-331-173),
('Ruben','asdasd','asd@sddeda.ru',163-321-183),
('Ruben','asdasd','asd@sddfa.ru',173-341-193)
;

-- insert 2
insert into users
set
	login = 'qweqwadsa',
	email = 'sadsa@dsadsa.dq',
	phone = ' 312-234-123',
	pass = 'asdasdas';

-- insert 3 
insert into vk.users(login, email, phone, pass) -- Âñòîâëÿòü 
select vk2.users.lastname, vk2.users.email, vk2.users.phone, test.users.pass from vk2.users  -- Âûáèğàòü äëÿ 
join test.users 																				-- Ïğèñîåäèíèòü òàáëèöó
on test.users.id = vk2.users.id																	-- ê òàáëè÷êå  ïî ïîëş èä
where vk2.users.id > 10;

-- insert profiles
insert into profiles (user_id, name, lastname, hometown ) -- Âûáèğàåì èç ïğîôåëåé
select student_id, name, surname, city from test.student where name = 'Îëüãà' -- Äîáîâëÿåì â òàáëè÷êó âñåõ ñ èìåíåì Îëüãà

-- update  Çàìåíà ïî id
update users 
set
	login = 'lost' 
where id = 1;

-- SELECT

select 'hello world';
select * from profiles limit 20; -- âûáğàòü âñå çíà÷åíèÿ èç òàáëèöû ïğîôèëåé. 20 ëèìèò. 
select name, lastname from profiles limit 20;  -- âûáğàòü òîëüêî èìÿ è ôàìèëèÿ òàáëèöû ïğîôèëè ñ ëèìèòîì â 20 çàïèñåé.
select distinct name from profiles;  -- âûáîğ óíèêàëüíûõ èìåí 
select name, lastname, hometown from profiles where hometown = 'Âîëãîãğàä'; 
select name, lastname, hometown from profiles where name = 'Èğèíà' and id > 10;
select name, lastname, hometown from profiles where name in ('Şëèÿ', 'Àëåêñåé','Ñâåòëàíà','Äìèòğèé') and lastname in ('Ìèõååâà','Ìèøèíà');
select name, lastname, hometown from profiles where name not in ('Şëèÿ', 'Àëåêñåé','Ñâåòëàíà','Äìèòğèé');
select * from users where id >= 20 and id <=40;
select * from users where id between 20 and 40;
select hometown, name, lastname from profiles where hometown like 'Íàõîäêà';
select hometown, name, lastname from profiles where hometown like 'Íàõîäê%'; -- Íàçâàíèå íà÷èíàåòüñÿ íà ÍÀÕÎÄÊ
select hometown, name, lastname from profiles where hometown like '%àâ%'; -- Èìååò â ñåğåäèíå ÀÂ 
select hometown, name, lastname from profiles where hometown like '%ê_'; -- Èìååò îäèí ñèìâîë. _ - îäèí ñèìâîë
select 'Íàøè äàííûå ÷åğåç êîíñò', hometown, name, lastname from profiles where hometown like 'Íàõîäêà';
select concat(name,' ',lastname) as fulname from profiles limit 20;  -- Îáüåäåíåíèå ñòğîêè. È ïğèñâàèâàíèå ïñåâäàíèìà. 
select count(*) from profiles; -- Êîëè÷åñòâà
select count(*) from users;
select count(photo_id) from profiles;
select count(distinct hometown) from profiles where hometown like 'Íà%';  -- ñêîëüêî óíèêàëüíûõ çíà÷åíèé íà÷èíàşòüñÿ íà 'Íà'
select count(hometown) as total_city ,hometown from profiles group by hometown;  -- Êîëè÷åñòâî ïîâòîğÿşùèõñÿ ãîğîäîâ â ñïèñêå. 
select count(hometown) as total_city ,hometown from profiles group by hometown order by total_city; -- Ñîğòèğîâêàé íà óâåëè÷åíèå. 
select count(hometown) as total_city ,hometown from profiles group by hometown order by total_city DESC; -- ïî óáûâàíèş
select count(hometown) as total_city ,hometown from profiles group by hometown having total_city >= 3;

update users
set phone = null 
where phone = '';
select * from users where phone is null; 
select * from users where phone = null; 

-- TRUNCATE
truncate table student;
delete from student where student_id >= 1200; 