------------------2024-7-9
--�Ӳ�ѯ
--�õ����ʴ����Լ� ����ƽ�����ʵ�Ա����Ϣ
select e.*, round(t.avgsal) from emp e, (select e.deptno, avg(e.sal) avgsal from emp e group by e.deptno) t
where  e.deptno = t.deptno and e.sal > t.avgsal
order by e.ename;

--�����Ӳ�ѯ  --��ѯ����͵���ƥ��
-- �ҳ��� smith ������ͬ��Ա��
select e.* from emp e
where e.sal =  (select e.sal from emp e where e.ename = 'SMITH') and e.ename != 'SMITH';

--�����Ӳ�ѯ --��ѯ����Ͷ���ƥ��  

--in
-- �ҳ��� ���� 10 ��ͬ���ʵ�Ա��
select e.* from emp e where e.sal in (select e.sal from emp e where e.deptno =10)
order by e.ename;

--any 
-- �ҳ��� ���� 10  ��any��һ��Ա��  ���ʸߵ�Ա��
select e.* from emp e where e.sal > any(select e.sal from emp e where e.deptno = 10)
order by e.ename;

--all 
-- �ҳ��� ���� 10  ��all��һ��Ա��  ���ʸߵ�Ա��
select e.* from emp e where e.sal > all(select e.sal from emp e where e.deptno = 10)
order by e.sal;

--TOPN  --����  
--�ҳ� ����ǰ����Ա��
select t.* from (select e.* from emp e order by e.sal desc nulls last) t where rownum <= 3 ;

--rowid:�����ַ   ����ı�
select e.*, rowid from emp e;

--rownumber:�߼���ַ  �����1��ʼ  �ᷢ���ı�
select t.*,rownum from (select e.*, rownum r1 from emp e order by e.ename desc) t order by t.ename;

-- where rownum <= 3 �н�� ǰ����
-- where rownum = 3 �޽�� 

--��ҳ
select t2.* from (select t1.*, rownum ro from (select e.* from emp e order by e.sal desc nulls last) t1 where rownum <= 6) t2 where t2.ro <= 3 ;
select t2.* from (select t1.*, rownum ro from (select e.* from emp e order by e.sal desc nulls last) t1 where rownum <= 6) t2 where t2.ro > 3 ;

--�ۼƼ���
--һ��ÿ�µ��ۼ����۶�
select e.*,trunc(e.hiredate, 'month') months from emp e where e.sal is not null; -- ÿ�����۶� 
select trunc(e.hiredate, 'month') months, sum(e.sal) from emp e where e.sal is not null group by trunc(e.hiredate, 'month'); -- ÿ���ۼ����۶�

--һ��ÿ�µ��ۼ����۶�
select  t1.months, sum(t2.sum_avg) from
(select trunc(e.hiredate, 'month') months, sum(e.sal) sum_avg from emp e where e.sal is not null group by trunc(e.hiredate, 'month')) t1, 
(select trunc(e.hiredate, 'month') months, sum(e.sal) sum_avg from emp e where e.sal is not null group by trunc(e.hiredate, 'month')) t2
where t1.months >= t2.months
group by t1.months
order by t1.months;

--����TOPN  
--�����Ź���ǰ����Ա��
select t.ename, t.sal from (select e.* from emp e order by e.sal desc nulls last) t where rownum <= 3;
--����Ӳ�ѯ
create table dept_sal as 
select e.ename,e.deptno,e.sal from emp e;

select * from dept_sal t1 
where (select count(1) from dept_sal t2  where t1.deptno = t2.deptno and t1.sal < t2.sal) <=2 
order by t1.deptno ,t1.sal desc;

--------------------��ɾ�� ����Ҫcommit �ύ������
--insert into/ delete / update [tablename] 
--������ 
create table tb_student(
sno int primary key,   --���� ��null��Ψһ
sname varchar(8),
birth date,
height number(3,2),     --��ֵ����λ����λС��
create_time timestamp
);
select * from tb_student;

