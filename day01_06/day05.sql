-- dept 2 ���̺��� deptno �÷��� primary key ���������� �߰��غ���
alter table dept2 add constraint dept2_deptno_pk primary key(deptno);

desc dept2;

insert into dept2 values(10,'�빫��','����');
select * from dept2;

-- emp2 ���̺��� deptno �÷��� dept2 �� deptno �÷��� �����ϴ� �ܷ�Ű�� ���������� �߰��غ���
ALTER TABLE EMP2 ADD CONSTRAINT EMP2_DEPTNO_FK FOREIGN KEY (DEPTNO) 
REFERENCES DEPT2 (DEPTNO);
COMMIT;

SELECT * FROM DEPT2;
SELECT * FROM EMP2;

-- EMP2 �� 7566�� ����� �μ� ��ȣ�� 40�� �μ��� �����ϼ���
DESC EMP2;
UPDATE EMP2 SET DEPTNO = 40 WHERE EMPNO = 7566;

-- 7521�� ����� �μ���ȣ�� 90������ �����ϼ���
UPDATE EMP2 SET DEPTNO = 90 WHERE EMPNO =7521; -- �θ� ���̺� ���� �����ͷ� �����Ϸ��� �� ��� ���Ἲ �������� ������ �߻��Ѵ�.






--------------------------------------------------------------------------------

# DELETE �� - ������ ����
DELETE FROM ���̺�� WHERE ������; -- �������� ������ ���̺��� ��� �����Ͱ� ������

--------------------------------------------------------------------------------
7521�� ����� �μ���ȣ�� 90�� �μ��� �����ϼ���

-- EMP2���̺��� �����ȣ�� 7499�� ����� ������ �����϶�.
DELETE FROM EMP2 WHERE EMPNO=7499;	

-- EMP2���̺��� �Ի����ڰ� 83���� ����� ������ �����϶�.
DESC EMP2;
DELETE FROM EMP2 WHERE HIREDATE LIKE '83%';
-- DELETE FROM EMP2 WHERE TO_CHAR(HIREDATE,'YY')='83';

--EMP2���̺��� �μ����� 'SALES'�� ����� ������ �����ϼ���
DELETE FROM EMP2 WHERE DEPTNO =(SELECT DEPTNO FROM DEPT WHERE DNAME LIKE 'SALES');

--1] ��ǰ ���̺� �ִ� ��ǰ �� ��ǰ�� �Ǹ� ������ 100000�� ������ ��ǰ�� ��� �����ϼ���.
SELECT *FROM PRODUCTS WHERE OUTPUT_PRICE<=10000;
DELETE FROM PRODUCTS WHERE OUTPUT_PRICE<=10000;
ROLLBACK;
--	2] ��ǰ ���̺� �ִ� ��ǰ �� ��ǰ�� ��з��� ������ ��ǰ�� �����ϼ���.
SELECT * FROM  PRODUCTS;
DELETE FROM PRODUCTS WHERE CATEGORY_FK 
= (SELECT CATEGORY_CODE FROM CATEGORY WHERE CATEGORY_NAME LIKE '����'); 

--	3] ��ǰ ���̺� �ִ� ��� ������ �����ϼ���.
DELETE FROM PRODUCTS;

-- DEPT2���� 10�� �μ��� �����ϼ���
DELETE FROM DEPT2 WHERE DEPTNO =10;
SELECT * FROM EMP2 WHERE DEPTNO = 10;
ROLLBACK;
UPDATE EMP2 SET DEPTNO = 20 WHERE DEPTNO = 10;

--------------------------------------------------------------------------------
# TCL - TRANSACTION CONTROL LANGUAGE
COMMIT
ROLLBACK
SAVEPOINT : �������� ������ �� ����Ѵ�.;
--------------------------------------------------------------------------------
-- 1. 7788�� ����� �̸��� CHARSE�� ����
DESC EMP2;
UPDATE EMP2 SET ENAME = 'CHARSE' WHERE EMPNO = 7788;

-- 2. ������ ���� - SAVEPOINT ������ �̸�;
SAVEPOINT MYPOINT;
-- 3. EMP���� ��� ����� JOB�� MANAGER�� �����Ѵ�.
UPDATE EMP2 SET JOB = 'MANAGER';

-- 4. ROLLBACK�Ҷ� ������������ ROLLBACK�� �غ���
ROLLBACK MYPOINT;

SELECT JOB FROM EMP2;