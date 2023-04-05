/* ����Ŭ �Լ�
# ������ �Լ�
    [1]������ �Լ�
    [2] ������ �Լ�
    [3] ��¥�� �Լ�
    [4] ��ȯ�� �Լ�
    [5] ��Ÿ �Լ�   */
    
-- dual : 1���� �ุ ���´�.

-----------------------------------------------------
[1] ������ �Լ�
- lower() / upper() : �ҹ��� / �빮�ڷ� �ٲ� ����ϴ� �Լ�
- initcap() : ù ���ڸ� �빮�ڷ� �������� �ҹ��ڷ� ��ȯ
- concat(�÷�1, �÷�2) : �÷�1�� �÷�2�� ������ ���� ��ȯ�Ѵ�.
- substr(�÷�, N, LEN) : �÷������� N���� �����Ͽ� LEN���̸�ŭ ������
- length(�÷�) : ���ڿ� ���� ��ȯ
- lpad(�÷�, n, c) : �÷����� n�ڸ���ŭ ����ϵ�, ���ʿ� ���� ������ ������ c ������ ä���
- rpad(�÷�, n, c) : �÷����� n�ڸ���ŭ ����ϵ�, �����ʿ� ���� ������ ������ c ������ ä���
- ltrim()/rtrim() : ����/������ ������ �����Ѵ�.
- ltrim(����1, ����2) 

-----------------------------------------------------
select lower('Happy Birthday to you'), upper('Happy birthday to you') from dual;
select initcap(ename) from emp;
select concat('ABCD','1234') from dual; 
select empno, ename, job, concat(ename,empno), concat(ename,job) from emp;
select substr('051224-1012456',1,6) from dual;
select substr('051224-1012456',8) from dual;
select substr('051224-1012456',-7) from dual;
select substr('ABCDEFG',-4,3)from dual;

---------------------------------------------------------
-- Q-[����] ��� ���̺��� ù���ڰ� 'K'���� ũ�� 'Y'���� ���� ����� ���,�̸�,����,�޿��� ����ϼ���. �� �̸������� �����ϼ���.
select empno,ename, job, sal from emp
where substr(ename,1,1)> 'K'and substr(ename,1,1)< 'Y';

--  ������̺��� �μ��� 20���� ����� ���,�̸�,�̸��ڸ���, �޿�,�޿��� �ڸ����� ����ϼ���.	
select empno, ename, deptno, length(ename), sal, length(sal)
from emp where deptno=20;
	
--	������̺��� ����̸� �� 6�ڸ� �̻��� �����ϴ� ������̸��� �̸��ڸ����� �����ּ���.
select ename,length(ename) from emp
where length(ename)>=6;

select ename,  lpad(ename,15,'*') from emp; -- ������ ����
select ename,  lpad(ename,15,'*'), sal, lpad(sal,10,'#') from emp; -- ������ ����

select dname, rpad(dname,15,'@')from dept;

select ltrim('TTTHeloow TEST', 'T'), LTRIM('TOPHELLO TEST', 'T') from dual;
select rtrim('TTTHello TEST','T') FROM DUAL;

select LTRIM('        ORACLE TEST '), RTRIM('   ORACLE TEST ') FROM DUAL;
select (RTRIM(LTRIM('      ORACLE TEST  '))) RESULT FROM DUAL;


--------------------------------------------------------------------
REPLACE(�÷�, ��1, ��2) : �÷��� �� ��1�� �ش��ϴ� ���� ������ ��2�� �����Ѵ�.

select REPLACE('ORACLE TEST', 'TEST','HI') FROM DUAL;
--------------------------------------------------------------------
--[����]
--	������̺��� 10�� �μ��� ����� ���� ������ �� ������'T'�� �����ϰ� �޿��� ������ 0�� �����Ͽ� ����ϼ���.      
desc emp;
select ename, RTRIM(job,'T'),sal, RTRIM(SAL,0) from emp;


-- ������̺� JOB���� 'A'�� '$'�� �ٲپ� ����ϼ���.
select ename,job, replace(job,'A','$')from emp;
--
--�� ���̺��� ������ �ش��ϴ� �÷����� ���� ������ �л��� ������ ��� ���л����� ������ ��µǰ� �ϼ���.
select name, job, replace(job, '�л�','���л�'), addr from member;

/*--------------------------------------------------------------------------------
 Update ���̺�� set �÷���1=��1 where ������

--�� ���̺� �ּҿ��� ����ø� ����Ư���÷� �����ϼ���
--------------------------------------------------------------------------------*/

select * from member;
update member set addr = '����Ư���� ���� ' where name= 'ȫ�浿'  and job = '�ֺ�';

rollback;

update member set addr = replace(addr,'�����', '���� Ư����');

