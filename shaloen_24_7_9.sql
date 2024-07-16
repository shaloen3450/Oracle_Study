------------------2024-7-9
--子查询
--得到工资大于自己 部门平均工资的员工信息
select e.*, round(t.avgsal) from emp e, (select e.deptno, avg(e.sal) avgsal from emp e group by e.deptno) t
where  e.deptno = t.deptno and e.sal > t.avgsal
order by e.ename;

--单行子查询  --查询结果和单行匹配
-- 找出和 smith 工资相同的员工
select e.* from emp e
where e.sal =  (select e.sal from emp e where e.ename = 'SMITH') and e.ename != 'SMITH';

--多行子查询 --查询结果和多行匹配  

--in
-- 找出和 部门 10 相同工资的员工
select e.* from emp e where e.sal in (select e.sal from emp e where e.deptno =10)
order by e.ename;

--any 
-- 找出比 部门 10  （any）一个员工  工资高的员工
select e.* from emp e where e.sal > any(select e.sal from emp e where e.deptno = 10)
order by e.ename;

--all 
-- 找出比 部门 10  （all）一个员工  工资高的员工
select e.* from emp e where e.sal > all(select e.sal from emp e where e.deptno = 10)
order by e.sal;

--TOPN  --排行  
--找出 工资前三的员工
select t.* from (select e.* from emp e order by e.sal desc nulls last) t where rownum <= 3 ;

--rowid:物理地址   不会改变
select e.*, rowid from emp e;

--rownumber:逻辑地址  必须从1开始  会发生改变
select t.*,rownum from (select e.*, rownum r1 from emp e order by e.ename desc) t order by t.ename;

-- where rownum <= 3 有结果 前三个
-- where rownum = 3 无结果 

--分页
select t2.* from (select t1.*, rownum ro from (select e.* from emp e order by e.sal desc nulls last) t1 where rownum <= 6) t2 where t2.ro <= 3 ;
select t2.* from (select t1.*, rownum ro from (select e.* from emp e order by e.sal desc nulls last) t1 where rownum <= 6) t2 where t2.ro > 3 ;

--累计计算
--一年每月的累计销售额
select e.*,trunc(e.hiredate, 'month') months from emp e where e.sal is not null; -- 每月销售额 
select trunc(e.hiredate, 'month') months, sum(e.sal) from emp e where e.sal is not null group by trunc(e.hiredate, 'month'); -- 每月累计销售额

--一年每月的累计销售额
select  t1.months, sum(t2.sum_avg) from
(select trunc(e.hiredate, 'month') months, sum(e.sal) sum_avg from emp e where e.sal is not null group by trunc(e.hiredate, 'month')) t1, 
(select trunc(e.hiredate, 'month') months, sum(e.sal) sum_avg from emp e where e.sal is not null group by trunc(e.hiredate, 'month')) t2
where t1.months >= t2.months
group by t1.months
order by t1.months;

--分组TOPN  
--各部门工资前三的员工
select t.ename, t.sal from (select e.* from emp e order by e.sal desc nulls last) t where rownum <= 3;
--相关子查询
create table dept_sal as 
select e.ename,e.deptno,e.sal from emp e;

select * from dept_sal t1 
where (select count(1) from dept_sal t2  where t1.deptno = t2.deptno and t1.sal < t2.sal) <=2 
order by t1.deptno ,t1.sal desc;

--------------------增删改 都需要commit 提交服务器
--insert into/ delete / update [tablename] 
--创建表 
create table tb_student(
sno int primary key,   --主键 非null且唯一
sname varchar(8),
birth date,
height number(3,2),     --数值型三位，两位小数
create_time timestamp
);
select * from tb_student;

----添加数据
--insert into [tablename] (col, ...) values (val, ...)
insert into tb_student (sno, sname, birth, height, create_time) values (0, '赵0', '1-1月-2011', 1.72, systimestamp);

--如果插入的列包含所有列，则可以缺省   但col 与val 要一一对应

--修改数据  一定要使用主键修改  主键作为修改条件
update tb_student set sname = '赵一'  where sno = 0;

--删除数据 一定要使用主键修改  主键作为修改条件
delete tb_student  where sno =0;  -- 删除整行

--清空表数据 truncate table [tablename]; --不支持回滚  断开数据与表的连接
truncate table tb_student;

--rollback 回滚操作  针对增加(insert)删除(delete)修改(update)
rollback;

--查看对象（包含表和垃圾）
select * from tab;

--彻底删除 清空回收站 
purge recyclebin;

--修改表 alte table [tablename] add/ drop colum/ modify 
--增加一列
 alter table tb_student  add age number(2);
 
 --删除一列
 alter table tb_student drop column age;
 
 --修改一列  要注意数据长度 
 alter table tb_student modify sname varchar(12);
 
 
 --作业
 select e.*, d.* from emp e, dept d where e.deptno = d.deptno and e.sal is not null order by e.deptno;
 --列出员工表中每个部门的员工数，和部门 no
 select e.deptno, count(e.ename) from emp e
 group by e.deptno
 having e.deptno is not null
 order by e.deptno;
 
--列出员工表中每个部门的员工数（员工数必须大于 3），和部门名称
select d.dname, t.amount from dept d, (select e.deptno, count(e.ename) amount from emp e
group by e.deptno
having count(e.ename) > 3
order by e.deptno) t 
where d.deptno = t.deptno;

