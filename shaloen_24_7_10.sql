--***********************************************
create table student(
sno varchar2(10) primary key,
sname varchar2(20),
sage number(3),
ssex varchar2(5)
);
create table teacher(
tno varchar2(10) primary key,
tname varchar2(20)
);
create table course(
cno varchar2(10),
cname varchar2(20),
tno varchar2(20),
constraint pk_course primary key (cno,tno)
);
create table sc(
sno varchar2(10),
cno varchar2(10),
score number(4,2),
constraint pk_sc primary key (sno,cno)
);
/*******初始化学生表的数据******/
insert into student values ('s001','张三',23,'男');
insert into student values ('s002','李四',23,'男');
insert into student values ('s003','吴鹏',25,'男');
insert into student values ('s004','琴沁',20,'女');
insert into student values ('s005','王丽',20,'女');
insert into student values ('s006','李波',21,'男');
insert into student values ('s007','刘玉',21,'男');
insert into student values ('s008','萧蓉',21,'女');
insert into student values ('s009','陈萧晓',23,'女');
insert into student values ('s010','陈美',22,'女');
commit;
/******************初始化教师表***********************/
insert into teacher values ('t001', '刘阳');
insert into teacher values ('t002', '谌燕');
insert into teacher values ('t003', '胡明星');
commit;
/***************初始化课程表****************************/
insert into course values ('c001','J2SE','t002');
insert into course values ('c002','Java Web','t002');
insert into course values ('c003','SSH','t001');
insert into course values ('c004','Oracle','t001');
insert into course values ('c005','SQL SERVER 2005','t003');
insert into course values ('c006','C#','t003');
insert into course values ('c007','JavaScript','t002');
insert into course values ('c008','DIV+CSS','t001');
insert into course values ('c009','PHP','t003');
insert into course values ('c010','EJB3.0','t002');
commit;
/***************初始化成绩表***********************/
insert into sc values ('s001','c001',78.9);
insert into sc values ('s002','c001',80.9);
insert into sc values ('s003','c001',81.9);
insert into sc values ('s004','c001',60.9);
insert into sc values ('s001','c002',82.9);
insert into sc values ('s002','c002',72.9);
insert into sc values ('s003','c002',81.9);
insert into sc values ('s001','c003','59');
commit;
 
 select * from student;
 select * from teacher;
 select * from course;
 select * from sc;
--练习：
--注意：以下练习中的数据是根据初始化到数据库中的数据来写的SQL 语句，请大家务必注意。

-- 1、查询“c001”课程比“c002”课程成绩高的所有学生的学号；
select t.sno1  from
(select sc1.*, sc2.*, (sc1.score - sc2.score) score2, sc1.sno sno1, sc2.sno sno2 from sc sc1, sc sc2 where sc1.sno = sc2.sno and sc1.cno = 'c001' and sc2.cno = 'c002') t
where score2 > 0;

-- 2、查询平均成绩大于60 分的同学的学号和平均成绩；
select s.sno, t.avgsco from
(select s.sno, avg(sc.score) avgsco from student s, sc where s.sno = sc.sno group by s.sno order by avg(sc.score)) t join student s
on t.sno = s.sno
where avgsco > 60;

-- 3、查询所有同学的学号、姓名、选课数、总成绩；
select max(s.sname), max(s.sno), sum(sc.score), count(sc.cno) from
(select * from student)s join sc on s.sno = sc.sno 
group by s.sno;

-- 4、查询姓“刘”的老师的个数；
select count(t.tno) from
(select * from teacher t where t.tname like '刘%') t
group by t.tno;

-- 5、查询没学过“谌燕”老师课的同学的学号、姓名；
select sc.sno from sc 
group by sc.sno
having  not in (select c.cno from
(select * from teacher t where t.tname = '谌燕') t join course c on t.tno = c.tno)
;
select sc.* from sc group by sc.sno order by sc.sno;
-- 6、查询学过“c001”并且也学过编号“c002”课程的同学的学号、姓名；
select t1.sno, s.sname from 
(select s1.sno from sc s1, sc s2 where s1.cno = 'c001' and s2.cno = 'c001' and s1.sno = s2.sno) t1, student s where t1.sno = s.sno ;

--交集intersect   并集 union 差集minus
select sno from sc  where cno = 'c001'
intersect
select sno from sc where cno = 'c002';