--------------------------------------------------------------------------------
[2] ������ �Լ�
- round() : �ݿø� �Լ�
- round(��), round(��,�ڸ���) : �ڸ����� ����� �Ҽ��ڸ��� �ݿø��ϰ�, ������ �����ڸ��� �ݿø� �Ѵ�.

select round(4567.678), round(4567.678,0), round(4567.678,2),round(4567.678,-2) from dual;
----------------------------------------------------------------------------------------------
- trunc(��), trunc(��, �ڸ���) : ���� �Լ� ����

select trunc(4567.678),trunc(4567.678,0),trunc(4567.678,2),trunc(4567.678,-2) from dual;
----------------------------------------------------------------------------------------------
- mod(��1, ��2): ��1�� ��2�� ���� ���������� ��ȯ�ϴ� �Լ�
select mod(100,3) from dual;
----------------------------------------------------------------------------------------------
--[1] MEMBER���̺��� �� �̸���,���ϸ���,���̸� ����ϰ�, ���ϸ����� ���̷� ���� ���� �ݿø��Ͽ� ����ϼ���
desc member;
select name, mileage, age, round(mileage/age) from member;
--[2] ��ǰ ���̺��� ��ǰ ������� ����������� ���� ��ۺ� ���Ͽ� ����ϼ���.
desc products;
select trunc(trans_cost,-2) from products;
--[3] ������̺��� �μ���ȣ�� 10�� ����� �޿��� 	30���� ���� �������� ����ϼ���.
desc emp;
select ename, mod(sal,30) from emp where deptno =10;

----------------------------------------------------------------------------------------------

- ceil() : �ø� �Լ�
- floor() : ���� �Լ�
- abs() : ���밪�� ��ȯ
select ceil(12.001), floor(12.001) from dual;

select name, age, 40-age, abs(40-age)"40����� ���� ����" from member;

----------------------------------------------------------------------------------------------
[3] ��¥ �Լ�
��¥ ����

select sysdate, sysdate+3, sysdate-3 from dual;

date- date => �ϼ�
date + number => ��ĥ ��
date - number => ��ĥ ��

alter session set nls_date_format ='yy/mm/dd';

select (TO_DATE('23/05/05','YY/MM/DD') - SYSDATE) from dual;

--���� �ð����� 2�ð� ���� 2�ð� �� �ð��� ����ϼ���
to_char(date,'���˹��ڿ�')
��: yy
��: mm
��: dd
��: hh => hh24 (24�ð� ����)
��: mi
��: ss
select to_char(sysdate-2/24,'yy/mm/dd hh:mi:ss'), to_char(sysdate+2/24,'yy/mm/dd hh24:mi:ss') from dual;
select to_char(sysdate,'cc yyy') from dual;
select to_char(sysdate,'cc-yyy-ddd') from dual;
select to_char(sysdate,'cc-yyy-ddd dy') from dual;
select to_char(sysdate,'cc-yyy-ddd day') from dual;
ddd => 1���� �������� �� ��¥
dd => 1���� �������� �� ��¥
d => 1������ �������� �� ��¥

----------------------------------------------------------------------------------------------
- months_between(d1,d2) : �� ��¥ ������ ������ ���
- add_months(date,number) : ��¥�� number�� ��ŭ ���� ��¥�� ��ȯ��
- lasy_day(date)


select months_between(sysdate,(to_date('23/12/24','yy/mm/dd'))) from dual;

---------------------------------------------------------------------------------------------- 
-- ���ú��� 5�� ���� ��¥�� ����ϼ���
---------------------------------------------------------------------------------------------- 
select sysdate, add_months(sysdate,5) "5�� ��",add_months(sysdate,-5) "5�� ��" from dual;

select last_day(sysdate), last_day('23/02/01'), last_day('22/02/01'),last_day('20/02/01'), last_day('24/02/01') from dual;

-- ��� ���̺��� ������� �ٹ� �ϼ��� �� �� �����ΰ��� ����ϼ��� - �� �ݴ��ϼ��� ���� ��������� ����ϼ���
desc emp;
select ename, hiredate,trunc((sysdate- hiredate))"�ٹ��ϼ�", trunc((sysdate-hiredate)/365)"�ټӳ��", 
trunc((sysdate-hiredate)/7) "weeks", trunc(mod(sysdate - hiredate,7)) "DAYS"
from emp
order by 3;

---------------------------------------------------------------------------------------------- 
[4] ��ȯ�� �Լ�
- to_char() 
    * to_char(��¥, ��� ����) : date ������ ���ڿ��� ��ȯ�ϴ� �Լ�
    * to_char(����, ��� ����) : number ������ ���ڿ��� ��ȯ�ϴ� �Լ�
---------------------------------------------------------------------------------------------- 
select to_char(sysdate) from dual;
select to_char(sysdate,'yyyy-mm-dd hh12:mi:ss') from dual;

