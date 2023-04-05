# ����Ŭ ��ü
--------------------------------------------------------------------------------
[1] ������ (sequence)
CREATE SEQUENCE �������� 
[INCREMENT BY n]
[START WITH n] 
[{MAXVALUE n | NOMAXVALE}] 
[{MINVALUE n | NOMINVALUE}] 
[{CYCLE | NOCYCLE}] 
[{CACHE | NOCACHE}];

EX_01 
- DEPT�� �μ���ȣ�� ����� �������� �����غ���
���۰� : 50, ����ġ : 10, �ִ밪 : 90, �ּҰ� : 50, NOCYCLE, NOCACHE


- EX_01_SOL
CREATE SEQUENCE DEPT_SEQ
START WITH 50
INCREMENT BY 10
MAXVALUE 90
MINVALUE 50
NOCYCLE
NOCACHE;


- ������ �������� ��ȸ�ϱ� 
: USER_OBJECTS
: USER_SEQUENCES
SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE ='SEQUENCE';
SELECT * FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'DEPT_SEQ';


- ������ ���簪 ��ȸ 
: ��������.CURRVAL
: [����] NEXTVAL�� ���� ����ä�� CURRVAL�� �䱸�� �� ����. => ERROR
SELECT DEPT_SEQ.NEXTVAL FROM DUAL;
SELECT DEPT_SEQ.CURRVAL FROM DUAL;


- ������ ������ ��ȸ
: ��������.NEXTVAL
INSERT INTO DEPT(DEPTNO,DNAME,LOC) 
VALUES(DEPT_SEQ.NEXTVAL, 'EDUCATION'||DEPT_SEQ.CURRVAL, 'SEOUL');

SELECT * FROM DEPT;

ROLLBACK;

--------------------------------------------------------------------------------
# ������ ����/���� 
: [����] START WITH�� ���� �Ұ���
ALTER SEQUENCE �ÈB����
INCREMENT BY M
MAXVALUE N|NOMAXVALUE
MINVALUE N|NOMAXVALUE
CYCLE |NOCYCLE
CACHE N|NOCACHE

Q. DEPT_SEQ�� �Ʒ��� ���� �����ϼ���
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
select dept_seq.nextval from dual;


--------------------------------------------------------------------------------
# ������ ����
: DROP SEQUENCE ������ ��;

DROP SEQUENCE DEPT_SEQ;

--------------------------------------------------------------------------------
[2] VIEW
CREATE VIEW ���̸�
AS
SELECT �÷���1, �÷���2...
FROM �信 ����� ���̺��
WHERE ����;

Q. EMP ���̺��� 20�� �μ��� ��� �÷��� �����ϴ� EMP20_VIEW�� �����϶�

CREATE VIEW EMP20_VIEW
AS 
SELECT * 
FROM EMP 
WHERE DEPTNO=20;

SYSTEN, SYS �������� �����ؼ� SCOTT���� ������ �ο�����
CONN SYSTEM/Abcd1234;
SHOW USER;
GRANT CREATE VIEW TO SCOTT;

������ �������� VIEW�� ��ȸ�ϱ�
SELECT * FROM USER_VIEWS;

SELECT * FROM EMP20_VIEW;


Q. [1] EMP���̺��� 30�� �μ��� EMPNO�� EMP_NO�� ENAME�� NAME���� SAL�� SALARY�� �ٲپ� EMP30_VIEW�� �����Ͽ���.
CREATE VIEW EMP30_VIEW
AS
SELECT EMPNO EMP_NO, ENAME NAME, SAL SALARY FROM EMP WHERE DEPTNO =30;
SELECT * FROM EMP30_VIEW;
   
Q. [2] �����̺��� �� ���� �� ���̰� 19�� �̻��� ���� ������ Ȯ���ϴ� �並 
��������.�� ���� �̸��� MEMBER_19�� �ϼ���.

CREATE VIEW MEMBER_19
AS
SELECT * 
FROM MEMBER 
WHERE AGE>=19;

SELECT* FROM MEMBER_19;

update member set age = 17 where num=1;

--------------------------------------------------------------------------------
# view ���� : or replace �ɼ��� �־� �����Ѵ�
create or replace view member_19
as
select * from member where age<19;

select * from member_19;
--------------------------------------------------------------------------------
Q. [1] �μ��� �޿��Ѿ�, �����, ��ձ޿�(�Ҽ���2�ڸ�����), �ּұ޿�,�ִ�޿��� ����ϴ�
    view�� ���弼��
    ���̸�: emp_statistic
    