----�������
--insert into [tablename] (col, ...) values (val, ...)
insert into tb_student (sno, sname, birth, height, create_time) values (0, '��0', '1-1��-2011', 1.72, systimestamp);

--���������а��������У������ȱʡ   ��col ��val Ҫһһ��Ӧ

--�޸�����  һ��Ҫʹ�������޸�  ������Ϊ�޸�����
update tb_student set sname = '��һ'  where sno = 0;

--ɾ������ һ��Ҫʹ�������޸�  ������Ϊ�޸�����
delete tb_student  where sno =0;  -- ɾ������

--��ձ����� truncate table [tablename]; --��֧�ֻع�  �Ͽ�������������
truncate table tb_student;

--rollback �ع�����  �������(insert)ɾ��(delete)�޸�(update)
rollback;

--�鿴���󣨰������������
select * from tab;

--����ɾ�� ��ջ���վ 
purge recyclebin;

--�޸ı� alte table [tablename] add/ drop colum/ modify 
--����һ��
 alter table tb_student  add age number(2);
 
 --ɾ��һ��
 alter table tb_student drop column age;
 
 --�޸�һ��  Ҫע�����ݳ��� 
 alter table tb_student modify sname varchar(12);
 
 
 --��ҵ
 select e.*, d.* from emp e, dept d where e.deptno = d.deptno and e.sal is not null order by e.deptno;
 --�г�Ա������ÿ�����ŵ�Ա�������Ͳ��� no
 select e.deptno, count(e.ename) from emp e
 group by e.deptno
 having e.deptno is not null
 order by e.deptno;
 
--�г�Ա������ÿ�����ŵ�Ա������Ա����������� 3�����Ͳ�������
select d.dname, t.amount from dept d, (select e.deptno, count(e.ename) amount from emp e
group by e.deptno
having count(e.ename) > 3
order by e.deptno) t 
where d.deptno = t.deptno;

--�ҳ����ʱ� jones ���Ա��
select e2.* from (select e1.* from emp e1 where e1.ename = 'JONES'), 
emp e2 where e1.ename = e2.ename and e2.ename != 'JONES' and e2.sal > e1.sal;

--�г�����Ա�������������ϼ�������
select e1.ename, e1.mgr,e2.ename, e2.empno from emp e1, emp e2 where e1.mgr = e2.empno order by e1.ename;

--��ְλ���飬�ҳ�ƽ��������ߵ�����ְλ
select t.job, t.avg_sal from 
(select e.job, round(avg(e.sal)) avg_sal from emp e group by e.job order by round(avg(e.sal)) desc nulls last) t 
where rownum <= 2;

--���ҳ����ڲ��� 20���ұȲ��� 20 ���κ�һ���˹��ʶ��ߵ�Ա����������������
select d.dname,t.ename from
( (select e.ename, e.deptno from emp e where e.sal > all( select e.sal from emp e where e.deptno = 20)and e.deptno != 20)) t, 
dept d where t.deptno = d.deptno ;

--�õ�ƽ�����ʴ��� 2000 �Ĺ���ְ�� job 
select e.job,round(avg(e.sal)) from emp e group by e.job
having e.job is not null and round(avg(e.sal)) > 2000
order by round(avg(e.sal)) desc;

--�ֲ��ŵõ����ʴ��� 2000 ������Ա����ƽ�����ʣ�����ƽ�����ʻ�Ҫ���� 2500
select e.deptno, avg(e.sal) from (select e.* from emp e where e.sal > 2000) e group by e.deptno 
having avg(e.sal) > 2500; 

--�õ�ÿ���¹����������ٵ��Ǹ����ŵĲ��ű�ţ��������ƣ�����λ��
select d.dname, d.loc, t.deptno from
(select e.deptno, sum(nvl(e.sal, 0) + nvl(e.comm, 0)) from emp e group by e.deptno having e.deptno is not null order by e.deptno) t, dept d
where t.deptno = d.deptno and rownum <= 1;

