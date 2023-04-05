# ����Ŭ ��ü
[1] ������(sequence)

CREATE SEQUENCE �������� 
[INCREMENT BY n]
[START WITH n] 
[{MAXVALUE n | NOMAXVALE}] 
[{MINVALUE n | NOMINVALUE}] 
[{CYCLE | NOCYCLE}] 
[{CACHE | NOCACHE}] 
-------------------------------------------
desc dept;
dept�� �μ���ȣ�� ����� �������� �����غ���

���۰� : 50
����ġ : 10
�ִ밪 : 90
�ּҰ� : 50
nocycle
nocache
------------------------
create sequence dept_seq
start with 50
increment by 10
maxvalue 90
minvalue 50
nocycle
nocache;

- ������ �������� ��ȸ�ϱ�
user_objects
user_sequences

select * from user_objects where object_type='SEQUENCE';
SELECT * FROM USER_SEQUENCES;

-- ������ ���簪 ��ȸ: ��������.CURRVAL
-- ������ ������ ��ȸ: ��������.NEXTVAL
: [����] NEXTVAL�� ���� ����ä�� CURRVAL�� �䱸�� �� ���� => �����߻�
SELECT DEPT_SEQ.CURRVAL FROM DUAL; 

SELECT DEPT_SEQ.NEXTVAL FROM DUAL;

INSERT INTO DEPT(DEPTNO,DNAME,LOC)
VALUES(DEPT_SEQ.NEXTVAL,'EDUCATION'||DEPT_SEQ.CURRVAL,'SEOUL');

SELECT * FROM DEPT;

ROLLBACK;

#  ������ ����/ ����
[����] START WITH �� ���� �Ұ�
ALTER SEQUENCE ��������
INCREMENT BY N
MAXVALUE N|NOMAXVALUE
MINVALUE N|NOMINVALUE
CYCLE|NOCYCLE
CACHE N|NOCACHE

���� 
DROP SEQUENCE ��������

--DEPT_SEQ�� �Ʒ��� ���� �����ϼ���
--MAXVALUE 99
--MINVALUE 50
--����ġ 5
--CYCLE �����ϵ���
--CACHE 10

ALTER SEQUENCE DEPT_SEQ
INCREMENT BY 5
MAXVALUE 99
MINVALUE 50
CYCLE
CACHE 10;

SELECT * FROM USER_SEQUENCES;

SELECT DEPT_SEQ.NEXTVAL FROM DUAL;

DROP SEQUENCE DEPT_SEQ;
----------------------------------------
[2] VIEW
--
--CREATE VIEW ���̸�
--	AS
--	SELECT �÷���1, �÷���2...
--	FROM �信 ����� ���̺��
--	WHERE ����
--
--	[�ǽ�]
--	EMP���̺��� 20�� �μ��� ��� �÷��� �����ϴ� EMP20_VIEW�� �����϶�.

CREATE VIEW EMP20_VIEW
AS
SELECT * FROM EMP
WHERE DEPTNO=20;

=> ERROR�߻� INSUFFICIENT PRIVILEGES
�� ���� ������ �ο��ؾ� ���� �����ϴ�

SYSTEM, SYS ���� ���� �����ؼ� SCOTT���� ������ �ο�����
CONN SYSTEM/Abcd1234
SHOW USER;
GRANT CREATE VIEW TO SCOTT;

-- ������ �������� view�� ��ȸ�ϱ�
-- user_views

select * from user_views;

select * from emp20_view;

--
--[1] EMP���̺��� 30�� �μ��� EMPNO�� EMP_NO�� ENAME�� NAME����
--	SAL�� SALARY�� �ٲپ� EMP30_VIEW�� �����Ͽ���.
create view emp30_view
as
select empno emp_no, ename name, sal salary, deptno dno
from emp
where deptno=30;

select * from emp30_view;

--    
--[2] �����̺��� �� ���� �� ���̰� 19�� �̻���
--	���� ������
--	Ȯ���ϴ� �並 ��������.
--	�� ���� �̸��� MEMBER_19�� �ϼ���.
create view member_19
as
select * from member where age>=19;

select * from member_19;

update member set age=17 where num=1;

# view ����
- or replace �ɼ��� �־� �����Ѵ�
create or replace view member_19
as
select * from member where age<19;

select * from member_19;

--
--[1] �μ��� �޿��Ѿ�, �����, ��ձ޿�(�Ҽ���2�ڸ�����), �ּұ޿�,�ִ�޿��� ����ϴ�
--view�� ���弼��
--���̸�: emp_statistic
create or replace view emp_statistic
as
select deptno, sum(sal) sum_sal, count(empno) cnt,
round(avg(sal),2) avg_sal, min(sal) min_sal, max(sal) max_sal
from emp
group by deptno;

select * from emp_statistic order by deptno;

--
--[2] ī�װ�, ��ǰ�� join�Ͽ� �����ִ� view�� �����ϼ���
--���̸�: products_view

create or replace view product_view
as
select category_name, products_name, output_price, company
from category c join products p
on c.category_code = p.category_fk;

select * from product_view
where category_name like '%����%';


select category_name, products_name, output_price, company
from category c join products p
on c.category_code = p.category_fk
where  category_name like '%����%';

select * from emp20_view;

update emp20_view set sal=sal*1.1 where ename=upper('scott');

select * from emp;

-- group by ���� �̿��ؼ� ������ view�� dml������ �Ұ����ϴ�.

rollback;

# view �� �ɼ�

<1> with read only : �б� �������θ� view�� ����ϰ��� �� ���
<2> with check option: view�� �����Ҷ� �־��� ���ǿ� �����ʴ� 
            �����Ͱ� insert�ǰų� update�Ǵ� ���� ������� �ʴ´�
------------------------------------------------------------------
create or replace view emp10_view
as
select empno,ename,job,deptno
from emp where deptno=10
with read only;

select * from emp10_view;

update emp set job='ANALYST' where empno=7782;

rollback;

update emp10_view set job='ANALYST' where empno=7782;
-- cannot perform a DML operation on a read-only view
-----------------------------------------------------
--job�� SALESMAN�� ��� ������ ��� EMP_SALES_VIEW�� �����ϵ�
--WITH CHECK OPTION�� �༭ �����ϼ���

CREATE OR REPLACE VIEW EMP_SALES_VIEW
AS
SELECT * FROM EMP
WHERE JOB='SALESMAN'
WITH CHECK OPTION;

SELECT * FROM EMP_SALES_VIEW;
SELECT * FROM EMP;
UPDATE EMP_SALES_VIEW SET COMM=100 WHERE EMPNO=7844; -- [O]
UPDATE EMP_SALES_VIEW SET JOB='MANAGER' WHERE EMPNO=7844;--[X]
--ORA-01402: view WITH CHECK OPTION where-clause violation

UPDATE EMP SET JOB='MANAGER' WHERE EMPNO=7844;

ROLLBACK;

# INLINE VIEW
FROM ���� ����� SUBQUERY�� INLINE VIEW��� ��
