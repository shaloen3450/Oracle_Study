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
/*******��ʼ��ѧ���������******/
insert into student values ('s001','����',23,'��');
insert into student values ('s002','����',23,'��');
insert into student values ('s003','����',25,'��');
insert into student values ('s004','����',20,'Ů');
insert into student values ('s005','����',20,'Ů');
insert into student values ('s006','�',21,'��');
insert into student values ('s007','����',21,'��');
insert into student values ('s008','����',21,'Ů');
insert into student values ('s009','������',23,'Ů');
insert into student values ('s010','����',22,'Ů');
commit;
/******************��ʼ����ʦ��***********************/
insert into teacher values ('t001', '����');
insert into teacher values ('t002', '����');
insert into teacher values ('t003', '������');
commit;
/***************��ʼ���γ̱�****************************/
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
/***************��ʼ���ɼ���***********************/
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
--��ϰ��
--ע�⣺������ϰ�е������Ǹ��ݳ�ʼ�������ݿ��е�������д��SQL ��䣬�������ע�⡣

-- 1����ѯ��c001���γ̱ȡ�c002���γ̳ɼ��ߵ�����ѧ����ѧ�ţ�
select t.sno1  from
(select sc1.*, sc2.*, (sc1.score - sc2.score) score2, sc1.sno sno1, sc2.sno sno2 from sc sc1, sc sc2 where sc1.sno = sc2.sno and sc1.cno = 'c001' and sc2.cno = 'c002') t
where score2 > 0;

-- 2����ѯƽ���ɼ�����60 �ֵ�ͬѧ��ѧ�ź�ƽ���ɼ���
select s.sno, t.avgsco from
(select s.sno, avg(sc.score) avgsco from student s, sc where s.sno = sc.sno group by s.sno order by avg(sc.score)) t join student s
on t.sno = s.sno
where avgsco > 60;

-- 3����ѯ����ͬѧ��ѧ�š�������ѡ�������ܳɼ���
select max(s.sname), max(s.sno), sum(sc.score), count(sc.cno) from
(select * from student)s join sc on s.sno = sc.sno 
group by s.sno;

-- 4����ѯ�ա���������ʦ�ĸ�����
select count(t.tno) from
(select * from teacher t where t.tname like '��%') t
group by t.tno;

-- 5����ѯûѧ�������ࡱ��ʦ�ε�ͬѧ��ѧ�š�������
select sc.sno from sc 
group by sc.sno
having  not in (select c.cno from
(select * from teacher t where t.tname = '����') t join course c on t.tno = c.tno)
;
select sc.* from sc group by sc.sno order by sc.sno;
-- 6����ѯѧ����c001������Ҳѧ����š�c002���γ̵�ͬѧ��ѧ�š�������
select t1.sno, s.sname from 
(select s1.sno from sc s1, sc s2 where s1.cno = 'c001' and s2.cno = 'c001' and s1.sno = s2.sno) t1, student s where t1.sno = s.sno ;

--����intersect   ���� union �minus
select sno from sc  where cno = 'c001'
intersect
select sno from sc where cno = 'c002';

-- 7����ѯѧ�������ࡱ��ʦ���̵����пε�ͬѧ��ѧ�š�������
select s.sno, count(t.cno) from student s where s.sno in 
(select distinct sc.sno, sc.cno from (select c.cno from teacher t, course c where t.tname = '����' and t.tno = c.tno)t1, sc where t1.cno = sc.cno ) t
group by s.sno
having count(t.cno) =
(select c.cno from teacher t, course c where t.tname = '����' and t.tno = c.tno);



-- 8����ѯ�γ̱�š�c002���ĳɼ��ȿγ̱�š�c001���γ̵͵�����ͬѧ��ѧ�š�������
select distinct t.sno, s.sname from 
(select s1.sno from sc s1, sc s2 where s1.score > s2.score and s1.sno = s2.sno) t, student s where t.sno = s.sno;


-- 9����ѯ���пγ̳ɼ�С��60 �ֵ�ͬѧ��ѧ�š�������
select s1.sno, s2.sname from sc s1, student s2 where s1.score < 60 and s1.sno = s2.sno;


-- 10����ѯû��ѧȫ���пε�ͬѧ��ѧ�š�������
select s1.sno, count(s2.cno) from student s1 left join sc s2 on s1.sno =s2.sno group by s1.sno; --ѧ�Ŀγ��� 
select count(cno) from course; --�ܵĿγ���

