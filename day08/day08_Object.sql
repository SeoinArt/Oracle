# 오라클 객체
--------------------------------------------------------------------------------
[1] 시퀸스 (sequence)
CREATE SEQUENCE 시퀀스명 
[INCREMENT BY n]
[START WITH n] 
[{MAXVALUE n | NOMAXVALE}] 
[{MINVALUE n | NOMINVALUE}] 
[{CYCLE | NOCYCLE}] 
[{CACHE | NOCACHE}];

EX_01 
- DEPT의 부서본호로 사용할 시퀸스를 생성해보자
시작값 : 50, 증가치 : 10, 최대값 : 90, 최소값 : 50, NOCYCLE, NOCACHE


- EX_01_SOL
CREATE SEQUENCE DEPT_SEQ
START WITH 50
INCREMENT BY 10
MAXVALUE 90
MINVALUE 50
NOCYCLE
NOCACHE;


- 데이터 사전에서 조회하기 
: USER_OBJECTS
: USER_SEQUENCES
SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE ='SEQUENCE';
SELECT * FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'DEPT_SEQ';


- 시퀸스 현재값 조회 
: 시퀸스명.CURRVAL
: [주의] NEXTVAL을 하지 않은채로 CURRVAL을 요구할 수 없다. => ERROR
SELECT DEPT_SEQ.NEXTVAL FROM DUAL;
SELECT DEPT_SEQ.CURRVAL FROM DUAL;


- 시퀸스 다음값 조회
: 시퀸스명.NEXTVAL
INSERT INTO DEPT(DEPTNO,DNAME,LOC) 
VALUES(DEPT_SEQ.NEXTVAL, 'EDUCATION'||DEPT_SEQ.CURRVAL, 'SEOUL');

SELECT * FROM DEPT;

ROLLBACK;

--------------------------------------------------------------------------------
# 시퀸스 수정/삭제 
: [주의] START WITH는 수정 불가능
ALTER SEQUENCE 시뉰스명
INCREMENT BY M
MAXVALUE N|NOMAXVALUE
MINVALUE N|NOMAXVALUE
CYCLE |NOCYCLE
CACHE N|NOCACHE

Q. DEPT_SEQ를 아래와 같이 수정하세요
--MAXVALUE 99
--MINVALUE 50
--증가치 5
--CYCLE 가능하도록
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
# 시퀸스 삭제
: DROP SEQUENCE 시퀸스 명;

DROP SEQUENCE DEPT_SEQ;

--------------------------------------------------------------------------------
[2] VIEW
CREATE VIEW 뷰이름
AS
SELECT 컬럼명1, 컬럼명2...
FROM 뷰에 사용할 테이블명
WHERE 조건;

Q. EMP 테이블에서 20번 부서의 모든 컬럼을 포함하는 EMP20_VIEW를 생성하라

CREATE VIEW EMP20_VIEW
AS 
SELECT * 
FROM EMP 
WHERE DEPTNO=20;

SYSTEN, SYS 계정으로 접속해서 SCOTT에게 권한을 부여하자
CONN SYSTEM/Abcd1234;
SHOW USER;
GRANT CREATE VIEW TO SCOTT;

데이터 사전에서 VIEW를 조회하기
SELECT * FROM USER_VIEWS;

SELECT * FROM EMP20_VIEW;


Q. [1] EMP테이블에서 30번 부서만 EMPNO를 EMP_NO로 ENAME을 NAME으로 SAL를 SALARY로 바꾸어 EMP30_VIEW를 생성하여라.
CREATE VIEW EMP30_VIEW
AS
SELECT EMPNO EMP_NO, ENAME NAME, SAL SALARY FROM EMP WHERE DEPTNO =30;
SELECT * FROM EMP30_VIEW;
   
Q. [2] 고객테이블의 고객 정보 중 나이가 19세 이상인 고객의 정보를 확인하는 뷰를 
만들어보세요.단 뷰의 이름은 MEMBER_19로 하세요.