select to_char(25000,'99,999') from dual;
select to_char(25000,'$999,999') from dual;
----------------------------------------------------------------------------------------------
--1] ��ǰ ���̺��� ��ǰ�� ���� �ݾ��� ���� ǥ�� ������� ǥ���ϼ���.  õ�ڸ� ���� , �� ǥ���մϴ�.
select products_name, input_price, to_char(input_price,'l999g999g999')"���� ����"
from products
order by 2;

--2] ��ǰ ���̺��� ��ǰ�� �ǸŰ��� ����ϵ� ��ȭ�� ǥ���� �� ����ϴ� �����  ����Ͽ� ����ϼ���.[��: \10,000]
select products_name, output_price, to_char(output_price,'L999g999g999')"�Ǹ� ����"
from products
order by 2;

select to_char(trans_cost,'c99999.99') from products;

----------------------------------------------------------------------------------------------     
- to_date(���ڿ�, �������) : ���ڿ��� date�������� ��ȯ�ϴ� �Լ�

select sysdate-to_date('20220531','yyyymmdd') from dual;


--�����̺��� �� ���� �� ������ڰ� 2003�� 6��1�� ���� ����� ���� ������ ���� �ּ���
desc member;

select * from member
where reg_date>(to_date('2013/06/01','yyyy/mm/dd'));

-- �����̺� �ִ� �� ���� �� ��Ͽ����� 2013���� ���� ������ �����ּ���.
select * from member
where to_char(reg_date,'yyyy') = '2013';

----------------------------------------------------------------------------------------------     
- to_number(char|varchar2) : ���ڿ��� ���ڷ� ��ȯ�ϴ� �Լ�
- to_number(����, �������)

--select '\25,000' *5 from dual; [x]
select to_number('$25,000','$99,999') *2 from dual;

----------------------------------------------------------------------------------------------   
[5] ��Ÿ�Լ�
- nal()
- nal2()
- decode()
- rank()
- over()

----------------------------------------------------------------------------------------------   
- ex) decode(����, ��1,'��°�',...) : ���� ���� ��1�� ������ ��°� 1�� ���
select ename, deptno from emp;
select ename, deptno, decode(deptno,10,'ȸ��μ�',20,'�����μ�',30,'�����μ�','��Ÿ�μ�')
from emp order by deptno;

- ex) rank() over (�м���) : �м����� �������� ��ŷ�� �ű�� �Լ�
select * from(
select rank() over (order by sal desc) RNK, E.* from emp E)
where RNK<=3;
-- from������ ���� ��Ī�� ��𼭵� �������� but select ������ ���� ��Ī�� select �ȿ����� ��밡��

- ex) row_number() over() : �м����� �������� ���ȣ�� �ٿ��ش�.
select row_number() over(order by hiredate) RNUM, emp.* from emp;

select * from ( select row_number() over(order by hiredate) RNUM, EMP.* FROM EMP)
WHERE RNUM BETWEEN 11 AND 20;

----------------------------------------------------------------------------------------------  
- # �׷� �Լ� 
: group by���� �Բ� ���� ���� ����.
: ���� �� �Ǵ� ���̺� ��ü�� ���� �Լ��� ����Ǿ� �ϳ��� ����� ��ȯ�ϴ� �Լ�
---------------------------------------------------------------------------------------------- 
- avg() :��հ� _NULL �� ����
- sum() : �հ� _NULL �� ����
- min() : �ּҰ�
- max() : �ִ밪
- stddev() : ǥ������
- variance() : �л�
- count()

---------------------------------------------------------------------------------------------- 
- count()
select count(empno) from emp;

select count(mgr) from emp; -- null���� �����ϰ� ī������ �� (king_�� mgr���� null)

select count(distinct mgr) from emp; -- �ߺ����� �ʴ� ���� ��ȯ

select count(*) from EMP; -- NULL ���� ī���� ��

CREATE TABLE MYTAB(
    A NUMBER,
    B NUMBER,
    C NUMBER
);

DESC MYTAB;

INSERT INTO MYTAB(A,B,C) VALUES (NULL,NULL,NULL);
COMMIT;
SELECT * FROM MYTAB;

SELECT COUNT(A) FROM MYTAB; -- 0
SELECT COUNT(*) FROM MYTAB; -- 3

--------------------------------------------------------------------------------
--[1] emp���̺��� ��� SALESMAN�� ���Ͽ� �޿��� ���,�ְ��,������,�հ踦 ���Ͽ� ����ϼ���.
SELECT AVG(SAL)"���", MAX(SAL)"�ְ��", MIN(SAL)"������", SUM(SAL)"�հ�" FROM EMP WHERE JOB LIKE 'SALESMAN';