--�ֲ��ŵõ�ƽ�����ʵȼ�Ϊ 2 �����ȼ����Ĳ��ű��
select t.deptno from
(select e.deptno, round(avg(e.sal)) avgsal from emp e group by e.deptno) t, salgrade s
where t.avgsal between (select s.losal from salgrade s where grade = 2) and (select s.hisal from salgrade s where grade = 2);

select * from salgrade;
--���ҳ����� 10 �Ͳ��� 20 �У�������ߵ� 3 �������ʵ� 5 ����Ա����Ա�����֣��������֣�����λ��
select t3.ename, d.dname, d.loc from
(select t2.ename,t2.deptno  from 
(select rownum ro, t1.ename, t1.deptno from (select e.ename ,e.sal, e.deptno from emp e where e.deptno in (10, 20) order by e.sal desc) t1) t2
where ro in (3,4,5)) t3, dept d
where t3.deptno = d.deptno;

--���ҳ����루���ʼ��Ͻ��𣩣��¼����Լ��ϼ����ߵ�Ա����ţ�Ա�����֣�Ա������
select t1.empno, t1.ename, t1.total from
(select nvl(e.sal, 0) + nvl(e.comm, 0) total, e.empno, e.ename, e.mgr from emp e order by nvl(e.sal, 0) + nvl(e.comm, 0) desc) t1, 
(select nvl(e.sal, 0) + nvl(e.comm, 0) total, e.empno, e.ename, e.mgr from emp e order by nvl(e.sal, 0) + nvl(e.comm, 0) desc) t2
where t1.mgr = t2.empno and t1.total > t2.total;
select * from emp;

--���ҳ����ʵȼ���Ϊ 4 ����Ա����Ա�����֣��������֣�����λ��
select t.ename,d.dname,d.loc from 
(select e.ename, e.sal, e.deptno from emp e where e.sal 
not between (select s.losal from salgrade s where s.grade = 4) and 
(select s.hisal from salgrade s where s.grade = 4)) t, dept d
where t.deptno = d.deptno;

--���ҳ�ְλ��'MARTIN' ����'SMITH'һ����Ա����ƽ������
select e.job from emp e where e.ename in ('MARTIN','SMITH');--�ҵ����˵�job
select e.job, round(avg(e.sal)) from emp e group by e.job 
having e.job is not null and e.job in(select e.job from emp e where e.ename in ('MARTIN','SMITH'));

--���ҳ��������κβ��ŵ�Ա��
select e.* from emp e where e.deptno is null;

--������ͳ��Ա���������Ա�������Ĳ��ŵĵڶ��������������г��������֣�����λ�ã�
select t2.deptno, d.dname, d.loc from
(select t1.deptno, rownum ro from (select e.deptno, count(e.ename) from emp e group by e.deptno order by count(e.ename) desc) t1) t2, dept d
where t2.deptno = d.deptno and t2.ro in (2,3,4,5) ;

--��ѯ�� king ���ڲ��ŵĲ��ź�\��������\��������
select t.deptno, max(t.dname), count(e.ename) from
(select d.deptno, d.dname from dept d where d.deptno = (select e.deptno from emp e where e.ename = 'KING')) t, emp e
group by t.deptno;

--��ѯ�� king ���ڲ��ŵĹ�����������Ա������
select t.ename from (
select e.ename, rownum ro, e.hiredate from emp e where e.deptno = 
(select e.deptno  from emp e where e.ename = 'KING') 
order by e.hiredate) t where ro <= 1;

--��ѯ�����ʳɱ���ߵĲ��ŵĲ��źźͲ�������  �ܹ�����ߵĲ���
select t2.deptno,d.dname, t2.total from 
(select t1.deptno,t1.total from
(select e.deptno, sum(nvl(e.sal, 0) + nvl(e.comm, 0)) total from emp e 
group by e.deptno 
having e.deptno is not null order by sum(nvl(e.sal, 0) + nvl(e.comm, 0)) desc ) t1 where rownum < 2) t2, dept d
where t2.deptno = d.deptno;
















