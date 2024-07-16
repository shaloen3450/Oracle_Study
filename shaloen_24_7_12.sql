--2024_7_12

----约束--给数据约定的一个规则

--约束分类    
--主键约束 非空且唯一                    primary key
--唯一约束  唯一性                           unique
--检查约束 条件约束 范围...              check (...)
--非空约束  不能为null                   not null
--缺省值     插入数据时可以不给定值 default ...
--外键约束                                        reference tablename

--创建表时添加约束
select * from tb_test;
create table tb_class(
cno int primary key,
cname varchar2(6)
);

create table tb_student_test(
sno int primary key,  --主键约束
sname varchar2(10) not null, --非空约束
phone varchar2(11) unique ,  --唯一性
sex varchar2(2) check (sex = '男' or sex = '女'), --检查约束
ctime timestamp default systimestamp,     --缺省值
cno int references tb_class); --外键约束
select * from tb_student_test;



--级联删除  删除父项时同时删除其所有引用  关键字 delete cascade


--创建表后再添加约束


--除主键外 其他约束在创建时均不使用




--索引
--【user】
--查询索引
select * from user_indexes;


---为什么要索引
--索引可以提高查询效率


-- 怎么建立索引 create index index_name on tablename(colum ...)
--oracle 索引的分类     唯一索引 非唯一索引  根据数据特征确定
--  电话号码列  （电话号码唯一）   建立唯一索引
--姓名列         （不唯一）               建立非唯一索引
--唯一索引查询效率比非唯一索引效率高   但插入数据时需要验证数据是否唯一



--复合索引 由多个列建立的索引 查询时使用多个条件 遵循最左前缀原则
--带有主键约束或唯一约束的列自带索引且为唯一索引


--索引的工作原理
--将索引列排序之后创建索引  索引内 存放的是数据和数据对应的物理地址
--搜索时搜索索引列得到物理地址
--索引列的数据结构是B-Tree

-- 什么时候使用索引 什么时候不用
--连接查询 范围查询  会使用索引 

--索引失效
--无法确定的 会导致索引失效   
--!= <> not in   

--模糊查询like 由通配符开头的会导致索引失效  '_A%' '%A'  ,  'A%'则不会
-- 计算或使用函数导致数据结构发生变化 会使索引失效 

--索引的使用
--1.数据少的表不使用索引
--2.经常查询的列需要索引
--3.经常修改 插入 删除的列不建立索引
--4.复合索引遵循最左前缀原则



--事务
--一系列操作视为一个原子操作
/*事务的四大特征ACID
1.原子性 atomic          不可分割
2.一致性 consistency 事务结束前后 数据整体不变
3.隔离性 isolation       多个事务独立运行，互不干扰
4.持久性 durability     事务一旦提交commit 将持久到数据库


事务的命令
commit rollback savepoint
*/


--pl/sql编程
--pl/sql块  顺序执行
--赋值号为:=  判断是否相等为 =

declare 
--森林部分 定义变量   变量名前加v_ 以区分列名
--oracle 两种变量类型 -列类型  -行类型
--  列类型  表名.col%type  自动匹配对应类型      v_sal emp.sal%type   --v_sal 自动匹配为sal的数据类型
--  行类型    表名%rowtype                                   v_row emp%rowtype
begin
--脚本部分
--执行出现异常时 跳转到 exception  进行异常处理
--exception when 异常代码 then 异常处理语句
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('数据不存在');
end;



--流程控制 
--分支
/*
if 条件一 then         分支开始
执行语句一

elsif 条件二 then
执行语句二

else 条件三
执行语句三

end if                       分支结束
*/
--循环
declare

begin
loop                         --循环开始


end loop;                --循环结束
end;
--两种退出循环的方式
/*1.loop

    exit when x = 10; -- 退出方式一  when 条件成立时退出loop

  end loop;
*/
/*2.while

while (x<=10) loop    --退出方式二  while判断是否进入loop
    dbms_output.put_line(x);
    x := x+1;
  end loop;
  
*/

--遍历  sql中 for循环只用于遍历
/*
for x in 1..10  loop
执行语句...
..
end loop;
*/

--函数 创建一个封装的代码块
--有且仅有一个返回值   格式
create or replace function f_fname(
--参数
v_ename emp.ename%type
)return varchar --return 返回值类型
as
--参数
begin
--函数脚本
return v_ename(10);   --return 返回值
end;
select * from emp;

--存储过程   通过 in out 匹配形参和返回值 
--游标  指针工具  用于遍历  可以取出一行数据
--且读取游标的值后游标会自动指向下一个值
--创建游标
create or replace package pk_package as 
type my_cursor is ref cursor;
end;

--使用游标
declare 
v_sql varchar2(1000);
v_cur pk_package.my_cursor;
v_row emp%rowtype;
begin

v_sql := 'select * from emp';
open v_cur for v_sql;      --打开游标
loop      --使用游标遍历emp表
fetch v_cur into v_row; -- 将游标数据传到v_row中  传完后游标会自动指向下一个数据
exit when v_cur%notfound;
end loop;
close v_cur;

end;

--分页
--in  页码 page in int, 每页的行数 amount in int
--out 总页数 pages out int 数据 v_cur out pk_package.my_cursor 

create or replace procedure output (      --参数部分
v_page in int,
v_amount in int,
v_pages out int,
v_cur out pk_package.my_cursor)
as
v_start int;          --每页的第一行
v_end int;           --每页的最后一行
v_total int;          --总行数
v_emp varchar2(1000); --存放查询得到的数据
begin

v_start := (v_page - 1) * v_amount;
v_end := v_page * v_amount;

v_emp :='select * from (select e.*, rownum ro from emp e  where rownum  <= '|| v_end ||' order by e.empno)  where ro > '||v_start;
select count(empno)  into v_total from emp;

v_pages := ceil(v_total/v_amount);
open v_cur for v_emp;
end;
--分页
select * from (select e.*, rownum ro from emp e  where rownum  <= v_total order by e.empno)  where ro > v_amount;


grant debug connect session to scott;
