select * from student s left join (
select s1.sno, count(s2.cno) from student s1 left join sc s2 on s1.sno =s2.sno group by s1.sno) t on s.sno = t.sno
where (select count(cno) from course) not in (select count(s2.cno) from student s1 left join sc s2 on s1.sno =s2.sno group by s1.sno);

-- 11����ѯ������һ�ſ���ѧ��Ϊ��s001����ͬѧ��ѧ��ͬ��ͬѧ��ѧ�ź�������
select distinct sc.sno, s.sname from sc left join student s on sc.sno = s.sno where sc.sno != 's001' and sc.cno in(
select sc.cno from sc where sc.sno = 's001');


-- 12����ѯ����ѧ��ѧ��Ϊ��s001��ͬѧ����һ�ſε�����ͬѧѧ�ź�������

-- 13���ѡ�SC�����С����ࡱ��ʦ�̵Ŀεĳɼ�������Ϊ�˿γ̵�ƽ���ɼ���
update sc set (select course from sc where cno in()) where(select * from sc where in 
(select distinct cno from teacher t join course c on t.tno = c.tno join sc on c.cno = sc.cno where t.tname = '����'));

select distinct cno from teacher t join course c on t.tno = c.tno join sc on c.cno = sc.cno where t.tname = '����'; --�̵Ŀε�cno

-- 14����ѯ�͡�s001���ŵ�ͬѧѧϰ�Ŀγ���ȫ��ͬ������ͬѧѧ�ź�������
select s1.cno from sc s1 where s1.sno = 's001';


-- 15��ɾ��ѧϰ�����ࡱ��ʦ�ε�SC ���¼��
delete sc  where sc.cno in (select sc.cno from teacher t join course c on t.tno =c.tno join sc on c.cno = sc.cno where t.tname = '����' 
group by sc.cno);
rollback;
-- 16����SC ���в���һЩ��¼����Щ��¼Ҫ���������������û���Ϲ���š�c002���γ̵�ͬѧѧ�š���c002���ſε�ƽ���ɼ���
insert into sc (select s.sno, 'c002',(select avg(score) from sc where cno = 'c002' group by cno) from student s left join sc on sc.sno = s.sno where
s.sno not in (select sno from sc where cno ='c002') );

select * from sc;
 rollback;
select s.sno from student s left join sc on sc.sno = s.sno where
s.sno not in (select sno from sc where cno ='c002');
-- 17����ѯ���Ƴɼ���ߺ���͵ķ֣���������ʽ��ʾ���γ�ID����߷֣���ͷ�
select max(sc.score), min(sc.score), sc.cno from sc group by sc.cno;



-- 18��������ƽ���ɼ��ӵ͵��ߺͼ����ʵİٷ����Ӹߵ���˳��
select sc.cno, avg(sc.score) from sc group by cno ;

-- 19����ѯ��ͬ��ʦ���̲�ͬ�γ�ƽ���ִӸߵ�����ʾ
select sc.cno, c.tno, avg(sc.score) from sc join course c on sc.cno = c.cno group by sc.cno, c.tno order by avg(sc.score) desc;


-- 20��ͳ����ӡ���Ƴɼ�,������������:�γ�ID,�γ�����,[100-85],[85-70],[70-60],[ <60]

select sc.cno, max(c.cname), sum(case when sc.score >= 85 then 1 else 0 end), 
sum(case when sc.score >= 70 and sc.score < 85 then 1 else 0 end),
sum(case when sc.score >= 60 and sc.score < 70 then 1 else 0 end),
sum(case when sc.score < 60 then 1 else 0 end)
 from sc join course c on sc.cno = c.cno group by sc.cno;


-- 21����ѯ���Ƴɼ�ǰ�����ļ�¼:(�����ǳɼ��������)
select * from
(select cno from sc group by cno) t1, sc t2 where t1.cno = t2.cno order by t1.cno asc, t2.score desc;

select * from sc s1
where (select count(1) from sc s2 where s1.cno = s2.cno and s1.score < s2.score) <= 2;

-- 22����ѯÿ�ſγ̱�ѡ�޵�ѧ����
select c.cno, count(sno) from course c left join sc on c.cno = sc.cno group by c.cno order by c.cno;


-- 23����ѯ��ֻѡ����һ�ſγ̵�ȫ��ѧ����ѧ�ź�����
select s.sname, s.sno from student s where s.sno in(
select sno from sc group by sno having count(cno) = 1);


-- 24����ѯ������Ů������
select count(s.sno), s.ssex from student s group by s.ssex;