-- 7、查询学过“谌燕”老师所教的所有课的同学的学号、姓名；
select s.sno, count(t.cno) from student s where s.sno in 
(select distinct sc.sno, sc.cno from (select c.cno from teacher t, course c where t.tname = '谌燕' and t.tno = c.tno)t1, sc where t1.cno = sc.cno ) t
group by s.sno
having count(t.cno) =
(select c.cno from teacher t, course c where t.tname = '谌燕' and t.tno = c.tno);



-- 8、查询课程编号“c002”的成绩比课程编号“c001”课程低的所有同学的学号、姓名；
select distinct t.sno, s.sname from 
(select s1.sno from sc s1, sc s2 where s1.score > s2.score and s1.sno = s2.sno) t, student s where t.sno = s.sno;


-- 9、查询所有课程成绩小于60 分的同学的学号、姓名；
select s1.sno, s2.sname from sc s1, student s2 where s1.score < 60 and s1.sno = s2.sno;


-- 10、查询没有学全所有课的同学的学号、姓名；
select s1.sno, count(s2.cno) from student s1 left join sc s2 on s1.sno =s2.sno group by s1.sno; --学的课程数 
select count(cno) from course; --总的课程数

select * from student s left join (
select s1.sno, count(s2.cno) from student s1 left join sc s2 on s1.sno =s2.sno group by s1.sno) t on s.sno = t.sno
where (select count(cno) from course) not in (select count(s2.cno) from student s1 left join sc s2 on s1.sno =s2.sno group by s1.sno);

-- 11、查询至少有一门课与学号为“s001”的同学所学相同的同学的学号和姓名；
select distinct sc.sno, s.sname from sc left join student s on sc.sno = s.sno where sc.sno != 's001' and sc.cno in(
select sc.cno from sc where sc.sno = 's001');


-- 12、查询至少学过学号为“s001”同学所有一门课的其他同学学号和姓名；

-- 13、把“SC”表中“谌燕”老师教的课的成绩都更改为此课程的平均成绩；
update sc set (select course from sc where cno in()) where(select * from sc where in 
(select distinct cno from teacher t join course c on t.tno = c.tno join sc on c.cno = sc.cno where t.tname = '谌燕'));

select distinct cno from teacher t join course c on t.tno = c.tno join sc on c.cno = sc.cno where t.tname = '谌燕'; --教的课的cno

-- 14、查询和“s001”号的同学学习的课程完全相同的其他同学学号和姓名；
select s1.cno from sc s1 where s1.sno = 's001';


-- 15、删除学习“谌燕”老师课的SC 表记录；
delete sc  where sc.cno in (select sc.cno from teacher t join course c on t.tno =c.tno join sc on c.cno = sc.cno where t.tname = '谌燕' 
group by sc.cno);
rollback;
-- 16、向SC 表中插入一些记录，这些记录要求符合以下条件：没有上过编号“c002”课程的同学学号、“c002”号课的平均成绩；
insert into sc (select s.sno, 'c002',(select avg(score) from sc where cno = 'c002' group by cno) from student s left join sc on sc.sno = s.sno where
s.sno not in (select sno from sc where cno ='c002') );

select * from sc;
 rollback;
select s.sno from student s left join sc on sc.sno = s.sno where
s.sno not in (select sno from sc where cno ='c002');
-- 17、查询各科成绩最高和最低的分：以如下形式显示：课程ID，最高分，最低分
select max(sc.score), min(sc.score), sc.cno from sc group by sc.cno;



-- 18、按各科平均成绩从低到高和及格率的百分数从高到低顺序
select sc.cno, avg(sc.score) from sc group by cno ;

-- 19、查询不同老师所教不同课程平均分从高到低显示
select sc.cno, c.tno, avg(sc.score) from sc join course c on sc.cno = c.cno group by sc.cno, c.tno order by avg(sc.score) desc;


-- 20、统计列印各科成绩,各分数段人数:课程ID,课程名称,[100-85],[85-70],[70-60],[ <60]

select sc.cno, max(c.cname), sum(case when sc.score >= 85 then 1 else 0 end), 
sum(case when sc.score >= 70 and sc.score < 85 then 1 else 0 end),
sum(case when sc.score >= 60 and sc.score < 70 then 1 else 0 end),
sum(case when sc.score < 60 then 1 else 0 end)
 from sc join course c on sc.cno = c.cno group by sc.cno;


-- 21、查询各科成绩前三名的记录:(不考虑成绩并列情况)
select * from
(select cno from sc group by cno) t1, sc t2 where t1.cno = t2.cno order by t1.cno asc, t2.score desc;

