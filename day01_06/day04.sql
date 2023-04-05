# DML 문장 
- insert
- update
- delete

[1] INSERT 문
INSERT INTO 테이블명(컬럼명1, 컬럼명2,...) VALUES (값1, 값2,..);
INSERT INTO 테이블명 VALUES(값1, 값2, 값3,...);

-- EMP테이블을 COPY하여 EMP2 만들기

CREATE TABLE EMP2 AS SELECT * FROM EMP;
COMMIT;
ROLLBACK;

SELECT * FROM EMP2;

INSERT INTO EMP2 (EMPNO, ENAME, JOB, HIREDATE,DEPTNO)
VALUES (8001,'TOM','MANAGER',SYSDATE,40);

INSERT INTO EMP2 
VALUES (8002,'SUSAN','SALESMAN',7788,SYSDATE,4000,500,30);

-- DEPT 테이블을 COPY하되 테이블 구조만 카피하세요 그런뒤 아래 데이터를 삽입해보세요
-- 회계부서 뉴욕
-- 연구부서 달라스
-- 영업부서 LA
-- 운영부서 보스턴

CREATE TABLE DEPT2 
AS SELECT * FROM DEPT 
    WHERE 1=2;
    
INSERT INTO DEPT2 VALUES(10,'회계부서','뉴욕');
INSERT INTO DEPT2 VALUES(20,'연구부서','달라스');
INSERT INTO DEPT2 VALUES(30,'영업부서','LA');
INSERT INTO DEPT2 VALUES(40,'운영부서','보스턴');
--------------------------------------------------------------------------------
-- 여러 데이터를 한꺼번에 INSERT 하는 방법
INSERT ALL 
INTO DEPT2 VALUES(50,'교육부서','서울')
INTO DEPT2 VALUES(60,'노무부','인천')
INTO DEPT2 VALUES(70,'기획부서','수원')
SELECT * FROM DUAL;

SELECT * FROM DEPT2;


SELECT * FROM DEPT2;

DESC DEPT2;
DESC EMP2;


--------------------------------------------------------------------------------
# 데이터 수정
UPDATE 테이블명 SET 컬럼명1 = 값1, 컬럼명2 = 값2,... 
WHERE 조건절;

-- emp2테이블에서 사번이 7788인 사원의 부서번호를 10으로 수정하세요.
DESC EMP2;
UPDATE EMP2 SET DEPTNO = 10 WHERE EMPNO =7788;

--emp2 테이블에서 사번이 7788인 사원의 부서를 20,급여를 3500으로 변경하여라.
UPDATE EMP2 SET DEPTNO = 20, SAL = 3500 WHERE EMPNO = 7788;
SELECT * FROM EMP2 WHERE EMPNO = 7788;

--emp2에서 모든 사원의 급여를 10%씩 인상하세요
SELECT * FROM EMP2;
UPDATE EMP2 SET SAL=SAL*1.1;

--EMP2테이블에서 SCOTT의 업무와 급여가 일치하도록 JONES의 업무와 급여를 변경하여라
UPDATE EMP2 SET JOB=(SELECT JOB FROM EMP2 WHERE ENAME LIKE 'SCOTT'), SAL=(SELECT SAL FROM EMP2 WHERE ENAME LIKE 'SCOTT') WHERE ENAME LIKE 'JONES';
ROLLBACK;
SELECT * FROM EMP2 WHERE ENAME IN ('JONES','SCOTT');


/* [문제]*/
-- [1] 고객 테이블 중 이름이 '김길동'인 사람의 이름을 박길동으로 변경하세요. ...김길동이 2명일 경우...where조건절을 좀 더 구체적으로 하여 변경한다.
DESC MEMBER;
UPDATE MEMBER SET NAME ='박길동' WHERE NAME LIKE'김길동' AND AGE=62;
SELECT * FROM MEMBER;

--[2] 등록된 고객 정보 중 고객의 나이를 현재 나이에서 모두 5를 더한 값으로 수정하세요.
UPDATE MEMBER SET AGE = AGE+5;

--[2_1] 고객 중 13/09/01이후 등록한 고객들의 마일리지를 350점씩 올려주세요.
SELECT * FROM MEMBER WHERE REG_DATE>TO_DATE('13/09/01','YY/MM/DD');
UPDATE MEMBER SET MILEAGE = MILEAGE +350 WHERE REG_DATE>TO_DATE('13/09/01','YY/MM/DD');
	

--[3]수정하려는 정보가 문자가 아닌 컬럼이름이나 함수라고 해도 update구문을 실행하는데 전혀 문제가 없다. 아래 예제 참조.
	
--[4] 등록되어 있는 고객 정보 중 이름에 '김'자가 들어있는 모든 이름을 '김' 대신 '최'로 변경하세요
SELECT * FROM MEMBER WHERE NAME LIKE '김%';
ROLLBACK;
UPDATE MEMBER SET NAME = CONCAT('최',SUBSTAR(NAME,2)) WHERE NAME LIKE '김%';



