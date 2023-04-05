# DML ���� 
- insert
- update
- delete

[1] INSERT ��
INSERT INTO ���̺��(�÷���1, �÷���2,...) VALUES (��1, ��2,..);
INSERT INTO ���̺�� VALUES(��1, ��2, ��3,...);

-- EMP���̺��� COPY�Ͽ� EMP2 �����

CREATE TABLE EMP2 AS SELECT * FROM EMP;
COMMIT;
ROLLBACK;

SELECT * FROM EMP2;

INSERT INTO EMP2 (EMPNO, ENAME, JOB, HIREDATE,DEPTNO)
VALUES (8001,'TOM','MANAGER',SYSDATE,40);

INSERT INTO EMP2 
VALUES (8002,'SUSAN','SALESMAN',7788,SYSDATE,4000,500,30);

-- DEPT ���̺��� COPY�ϵ� ���̺� ������ ī���ϼ��� �׷��� �Ʒ� �����͸� �����غ�����
-- ȸ��μ� ����
-- �����μ� �޶�
-- �����μ� LA
-- ��μ� ������

CREATE TABLE DEPT2 
AS SELECT * FROM DEPT 
    WHERE 1=2;
    
INSERT INTO DEPT2 VALUES(10,'ȸ��μ�','����');
INSERT INTO DEPT2 VALUES(20,'�����μ�','�޶�');
INSERT INTO DEPT2 VALUES(30,'�����μ�','LA');
INSERT INTO DEPT2 VALUES(40,'��μ�','������');
--------------------------------------------------------------------------------
-- ���� �����͸� �Ѳ����� INSERT �ϴ� ���
INSERT ALL 
INTO DEPT2 VALUES(50,'�����μ�','����')
INTO DEPT2 VALUES(60,'�빫��','��õ')
INTO DEPT2 VALUES(70,'��ȹ�μ�','����')
SELECT * FROM DUAL;

SELECT * FROM DEPT2;


SELECT * FROM DEPT2;

DESC DEPT2;
DESC EMP2;


--------------------------------------------------------------------------------
# ������ ����
UPDATE ���̺�� SET �÷���1 = ��1, �÷���2 = ��2,... 
WHERE ������;

-- emp2���̺��� ����� 7788�� ����� �μ���ȣ�� 10���� �����ϼ���.
DESC EMP2;
UPDATE EMP2 SET DEPTNO = 10 WHERE EMPNO =7788;

--emp2 ���̺��� ����� 7788�� ����� �μ��� 20,�޿��� 3500���� �����Ͽ���.
UPDATE EMP2 SET DEPTNO = 20, SAL = 3500 WHERE EMPNO = 7788;
SELECT * FROM EMP2 WHERE EMPNO = 7788;

--emp2���� ��� ����� �޿��� 10%�� �λ��ϼ���
SELECT * FROM EMP2;
UPDATE EMP2 SET SAL=SAL*1.1;

--EMP2���̺��� SCOTT�� ������ �޿��� ��ġ�ϵ��� JONES�� ������ �޿��� �����Ͽ���
UPDATE EMP2 SET JOB=(SELECT JOB FROM EMP2 WHERE ENAME LIKE 'SCOTT'), SAL=(SELECT SAL FROM EMP2 WHERE ENAME LIKE 'SCOTT') WHERE ENAME LIKE 'JONES';
ROLLBACK;
SELECT * FROM EMP2 WHERE ENAME IN ('JONES','SCOTT');


/* [����]*/
-- [1] �� ���̺� �� �̸��� '��浿'�� ����� �̸��� �ڱ浿���� �����ϼ���. ...��浿�� 2���� ���...where�������� �� �� ��ü������ �Ͽ� �����Ѵ�.
DESC MEMBER;
UPDATE MEMBER SET NAME ='�ڱ浿' WHERE NAME LIKE'��浿' AND AGE=62;
SELECT * FROM MEMBER;

--[2] ��ϵ� �� ���� �� ���� ���̸� ���� ���̿��� ��� 5�� ���� ������ �����ϼ���.
UPDATE MEMBER SET AGE = AGE+5;

--[2_1] �� �� 13/09/01���� ����� ������ ���ϸ����� 350���� �÷��ּ���.
SELECT * FROM MEMBER WHERE REG_DATE>TO_DATE('13/09/01','YY/MM/DD');
UPDATE MEMBER SET MILEAGE = MILEAGE +350 WHERE REG_DATE>TO_DATE('13/09/01','YY/MM/DD');
	

--[3]�����Ϸ��� ������ ���ڰ� �ƴ� �÷��̸��̳� �Լ���� �ص� update������ �����ϴµ� ���� ������ ����. �Ʒ� ���� ����.
	
--[4] ��ϵǾ� �ִ� �� ���� �� �̸��� '��'�ڰ� ����ִ� ��� �̸��� '��' ��� '��'�� �����ϼ���
SELECT * FROM MEMBER WHERE NAME LIKE '��%';
ROLLBACK;
UPDATE MEMBER SET NAME = CONCAT('��',SUBSTAR(NAME,2)) WHERE NAME LIKE '��%';



