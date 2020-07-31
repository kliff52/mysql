-- ����������
create table accounts (
	id serial primary key,
	user_id INT,
	total DECIMAL (11,2) comment '����',
	created_at DATETIME default CURRENT_TIMESTAMP,
	updated_at DATETIME default current_TIMESTAMP on update current_TIMESTAMP
	) comment  = '����� ������������� � ��������� ��������';

	insert into accounts (user_id, total) values
	(4,5000.00),
	(3,0.00),
	(2,200.00),
	(null,25000.00);
	
select * from accounts;

start transaction;
select total from accounts where user_id = 4;
update accounts set total = total - 2000 where user_id = 4;
update accounts set total = total + 2000 where user_id is null;
select * from accounts;
commit;

-- �������� ����������
start transaction; 
update accounts set total = total - 2000 where user_id = 4;
update accounts set total = total + 2000 where user_id is null;
rollback;
-- ����� ����������
start transaction;
select total from accounts where user_id = 4;
savepoint accounts_4
update accounts set total = total - 2000 where user_id = 4;
rollback to savepoint accounts_4; 
select * from accounts;

-- ���������� ����������. ����� ������� ����� ��� ����������. 
set autocommit = 0;
-- ��� ���������� ������������������ �������� ����� ������ 
-- commite; 
-- rollback ��� �� ������. 
-- ��� ��������� ������ �������������� ���������� ���������� �������� 
set autocommit = 1;
-- �������� ������� ��������� ����������.
 set transaction isolation level read committed;

-- ��������� ������� ����������. 
show variables like 'innodb_log%';
-- ���� � �������� ������. 
show variables like 'datadir';
-- ���������� ����� ���������� ������� ���������� 
set global innodb_flush_log_at_trx_commit=0;

-- ���������� ��������� ����������. 
select @total := COUNT(*) from accounts;
select @total;
select * from accounts;
select @ptice := max(total) from accounts;
select * from accounts where total = @ptice; 
set @last = now() - interval 7 day;
select CURDATE(), @last;

-- ������������� ������� 
select * from tbl1;
set @start := 0;
select @start:= @start + 1 as id, value from tbl1; 

-- �������� ������ ������ ���������� 
show VARIABLES;

-- ��������� ������� 
create temporary table temp (id int, name VARCHAR(255));
show tables;
describe temp;
-- ��������� ������� ��������� � ��������� ����� ibtmp1 

-- ������������ ������� 
 prepare ver from 'SELECT VERSION()';
 execute ver; 
 
prepare prd from 'SELECT id, name, price FROM products where catalog_id = ?';
set @catalog_id = 6;
execute prd using @catalog_id; 
drop prepare prd;

-- �������������. 
select * from catalogs;
create view cat as select * from catalogs order by name; 
select 	* from cat;
-- 
show tables;
create view cat_revers (`catalog`, catalog_id) as select name, id from catalogs;
select * from cat_revers; 
-- ��� �� �������� ���������� ������������� ���������� create or replace 
create or replace view namecat (id,name,total) as select id, name, length(name) from catalogs ;
select * from namecat order by total desc;

-- ������ ������������� ��������� �������. 
create algorithm = TEMPTABLE view cat2 as select * from catalogs; 
describe products; 
-- ������������ ������������� �������� 
create or replace view prod as
select id, name, price, catalog_id
from products
order by catalog_id, name;

select * from prod order by name desc;
-- �������� ������������� ������ ���������� 
create or replace view processors as 
select id,name,price, catalog_id
from products 
where catalog_id = 2;

select * from processors; 

-- ������� ������ ����� ������������� 
create view v1 as select * from tbl1 where value < 'fst5'
with check option;
insert into v1 values ('fst4');
insert into v1 values ('fst5');

alter view v1 as select * from tbl1 where value > 'fst4'
with check option;

create or replace view v1 as select * from tbl1 where value > 'fst4'
with check option;

drop view cat, namecat, prod, processors, v1;
drop view if exists cat, namecat, prod, processors, v1;

-- ����������������� MYSQ 

show variables like 'date%_format';
show variables like 'time_format';
show variables like 'system_time_zone';
set session tmp_table_size = 167772;
show variables like 'log_error';
show variables like 'general_log%';
show processlist;
kill id; 
create user name identifles with sha256_password by 'pass';
select user;
select Host,User from mysql.user;
drop user name; 
rename user name1 to name2;
grant all on *.* to 'foo'@'localhost' IDENTIFIED with sha256_password by 'pass';
revoke all on *.* to 'foo'@'localhost';
show grants;

-- My.cnf
-- ���������� ���� �������� 