CREATE VIEW EMP_STATISTIC
AS
SELECT DEPTNO, SUM(SAL) SUM_SAL, COUNT(*) CNT, ROUND(AVG(SAL),2) 
    AVG_SAL, MIN(SAL) MIN_SAL, MAX(SAL) MAX_SAL
FROM EMP 
GROUP BY DEPTNO;

SELECT * FROM EMP_STATISTIC ORDER BY DEPTNO;

Q. [2] ī�װ�, ��ǰ�� join�Ͽ� �����ִ� view�� �����ϼ���
    ���̸�: products_view

CREATE VIEW PRODUCTS_VIEW
AS
SELECT CATEGORY_NAME, PRODUCTS_NAME, OUTPUT_PRICE, COMPANY
FROM CATEGORY C JOIN PRODUCTS P
    ON  P.CATEGORY_FK = C.CATEGORY_CODE;
    
SELECT * FROM PRODUCTS_VIEW WHERE CATEGORY_NAME LIKE '%����%';


select* from emp20_view;

update emp20_view set sal = sal*1.5 where ename like 'SCOTT';

select * from emp where ename like 'SCOTT';

=> GROUP BY���� �̿��ؼ� ������ VIEW�� �� ������ �Ұ����ϴ�.

ROLLBACK;

--------------------------------------------------------------------------------
# VIEW�� �ɼ�
<1> WITH READ ONLY 
: �б� �������θ� VIEW�� ����ϰ��� �� ���

CREATE OR REPLACE VIEW EMP10_VIEW
AS
SELECT EMPNO, ENAME, JOB, DEPTNO
FROM EMP WHERE DEPTNO = 10
WITH READ ONLY;

SELECT * FROM EMP10_VIEW;

UPDATE EMP SET JOB = 'ANALYST' WHERE EMPNO = 7782;
ROLLBACK;
UPDATE EMP10_VIEW SET JOB = 'ANALYST' WHERE EMPNO = 7782;


<2> WITH CHECK OPTION 
: VIEW�� ������ �� �־��� ���ǿ� ���� �ʴ� �����Ͱ� INSERT, UPDATE �Ǵ� ���� ������� �ʴµ�.

Q. JOB�� SALESMAN�� ��� ������ ��� EMP_SALES_VIEW�� �����ϵ� WITH CHECK OPTION�� 
�༭ �����϶�

CREATE OR REPLACE VIEW EMP_SALES_VIEW
AS
SELECT * FROM EMP WHERE JOB LIKE 'SALESMAN'
WITH CHECK OPTION;

UPDATE EMP_SALES_VIEW SET COMM =100 WHERE EMPNO = 7844;
SELECT * FROM EMP_SALES_VIEW;[O]
SELECT * FROM EMP WHERE EMPNO = 7844; 

ROLLBACK;

UPDATE EMP_SALES_VIEW SET JOB = 'MANAGER' WHERE EMPNO = 7844; [X]
UPDATE EMP SET JOB = 'MANAGER' WHERE EMPNO = 7844;



--------------------------------------------------------------------------------
# INLINE VIEW
FROM ������ ����� SUBQUERY�� INLINE VIEW

RANK() OVER(�м���) : �м����� �������� ��ŷ�� �ű��.(���� ������ �ڼ����� �������)
ROW_NUMBER() OVER(�м���) : �м����� �������� ���ȣ�� �ű��. (���� ���Ƶ� �� ������ ����ȴ�)

�м���
PARITION BY �÷��� : �÷����� �������� �׷����� �Ѵ�.
ORDER BY �÷��� : �÷����� �������� �����Ѵ�.

SELECT RANK() OVER(ORDER BY SAL DESC) RNK, EMP.* 
FROM EMP;

Q. �������� �޿��� ���� �޴� ����� ������ �ű⼼��

SELECT RANK() OVER(PARTITION BY JOB ORDER BY SAL DESC) RNK, EMP.*
FROM EMP;

SELECT ROW_NUMBER() OVER(PARTITION BY JOB ORDER BY SAL DESC) RN, EMP.*
FROM EMP;

Q. ������ �޿��� ���� ���� �޴� ��� 1��� ����ϼ���
SELECT *
FROM (
    SELECT RANK() OVER(PARTITION BY JOB ORDER BY SAL DESC) RNK, EMP.* FROM EMP)
WHERE RNK=1;

desc emp;

select * from memo;
rollback;
desc emp;

update memo set msg = '�ȳ��ϼ���!!', wdate = sysdate where name like '�÷���';
select * from emp;
delete from emp where empno =321;
desc memo;

alter table memo modify msg varchar2(100);