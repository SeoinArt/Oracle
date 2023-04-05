-- 사원 테이블에서 scott의 급여보다 많은 사원의 사원번호, 이름, 업무, 급여를 출력하세요

 select sal from emp where ename = 'SCOTT';
 
 SELECT EMPNO, ENAME, JOB, SAL
 FROM EMP WHERE SAL>3000;
 
 
 SELECT SAL
 FROM EMP
 WHERE SAL>(SELECT SAL FROM EMP WHERE ENAME='SCOTT');
 
 --문제1] 사원테이블에서 사원번호가 7521인 사원과 업무가 같고 급여가 7934인 
 -- 사원보다 많은 사원의 사번,이름,업무,입사일자,급여를 출력하세요.

SELECT EMPNO, ENAME, JOB, HIREDATE, SAL
FROM EMP
WHERE JOB = (SELECT JOB FROM EMP WHERE EMPNO = 7521)
    AND SAL>(SELECT SAL FROM EMP WHERE EMPNO = 7934);
    
# 단일행 서브쿼리    
        
--문제2]사원테이블에서 급여의 평균보다 적은 사원의 사번,이름 업무,급여,부서번호를 출력하세요.
DESC EMP;
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE SAL < (SELECT AVG(SAL) FROM EMP);

# 다중행 서브쿼리
- 다중행 서브쿼리 연산자  
    IN 
    ANY 
    ALL  
    EXIST

-------------------------------------------------------------------------------- (IN)
[1] IN 연산자
-- 업무별로 최대 급여를 받는 사원의 사원번호와 이름을 출력하세요.

SELECT EMPNO, ENAME, SAL, JOB
FROM EMP
WHERE (JOB,SAL) IN (SELECT JOB, MAX(SAL) FROM EMP GROUP BY JOB);

-- 부서별로 최소급여를 받는 사원의 사번,이름,부서번호,급여,업무를 출력하세요
SELECT EMPNO, ENAME, DEPTNO, SAL, JOB
FROM EMP
WHERE (DEPTNO,SAL) IN (SELECT DEPTNO, MIN(SAL) FROM EMP GROUP BY DEPTNO);




-------------------------------------------------------------------------------- (ANY)
[2] ANY 연산자 : 서브퀘리 결과값 중 어느 하나의 값이라도 만족하면 결과를 반환한다.

SELECT ENAME, SAL FROM EMP
WHERE DEPTNO <>20 AND SAL > ANY(SELECT SAL FROM EMP WHERE JOB ='SALESMAN');
 -- SAL > (SELECT MIN(SAL) FROM EMP WHERE JOB LIKE 'SALESMAN';



-------------------------------------------------------------------------------- (ALL)
[3] ALL 연산자 : 서브퀘리 결과값 중 모든 결과값이라도 만족하면 결과를 반환한다.

SELECT ENAME, SAL FROM EMP
WHERE DEPTNO <>20 AND SAL > ALL(SELECT SAL FROM EMP WHERE JOB ='SALESMAN');
-- SAL > (SELECT MAX(SAL) FROM EMP WHERE JOB LIKE 'SALESMAN';

-------------------------------------------------------------------------------- (EXISTS)
[4] EXIST 연산자 : 서브퀘리의 데이터가 존재하는지 여부를 따져서 존재하는 값들만 반환한다.

SELECT EMPNO, ENAME, JOB FROM EMP E
WHERE EXISTS (SELECT EMPNO FROM EMP WHERE E.EMPNO= MGR);


-------------------------------------------------------------------------------- (Q)
--1] 고객 테이블에 있는 고객 정보 중 마일리지가 
--	가장 높은 금액의 고객 정보를 보여주세요.
DESC MEMBER;
SELECT * FROM MEMBER
WHERE MILEAGE IN (SELECT MAX(MILEAGE) FROM MEMBER);


--	2] 상품 테이블에 있는 전체 상품 정보 중 상품의 판매가격이 
--	    판매가격의 평균보다 큰  상품의 목록을 보여주세요. 
--	    단, 평균을 구할 때와 결과를 보여줄 때의 판매 가격이
--	    50만원을 넘어가는 상품은 제외시키세요.

