--多表查询

--笛卡尔积
select * from emp e,dept d;

--等值查询
select e.*, d.dname, d.loc from emp e,dept d where e.deptno = d.deptno;

--自连接
select * from emp e1, emp e2 where e1.mgr = e2.empno;

--不等值连接

select * from emp e, salgrade s where e.sal between s.losal and s.hisal order by s.grade,e.empno;

select * from emp e, salgrade s 
where sal between losal and hisal
order by grade, sal; 

--连接查询 左连接 右连接 连接 满外连接 

--左连接 left join on 保留左表 
select * from dept d left join emp e on d.deptno = e.deptno order by d.deptno;

--右连接 right join on 保留右表
select * from emp e right join dept d on e.deptno = d.deptno order by d.deptno;

--连接 join on  同笛卡尔积 不保留不匹配的行
select * from emp e join dept d on e.deptno = d.deptno order by d.deptno;

--增加一行数据 
insert  into emp(empno, ename) values (9000, 'ZHANGSAN');
commit;

--满外连接 full outer join on  全保留
select * from emp e full join dept d on e.deptno = d.deptno order by d.deptno;

select e.*,d.* from emp e full outer join dept d on e.deptno = d.deptno where e.deptno = 40; 

--常用函数

--字符函数
--大写 upper(待转换字符串)  键入名称搜索员工 
select * from emp e where e.ename = upper('&ename');

--小写 lower(待转换字符串)  
SELECT LOWER('Ename') 
  FROM dual;
SELECT LOWER(Ename) 
  FROM emp; 

--切割  substr(待切割部分,从第几位开始切割,切割长度) 不指定长度默认之后全部
select SUBSTR(e.ename,2,3) from emp e;  
select substr(e.ename,2) from emp e;

--填充  左填充lpad('待填充的内容',填充后有多少个字符,'用这个字符串填充') 右填充rpad('待填充的内容',填充后有多少个字符,'用这个字符串填充') 
select lpad(e.ename,10,'*_') from emp e;
select rpad(e.ename,10,'*_') from emp e;

--替换  replace() 后一个''的内容替换前一个''的内容 
SELECT REPLACE('JACK and JUE','J','BL') "Changes"
     FROM DUAL;
     