--找出工资比 jones 多的员工
select e2.* from (select e1.* from emp e1 where e1.ename = 'JONES'), 
emp e2 where e1.ename = e2.ename and e2.ename != 'JONES' and e2.sal > e1.sal;

--列出所有员工的姓名和其上级的姓名
select e1.ename, e1.mgr,e2.ename, e2.empno from emp e1, emp e2 where e1.mgr = e2.empno order by e1.ename;

--以职位分组，找出平均工资最高的两种职位
select t.job, t.avg_sal from 
(select e.job, round(avg(e.sal)) avg_sal from emp e group by e.job order by round(avg(e.sal)) desc nulls last) t 
where rownum <= 2;

--查找出不在部门 20，且比部门 20 中任何一个人工资都高的员工姓名、部门名称
select d.dname,t.ename from
( (select e.ename, e.deptno from emp e where e.sal > all( select e.sal from emp e where e.deptno = 20)and e.deptno != 20)) t, 
dept d where t.deptno = d.deptno ;

--得到平均工资大于 2000 的工作职种 job 
select e.job,round(avg(e.sal)) from emp e group by e.job
having e.job is not null and round(avg(e.sal)) > 2000
order by round(avg(e.sal)) desc;

--分部门得到工资大于 2000 的所有员工的平均工资，并且平均工资还要大于 2500
select e.deptno, avg(e.sal) from (select e.* from emp e where e.sal > 2000) e group by e.deptno 
having avg(e.sal) > 2500; 

--得到每个月工资总数最少的那个部门的部门编号，部门名称，部门位置
select d.dname, d.loc, t.deptno from
(select e.deptno, sum(nvl(e.sal, 0) + nvl(e.comm, 0)) from emp e group by e.deptno having e.deptno is not null order by e.deptno) t, dept d
where t.deptno = d.deptno and rownum <= 1;

--分部门得到平均工资等级为 2 级（等级表）的部门编号
select t.deptno from
(select e.deptno, round(avg(e.sal)) avgsal from emp e group by e.deptno) t, salgrade s
where t.avgsal between (select s.losal from salgrade s where grade = 2) and (select s.hisal from salgrade s where grade = 2);

select * from salgrade;
--查找出部门 10 和部门 20 中，工资最高第 3 名到工资第 5 名的员工的员工名字，部门名字，部门位置
select t3.ename, d.dname, d.loc from
(select t2.ename,t2.deptno  from 
(select rownum ro, t1.ename, t1.deptno from (select e.ename ,e.sal, e.deptno from emp e where e.deptno in (10, 20) order by e.sal desc) t1) t2
where ro in (3,4,5)) t3, dept d
where t3.deptno = d.deptno;

--查找出收入（工资加上奖金），下级比自己上级还高的员工编号，员工名字，员工收入
select t1.empno, t1.ename, t1.total from
(select nvl(e.sal, 0) + nvl(e.comm, 0) total, e.empno, e.ename, e.mgr from emp e order by nvl(e.sal, 0) + nvl(e.comm, 0) desc) t1, 
(select nvl(e.sal, 0) + nvl(e.comm, 0) total, e.empno, e.ename, e.mgr from emp e order by nvl(e.sal, 0) + nvl(e.comm, 0) desc) t2
where t1.mgr = t2.empno and t1.total > t2.total;
select * from emp;

--查找出工资等级不为 4 级的员工的员工名字，部门名字，部门位置
select t.ename,d.dname,d.loc from 
(select e.ename, e.sal, e.deptno from emp e where e.sal 
not between (select s.losal from salgrade s where s.grade = 4) and 
(select s.hisal from salgrade s where s.grade = 4)) t, dept d
where t.deptno = d.deptno;

--查找出职位和'MARTIN' 或者'SMITH'一样的员工的平均工资
select e.job from emp e where e.ename in ('MARTIN','SMITH');--找到两人的job
select e.job, round(avg(e.sal)) from emp e group by e.job 
having e.job is not null and e.job in(select e.job from emp e where e.ename in ('MARTIN','SMITH'));

--查找出不属于任何部门的员工
select e.* from emp e where e.deptno is null;

--按部门统计员工数，查出员工数最多的部门的第二名到第五名（列出部门名字，部门位置）
select t2.deptno, d.dname, d.loc from
(select t1.deptno, rownum ro from (select e.deptno, count(e.ename) from emp e group by e.deptno order by count(e.ename) desc) t1) t2, dept d
where t2.deptno = d.deptno and t2.ro in (2,3,4,5) ;

--查询出 king 所在部门的部门号\部门名称\部门人数
select t.deptno, max(t.dname), count(e.ename) from
(select d.deptno, d.dname from dept d where d.deptno = (select e.deptno from emp e where e.ename = 'KING')) t, emp e
group by t.deptno;

--查询出 king 所在部门的工作年限最大的员工名字
select t.ename from (
select e.ename, rownum ro, e.hiredate from emp e where e.deptno = 
(select e.deptno  from emp e where e.ename = 'KING') 
order by e.hiredate) t where ro <= 1;

--查询出工资成本最高的部门的部门号和部门名称  总工资最高的部门
select t2.deptno,d.dname, t2.total from 
(select t1.deptno,t1.total from
(select e.deptno, sum(nvl(e.sal, 0) + nvl(e.comm, 0)) total from emp e 
group by e.deptno 
having e.deptno is not null order by sum(nvl(e.sal, 0) + nvl(e.comm, 0)) desc ) t1 where rownum < 2) t2, dept d
where t2.deptno = d.deptno;
















