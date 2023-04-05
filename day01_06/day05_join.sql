#Table Join
-- dept와 emp를 join 해봅시다.

-- 1.
select dept.deptno, dept.dname, emp.ename, emp.job, emp.deptno
from dept, emp
where dept.deptno = emp.deptno
order by 1;

-- 2. 명시적 Join절 => 표준
select d.deptno, dname, e.*, loc
from dept d join emp e
on d.deptno = e.deptno order by 1;

-- Q. SALESMAN의 사원번호, 이름, 급여, 부서명, 근무지를 출력하라
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


-- Q. CATEGORY와 PRODUCTS를 JOIN해서 카테고리코드, 카테고리명, 상품명, 판매가, 제조사를 출력하세요
SELECT C.CATEGORY_CODE, C.CATEGORY_NAME, PRODUCTS_NAME, OUTPUT_PRICE, COMPANY
FROM CATEGORY C JOIN PRODUCTS  P
ON C.CATEGORY_CODE = P.CATEGORY_FK ;

DESC CATEGORY;
-- Q. 카테고리 테이블과 상품 테이블을 조인하여 화면에 출력하되 상품의 정보 중 제조업체가 삼성인 상품의 정보만 추출하여 카테고리 이름과 상품이름, 상품가격 제조사 등의 정보를 화면에 보여주세요.
SELECT CATEGORY_NAME,PRODUCTS_NAME,OUTPUT_PRICE, COMPANY
FROM CATEGORY C JOIN PRODUCTS  P
ON C.CATEGORY_CODE = P.CATEGORY_FK 
WHERE COMPANY LIKE '삼성';

-- Q. 각 상품별로 카테고리 및 상품명, 가격을 출력하세요. 단 카테고리가 'TV'인 것은 제외하고 나머지 정보는 상품의 가격이 저렴한 순으로 정렬하세요.
SELECT CATEGORY_NAME,PRODUCTS_NAME,OUTPUT_PRICE
FROM CATEGORY C JOIN PRODUCTS  P
ON C.CATEGORY_CODE = P.CATEGORY_FK 
WHERE CATEGORY_NAME <> 'TV'
ORDER BY OUTPUT_PRICE ASC;








--------------------------------------------------------------------------------
[2] NON - EQUI JOIN
EQUAL(=)이 아닌 연산자를 이용해서 조인하는 경우

SELECT * FROM SALGRADE;

-- Q. 사원들의 정보를 보여주되 급여 등급 정보도 보여주세요

SELECT S.GRADE, ENAME, SAL, LOSAL, HISAL
FROM EMP E JOIN SALGRADE S
    ON E.SAL BETWEEN S.LOSAL AND S.HISAL
    ORDER BY SAL;

--------------------------------------------------------------------------------    
[3] OUTER JOIN
SELECT D.DEPTNO, D.DNAME, EMPNO, ENAME, JOB,LOC
FROM DEPT D, EMP E
WHERE D.DEPTNO = E.DEPTNO(+) ORDER BY 1;

-- 명시적 JOIN절을 이용한 OUTER JOIN
-- 1. LEFT OUTER JOIN : 왼쪽에 위치한 테이블을 기준으로 데이터를 보여주고자 할 때
-- 2. RIGHT OUTER JOIN : 오른쪽에 위치한 테이블을 기준으로 데이터를 보여주고자 할 때
-- 3. FULL OUTER JOIN : 왼쪽, 오른쪽 둘 다 거는 경우

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


--문제1] 상품테이블의 모든 상품을 공급업체, 공급업체코드, 상품이름, 상품공급가, 상품 판매가 순서로 출력하되 공급업체가 없는 상품도 출력하세요(상품을 기준으로).
SELECT S.*,PRODUCTS_NAME,INPUT_PRICE, OUTPUT_PRICE
FROM PRODUCTS P LEFT OUTER JOIN SUPPLY_COMP S
    ON P.EP_CODE_FK = EP_CODE;
    
-- PRODUCTS를 기준으로 데이터 출력
SELECT S.*,PRODUCTS_NAME,INPUT_PRICE, OUTPUT_PRICE
FROM SUPPLY_COMP S RIGHT JOIN PRODUCTS P
    ON S.EP_CODE = P. EP_CODE_FK;

-- SUPPLY_COMP를 기준으로 데이터 출력
SELECT S.*,PRODUCTS_NAME,INPUT_PRICE, OUTPUT_PRICE
FROM SUPPLY_COMP S LEFT JOIN PRODUCTS P
    ON S.EP_CODE = P. EP_CODE_FK;
    
    
-- FULL OUTER JOIN : 양쪽 테이블 모두 데이터를 보여줌
SELECT S.*,PRODUCTS_NAME,INPUT_PRICE, OUTPUT_PRICE
FROM SUPPLY_COMP S LEFT JOIN PRODUCTS P
    ON S.EP_CODE = P. EP_CODE_FK;



--	문제2] 상품테이블의 모든 상품을 공급업체, 카테고리명, 상품명, 상품판매가 순서로 출력하세요. 단, 공급업체나 상품 카테고리가 없는 상품도 출력합니다.
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
                

SELECT E.EMPNO, E.ENAME, E.MGR, M.ENAME, E.ENAME "관리자 이름"
FROM EMP E JOIN EMP M
    ON E.MGR = M.EMPNO
ORDER BY 1;

-- emp테이블에서 "누구의 관리자는 누구이다"는 내용을 출력하세요.

SELECT E.ENAME || '의 관리자는' || M.ENAME || '입니다.'
FROM EMP E INNER JOIN EMP M
    ON E.MGR = M.EMPNO;

SELECT *
FROM EMP E INNER JOIN EMP M
    ON E.MGR = M.EMPNO;
    
-- 조인 조건이 잘못되거나 생략된 경우, 가능한 행들을 모두 결합하여 보여줌 => 유용하지 못한 데이터
SELECT D.*, E.*
FROM DEPT D, EMP E ORDER BY D.DEPTNO ASC;

# 합집합 / 교집합 / 차집합 ==> SET OPERATOR
- UNION ( 합집합 )
- UNION ALL ( 합집합 )
- INTERSECT ( 교집합 )
- MINUS ( 차집합 )

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



--1. emp테이블에서 모든 사원에 대한 이름,부서번호,부서명을 출력하는 문장을 작성하세요.
SELECT E.ENAME, E.DEPTNO , D.DNAME
FROM EMP E JOIN DEPT D 
    ON E.DEPTNO = D.DEPTNO;
    
--2. emp테이블에서 NEW YORK에서 근무하고 있는 사원에 대하여 이름,업무,급여,부서명을 출력하는 SELECT문을 작성하세요.
SELECT ENAME, JOB, D.DNAME
FROM EMP E INNER JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
WHERE LOC LIKE 'NEW YORK';

DESC EMP;

--3. EMP테이블에서 보너스를 받는 사원에 대하여 이름,부서명,위치를 출력하는 SELECT문을 작성하세요.
SELECT ENAME, JOB,COMM, LOC
FROM EMP E JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
WHERE E.COMM IS NOT NULL;


--4. EMP테이블에서 이름 중 L자가 있는 사원에 대해 이름,업무,부서명,위치를  출력하는 문장을 작성하세요.
SELECT ENAME, E.DEPTNO, DNAME,JOB, LOC
FROM DEPT D JOIN EMP E
ON D.DEPTNO = E.DEPTNO
WHERE ENAME LIKE '%L%';


--5. 아래의 결과를 출력하는 문장을 작성하에요(관리자가 없는 King을 포함하여 모든 사원을 출력)

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


