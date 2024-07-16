--2024_7_12

----Լ��--������Լ����һ������

--Լ������    
--����Լ�� �ǿ���Ψһ                    primary key
--ΨһԼ��  Ψһ��                           unique
--���Լ�� ����Լ�� ��Χ...              check (...)
--�ǿ�Լ��  ����Ϊnull                   not null
--ȱʡֵ     ��������ʱ���Բ�����ֵ default ...
--���Լ��                                        reference tablename

--������ʱ���Լ��
select * from tb_test;
create table tb_class(
cno int primary key,
cname varchar2(6)
);

create table tb_student_test(
sno int primary key,  --����Լ��
sname varchar2(10) not null, --�ǿ�Լ��
phone varchar2(11) unique ,  --Ψһ��
sex varchar2(2) check (sex = '��' or sex = 'Ů'), --���Լ��
ctime timestamp default systimestamp,     --ȱʡֵ
cno int references tb_class); --���Լ��
select * from tb_student_test;



--����ɾ��  ɾ������ʱͬʱɾ������������  �ؼ��� delete cascade


--������������Լ��


--�������� ����Լ���ڴ���ʱ����ʹ��




--����
--��user��
--��ѯ����
select * from user_indexes;


---ΪʲôҪ����
--����������߲�ѯЧ��


-- ��ô�������� create index index_name on tablename(colum ...)
--oracle �����ķ���     Ψһ���� ��Ψһ����  ������������ȷ��
--  �绰������  ���绰����Ψһ��   ����Ψһ����
--������         ����Ψһ��               ������Ψһ����
--Ψһ������ѯЧ�ʱȷ�Ψһ����Ч�ʸ�   ����������ʱ��Ҫ��֤�����Ƿ�Ψһ



--�������� �ɶ���н��������� ��ѯʱʹ�ö������ ��ѭ����ǰ׺ԭ��
--��������Լ����ΨһԼ�������Դ�������ΪΨһ����


--�����Ĺ���ԭ��
--������������֮�󴴽�����  ������ ��ŵ������ݺ����ݶ�Ӧ�������ַ
--����ʱ���������еõ������ַ
--�����е����ݽṹ��B-Tree

-- ʲôʱ��ʹ������ ʲôʱ����
--���Ӳ�ѯ ��Χ��ѯ  ��ʹ������ 

--����ʧЧ
--�޷�ȷ���� �ᵼ������ʧЧ   
--!= <> not in   

--ģ����ѯlike ��ͨ�����ͷ�Ļᵼ������ʧЧ  '_A%' '%A'  ,  'A%'�򲻻�
-- �����ʹ�ú����������ݽṹ�����仯 ��ʹ����ʧЧ 

--������ʹ��
--1.�����ٵı�ʹ������
--2.������ѯ������Ҫ����
--3.�����޸� ���� ɾ�����в���������
--4.����������ѭ����ǰ׺ԭ��



--����
--һϵ�в�����Ϊһ��ԭ�Ӳ���
/*������Ĵ�����ACID
1.ԭ���� atomic          ���ɷָ�
2.һ���� consistency �������ǰ�� �������岻��
3.������ isolation       �������������У���������
4.�־��� durability     ����һ���ύcommit ���־õ����ݿ�


���������
commit rollback savepoint
*/


--pl/sql���
--pl/sql��  ˳��ִ��
--��ֵ��Ϊ:=  �ж��Ƿ����Ϊ =

declare 
--ɭ�ֲ��� �������   ������ǰ��v_ ����������
--oracle ���ֱ������� -������  -������
--  ������  ����.col%type  �Զ�ƥ���Ӧ����      v_sal emp.sal%type   --v_sal �Զ�ƥ��Ϊsal����������
--  ������    ����%rowtype                                   v_row emp%rowtype
begin
--�ű�����
--ִ�г����쳣ʱ ��ת�� exception  �����쳣����
--exception when �쳣���� then �쳣�������
EXCEPTION
WHEN no_data_found THEN
  dbms_output.put_line('���ݲ�����');
end;



--���̿��� 
--��֧
/*
if ����һ then         ��֧��ʼ
ִ�����һ

elsif ������ then
ִ������

else ������
ִ�������

end if                       ��֧����
*/
--ѭ��
declare

begin
loop                         --ѭ����ʼ


end loop;                --ѭ������
end;
--�����˳�ѭ���ķ�ʽ
/*1.loop

    exit when x = 10; -- �˳���ʽһ  when ��������ʱ�˳�loop

  end loop;
*/
/*2.while

while (x<=10) loop    --�˳���ʽ��  while�ж��Ƿ����loop
    dbms_output.put_line(x);
    x := x+1;
  end loop;
  
*/

--����  sql�� forѭ��ֻ���ڱ���
/*
for x in 1..10  loop
ִ�����...
..
end loop;
*/

--���� ����һ����װ�Ĵ����
--���ҽ���һ������ֵ   ��ʽ
create or replace function f_fname(
--����
v_ename emp.ename%type
)return varchar --return ����ֵ����
as
--����
begin
--�����ű�
return v_ename(10);   --return ����ֵ
end;
select * from emp;

--�洢����   ͨ�� in out ƥ���βκͷ���ֵ 
--�α�  ָ�빤��  ���ڱ���  ����ȡ��һ������
--�Ҷ�ȡ�α��ֵ���α���Զ�ָ����һ��ֵ
--�����α�
create or replace package pk_package as 
type my_cursor is ref cursor;
end;

--ʹ���α�
declare 
v_sql varchar2(1000);
v_cur pk_package.my_cursor;
v_row emp%rowtype;
begin

v_sql := 'select * from emp';
open v_cur for v_sql;      --���α�
loop      --ʹ���α����emp��
fetch v_cur into v_row; -- ���α����ݴ���v_row��  ������α���Զ�ָ����һ������
exit when v_cur%notfound;
end loop;
close v_cur;

end;

--��ҳ
--in  ҳ�� page in int, ÿҳ������ amount in int
--out ��ҳ�� pages out int ���� v_cur out pk_package.my_cursor 

create or replace procedure output (      --��������
v_page in int,
v_amount in int,
v_pages out int,
v_cur out pk_package.my_cursor)
as
v_start int;          --ÿҳ�ĵ�һ��
v_end int;           --ÿҳ�����һ��
v_total int;          --������
v_emp varchar2(1000); --��Ų�ѯ�õ�������
begin

v_start := (v_page - 1) * v_amount;
v_end := v_page * v_amount;

v_emp :='select * from (select e.*, rownum ro from emp e  where rownum  <= '|| v_end ||' order by e.empno)  where ro > '||v_start;
select count(empno)  into v_total from emp;

v_pages := ceil(v_total/v_amount);
open v_cur for v_emp;
end;
--��ҳ
select * from (select e.*, rownum ro from emp e  where rownum  <= v_total order by e.empno)  where ro > v_amount;


grant debug connect session to scott;
