--[2] EMP���̺� ��ϵǾ� �ִ� �ο���, ���ʽ��� NULL�� �ƴ� �ο���,���ʽ��� ���,��ϵǾ� �ִ� �μ��� ���� ���Ͽ� ����ϼ���
DESC EMP;
SELECT COUNT(EMPNO)"�ο���", COUNT(COMM)"���ʽ� NOT NULL", AVG(COMM)"���ʽ� ���", COUNT(JOB)"��ϵ� �μ�" FROM EMP;

SELECT MIN(ENAME), MAX(ENAME), MIN(HIREDATE), MAX(HIREDATE), MIN(SAL), MAX(SAL) FROM EMP;

--------------------------------------------------------------------------------
GROUP BY : Ư�� �÷��̳� ���� �������� ���ڵ带 ��� �����͸� ������ �� ����ϴ� ���� (�׷��Լ��� �Բ� ���)

SELECT (GROUP BY)���� ���� �÷���, �׷��Լ�
FROM ���̺��
GROUP BY;



--------------------------------------------------------------------------------
--[1] �� ���̺��� ������ ������ �� ������ ���� ����� ���� �����ֽÿ�.
SELECT JOB, COUNT(*)
FROM MEMBER
GROUP BY JOB
ORDER BY COUNT(*);

--[2] �� ���̺��� ������ ����, �� ������ ���� �ִ� ���ϸ��� ������ �����ּ���
DESC MEMBER;
SELECT JOB, MAX(MILEAGE)
FROM MEMBER
GROUP BY JOB
ORDER BY MAX(MILEAGE) DESC;

--3] ��ǰ ���̺��� �� ��ǰī�װ����� �� �� ���� ��ǰ�� �ִ��� �����ּ���. ���� �ִ� �ǸŰ��� �ּ� �ǸŰ��� �Բ� �����ּ���.
DESC PRODUCTS;

SELECT CATEGORY_FK, COUNT(*), MAX(OUTPUT_PRICE), MIN(OUTPUT_PRICE)
FROM PRODUCTS
GROUP BY CATEGORY_FK
ORDER BY CATEGORY_FK;

--	4 ��ǰ ���̺��� �� ���޾�ü �ڵ庰�� ������ ��ǰ�� ����԰��� �����ּ���.
SELECT EP_CODE_FK, ROUND(AVG(INPUT_PRICE)) "��� �԰�"
FROM PRODUCTS
GROUP BY EP_CODE_FK;

--	5] ��� ���̺��� �Ի��� �⵵���� ��� ���� �����ּ���.
DESC EMP;

SELECT TO_CHAR(HIREDATE,'YY')"�Ի� �⵵",COUNT(*)"�����"
FROM EMP
GROUP BY TO_CHAR(HIREDATE,'YY')
ORDER BY 1;

--	6] ��� ���̺��� �ش�⵵ �� ������ �Ի��� ������� �����ּ���.
SELECT TO_CHAR(HIREDATE,'YY-MM')" �ش�⵵ �� ��" ,COUNT(*)"�����"
FROM EMP
GROUP BY TO_CHAR(HIREDATE,'YY-MM')
ORDER BY 1;;

--	7] ��� ���̺��� ������ �ִ� ����, �ּ� ������ ����ϼ���
SELECT JOB, MAX(SAL*12),MIN(SAL*12)
FROM EMP
GROUP BY JOB;


--------------------------------------------------------------------------------
- HAVING�� 
GROUP BY ���� �Բ� ���
GROUP BY�� ������ �ξ� �����͸� ��ȸ�� �� ����Ѵ�.


--------------------------------------------------------------------------------
SELECT JOB, COUNT(*)
FROM MEMBER
GROUP BY JOB
HAVING COUNT(*)>=2;


--1] �� ���̺��� ������ ������ �� ������ ���� �ִ� ���ϸ��� ������ �����ּ���. ��, �������� �ִ� ���ϸ����� 0�� ���� ���ܽ�ŵ�ô�.
SELECT JOB, MAX(MILEAGE)
FROM MEMBER
GROUP BY JOB
HAVING MAX(MILEAGE) !=0;

--	2] ��ǰ ���̺��� �� ī�װ����� ��ǰ�� ���� ���, �ش� ī�װ��� ��ǰ�� 2���� ��ǰ���� ������ �����ּ���.
DESC PRODUCTS;

SELECT CATEGORY_FK, COUNT(*)
FROM PRODUCTS
GROUP BY CATEGORY_FK
HAVING COUNT(*)=2;


--	3] ��ǰ ���̺��� �� ���޾�ü �ڵ庰�� ��ǰ �ǸŰ��� ��հ� �� ������ 100������ �������� �׸��� ������ �����ּ���
SELECT EP_CODE_FK, AVG(OUTPUT_PRICE)
FROM PRODUCTS
GROUP BY EP_CODE_FK
HAVING MOD(AVG(OUTPUT_PRICE),100)=0;