-- �������� ������� � �������� 
call my_version();
-- ������ ���� �������� ��������
show procedure STATUS like 'my_version%'
-- ������ �������. 
select name, type from mysql.proc limit 10;
show create procedure my_version;
drop procedure my_version;
drop procedure if exists my_version; 
-- ����� �������. 
delimiter //
select get_version();

-- ���� ���������� 
-- IN ������ ����������� ������ ������ �������� ���������
-- OUT ������ ����������� ������ �� ��������  ���������.
-- INOUT ������ ����������� ��� ������ ��������� ��� � �� ���� �� ��������.
delimiter // 
create procedure set_x (in value INT)
begin
	set @x = value;
end 

call set_x(123456) 
select @x 

drop procedure if exists set_x
create procedure set_x (in value INT)
begin
	set @x = value;
	set value = value - 1000;
end 
set @y = 1000
call set_x(@y)
select @x , @y

drop procedure if exists set_x
create procedure set_x (OUT value INT)
begin
	set @x = value;
	set value = 1000;
end 
set @y = 10000
call set_x(@y)
select @x , @y

drop procedure if exists set_x
create procedure set_x (INOUT value INT)
begin
	set @x = value;
	set value = value -  1000;
end 
set @y = 10000
call set_x(@y)
select @x , @y

-- 

create procedure declare_var()
begin 
	declare id,num INT(11) default 0;
	declare name,hello, temp tinytext;
end
-- 
drop procedure if exists declare_var
create procedure declare_var()
begin 
	declare var tinytext default '������� ����������';
	begin
		declare var tinytext default '��������� ����������';
		select var;
	end;
	select var;
end

call declare_var(); 
-- 
create procedure one_declare_var()
begin 
	declare var tinytext default '������� ����������';
	begin
		select var;
	end;
	select var;
end
call one_declare_var(); 

-- ������������� ���������� 

drop FUNCTION if exists second_format;
create FUNCTION second_format(seconds INT)
returns VARCHAR(255) deterministic
begin 
	declare days, hours, minutes int;
	set days = FLOOR (seconds / 86400);
	set seconds = seconds - days * 86400;
	set hours = FLOOR (seconds / 3600);
	set seconds = seconds - hours * 3600;
	set minutes = FLOOR (seconds / 60);
	set seconds = seconds - minutes * 60;
	
	return CONCAT(days, 'days',
				hours, 'hours',
				minutes, 'minuts',
				seconds, 'seconds');
end;

select second_format(213131321)
-- 
create procedure numcatalog (out total INT)
begin 
	select COUNT(*) into total from catalogs;
end 
call numcatalog (@a)
select @a

-- 

create procedure format_now (format CHAR(4))
begin
	if(format = 'date') then 
		select DATE_FORMAT(now(), "%d.%m.%Y") as format_now;
	end if;
	if(format = 'time') then 
		select DATE_FORMAT(now(), "%H.%i.%s") as format_now;
	end if;
end 
call format_now('date') 
call format_now('time') 

-- 
drop procedure if exists format_now
create procedure format_now (format CHAR(4))
begin
	if(format = 'date') then 
		select DATE_FORMAT(now(), "%d.%m.%Y") as format_now;
	else
		select DATE_FORMAT(now(), "%H.%i.%s") as format_now;
	end if;
end 
call format_now('date') 
call format_now('time') 

-- 
drop procedure if exists format_now
create procedure format_now (format CHAR(4))
begin
	if(format = 'date') then 
		select DATE_FORMAT(now(), "%d.%m.%Y") as format_now;
	elseif (format = 'time') then 
		select DATE_FORMAT(now(), "%H.%i.%s") as format_now;
	else 
		select unix_timestamp(now()) as format_now; 
	end if;
end 
call format_now('date') 
call format_now('time') 
call format_now('tims') 

-- 
drop procedure if exists format_now
create procedure format_now (format CHAR(4))
begin 
	case format 
		when 'date' then 
			select DATE_FORMAT(now(), "%d.%m.%Y") as format_now;
		when 'time'then
			select DATE_FORMAT(now(), "%H.%i.%s") as format_now;
		when 'secs' then
			select unix_timestamp(now()) as format_now;
		else 
			select '������ � �������� format';
		end case;
end
call format_now('date') 
call format_now('time') 
call format_now('secs')

-- WHILE REPEAT LOOP 
create procedure now3 ()
begin 
	declare i int default 3;
	while i > 0 do
		select now();
		set i = i - 1;
	end while;
end 
call now3

-- 
create procedure nown (in num int)
begin 
	declare i int default 0;
	if (num > 0) then 
		while i < num do
			select now();
			set i = i +1;
		end while;
	else 
		select '��������� �������� ���������';
	end if;
