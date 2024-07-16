--����ѯ

--�ѿ�����
select * from emp e,dept d;

--��ֵ��ѯ
select e.*, d.dname, d.loc from emp e,dept d where e.deptno = d.deptno;

--������
select * from emp e1, emp e2 where e1.mgr = e2.empno;

--����ֵ����

select * from emp e, salgrade s where e.sal between s.losal and s.hisal order by s.grade,e.empno;

select * from emp e, salgrade s 
where sal between losal and hisal
order by grade, sal; 

--���Ӳ�ѯ ������ ������ ���� �������� 

--������ left join on ������� 
select * from dept d left join emp e on d.deptno = e.deptno order by d.deptno;

--������ right join on �����ұ�
select * from emp e right join dept d on e.deptno = d.deptno order by d.deptno;

--���� join on  ͬ�ѿ����� ��������ƥ�����
select * from emp e join dept d on e.deptno = d.deptno order by d.deptno;

--����һ������ 
insert  into emp(empno, ename) values (9000, 'ZHANGSAN');
commit;

--�������� full outer join on  ȫ����
select * from emp e full join dept d on e.deptno = d.deptno order by d.deptno;

select e.*,d.* from emp e full outer join dept d on e.deptno = d.deptno where e.deptno = 40; 

--���ú���

--�ַ�����
--��д upper(��ת���ַ���)  ������������Ա�� 
select * from emp e where e.ename = upper('&ename');

--Сд lower(��ת���ַ���)  
SELECT LOWER('Ename') 
  FROM dual;
SELECT LOWER(Ename) 
  FROM emp; 

--�и�  substr(���и��,�ӵڼ�λ��ʼ�и�,�и��) ��ָ������Ĭ��֮��ȫ��
select SUBSTR(e.ename,2,3) from emp e;  
select substr(e.ename,2) from emp e;

--���  �����lpad('����������',�����ж��ٸ��ַ�,'������ַ������') �����rpad('����������',�����ж��ٸ��ַ�,'������ַ������') 
select lpad(e.ename,10,'*_') from emp e;
select rpad(e.ename,10,'*_') from emp e;

--�滻  replace() ��һ��''�������滻ǰһ��''������ 
SELECT REPLACE('JACK and JUE','J','BL') "Changes"
     FROM DUAL;
     
