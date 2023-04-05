#Table Join
-- dept�� emp�� join �غ��ô�.

-- 1.
select dept.deptno, dept.dname, emp.ename, emp.job, emp.deptno
from dept, emp
where dept.deptno = emp.deptno
order by 1;

-- 2. ����� Join�� => ǥ��
select d.deptno, dname, e.*, loc
from dept d join emp e
on d.deptno = e.deptno order by 1;

-- Q. SALESMAN�� �����ȣ, �̸�, �޿�, �μ���, �ٹ����� ����϶�
desc emp;
select EMPNO, ENAME, SAL, DNAME, LOC
from emp e, dept d
where e.deptno = d.deptno and e.job='SALESMAN';

SELECT EMPNO, ENAME, SAL, DNAME, LOC
FROM EMP E JOIN DEPT D 
ON E.DEPTNO = D.DEPTNO AND E.JOB='SALESMAN';

SELECT
FROM CATEGORY C JOIN PRODUCTS  P
ON C.CATEGORY_CODE = P.CATEGORY_FK ;


-- Q. CATEGORY�� PRODUCTS�� JOIN�ؼ� ī�װ��ڵ�, ī�װ���, ��ǰ��, �ǸŰ�, �����縦 ����ϼ���
SELECT C.CATEGORY_CODE, C.CATEGORY_NAME, PRODUCTS_NAME, OUTPUT_PRICE, COMPANY
FROM CATEGORY C JOIN PRODUCTS  P
ON C.CATEGORY_CODE = P.CATEGORY_FK ;

DESC CATEGORY;
-- Q. ī�װ� ���̺�� ��ǰ ���̺��� �����Ͽ� ȭ�鿡 ����ϵ� ��ǰ�� ���� �� ������ü�� �Ｚ�� ��ǰ�� ������ �����Ͽ� ī�װ� �̸��� ��ǰ�̸�, ��ǰ���� ������ ���� ������ ȭ�鿡 �����ּ���.
SELECT CATEGORY_NAME,PRODUCTS_NAME,OUTPUT_PRICE, COMPANY
FROM CATEGORY C JOIN PRODUCTS  P
ON C.CATEGORY_CODE = P.CATEGORY_FK 
WHERE COMPANY LIKE '�Ｚ';

-- Q. �� ��ǰ���� ī�װ� �� ��ǰ��, ������ ����ϼ���. �� ī�װ��� 'TV'�� ���� �����ϰ� ������ ������ ��ǰ�� ������ ������ ������ �����ϼ���.
SELECT CATEGORY_NAME,PRODUCTS_NAME,OUTPUT_PRICE
FROM CATEGORY C JOIN PRODUCTS  P
ON C.CATEGORY_CODE = P.CATEGORY_FK 
WHERE CATEGORY_NAME <> 'TV'
ORDER BY OUTPUT_PRICE ASC;








--------------------------------------------------------------------------------
[2] NON - EQUI JOIN
EQUAL(=)�� �ƴ� �����ڸ� �̿��ؼ� �����ϴ� ���

SELECT * FROM SALGRADE;

-- Q. ������� ������ �����ֵ� �޿� ��� ������ �����ּ���

SELECT S.GRADE, ENAME, SAL, LOSAL, HISAL
FROM EMP E JOIN SALGRADE S
    ON E.SAL BETWEEN S.LOSAL AND S.HISAL
    ORDER BY SAL;

--------------------------------------------------------------------------------    
[3] OUTER JOIN
SELECT D.DEPTNO, D.DNAME, EMPNO, ENAME, JOB,LOC
FROM DEPT D, EMP E
WHERE D.DEPTNO = E.DEPTNO(+) ORDER BY 1;

-- ����� JOIN���� �̿��� OUTER JOIN
-- 1. LEFT OUTER JOIN : ���ʿ� ��ġ�� ���̺��� �������� �����͸� �����ְ��� �� ��
-- 2. RIGHT OUTER JOIN : �����ʿ� ��ġ�� ���̺��� �������� �����͸� �����ְ��� �� ��
-- 3. FULL OUTER JOIN : ����, ������ �� �� �Ŵ� ���

-- EQUAL
SELECT D.*, ENAME, JOB
FROM DEPT D JOIN EMP E
    ON D.DEPTNO = E.DEPTNO 
ORDER BY 1;

-- LEFT JOIN
SELECT D.*, ENAME, JOB
FROM DEPT D LEFT OUTER JOIN EMP E
    ON D.DEPTNO = E.DEPTNO 
ORDER BY 1;

-- RIGHT JOIN
SELECT D.*, ENAME, JOB
FROM DEPT D RIGHT OUTER JOIN EMP E
    ON D.DEPTNO = E.DEPTNO 
ORDER BY 1;

--  FULL JOIN
SELECT D.*, ENAME, JOB
FROM DEPT D FULL OUTER JOIN EMP E
    ON D.DEPTNO = E.DEPTNO 
ORDER BY 1;


--����1] ��ǰ���̺��� ��� ��ǰ�� ���޾�ü, ���޾�ü�ڵ�, ��ǰ�̸�, ��ǰ���ް�, ��ǰ �ǸŰ� ������ ����ϵ� ���޾�ü�� ���� ��ǰ�� ����ϼ���(��ǰ�� ��������).
SELECT S.*,PRODUCTS_NAME,INPUT_PRICE, OUTPUT_PRICE
FROM PRODUCTS P LEFT OUTER JOIN SUPPLY_COMP S
    ON P.EP_CODE_FK = EP_CODE;
    
-- PRODUCTS�� �������� ������ ���
SELECT S.*,PRODUCTS_NAME,INPUT_PRICE, OUTPUT_PRICE
FROM SUPPLY_COMP S RIGHT JOIN PRODUCTS P
    ON S.EP_CODE = P. EP_CODE_FK;