SELECT *
FROM PRODUCTS
WHERE OUTPUT_PRICE > (SELECT AVG(OUTPUT_PRICE) FROM PRODUCTS WHERE OUTPUT_PRICE<=500000)
    AND OUTPUT_PRICE<500000;



	
-- 3] 상품 테이블에 있는 판매가격에서 평균가격 이상의 상품 목록을 구하되 평균을  구할 때 
-- 판매가격이 최대인 상품을 제외하고 평균을 구하세요

SELECT *
FROM PRODUCTS
WHERE OUTPUT_PRICE >= (SELECT AVG(OUTPUT_PRICE)FROM PRODUCTS 
WHERE OUTPUT_PRICE < (SELECT MAX(OUTPUT_PRICE) FROM PRODUCTS));
 

--4] 상품 카테고리 테이블에서 카테고리 이름에 컴퓨터라는 단어가 포함된 카테고리에 속하는 
-- 상품 목록을 보여주세요.
DESC PRODUCTS;
DESC CATEGORY;
SELECT * FROM PRODUCTS
WHERE CATEGORY_FK IN(SELECT CATEGORY_CODE FROM CATEGORY WHERE CATEGORY_NAME LIKE '%컴퓨터%');


--5] 고객 테이블에 있는 고객정보 중 직업의 종류별로 가장 나이가 많은 사람의 정보를  화면에 보여주세요.
DESC MEMBER;

SELECT *
FROM MEMBER
WHERE (JOB,AGE) IN (SELECT JOB,MAX(AGE) FROM MEMBER GROUP BY JOB);
    
    
--6] 고객 테이블에 있는 고객 정보 중 마일리지가 가장 높은 금액을
--	     가지는 고객에게 보너스 마일리지 5000점을 더 주는 SQL을 작성하세요.
DESC MEMBER;
UPDATE MEMBER SET MILEAGE =5000+ MILEAGE
WHERE MILEAGE IN (SELECT MAX(MILEAGE) FROM MEMBER);


--7] 고객 테이블에서 마일리지가 없는 고객의 등록일자를 고객 테이블의 
--	      등록일자 중 가장 뒤에 등록한 날짜에 속하는 값으로 수정하세요.
DESC MEMBER;
UPDATE MEMBER SET REG_DATE = (SELECT MAX(REG_DATE) FROM MEMBER)
WHERE MILEAGE = 0;



--8] 상품 테이블에 있는 상품 정보 중 공급가가 가장 큰 상품은 삭제 시키는 
--	      SQL문을 작성하세요.

DELETE FROM PRODUCTS WHERE INPUT_PRICE IN (SELECT MAX(INPUT_PRICE) FROM PRODUCTS);
SELECT * FROM PRODUCTS ORDER BY INPUT_PRICE;

--9] 상품 테이블에서 상품 목록을 공급 업체별로 정리한 뒤,
-- 각 공급업체별로 최소 판매 가격을 가진 상품을 삭제하세요.
DESC PRODUCTS;
DELETE FROM PRODUCTS WHERE (EP_CODE_FK,OUTPUT_PRICE) 
    IN (SELECT EP_CODE_FK, MIN(OUTPUT_PRICE) FROM PRODUCTS GROUP BY EP_CODE_FK);
ROLLBACK;



-------------------------------------------------------------------------------- (INLINE VIEW)
# FROM 절에 들어가는 SUBQUERY를 INLINE VIEW 라고 한다.


--EMP와 DEPT 테이블에서 업무가 MANAGER인 사원의 이름, 업무,부서명,근무지를 출력하세요.
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
-- 기존의 데이터에 ROWNUM을 먼저 붙이고 그런 뒤에 ORDER BY를 한다.
SELECT ROWNUM RN, MEMBER.* 
FROM MEMBER 
ORDER BY REG_DATE DESC;

-- 해결방안 : ORDER BY를 먼저 시행하고 ROUWNUM을 붙인다.
SELECT *
FROM(SELECT ROWNUM RN, A.* 
    FROM (SELECT * FROM MEMBER ORDER BY REG_DATE DESC) A)
WHERE RN <=3;

-------------------------------------------------------------------------------- ( ROW_NUMBER() OVER() )
SELECT * 
FROM (SELECT ROW_NUMBER() OVER(ORDER BY REG_DATE DESC) RN, MEMBER.*
    FROM MEMBER)
WHERE RN <=3;