--ƴ��  concat(��ƴ���ַ���1,��ƴ���ַ���2��..,��ƴ���ַ���n) ������β����ƴ�� 
SELECT CONCAT(CONCAT(ename, '''s dept number is '), deptno) "deptno" 
  FROM emp 
  WHERE deptno = 10;
  
--����ĸ��д initcap(����д�ַ���) 
SELECT INITCAP('ename') "ename"
  FROM DUAL; 
  
select initcap(lower(ename)) from emp;

--��ѧ����
--����ȡ�� ceil(��ȡ������)
select e.sal/10,ceil(e.sal/10) from emp e;

--����ȡ�� floor(��ȡ������)
select e.sal/10,floor(e.sal/10) from emp e;

--ȡ���� mod(��������,����)
select e.sal/10 ��ʮ�Ľ��,mod(e.sal,10)  ��ʮȡ��  from emp e;

--�������� round(���������������)
select e.sal/10 ��ʮ�Ľ��,round(e.sal/10) ��ʮ�������� from emp e;

--��ȡ trunc(����ȡ����, ������С��λ��) �����ֱ����ȥ
select e.sal/10000, trunc(e.sal/10000, 3) from emp e;
select e.sal/100, trunc(e.sal/100, 0) from emp e;
select e.sal/100, trunc(e.sal/100, -1) from emp e;

--���ں���


--����ʱ���·ݣ� months_between(ʱ��һ��ʱ���)һ�����õ����·��� 
select months_between(to_date('11-01-2022','MM-DD-YYYY'), to_date('11-08-2011','MM-DD-YYYY')) from dual;
select trunc(sysdate - to_date('2002-8-28','YYYY-MM-DD'),2) from dual;

--�¸����ڵ����� next_day()
select next_day(to_date('2024-7-8','yyyy-mm-dd'),'����һ') from dual;

--ÿ�µ����һ�� last_day()
select last_day(sysdate) from dual;

--ϵͳʱ�� sysdate   systimestamp

select systimestamp from dual;
select sysdate from dual;

--ת������
--ת�ַ�   to_char()
select to_char(1.2345) from dual;
select to_char(1.23450) from dual;
select to_char(0.2345) from dual;
select to_char(sysdate, 'yyyy-mm-dd') from dual;
select to_char(systimestamp,'yyyy-mm-dd hh24-mi-ss') from dual;

--ת��ֵ   to_number()
select to_number('100.00', '9g999d99') from dual;
select to_number('123') from dual;
--ת����   to_date()
select to_date('8-9-1980','mm-dd-YYYY') from dual;

--ͨ�ú���
--nvl() ��null�趨һ��ֵ
select nvl(null, 1) from dual ;

--decode() ��֧ ֻ������ֵ�Ƚ�
select decode(10,1,'A',2,'B',3,'C','D') from dual;
select e.ename,e.sal,decode(e.deptno, 10,'ACCOUNTING',20,'RESEARCH',30,'SALES','OPERATIONS') DEPT
from emp e 
order by e.deptno, e.ename desc nulls last;


--case when() �Ƚ� ����������ֵ�Ƚ�
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


--���麯�� �ۺϺ���  max min avg sum count  
--����ؼ���  grounp by �����ѯ�ؼ��� having
select e.deptno, max(e.sal) "���н��", 
min(e.sal) "��Сн��", 
trunc(avg(e.sal),2) "ƽ������", 
count(e.ename) "��������" 
from emp e group by e.deptno
order by e.deptno;

--����ʹ�þۺϺ��� �൱�� һ�ű���һ��
select e.* from emp e;
select e.job, count(e.ename) from emp e group by e.job;
select count(e.ename),sum(e.sal + nvl(e.comm, 0)) from emp e;

select count(d.ename) from emp e right join dept d on e.deptno = d.deptno group by d.deptno;

select d.dname from dept d group by d.dname;
select count(e.ename) from emp e group by e.deptno;


--��ҵ
--����
--�ҳ�ÿ���µ����������ܹ͵�Ա��
select e.ename,e.hiredate from emp e where 2 = last_day(e.hiredate) - e.hiredate;

--�ҳ� 20 ��ǰ�͵�Ա�� (�ο�ʵ��ʱ��)
select e.ename,e.hiredate from emp e;
select e.ename, e.hiredate, floor(months_between(sysdate, e.hiredate)/12) from emp e where floor(months_between(sysdate, e.hiredate)/12) > 10;

--����Ա������ǰ���� Dear ,������������ĸ��д
select e.ename, concat('Dear', initcap(lower(e.ename))) from emp e order by e.ename;

--�ҳ�����Ϊ 5 ����ĸ��Ա��
select e.ename from emp e where length(e.ename) = 5
order by e.ename asc;

--�ҳ������в��� R �����ĸ��Ա��
select e.ename from emp e where e.ename not like '%R%' order by e.ename asc;

--��ʾ����Ա���������ĵ�һ����
select e.ename, substr(e.ename,0,1) "����ĸ" from emp e order by e.ename;

--��ʾ����Ա���������ֽ������У�����ͬ���򰴹�����������
select e.ename, e.sal from emp e order by e.ename desc, e.sal asc;

--����һ����Ϊ 30 �죬�ҳ�����Ա������н������С��
select e.ename, e.sal, floor(nvl(e.sal, 0)/30) from emp e;  --ȥβ��
select e.ename, e.sal, ceil(nvl(e.sal, 0)/30) from emp e;   --��һ��

--�ҵ� 2 �·��ܹ͵�Ա��
select e.ename, e.hiredate from emp e where extract(month FROM e.hiredate) = 2;

--�г�Ա�����빫˾������(�������룩
select e.ename, e.hiredate, round(sysdate - e.hiredate)  from emp e order by e.hiredate;

--���з���
--����ͳ�Ƹ������¹���>500 ��Ա����ƽ�����ʡ�
select e.deptno, round(avg(e.sal)) from dept d left join emp e on d.deptno = e.deptno
group by e.deptno
having min(e.sal) > 500
order by e.deptno;

--ͳ�Ƹ�������ƽ�����ʴ��� 500 �Ĳ���
select e.deptno, round(avg(e.sal)) from dept d left join emp e on e.deptno = d.deptno
group by e.deptno
having round(avg(e.sal)) > 500
order by e.deptno;

--������� 30 �еõ���ཱ���Ա������
select e.deptno, max(e.comm) from emp e
group by e.deptno
having e.deptno = 30;

--���ÿ��ְλ��Ա��������͹���
select e.job, count(e.ename), min(e.sal) from emp e join dept d  on e.deptno = d.deptno
group by e.job;

--�г�Ա������ÿ�����ŵ�Ա�������Ͳ��� no
select e.deptno, max(d.dname), count(e.ename) from emp e join dept d on e.deptno = d.deptno
group by e.deptno;

--�õ����ʴ����Լ�����ƽ�����ʵ�Ա����Ϣ
select e.deptno, min(e.ename), round(avg(e.sal)) "AVGsal" from emp e left join dept d on e.deptno = d.deptno
group by e.deptno
having max(e.sal) > avg(e.sal)
order by e.deptno asc;

--����ͳ��ÿ�������£�ÿ��ְλ��ƽ������ҲҪ��û������ˣ����ܹ���(��������)
select e.deptno, e.job "job", round(sum(nvl(e.comm, 0))/count(e.ename)) "AVGCOMM", round(sum(nvl(e.comm, 0)+ nvl(e.sal, 0))/count(e.ename)) "ƽ���ܹ���"
from dept d right join emp e on d.deptno = e.deptno
group by e.deptno, e.job
order by e.deptno;


select e.*,d.* from emp e left join dept d on e.deptno = d.deptno
order by d.deptno; 
select e.ename, e.deptno, e.comm  from emp e
order by e.deptno;
