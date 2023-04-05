# 오러클 객체
[1] 시퀀스(sequence)

CREATE SEQUENCE 시퀀스명 
[INCREMENT BY n]
[START WITH n] 
[{MAXVALUE n | NOMAXVALE}] 
[{MINVALUE n | NOMINVALUE}] 
[{CYCLE | NOCYCLE}] 
[{CACHE | NOCACHE}] 
-------------------------------------------
desc dept;
dept의 부서번호로 사용할 시퀀스를 생성해보자

시작값 : 50
증가치 : 10
최대값 : 90
최소값 : 50
nocycle
nocache
------------------------
create sequence dept_seq
start with 50
increment by 10
maxvalue 90
minvalue 50
nocycle
nocache;

- 데이터 사전에서 조회하기
user_objects
user_sequences

select * from user_objects where object_type='SEQUENCE';
SELECT * FROM USER_SEQUENCES;

-- 시퀀스 현재값 조회: 시퀀스명.CURRVAL
-- 시퀀스 나음값 조회: 시퀀스명.NEXTVAL
: [주의] NEXTVAL을 하지 않은채로 CURRVAL을 요구할 수 없다 => 에러발생
SELECT DEPT_SEQ.CURRVAL FROM DUAL; 

SELECT DEPT_SEQ.NEXTVAL FROM DUAL;

INSERT INTO DEPT(DEPTNO,DNAME,LOC)
VALUES(DEPT_SEQ.NEXTVAL,'EDUCATION'||DEPT_SEQ.CURRVAL,'SEOUL');

SELECT * FROM DEPT;

ROLLBACK;

#  시퀀스 수정/ 삭제
[주의] START WITH 는 수정 불가
ALTER SEQUENCE 시퀀스명
INCREMENT BY N
MAXVALUE N|NOMAXVALUE
MINVALUE N|NOMINVALUE
CYCLE|NOCYCLE
CACHE N|NOCACHE

삭제 
DROP SEQUENCE 시퀀스명

--DEPT_SEQ를 아래와 같이 수정하세요
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

SELECT DEPT_SEQ.NEXTVAL FROM DUAL;

DROP SEQUENCE DEPT_SEQ;
----------------------------------------
[2] VIEW
--
--CREATE VIEW 뷰이름
--	AS
--	SELECT 컬럼명1, 컬럼명2...
--	FROM 뷰에 사용할 테이블명
--	WHERE 조건
--
--	[실습]
--	EMP테이블에서 20번 부서의 모든 컬럼을 포함하는 EMP20_VIEW를 생성하라.

CREATE VIEW EMP20_VIEW
AS
SELECT * FROM EMP
WHERE DEPTNO=20;

=> ERROR발생 INSUFFICIENT PRIVILEGES
뷰 생성 권한을 부여해야 생성 가능하다

SYSTEM, SYS 계정 으로 접속해서 SCOTT에게 권한을 부여하자
CONN SYSTEM/Abcd1234
SHOW USER;
GRANT CREATE VIEW TO SCOTT;

-- 데이터 사전에서 view를 조회하기
-- user_views

select * from user_views;

select * from emp20_view;

--
--[1] EMP테이블에서 30번 부서만 EMPNO를 EMP_NO로 ENAME을 NAME으로
--	SAL를 SALARY로 바꾸어 EMP30_VIEW를 생성하여라.
create view emp30_view
as
select empno emp_no, ename name, sal salary, deptno dno
from emp
where deptno=30;

select * from emp30_view;

--    
--[2] 고객테이블의 고객 정보 중 나이가 19세 이상인
--	고객의 정보를
--	확인하는 뷰를 만들어보세요.
--	단 뷰의 이름은 MEMBER_19로 하세요.
create view member_19
as
select * from member where age>=19;

select * from member_19;

update member set age=17 where num=1;

# view 수정
- or replace 옵션을 주어 수정한다
create or replace view member_19
as
select * from member where age<19;

select * from member_19;

--
--[1] 부서별 급여총액, 사원수, 평균급여(소수점2자리까지), 최소급여,최대급여를 출력하는
--view를 만드세요
--뷰이름: emp_statistic
create or replace view emp_statistic
as
select deptno, sum(sal) sum_sal, count(empno) cnt,
round(avg(sal),2) avg_sal, min(sal) min_sal, max(sal) max_sal
from emp
group by deptno;

select * from emp_statistic order by deptno;

--
--[2] 카테고리, 상품을 join하여 보여주는 view를 생성하세요
--뷰이름: products_view

create or replace view product_view
as
select category_name, products_name, output_price, company
from category c join products p
on c.category_code = p.category_fk;

select * from product_view
where category_name like '%도서%';


select category_name, products_name, output_price, company
from category c join products p
on c.category_code = p.category_fk
where  category_name like '%도서%';

select * from emp20_view;

update emp20_view set sal=sal*1.1 where ename=upper('scott');

select * from emp;

-- group by 절을 이용해서 생성한 view는 dml조작이 불가능하다.

rollback;

# view 의 옵션

<1> with read only : 읽기 전용으로만 view를 사용하고자 할 경우
<2> with check option: view를 생성할때 주었던 조건에 맞지않는 
            데이터가 insert되거나 update되는 것을 허용하지 않는다
------------------------------------------------------------------
create or replace view emp10_view
as
select empno,ename,job,deptno
from emp where deptno=10
with read only;

select * from emp10_view;

update emp set job='ANALYST' where empno=7782;

rollback;

update emp10_view set job='ANALYST' where empno=7782;
-- cannot perform a DML operation on a read-only view
-----------------------------------------------------
--job이 SALESMAN인 사원 정보만 모아 EMP_SALES_VIEW를 생성하되
--WITH CHECK OPTION을 줘서 생성하세요

CREATE OR REPLACE VIEW EMP_SALES_VIEW
AS
SELECT * FROM EMP
WHERE JOB='SALESMAN'
WITH CHECK OPTION;

SELECT * FROM EMP_SALES_VIEW;
SELECT * FROM EMP;
UPDATE EMP_SALES_VIEW SET COMM=100 WHERE EMPNO=7844; -- [O]
UPDATE EMP_SALES_VIEW SET JOB='MANAGER' WHERE EMPNO=7844;--[X]
--ORA-01402: view WITH CHECK OPTION where-clause violation

UPDATE EMP SET JOB='MANAGER' WHERE EMPNO=7844;

ROLLBACK;

# INLINE VIEW
FROM 절에 사용한 SUBQUERY를 INLINE VIEW라고 함
