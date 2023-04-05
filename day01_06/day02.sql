-- day2.sql
-- select �� �ǽ�

select * from dept;
select * from emp;

select DEPTNO, DNAME, LOC FROM DEPT;
SELECT ENAME, JOB, COMM,SAL*12+NVL(comm,0) "�� ��" FROM EMP;
SELECT ENAME, MGR, NVL2(MGR,'������ ����','������ ����')"������ ���� ����" FROM EMP;


-- '||'  : ���ڿ� ���� ������
SELECT ENAME || ' '|| 'IS A'|| JOB FROM EMP;

-- Q. ���� EMP���̺��� �̸��� ������ "KING: 1 YEAR SALARY = 60000" �������� ����϶�.
SELECT ENAME|| ' : 1 TEAR SALARY = '|| (sal*12+NVL(comm,0)) "����� ����" from emp order by sal DESC;



-- distinct : �ߺ� �� �����ϰ� 1���� ������
-- uniqe : distinct�� ���� ����
select job from emp;
select distinct job from emp;



-- emp���� ������� ����ϰ� �ִ� ������ ������ �����ּ���
select distinct job from emp;

select distinct deptno from emp;
select distinct deptno, job from emp order by deptno asc;
select distinct name, job from member;



--Q2. MEMBER���̺��� ȸ���� �̸��� ���� ������ �����ּ���.
select name,age from member;
select * from member;
--Q3. CATEGORY ���̺� ����� ��� ������ �����ּ���.
select * from category;
--Q4. MEMBER���̺��� ȸ���� �̸��� ������ ���ϸ����� �����ֵ�, ���ϸ����� 13�� ���� ����� "MILE_UP"�̶�� ��Ī���� �Բ� �����ּ���.
select  name, mileage ,mileage*13 "MILE_UP" from member;



-- where �� : ������
select * from emp where sal>=3000;

-- Q5. EMP���̺��� �������� MANAGER�� ����� ������ �����ȣ,�̸�,����,�޿�,�μ���ȣ�� ����ϼ���.
select * from emp;
select empno,ename,job,sal,deptno from emp where job = upper('manager');

-- Q6. EMP���̺��� 1982�� 1��1�� ���Ŀ� �Ի��� ����� �����ȣ,����,����,�޿�,�Ի����ڸ� ����ϼ���.
select empno, ename, job, sal, hiredate from emp where hiredate > '82/01/01';


-- Q7. emp���̺��� �޿��� 1300���� 1500������ ����� �̸�,����,�޿�,�μ���ȣ�� ����ϼ���.
select empno, ename, job, sal, deptno from emp where sal between 1300 and 1500;
	
--	Q8. emp���̺��� �����ȣ�� 7902,7788,7566�� ����� �����ȣ,�̸�,����,�޿�,�Ի����ڸ� ����ϼ���.
select empno, ename, job, sal, hiredate from emp where empno in(7902,7788,7566);
-- where empno = 7902 or empno = 7788 or empno =7566

--	Q9. 10�� �μ��� �ƴ� ����� �̸�,����,�μ���ȣ�� ����ϼ���
select ename, job, deptno from emp where deptno <> 10;
select ename, job, deptno from emp where deptno != 10;
select ename, job, deptno from emp where deptno not like 10;
desc emp;



-- # LIKE ������
-- Q10. EMP���̺��� �̸��� S�� ���۵Ǵ� ����� ������ �����ּ���.
select * from emp where ename like upper('s%');

-- Q11. �̸� �� S�ڰ� ���� ����� ������ �����ּ���.
select * from emp where ename like upper('%s%');

-- Q12. �̸��� �ι� °�� O�ڰ� ���� ����� ������ �����ּ���.
select * from emp where ename like upper('_o%');


desc member;
--	Q13. �� ���̺� ��� ���� �达�� ����� ������ �����ּ���.
select * from member where name like '��%';
--	Q14. �� ���̺� ��� '������'�� ���Ե� ������ �����ּ���.
select * from member where addr like '%����%';
--	Q15. ī�װ� ���̺� ��� category_code�� 0000�� ���� ��ǰ������ �����ּ���.

