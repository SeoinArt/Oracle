-- ��� ���̺��� scott�� �޿����� ���� ����� �����ȣ, �̸�, ����, �޿��� ����ϼ���

 select sal from emp where ename = 'SCOTT';
 
 SELECT EMPNO, ENAME, JOB, SAL
 FROM EMP WHERE SAL>3000;
 
 
 SELECT SAL
 FROM EMP
 WHERE SAL>(SELECT SAL FROM EMP WHERE ENAME='SCOTT');
 
 --����1] ������̺��� �����ȣ�� 7521�� ����� ������ ���� �޿��� 7934�� 
 -- ������� ���� ����� ���,�̸�,����,�Ի�����,�޿��� ����ϼ���.

SELECT EMPNO, ENAME, JOB, HIREDATE, SAL
FROM EMP
WHERE JOB = (SELECT JOB FROM EMP WHERE EMPNO = 7521)
    AND SAL>(SELECT SAL FROM EMP WHERE EMPNO = 7934);
    
# ������ ��������    
        
--����2]������̺��� �޿��� ��պ��� ���� ����� ���,�̸� ����,�޿�,�μ���ȣ�� ����ϼ���.
DESC EMP;
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE SAL < (SELECT AVG(SAL) FROM EMP);

# ������ ��������
- ������ �������� ������  
    IN 
    ANY 
    ALL  
    EXIST

-------------------------------------------------------------------------------- (IN)
[1] IN ������
-- �������� �ִ� �޿��� �޴� ����� �����ȣ�� �̸��� ����ϼ���.

SELECT EMPNO, ENAME, SAL, JOB
FROM EMP
WHERE (JOB,SAL) IN (SELECT JOB, MAX(SAL) FROM EMP GROUP BY JOB);

-- �μ����� �ּұ޿��� �޴� ����� ���,�̸�,�μ���ȣ,�޿�,������ ����ϼ���
SELECT EMPNO, ENAME, DEPTNO, SAL, JOB
FROM EMP
WHERE (DEPTNO,SAL) IN (SELECT DEPTNO, MIN(SAL) FROM EMP GROUP BY DEPTNO);




-------------------------------------------------------------------------------- (ANY)
[2] ANY ������ : �������� ����� �� ��� �ϳ��� ���̶� �����ϸ� ����� ��ȯ�Ѵ�.

SELECT ENAME, SAL FROM EMP
WHERE DEPTNO <>20 AND SAL > ANY(SELECT SAL FROM EMP WHERE JOB ='SALESMAN');
 -- SAL > (SELECT MIN(SAL) FROM EMP WHERE JOB LIKE 'SALESMAN';



-------------------------------------------------------------------------------- (ALL)
[3] ALL ������ : �������� ����� �� ��� ������̶� �����ϸ� ����� ��ȯ�Ѵ�.

SELECT ENAME, SAL FROM EMP
WHERE DEPTNO <>20 AND SAL > ALL(SELECT SAL FROM EMP WHERE JOB ='SALESMAN');
-- SAL > (SELECT MAX(SAL) FROM EMP WHERE JOB LIKE 'SALESMAN';

-------------------------------------------------------------------------------- (EXISTS)
[4] EXIST ������ : ���������� �����Ͱ� �����ϴ��� ���θ� ������ �����ϴ� ���鸸 ��ȯ�Ѵ�.

SELECT EMPNO, ENAME, JOB FROM EMP E
WHERE EXISTS (SELECT EMPNO FROM EMP WHERE E.EMPNO= MGR);


-------------------------------------------------------------------------------- (Q)
--1] �� ���̺� �ִ� �� ���� �� ���ϸ����� 
--	���� ���� �ݾ��� �� ������ �����ּ���.
DESC MEMBER;
SELECT * FROM MEMBER
WHERE MILEAGE IN (SELECT MAX(MILEAGE) FROM MEMBER);


--	2] ��ǰ ���̺� �ִ� ��ü ��ǰ ���� �� ��ǰ�� �ǸŰ����� 
--	    �ǸŰ����� ��պ��� ū  ��ǰ�� ����� �����ּ���. 
--	    ��, ����� ���� ���� ����� ������ ���� �Ǹ� ������
--	    50������ �Ѿ�� ��ǰ�� ���ܽ�Ű����.

SELECT *
FROM PRODUCTS
WHERE OUTPUT_PRICE > (SELECT AVG(OUTPUT_PRICE) FROM PRODUCTS WHERE OUTPUT_PRICE<=500000)
    AND OUTPUT_PRICE<500000;



	
-- 3] ��ǰ ���̺� �ִ� �ǸŰ��ݿ��� ��հ��� �̻��� ��ǰ ����� ���ϵ� �����  ���� �� 
-- �ǸŰ����� �ִ��� ��ǰ�� �����ϰ� ����� ���ϼ���

SELECT *
FROM PRODUCTS
WHERE OUTPUT_PRICE >= (SELECT AVG(OUTPUT_PRICE)FROM PRODUCTS 
WHERE OUTPUT_PRICE < (SELECT MAX(OUTPUT_PRICE) FROM PRODUCTS));
 

