select * from user_tables;
select * from emp;
select * from salgrade;
select * from bonus;
select * from dept;

select sal+comm as sals from emp;

select * from emp where sal+comm between 1000 and 2000;

select * from emp where comm is not null;

--ģ����ѯ like %��0�����ַ��� _��һ���ַ���
select * from emp where ename like '_A%';


select * from emp where sal = 1500 or sal = 2000 or sal = 3000;

-- in
select * from emp where sal not in(1250, 2000, 3000);

select * from emp where sal in(1250, 2000);

--���� order by colum asc/desc

select *from emp order by sal desc;

--��������  
select * from emp order by sal asc, comm desc;

-- orderby д�����ĩβ 
select * from emp where deptno = 10 order by sal asc;

--���� + - * /  nullֵ��������� 
select ename,sal,sal+200 as new_sal from emp; 

select e.*,comm + 100 as new_comm from emp e where comm is not null;
-- ���� e 
select e.*,ename,sal,sal+1000 as new_sal from emp e where sal+1000 > 2000 order by new_sal asc,mgr desc;

--���ӷ� || 
select e.ename||'('|| e.job || ')' from emp e;

select e.ename||'('||e.job||')' from emp e; 

select e.* from  emp e;
--ȥ�� distinct 




select * from emp where deptno = 30;
select * from emp where deptno = 30;
select empno,ename from emp where job = 'MANAGER';
select * from emp where comm > sal;
select * from emp where deptno = 10 and job = 'MANAGER' or deptno = 30 and job = 'CLERK';
select * from emp where deptno = 10 and job not in('MANAGER','CLERK') and sal >= 2000;
select distinct job from emp where comm is not null ;
select * from emp where comm is null or comm < 500;
select e.ename,e.hiredate from emp e order by hiredate desc;

select ename from emp  e;