-- SUPPLY_COMP�� �������� ������ ���
SELECT S.*,PRODUCTS_NAME,INPUT_PRICE, OUTPUT_PRICE
FROM SUPPLY_COMP S LEFT JOIN PRODUCTS P
    ON S.EP_CODE = P. EP_CODE_FK;
    
    
-- FULL OUTER JOIN : ���� ���̺� ��� �����͸� ������
SELECT S.*,PRODUCTS_NAME,INPUT_PRICE, OUTPUT_PRICE
FROM SUPPLY_COMP S LEFT JOIN PRODUCTS P
    ON S.EP_CODE = P. EP_CODE_FK;



--	����2] ��ǰ���̺��� ��� ��ǰ�� ���޾�ü, ī�װ���, ��ǰ��, ��ǰ�ǸŰ� ������ ����ϼ���. ��, ���޾�ü�� ��ǰ ī�װ��� ���� ��ǰ�� ����մϴ�.
SELECT P.*,CATEGORY_NAME, PRODUCTS_NAME, OUTPUT_PRICE
FROM (PRODUCTS P LEFT JOIN CATEGORY C 
    ON P.CATEGORY_FK = C. CATEGORY_CODE) LEFT JOIN SUPPLY_COMP S
        ON P.EP_CODE_FK = S.EP_CODE
        ORDER BY 1,CATEGORY_NAME;
        
SELECT EP_CODE, EP_NAME,CATEGORY_NAME, PRODUCTS_NAME,OUTPUT_PRICE
FROM SUPPLY_COMP S RIGHT JOIN PRODUCTS P
    ON S.EP_CODE = P.EP_CODE_FK
        LEFT JOIN CATEGORY C
            ON P.CATEGORY_FK = C.CATEGORY_CODE
                ORDER BY 1, CATEGORY_NAME;
                

SELECT E.EMPNO, E.ENAME, E.MGR, M.ENAME, E.ENAME "������ �̸�"
FROM EMP E JOIN EMP M
    ON E.MGR = M.EMPNO
ORDER BY 1;

-- emp���̺��� "������ �����ڴ� �����̴�"�� ������ ����ϼ���.

SELECT E.ENAME || '�� �����ڴ�' || M.ENAME || '�Դϴ�.'
FROM EMP E INNER JOIN EMP M
    ON E.MGR = M.EMPNO;

SELECT *
FROM EMP E INNER JOIN EMP M
    ON E.MGR = M.EMPNO;
    
-- ���� ������ �߸��ǰų� ������ ���, ������ ����� ��� �����Ͽ� ������ => �������� ���� ������
SELECT D.*, E.*
FROM DEPT D, EMP E ORDER BY D.DEPTNO ASC;

# ������ / ������ / ������ ==> SET OPERATOR
- UNION ( ������ )
- UNION ALL ( ������ )
- INTERSECT ( ������ )
- MINUS ( ������ )

SELECT DEPTNO FROM DEPT
UNION
SELECT DEPTNO FROM EMP;

SELECT DEPTNO FROM DEPT
UNION ALL
SELECT DEPTNO FROM EMP;

SELECT DEPTNO FROM DEPT
INTERSECT
SELECT DEPTNO FROM EMP;

SELECT DEPTNO FROM DEPT
MINUS
SELECT DEPTNO FROM EMP;



--1. emp���̺��� ��� ����� ���� �̸�,�μ���ȣ,�μ����� ����ϴ� ������ �ۼ��ϼ���.
SELECT E.ENAME, E.DEPTNO , D.DNAME
FROM EMP E JOIN DEPT D 
    ON E.DEPTNO = D.DEPTNO;
    
--2. emp���̺��� NEW YORK���� �ٹ��ϰ� �ִ� ����� ���Ͽ� �̸�,����,�޿�,�μ����� ����ϴ� SELECT���� �ۼ��ϼ���.
SELECT ENAME, JOB, D.DNAME
FROM EMP E INNER JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
WHERE LOC LIKE 'NEW YORK';

DESC EMP;

--3. EMP���̺��� ���ʽ��� �޴� ����� ���Ͽ� �̸�,�μ���,��ġ�� ����ϴ� SELECT���� �ۼ��ϼ���.
SELECT ENAME, JOB,COMM, LOC
FROM EMP E JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
WHERE E.COMM IS NOT NULL;


--4. EMP���̺��� �̸� �� L�ڰ� �ִ� ����� ���� �̸�,����,�μ���,��ġ��  ����ϴ� ������ �ۼ��ϼ���.
SELECT ENAME, E.DEPTNO, DNAME,JOB, LOC
FROM DEPT D JOIN EMP E
ON D.DEPTNO = E.DEPTNO
WHERE ENAME LIKE '%L%';


--5. �Ʒ��� ����� ����ϴ� ������ �ۼ��Ͽ���(�����ڰ� ���� King�� �����Ͽ� ��� ����� ���)

--	---------------------------------------------
--	Emplyee		Emp#		Manager	Mgr#
--	---------------------------------------------
--	KING		7839
--	BLAKE		7698		KING		7839
--	CKARK		7782		KING		7839
--	.....
--	---------------------------------------------
--	14ROWS SELECTED.

SELECT E.ENAME "EMPLYEE", E.EMPNO "EMP#", M.ENAME "MANAGER", M.EMPNO "Mgr#"
FROM EMP E LEFT OUTER JOIN EMP M
    ON E.MGR = M.EMPNO
    ORDER BY MANAGER DESC;
    
    C:\oraclexe\app\oracle\product\11.2.0\server\jdbc\lib\ojdbc6.jar
    
drop table memo;

select * from tab;

select * from memo;
delete from memo;
commit;