--4] ��ǰ ī�װ� ���̺��� ī�װ� �̸��� ��ǻ�Ͷ�� �ܾ ���Ե� ī�װ��� ���ϴ� 
-- ��ǰ ����� �����ּ���.
DESC PRODUCTS;
DESC CATEGORY;
SELECT * FROM PRODUCTS
WHERE CATEGORY_FK IN(SELECT CATEGORY_CODE FROM CATEGORY WHERE CATEGORY_NAME LIKE '%��ǻ��%');


--5] �� ���̺� �ִ� ������ �� ������ �������� ���� ���̰� ���� ����� ������  ȭ�鿡 �����ּ���.
DESC MEMBER;

SELECT *
FROM MEMBER
WHERE (JOB,AGE) IN (SELECT JOB,MAX(AGE) FROM MEMBER GROUP BY JOB);
    
    
--6] �� ���̺� �ִ� �� ���� �� ���ϸ����� ���� ���� �ݾ���
--	     ������ ������ ���ʽ� ���ϸ��� 5000���� �� �ִ� SQL�� �ۼ��ϼ���.
DESC MEMBER;
UPDATE MEMBER SET MILEAGE =5000+ MILEAGE
WHERE MILEAGE IN (SELECT MAX(MILEAGE) FROM MEMBER);


--7] �� ���̺��� ���ϸ����� ���� ���� ������ڸ� �� ���̺��� 
--	      ������� �� ���� �ڿ� ����� ��¥�� ���ϴ� ������ �����ϼ���.
DESC MEMBER;
UPDATE MEMBER SET REG_DATE = (SELECT MAX(REG_DATE) FROM MEMBER)
WHERE MILEAGE = 0;



--8] ��ǰ ���̺� �ִ� ��ǰ ���� �� ���ް��� ���� ū ��ǰ�� ���� ��Ű�� 
--	      SQL���� �ۼ��ϼ���.

DELETE FROM PRODUCTS WHERE INPUT_PRICE IN (SELECT MAX(INPUT_PRICE) FROM PRODUCTS);
SELECT * FROM PRODUCTS ORDER BY INPUT_PRICE;

--9] ��ǰ ���̺��� ��ǰ ����� ���� ��ü���� ������ ��,
-- �� ���޾�ü���� �ּ� �Ǹ� ������ ���� ��ǰ�� �����ϼ���.
DESC PRODUCTS;
DELETE FROM PRODUCTS WHERE (EP_CODE_FK,OUTPUT_PRICE) 
    IN (SELECT EP_CODE_FK, MIN(OUTPUT_PRICE) FROM PRODUCTS GROUP BY EP_CODE_FK);
ROLLBACK;



-------------------------------------------------------------------------------- (INLINE VIEW)
# FROM ���� ���� SUBQUERY�� INLINE VIEW ��� �Ѵ�.


--EMP�� DEPT ���̺��� ������ MANAGER�� ����� �̸�, ����,�μ���,�ٹ����� ����ϼ���.
SELECT *
FROM (SELECT ENAME, JOB, LOC FROM EMP E JOIN DEPT M 
    ON E.DEPTNO = M.DEPTNO 
    WHERE E.JOB LIKE 'MANAGER');
    
SELECT ENAME, JOB, LOC
FROM EMP E JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
WHERE JOB LIKE 'MANAGER';

SELECT ENAME, JOB, LOC
FROM (SELECT * FROM EMP WHERE JOB LIKE 'MANAGER') A JOIN DEPT D 
    ON A.DEPTNO = D.DEPTNO;
    
    
-------------------------------------------------------------------------------- (RANK)
RANK() OVER();
ROW_NUMBER() OVER();

SELECT * FROM PRODUCTS ORDER BY OUTPUT_PRICE DESC;

SELECT RANK() OVER(ORDER BY OUTPUT_PRICE DESC) RNK, PRODUCTS.* FROM PRODUCTS;

SELECT * FROM (
                SELECT RANK() OVER(ORDER BY OUTPUT_PRICE DESC) RNK, PRODUCTS.* 
                FROM PRODUCTS
                )
WHERE RNK <=3;


-------------------------------------------------------------------------------- (ROWNUM)
-- ������ �����Ϳ� ROWNUM�� ���� ���̰� �׷� �ڿ� ORDER BY�� �Ѵ�.
SELECT ROWNUM RN, MEMBER.* 
FROM MEMBER 
ORDER BY REG_DATE DESC;

-- �ذ��� : ORDER BY�� ���� �����ϰ� ROUWNUM�� ���δ�.
SELECT *
FROM(SELECT ROWNUM RN, A.* 
    FROM (SELECT * FROM MEMBER ORDER BY REG_DATE DESC) A)
WHERE RN <=3;

-------------------------------------------------------------------------------- ( ROW_NUMBER() OVER() )
SELECT * 
FROM (SELECT ROW_NUMBER() OVER(ORDER BY REG_DATE DESC) RN, MEMBER.*
    FROM MEMBER)
WHERE RN <=3;