select * from sc s1
where (select count(1) from sc s2 where s1.cno = s2.cno and s1.score < s2.score) <= 2;

-- 22、查询每门课程被选修的学生数
select c.cno, count(sno) from course c left join sc on c.cno = sc.cno group by c.cno order by c.cno;


-- 23、查询出只选修了一门课程的全部学生的学号和姓名
select s.sname, s.sno from student s where s.sno in(
select sno from sc group by sno having count(cno) = 1);


-- 24、查询男生、女生人数
select count(s.sno), s.ssex from student s group by s.ssex;


-- 25、查询姓“张”的学生名单
select * from student s where substr(s.sname, 0, 1) = '刘';



-- 26、查询同名同性学生名单，并统计同名人数
select count(s.sno), s.sname from student s group by s.sname having COUNT(s.sno) >0;


-- 27、1981 年出生的学生名单(注：Student 表中Sage 列的类型是number)
select * from student s where s.sage = to_number(to_char(sysdate, 'yyyy')) - 1981;


-- 28、查询每门课程的平均成绩，结果按平均成绩升序排列，平均成绩相同时，按课程号降序排列
select avg(score) from sc group by cno order by avg(score) asc, cno desc;

-- 29、查询平均成绩大于75 的所有学生的学号、姓名和平均成绩
select s.sname, t.sno, t.avg_score from student s join 
(select sno, avg(score) avg_score from sc group by sno having avg(score) > 75) t on s.sno = t.sno ;


-- 30、查询课程名称为“数据库”，且分数低于60 的学生姓名和分数
select * from (select * from course c where c.cname = 'Oracle') t 
left join sc on t.cno = sc.cno
left  join student s on sc.sno = s.sno where score < 60;


-- 31、查询所有学生的选课情况；
select * from sc right join student s on sc.sno = s.sno;


-- 32、查询任何一门课程成绩在70 分以上的姓名、课程名称和分数；
select s.sname, c.cname, t.score from student s join
(select * from sc where score > 70 ) t on s.sno = t.sno join course c on t.cno = c.cno;

-- 33、查询不及格的课程，并按课程号从大到小排列
select * from sc where score < 60 order by cno desc;

-- 34、查询课程编号为c001 且课程成绩在80 分以上的学生的学号和姓名；
select * from student where sno in(
select sno from sc where cno = 'c001' and score > 80);



-- 35、求选了课程的学生人数
select count(distinct sno) from sc ;


-- 36、查询选修“谌燕”老师所授课程的学生中，成绩最高的学生姓名及其成绩
SELECT *
FROM
  (SELECT *
  FROM sc
  WHERE sc.cno IN
    (SELECT c.cno
    FROM teacher t
    JOIN course c
    ON t.tno      = c.tno
    WHERE t.tname = '谌燕'
    )
  ORDER BY score DESC
  )
WHERE rownum = 1;

-- 37、查询各个课程及相应的选修人数
select cno, count(sno) from sc group by cno ;


-- 38、查询不同课程成绩相同的学生的学号、课程号、学生成绩
select cno, score from sc group by cno, score having count(sno) > 1;

-- 39、查询每门功课成绩最好的前两名
select t.* from  (select  sno, score,  rownum ro  from sc order by score desc) t where t.ro < 3;


-- 40、统计每门课程的学生选修人数（超过10 人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
select cno, count(sno) from sc group by cno having  count(sno)> 2 order by count(sno) desc, cno asc;


-- 41、检索至少选修两门课程的学生学号
select sno, count(cno) from sc group by sno having count(cno) >= 2;



-- 42、查询全部学生都选修的课程的课程号和课程名
select distinct s1.cno, c.cname from sc s1, course c where s1.cno = c.cno and s1.cno  in (
select cno from sc group by cno having count(sno) = (select count(sname) from student));


-- 43、查询两门以上不及格课程的同学的学号及其平均成绩
select sno, avg(score) from sc where sno = 
(select sno from sc where score < 60 group by sno having count(sno) >= 1)
group by sno;

-- 44、检索“c004”课程分数小于60，按分数降序排列的同学学号
select * from sc where cno = 'c004' and score < 60 order by score desc;
-- 45、删除“s002”同学的“c001”课程的成绩
 delete sc where sno = 's002' and cno = 'c001';
 rollback;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ---数据库设计
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 