end
call nown(3)

-- 
drop procedure if exists nown
create procedure nown (in num int)
begin 
	declare i int default 0;
	if (num > 0) then 
		cycle: while i < num do
			if i >= 2 then leave cycle;
			end if;
			select now();
			set i = i +1;
		end while cycle;
	else 
		select '��������� �������� ���������';
	end if;
end
call nown(3111)

-- iterate

create procedure numbers_string (in num int)
begin 
	declare i INT default 0;
	declare bin tinytext default '';
	if (num > 0) then 
		cycle: while i < num DO
			set i = i +1 ;
			set bin = CONCAT(bin, i);
			if i > CEILING(num/2) then  iterate cycle;
			end if;
			set bin = CONCAT(bin,i);
		end while cycle;
		select bin;
	else 
		select '��������� �������� ���������';
	end if;
end
call numbers_string(9) 

-- repeat
drop procedure if exists now3
create procedure now3()
begin 
	declare i int default 3;
	repeat
		select now();
		set i = i -1;
	UNTIL i <= 0
	end repeat;
end
call now3

-- loop
drop procedure if exists now3
create procedure now3()
begin 
	declare i int default 3;
	cycle: LOOP
		select now();
		set i = i -1;
		if  i <= 0 then leave cycle;
		end if;
	end loop cycle;
end
call now3

-- ������ 
create procedure insert_to_catalog (in id int, in name varchar(255))
begin 
	declare continue HANDLER for SQLSTATe '23000' set @error = '������ �����';
	insert into catalogs values(id,name);
	if @error is not null then
		select @error; 
	end if;
end
call insert_to_catalog(7, '���� �������') 
select * from catalogs ;

-- �������.
-- �������� ������� 
create table upcase_catalogs(
id serial primary key,
name VARCHAR (255) comment '�������� �������'
) comment = '������� ����-��������';

create procedure copy_catalogs()
begin 
	declare id INT;
	declare is_end INT default 0;
	declare name tinytext;

	declare curcat cursor for select * from catalogs;   -- ��������� ������
	declare continue HANDLER for not found set is_end = 1; -- ���������� ����� ������ ��������� �����
	open curcat;  -- ��������� ������ 
	cycle : loop
		fetch curcat into id, name;  -- ������ ������ �� ������� 
		if is_end then leave cycle;  -- ����� �� ����� ��� ���������� ����� ������ 
		end if;
		insert into upcase_catalogs values (id,UPPER(name)); -- ��������� ������ ��������� 
	end loop cycle; 
	close curcat; -- ��������� ������ 
end
call copy_catalogs() 
select * from upcase_catalogs 

-- ������� 

-- before insert		before update 			before delete 
-- 	insert 					update 					delete 
-- after insert 		after update 			after delete 

create trigger catalogs_count after insert on catalogs
for each row 
begin 
	select count(*) into @total from catalogs;
end

insert into catalogs values (null, '��������');
select * from catalogs c2 
select @total
-- 
show triggers
drop trigger if exists catalogs_count

-- ��������� � ������ ��� ����� �������. 
-- before  - new.name
-- ������� - name 
-- after - old.name 

create trigger check_catalog_id_insert before insert on products 
for each row 
begin 
	declare cat_id INT;
	select id into cat_id from catalogs order by id limit 1;
	set new.catalog_id = coalesce (new.catalog_id, cat_id);
	end
	
select * from products p 
insert into products (name, description, price)
values
('AMD RYZHEN 5 1600', '��������� AMD', 13200.00 );

-- 

create trigger check_catalog_id_update before update on products 
for each row 
begin 
	declare cat_id INT;
	select id into cat_id from catalogs order by id limit 1;
	set new.catalog_id = coalesce (new.catalog_id, old.catalog_id, cat_id);
	end
	
select * from products p 

UPDATE  products set catalog_id = null where name = 'AMD RYZHEN 5 1600' 
UPDATE  products set catalog_id = 3 where name = 'MSI B250M GAMING PRO'
UPDATE  products set catalog_id = NULL where name = 'MSI B250M GAMING PRO'

-- ���������� ������� �������. 
create table prices (
id serial primary key,
processor DECIMAL(11,2) comment '���� ��',
mother DECIMAL(11,2) comment '���� ���',
memory DECIMAL(11,2) comment '���� ����������',
total DECIMAL(11,2) comment '����� ���� ��������');
-- �������� ������� ��� �����
create trigger auto_update_price_on_insert before insert on prices
for each row
begin 
	set new.total = new.processor + new.mother + new.memory;