-- 25����ѯ�ա��š���ѧ������
select * from student s where substr(s.sname, 0, 1) = '��';



-- 26����ѯͬ��ͬ��ѧ����������ͳ��ͬ������
select count(s.sno), s.sname from student s group by s.sname having COUNT(s.sno) >0;


-- 27��1981 �������ѧ������(ע��Student ����Sage �е�������number)
select * from student s where s.sage = to_number(to_char(sysdate, 'yyyy')) - 1981;


-- 28����ѯÿ�ſγ̵�ƽ���ɼ��������ƽ���ɼ��������У�ƽ���ɼ���ͬʱ�����γ̺Ž�������
select avg(score) from sc group by cno order by avg(score) asc, cno desc;

-- 29����ѯƽ���ɼ�����75 ������ѧ����ѧ�š�������ƽ���ɼ�
select s.sname, t.sno, t.avg_score from student s join 
(select sno, avg(score) avg_score from sc group by sno having avg(score) > 75) t on s.sno = t.sno ;


-- 30����ѯ�γ�����Ϊ�����ݿ⡱���ҷ�������60 ��ѧ�������ͷ���
select * from (select * from course c where c.cname = 'Oracle') t 
left join sc on t.cno = sc.cno
left  join student s on sc.sno = s.sno where score < 60;


-- 31����ѯ����ѧ����ѡ�������
select * from sc right join student s on sc.sno = s.sno;


-- 32����ѯ�κ�һ�ſγ̳ɼ���70 �����ϵ��������γ����ƺͷ�����
select s.sname, c.cname, t.score from student s join
(select * from sc where score > 70 ) t on s.sno = t.sno join course c on t.cno = c.cno;

-- 33����ѯ������Ŀγ̣������γ̺ŴӴ�С����
select * from sc where score < 60 order by cno desc;

-- 34����ѯ�γ̱��Ϊc001 �ҿγ̳ɼ���80 �����ϵ�ѧ����ѧ�ź�������
select * from student where sno in(
select sno from sc where cno = 'c001' and score > 80);



-- 35����ѡ�˿γ̵�ѧ������
select count(distinct sno) from sc ;


-- 36����ѯѡ�ޡ����ࡱ��ʦ���ڿγ̵�ѧ���У��ɼ���ߵ�ѧ����������ɼ�
SELECT *
FROM
  (SELECT *
  FROM sc
  WHERE sc.cno IN
    (SELECT c.cno
    FROM teacher t
    JOIN course c
    ON t.tno      = c.tno
    WHERE t.tname = '����'
    )
  ORDER BY score DESC
  )
WHERE rownum = 1;

-- 37����ѯ�����γ̼���Ӧ��ѡ������
select cno, count(sno) from sc group by cno ;


-- 38����ѯ��ͬ�γ̳ɼ���ͬ��ѧ����ѧ�š��γ̺š�ѧ���ɼ�
select cno, score from sc group by cno, score having count(sno) > 1;

-- 39����ѯÿ�Ź��γɼ���õ�ǰ����
select t.* from  (select  sno, score,  rownum ro  from sc order by score desc) t where t.ro < 3;


-- 40��ͳ��ÿ�ſγ̵�ѧ��ѡ������������10 �˵Ŀγ̲�ͳ�ƣ���Ҫ������γ̺ź�ѡ����������ѯ����������������У���������ͬ�����γ̺���������
select cno, count(sno) from sc group by cno having  count(sno)> 2 order by count(sno) desc, cno asc;


-- 41����������ѡ�����ſγ̵�ѧ��ѧ��
select sno, count(cno) from sc group by sno having count(cno) >= 2;



-- 42����ѯȫ��ѧ����ѡ�޵Ŀγ̵Ŀγ̺źͿγ���
select distinct s1.cno, c.cname from sc s1, course c where s1.cno = c.cno and s1.cno  in (
select cno from sc group by cno having count(sno) = (select count(sname) from student));


-- 43����ѯ�������ϲ�����γ̵�ͬѧ��ѧ�ż���ƽ���ɼ�
select sno, avg(score) from sc where sno = 
(select sno from sc where score < 60 group by sno having count(sno) >= 1)
group by sno;

-- 44��������c004���γ̷���С��60���������������е�ͬѧѧ��
select * from sc where cno = 'c004' and score < 60 order by score desc;
-- 45��ɾ����s002��ͬѧ�ġ�c001���γ̵ĳɼ�
 delete sc where sno = 's002' and cno = 'c001';
 rollback;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ---���ݿ����
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 