CREATE VIEW MEMBER_19
AS
SELECT * 
FROM MEMBER 
WHERE AGE>=19;

SELECT* FROM MEMBER_19;

update member set age = 17 where num=1;

--------------------------------------------------------------------------------
# view 수정 : or replace 옵션을 주어 수정한다
create or replace view member_19
as
select * from member where age<19;

select * from member_19;
--------------------------------------------------------------------------------
Q. [1] 부서별 급여총액, 사원수, 평균급여(소수점2자리까지), 최소급여,최대급여를 출력하는
    view를 만드세요
    뷰이름: emp_statistic
    
CREATE VIEW EMP_STATISTIC
AS
SELECT DEPTNO, SUM(SAL) SUM_SAL, COUNT(*) CNT, ROUND(AVG(SAL),2) 
    AVG_SAL, MIN(SAL) MIN_SAL, MAX(SAL) MAX_SAL
FROM EMP 
GROUP BY DEPTNO;

SELECT * FROM EMP_STATISTIC ORDER BY DEPTNO;

Q. [2] 카테고리, 상품을 join하여 보여주는 view를 생성하세요
    뷰이름: products_view

CREATE VIEW PRODUCTS_VIEW
AS
SELECT CATEGORY_NAME, PRODUCTS_NAME, OUTPUT_PRICE, COMPANY
FROM CATEGORY C JOIN PRODUCTS P
    ON  P.CATEGORY_FK = C.CATEGORY_CODE;
    
SELECT * FROM PRODUCTS_VIEW WHERE CATEGORY_NAME LIKE '%도서%';


select* from emp20_view;

update emp20_view set sal = sal*1.5 where ename like 'SCOTT';

select * from emp where ename like 'SCOTT';

=> GROUP BY절을 이용해서 생성한 VIEW는 의 조작이 불가능하다.

ROLLBACK;

--------------------------------------------------------------------------------
# VIEW의 옵션
<1> WITH READ ONLY 
: 읽기 전용으로만 VIEW를 사용하고자 할 경우

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
: VIEW를 생성할 때 주었던 조건에 맞지 않는 데이터가 INSERT, UPDATE 되는 것을 허용하지 않는디.

Q. JOB이 SALESMAN인 사원 정보만 모아 EMP_SALES_VIEW를 생성하되 WITH CHECK OPTION을 
줘서 생성하라

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
FROM 절에서 사용한 SUBQUERY를 INLINE VIEW

RANK() OVER(분석절) : 분석절을 기준으로 랭킹을 매긴다.(값이 같으면 뒤순위는 사라진다)
ROW_NUMBER() OVER(분석절) : 분석절을 기준으로 행번호를 매긴다. (값이 같아도 뒤 순위는 적용된다)

분석절
PARITION BY 컬럼명 : 컬럼명을 기준으로 그룹핑을 한다.
ORDER BY 컬럼명 : 컬럼명을 기준으로 정렬한다.

SELECT RANK() OVER(ORDER BY SAL DESC) RNK, EMP.* 
FROM EMP;

Q. 업무별로 급여를 많이 받는 사원의 순위를 매기세요

SELECT RANK() OVER(PARTITION BY JOB ORDER BY SAL DESC) RNK, EMP.*
FROM EMP;

SELECT ROW_NUMBER() OVER(PARTITION BY JOB ORDER BY SAL DESC) RN, EMP.*
FROM EMP;

Q. 업무별 급여를 가장 많이 받는 사원 1명안 출력하세요
SELECT *
FROM (
    SELECT RANK() OVER(PARTITION BY JOB ORDER BY SAL DESC) RNK, EMP.* FROM EMP)
WHERE RNK=1;

desc emp;

select * from memo;
rollback;
desc emp;

update memo set msg = '안녕하세요!!', wdate = sysdate where name like '시럽용';
select * from emp;
delete from emp where empno =321;
desc memo;

alter table memo modify msg varchar2(100);