end

create trigger auto_update_price_on_update before update on prices
for each row
begin 
	set new.total = new.processor + new.mother + new.memory;
end

insert into prices (processor, mother, memory)
values
(2866.00,64678.00,4536.00)
select * from prices 
-- ����� �� ����� ��������� � ��� ��������. 
drop table if exists prices 
create table prices (
id serial primary key,
processor DECIMAL(11,2) comment '���� ��',
mother DECIMAL(11,2) comment '���� ���',
memory DECIMAL(11,2) comment '���� ����������',
total DECIMAL(11,2) as (processor + mother + memory) stored  comment '����� ���� ��������'
);

insert into prices (processor, mother, memory)
values
(2264.00,66638.00,4426.01);
select * from prices

-- �� �������� ������� ��������� ������ 

create trigger check_last_catalogs before DELETE on catalogs
for each row
begin 
	declare total INT;
	select COUNT(*) into total from catalogs;
	if total <= 1 then
		signal sqlstate '45000' set MESSAGE_TEXT = 'DELETE canceled';
	end if;
end

delete from catalogs limit 1 
select * from catalogs 

--                   								�������� ������
-- � ���� ������ shop � sample ������������ ���� � �� �� �������, ������� ���� ������.
-- ����������� ������ id = 1 �� ������� shop.users � ������� sample.users. ����������� ����������.
create database sample ;
create table accounts (
	id serial primary key,
	name varchar(255),
	surename varchar (255)); 
	insert into accounts (name, surename) values
	('Frank','Pilow'),
	('��������','��������'),
	('��������','�����������'),
	('������', '�������');	
select * from accounts;
select * from  shop.accounts a ;

drop table accounts;
set autocommit=0
start transaction;
insert into sample.accounts select * from shop.accounts where id = 4;
select * from accounts;
commit;

-- �������� �������������,
-- ������� ������� �������� name �������� ������� �� ������� products � ��������������� ��������
-- �������� name �� ������� catalogs.
CREATE OR REPLACE VIEW prods_desc(prod_id, prod_name, cat_name)
as SELECT p.id AS prod_id, p.name, cat.name FROM products AS p
LEFT JOIN catalogs AS cat 
ON p.catalog_id = cat.id;

SELECT * FROM prods_desc;

-- �������� �������� ������� hello(), ������� ����� ���������� �����������,
-- � ����������� �� �������� ������� �����. � 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����",
-- � 12:00 �� 18:00 ������� ������ ���������� �����
-- "������ ����", � 18:00 �� 00:00 � "������ �����", � 00:00 �� 6:00 � "������ ����".
select (curtime() between  '12:00:00' and '19:00:00') 
drop procedure if exists hello
create procedure hello()
begin
	IF(CURTIME() BETWEEN '05:59:59' AND '11:59:59') THEN
		SELECT '������ ����';
	ELSEIF(CURTIME() BETWEEN '12:00:00' AND '17:59:59') THEN
		SELECT '������ ����';
	ELSEIF(CURTIME() BETWEEN '18:00:00' AND '23:59:59') THEN
		SELECT '������ �����';
	elseif(CURTIME() BETWEEN '00:00:00' AND '05:59:59') THEN
		SELECT '������ ����';
	end if;
end
call hello 

drop procedure if exists hello
create procedure hello() 
begin 
	case 
		when curtime() between  '05:59:59' and '11:59:59' then 
			SELECT '������ ����';
		when CURTIME() BETWEEN '12:00:00' AND '17:59:59' then
			SELECT '������ ����';
		when CURTIME() BETWEEN '18:00:00' AND '23:59:59' then
			SELECT '������ �����';
		when CURTIME() BETWEEN '00:00:00' AND '05:59:59' then
			SELECT '������ ���� �������';
		end case;
end
call hello 

-- � ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������.
-- ��������� ����������� ����� ����� ��� ���� �� ���.
-- ��������, ����� ��� ���� ��������� �������������� �������� NULL �����������.
-- ��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ���� ���� ���������.
-- ��� ������� ��������� ����� NULL-�������� ���������� �������� ��������.

insert into products (name, description, price)
values
(null , '�����ewqh AMD�', 132230.00 );
insert into products (name, description, price)
values
('Intel�� corp2', null, 123302.00 );

select * from products;

select name, description from products;
drop  trigger check_name_insert;
create trigger check_name_insert before insert on products 
for each row 
begin
	IF(ISNULL(NEW.name)) then
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not null';
	-- set new.name = '������';
	end if;
	IF(ISNULL(NEW.description)) then
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not null';
	-- set new.description = '������';
	end if;
end
	