select * from category where category_code like '%0000';


--	Q16. 82�⵵�� �Ի��� ��� ������ �����ּ���
select * from emp where hiredate like '82%';




-- ��¥ ���� �ٲٱ�
alter session set nls_date_format='DD-mm-yy';
alter session set nls_date_format='yyyy-mm-dd';
select * from emp where hiredate like '%82';

--	Q17. comm�� null�� ����� �̸� ���� �޿� ���ʽ��� ����ϼ���
desc emp;
select ename, job, sal, comm from emp where comm is null;

-- null���� equal(=)�� ���ϸ� �ȵǰ� is null || is not null

-- �� ������ AND OR NOT


--- Q18. EMP���̺��� �޿��� 1100�̻��̰� JOB�� MANAGER�� ����� ���,�̸�,����,�޿��� ����ϼ���.
desc emp;
select empno, ename, job, sal from emp where sal>=1100 and job ='MANAGER';	

--	Q19. EMP���̺��� �޿��� 1100�̻��̰ų� JOB�� MANAGER�� ����� ���,�̸�,����,�޿��� ����ϼ���.
select empno, ename,job,sal from emp where sal>=1100 or job = 'MANAGER';

--	Q20. EMP���̺��� JOB�� MANAGER,CLERK,ANALYST�� �ƴ� ����� ���,�̸�,����,�޿��� ����ϼ���.
select empno, ename,job,sal from emp where job != 'MANAGER' and  job <> 'CLERK' and job != 'ANALYST';
select empno, ename,job,sal from emp where job not in('MANAGER','CLERK','ANALYST');



-- order by ��
-- �������� asc (default)
-- �������� desc

--	Q21. ������̺��� �Ի����� ������ �����Ͽ� ���,�̸�,����,�޿�,�Ի����ڸ� ����ϼ���.
desc emp;
select empno, ename, job, sal, hiredate from emp order by hiredate;
select empno, ename, job, sal, hiredate from emp order by hiredate desc;

select empno, ename, job, sal, sal*12 ANNSAL from emp order by sal*12 asc;
select empno, ename, job, sal, sal*12 ANNSAL from emp order by ANNSAL desc;


--	Q22.��� ���̺��� �μ���ȣ�� ������ �� �μ���ȣ�� ���� ��� �޿��� ���� ������ �����Ͽ� ���,�̸�,����,�μ���ȣ,�޿��� ����ϼ���.
select empno, ename, job, deptno, sal from emp order by deptno, sal desc; 

--	Q23.��� ���̺��� ù��° ������ �μ���ȣ��, �ι�° ������ ������, ����° ������ �޿��� ���� ������ �����Ͽ� ���,�̸�,�Ի�����,�μ���ȣ,����,�޿��� ����ϼ���
select empno, ename, job, deptno, sal from emp order by deptno, job, sal desc; 


select * from tab;
desc products;

-- Q24. ��ǰ ���̺��� �Ǹ� ������ ������ ������� ��ǰ�� �����ؼ� �����ּ���.
select * from products order by output_price;


-- Q25. �� ���̺��� ������ �̸��� ������ ������ �����ؼ� �����ּ���. ��, �̸��� ���� ��쿡�� ���̰� ���� ������� �����ּ���.
select * from member order by name, age desc;
desc member;


-- Q26. �� ���̺��� ������ ������ �� ������ ���� ����� ���� ���� ������� �����ּ���.
select job, count(*) 
from member 
group by job 
order by count(*) desc;


-- Q27. ��ǰ���̺��� ���޾�ü���� ����ǸŰ��� ���ϵ� ����ǸŰ� ������������ �����ּ���
select ep_code_fk, round(avg(output_price))"��� �ǸŰ�" 
from products 
group by ep_code_fk 
order by "��� �ǸŰ�" asc;













