-- dept 2 테이블의 deptno 컬럼에 primary key 제약조건을 추가해보자
alter table dept2 add constraint dept2_deptno_pk primary key(deptno);

desc dept2;

insert into dept2 values(10,'노무부','서울');
select * from dept2;

-- emp2 테이블의 deptno 컬럼을 dept2 의 deptno 컬럼을 참조하는 외래키로 제약조건을 추가해보자
ALTER TABLE EMP2 ADD CONSTRAINT EMP2_DEPTNO_FK FOREIGN KEY (DEPTNO) 
REFERENCES DEPT2 (DEPTNO);
COMMIT;

SELECT * FROM DEPT2;
SELECT * FROM EMP2;

-- EMP2 의 7566번 사원의 부서 번호를 40번 부서로 수정하세요
DESC EMP2;
UPDATE EMP2 SET DEPTNO = 40 WHERE EMPNO = 7566;

-- 7521번 사원의 부서번호를 90번으로 수정하세요
UPDATE EMP2 SET DEPTNO = 90 WHERE EMPNO =7521; -- 부모 테이블에 없는 데이터로 수정하려고 할 경우 무결성 제약조건 에러가 발생한다.






--------------------------------------------------------------------------------

# DELETE 문 - 데이터 삭제
DELETE FROM 테이블명 WHERE 조건절; -- 조건절이 없으면 테이블의 모든 데이터가 삭제됨

--------------------------------------------------------------------------------
7521번 사원의 부서번호를 90번 부서로 수정하세요

-- EMP2테이블에서 사원번호가 7499인 사원의 정보를 삭제하라.
DELETE FROM EMP2 WHERE EMPNO=7499;	

-- EMP2테이블에서 입사일자가 83년인 사원의 정보를 삭제하라.
DESC EMP2;
DELETE FROM EMP2 WHERE HIREDATE LIKE '83%';
-- DELETE FROM EMP2 WHERE TO_CHAR(HIREDATE,'YY')='83';

--EMP2테이블에서 부서명이 'SALES'인 사원의 정보를 삭제하세요
DELETE FROM EMP2 WHERE DEPTNO =(SELECT DEPTNO FROM DEPT WHERE DNAME LIKE 'SALES');

--1] 상품 테이블에 있는 상품 중 상품의 판매 가격이 100000원 이하인 상품을 모두 삭제하세요.
SELECT *FROM PRODUCTS WHERE OUTPUT_PRICE<=10000;
DELETE FROM PRODUCTS WHERE OUTPUT_PRICE<=10000;
ROLLBACK;
--	2] 상품 테이블에 있는 상품 중 상품의 대분류가 도서인 상품을 삭제하세요.
SELECT * FROM  PRODUCTS;
DELETE FROM PRODUCTS WHERE CATEGORY_FK 
= (SELECT CATEGORY_CODE FROM CATEGORY WHERE CATEGORY_NAME LIKE '도서'); 

--	3] 상품 테이블에 있는 모든 내용을 삭제하세요.
DELETE FROM PRODUCTS;

-- DEPT2에서 10번 부서를 삭제하세요
DELETE FROM DEPT2 WHERE DEPTNO =10;
SELECT * FROM EMP2 WHERE DEPTNO = 10;
ROLLBACK;
UPDATE EMP2 SET DEPTNO = 20 WHERE DEPTNO = 10;

--------------------------------------------------------------------------------
# TCL - TRANSACTION CONTROL LANGUAGE
COMMIT
ROLLBACK
SAVEPOINT : 저장점을 설정할 때 사용한다.;
--------------------------------------------------------------------------------
-- 1. 7788번 사원의 이름을 CHARSE로 변경
DESC EMP2;
UPDATE EMP2 SET ENAME = 'CHARSE' WHERE EMPNO = 7788;

-- 2. 저장점 설정 - SAVEPOINT 저장점 이름;
SAVEPOINT MYPOINT;
-- 3. EMP에서 모든 사원의 JOB을 MANAGER로 변경한다.
UPDATE EMP2 SET JOB = 'MANAGER';

-- 4. ROLLBACK할때 저장점까지만 ROLLBACK을 해보자
ROLLBACK MYPOINT;

SELECT JOB FROM EMP2;