--拼接  concat(待拼接字符串1,待拼接字符串2，..,待拼接字符串n) 依次首尾相连拼接 
SELECT CONCAT(CONCAT(ename, '''s dept number is '), deptno) "deptno" 
  FROM emp 
  WHERE deptno = 10;
  
--首字母大写 initcap(待大写字符串) 
SELECT INITCAP('ename') "ename"
  FROM DUAL; 
  
select initcap(lower(ename)) from emp;

--数学函数
--向上取整 ceil(待取整数据)
select e.sal/10,ceil(e.sal/10) from emp e;

--向下取整 floor(待取整数据)
select e.sal/10,floor(e.sal/10) from emp e;

--取余数 mod(待除数据,除数)
select e.sal/10 除十的结果,mod(e.sal,10)  除十取余  from emp e;

--四舍五入 round(待四舍五入的数据)
select e.sal/10 除十的结果,round(e.sal/10) 除十四舍五入 from emp e;

--截取 trunc(待截取数据, 保留的小数位数) 不足的直接舍去
select e.sal/10000, trunc(e.sal/10000, 3) from emp e;
select e.sal/100, trunc(e.sal/100, 0) from emp e;
select e.sal/100, trunc(e.sal/100, -1) from emp e;

--日期函数


--计算时间差（月份） months_between(时间一，时间二)一减二得到的月份数 
select months_between(to_date('11-01-2022','MM-DD-YYYY'), to_date('11-08-2011','MM-DD-YYYY')) from dual;
select trunc(sysdate - to_date('2002-8-28','YYYY-MM-DD'),2) from dual;

--下个星期的日期 next_day()
select next_day(to_date('2024-7-8','yyyy-mm-dd'),'星期一') from dual;

--每月的最后一天 last_day()
select last_day(sysdate) from dual;

--系统时间 sysdate   systimestamp

select systimestamp from dual;
select sysdate from dual;

--转换函数
--转字符   to_char()
select to_char(1.2345) from dual;
select to_char(1.23450) from dual;
select to_char(0.2345) from dual;
select to_char(sysdate, 'yyyy-mm-dd') from dual;
select to_char(systimestamp,'yyyy-mm-dd hh24-mi-ss') from dual;

--转数值   to_number()
select to_number('100.00', '9g999d99') from dual;
select to_number('123') from dual;
--转日期   to_date()
select to_date('8-9-1980','mm-dd-YYYY') from dual;

--通用函数
--nvl() 对null设定一个值
select nvl(null, 1) from dual ;

--decode() 分支 只能做等值比较
select decode(10,1,'A',2,'B',3,'C','D') from dual;
select e.ename,e.sal,decode(e.deptno, 10,'ACCOUNTING',20,'RESEARCH',30,'SALES','OPERATIONS') DEPT
from emp e 
order by e.deptno, e.ename desc nulls last;


--case when() 比较 可以做不等值比较
select e.* from dept e;
select e.ename,e.deptno,e.job,e.sal,
case
when e.sal > 3000 then 'S'
when e.sal > 2000 then 'A'
when e.sal > 1400 then 'B'
when e.sal > 1200 then 'C'
else 'D' end as salgrade
from emp e
order by e.sal desc nulls last;


--分组函数 聚合函数  max min avg sum count  
--分组关键字  grounp by 分组查询关键字 having
select e.deptno, max(e.sal) "最大薪资", 
min(e.sal) "最小薪资", 
trunc(avg(e.sal),2) "平均工资", 
count(e.ename) "部门人数" 
from emp e group by e.deptno
order by e.deptno;

--单独使用聚合函数 相当于 一张表是一组
select e.* from emp e;
select e.job, count(e.ename) from emp e group by e.job;
select count(e.ename),sum(e.sal + nvl(e.comm, 0)) from emp e;

select count(d.ename) from emp e right join dept d on e.deptno = d.deptno group by d.deptno;

select d.dname from dept d group by d.dname;
select count(e.ename) from emp e group by e.deptno;


--作业
--单行
--找出每个月倒数第三天受雇的员工
select e.ename,e.hiredate from emp e where 2 = last_day(e.hiredate) - e.hiredate;

--找出 20 年前雇的员工 (参考实际时间)
select e.ename,e.hiredate from emp e;
select e.ename, e.hiredate, floor(months_between(sysdate, e.hiredate)/12) from emp e where floor(months_between(sysdate, e.hiredate)/12) > 10;

--所有员工名字前加上 Dear ,并且名字首字母大写
select e.ename, concat('Dear', initcap(lower(e.ename))) from emp e order by e.ename;

--找出姓名为 5 个字母的员工
select e.ename from emp e where length(e.ename) = 5
order by e.ename asc;

--找出姓名中不带 R 这个字母的员工
select e.ename from emp e where e.ename not like '%R%' order by e.ename asc;

--显示所有员工的姓名的第一个字
select e.ename, substr(e.ename,0,1) "首字母" from emp e order by e.ename;

--显示所有员工，按名字降序排列，若相同，则按工资升序排序
select e.ename, e.sal from emp e order by e.ename desc, e.sal asc;

--假设一个月为 30 天，找出所有员工的日薪，不计小数
select e.ename, e.sal, floor(nvl(e.sal, 0)/30) from emp e;  --去尾法
select e.ename, e.sal, ceil(nvl(e.sal, 0)/30) from emp e;   --进一法

--找到 2 月份受雇的员工
select e.ename, e.hiredate from emp e where extract(month FROM e.hiredate) = 2;

--列出员工加入公司的天数(四舍五入）
select e.ename, e.hiredate, round(sysdate - e.hiredate)  from emp e order by e.hiredate;

--多行分组
--分组统计各部门下工资>500 的员工的平均工资、
select e.deptno, round(avg(e.sal)) from dept d left join emp e on d.deptno = e.deptno
group by e.deptno
having min(e.sal) > 500
order by e.deptno;

--统计各部门下平均工资大于 500 的部门
select e.deptno, round(avg(e.sal)) from dept d left join emp e on e.deptno = d.deptno
group by e.deptno
having round(avg(e.sal)) > 500
order by e.deptno;

--算出部门 30 中得到最多奖金的员工奖金
select e.deptno, max(e.comm) from emp e
group by e.deptno
having e.deptno = 30;

--算出每个职位的员工数和最低工资
select e.job, count(e.ename), min(e.sal) from emp e join dept d  on e.deptno = d.deptno
group by e.job;

--列出员工表中每个部门的员工数，和部门 no
select e.deptno, max(d.dname), count(e.ename) from emp e join dept d on e.deptno = d.deptno
group by e.deptno;

--得到工资大于自己部门平均工资的员工信息
select e.deptno, min(e.ename), round(avg(e.sal)) "AVGsal" from emp e left join dept d on e.deptno = d.deptno
group by e.deptno
having max(e.sal) > avg(e.sal)
order by e.deptno asc;

--分组统计每个部门下，每种职位的平均奖金（也要算没奖金的人）和总工资(包括奖金)
select e.deptno, e.job "job", round(sum(nvl(e.comm, 0))/count(e.ename)) "AVGCOMM", round(sum(nvl(e.comm, 0)+ nvl(e.sal, 0))/count(e.ename)) "平均总工资"
from dept d right join emp e on d.deptno = e.deptno
group by e.deptno, e.job
order by e.deptno;


select e.*,d.* from emp e left join dept d on e.deptno = d.deptno
order by d.deptno; 
select e.ename, e.deptno, e.comm  from emp e
order by e.deptno;
