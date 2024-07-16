---2024_7_13
------????????????
--  1 - 1 1 - n  m - n
--????    ??  ??????  ?????   ???PID???

--???????? sequence seq_name 
create sequence seq_no
start with 1                            --??1???
increment by 1                    --???????1
maxvalue 999                      --????999
nocache                                --??????
nocycle;                                  --?????






/*
??????????????
??   --????????   --????????????  --??????????
??????????
?????g_id  ?????gname ?????g_heroine ???????s_name
??? ???????   ???????id 

??????????????
?????id  ???? ?? ????????id ???????id

???????
?????id ???????? ??????id ???????id

????????  --
??????  ?? ?????????  ?????????
???????????? ????????????? ?????????????
?????????????????????????? ???¡À? 


*/

delete  tb_ginfo;

drop table tb_ginfo;
drop table tb_corporation;
drop table tb_staff;

select * from tb_ginfo;
select * from tb_corporation;
select * from tb_staff;


------------------------------------------------------------------------????????????  ???????
create table tb_ginfo(
g_id varchar2(10) primary key,
g_name varchar2(20),
g_heroine varchar2(20),
s_name varchar2(20),
g_prize number(5),
g_releasetime date,
c_name varchar2(20)
);
select * from tb_ginfo;


--????????seq_gid
create sequence seq_gid
start with 1
increment by 1
maxvalue 100
nocache
nocycle;
select seq_gid.nextval from dual;             --?????????

create  function f_gid return int
as
id int;
begin
select seq_gid.nextval into id from dual;
return id;
end;
--???????????????????   ?????????


/*
g_id varchar2(10) primary key,
g_name varchar2(20),
g_heroine varchar2(20),
s_id int,
g_prize number(5),
g_releasetime date,
c_id int
*/
--??????????????   ???????
create or replace procedure add_game(
v_gname in varchar2,
v_heroine in varchar2,
v_sname in varchar2,
v_gprize in number,
v_greleasetime date,
v_cname varchar2
)
as
begin
insert into tb_ginfo values(f_gid(), v_gname, v_heroine, v_sname, v_gprize, v_greleasetime, v_cname);
end;

declare 

begin
add_game(v_gname VARCHAR2,v_heroine VARCHAR2,v_sname VARCHAR2,v_gprize NUMBER,v_greleasetime DATE,v_cname VARCHAR2);

end;




--------------------------------------------------------------------------------------- ????????????
create table tb_corporation(
c_id int primary key,---????id
c_name varchar2(20),----??????
s_id int,--------------???id
g_id int-------------???id
);

--????????seq_cid
create sequence seq_cid
start with 1
increment by 1
maxvalue 100
nocache
nocycle;
select seq_cid.nextval from dual;             --?????????

create  function f_cid return int
as
id int;
begin
select seq_cid.nextval into id from dual;
return id;
end;

-----?????????????
insert into tb_corporation values (f_cid(), 'Yuzusoft', 1, 2);
insert into tb_corporation values (f_cid(), 'FAVORITE', 1, 2);


/*
--- ????????????
create table tb_corporation(
c_id int primary key,
c_name varchar2(20),
s_id int,
g_id int
);
*/

--------??????????????
create procedure add_corporation(
v_cname in varchar2
)
as

begin
insert into tb_corporation (c_id, c_name) values (f_cid(), v_cname);
end;

------???????????????????????????????
create  or replace procedure update_corporation(
v_cname in varchar2
)
as

begin
update tb_corporation c set c_id = (select s.s_id from tb_staff s where s.c_name = v_cname),
c.g_id = (select g.g_id from tb_ginfo g where g.c_name = v_cname) where c.c_name = v_cname ;
end;

------?????????????????????????
create or replace procedure update_corporation2(
v_cname in varchar2,
v_gname in varchar2,
v_sname in varchar2
)
as
v_gid int;
v_sid int;

begin
if  v_gname is null then
select c.g_id into v_gid from tb_corporation c where c.c_name = v_cname;
else 
select g.g_id into v_gid from tb_ginfo g where g.g_name = v_gname;
end if;

if v_sname is null then 
select c.s_id into v_gid from tb_corporation c where c.c_name = v_cname;
else
select s.s_id into v_sid from tb_staff s where s.s_name = v_sname;
end if;

update tb_corporation c set c.g_id = v_gid, c.s_id = v_sid  where c.c_name = v_cname;

end;



----------------------------------------------------------------????????????????
create table tb_staff(
s_id int primary key,
s_name varchar2(20),
s_job varchar2(20),---------Scenario  Character_design  Artist  Vocals
c_name varchar(20),
g_name varchar(20)
);


--????????seq_sid
create sequence seq_sid
start with 1
increment by 1
maxvalue 100
nocache
nocycle;
select seq_sid.nextval from dual;             --?????????

create  function f_sid return int
as
id int;
begin
select seq_sid.nextval into id from dual;
return id;
end;



-----?????????????

insert into tb_staff values (f_sid(), 'kazuhiro', 'Artist', 3, 2);
insert into tb_staff values (f_sid(), 'kazuhiro', 'Character_Design', 3, 2);
insert into tb_staff values (f_sid(), 'nakahiro', 'Scenario', 3, 2);

-------???????????????
create or replace procedure add_staff(
v_sname in varchar2,
v_sjob in varchar2,
v_cname in varchar2,
v_gname in varchar2
)
as
begin
insert into tb_staff s (s_id ,s.s_name, s.s_job, s.c_name, s.g_name) values (f_sid(), v_sname, v_sjob, v_cname, v_gname);
end;


--??????????????????/?¦Ë??? ???????????
create or replace procedure change_job(
v_sname in varchar2,
v_cname in varchar2,
v_sjob in varchar2
)
as
v_cid int;
v_name varchar2(20);
v_job varchar2(20);
begin
if v_cname is null then

v_name := 'select s.c_name from tb_staff s where s.s_name = v_sname';
else
v_name := v_name;
end if;


if v_sjob is null then 

v_job := 'select s.s_job from tb_staff s where s.s_name = v_sname';
else
v_job := v_job;
end if;

update tb_staff s set s.c_name = v_cname, s.s_job = v_sjob where s.s_name = v_sname;
end;



grant debug connect session to scott;



------------??????????????????
create or replace procedure sel_game(
v_cname in varchar2,
v_cur out pk_package.my_cursor
)
as
v_game varchar2(2000);
begin
v_game := 'select g.* from tb_ginfo g where g.c_name = v_cname';
open v_cur for v_emp;
end;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

------------?????????????????????
create procedure sel_staff(
)
as
begin
end;

















































































































































