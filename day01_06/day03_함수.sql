/* 오라클 함수
# 단일행 함수
    [1]문자형 함수
    [2] 숫자형 함수
    [3] 날짜형 함수
    [4] 변환형 함수
    [5] 기타 함수   */
    
-- dual : 1개의 행만 갖는다.

-----------------------------------------------------
[1] 문자형 함수
- lower() / upper() : 소문자 / 대문자로 바꿔 출력하는 함수
- initcap() : 첫 문자를 대문자로 나머지는 소문자로 변환
- concat(컬럼1, 컬럼2) : 컬럼1과 컬럼2를 연결한 값을 반환한다.
- substr(컬럼, N, LEN) : 컬럼값에서 N에서 시작하여 LEN길이만큼 추출함
- length(컬럼) : 문자열 길이 반환
- lpad(컬럼, n, c) : 컬럼값을 n자리만큼 출력하되, 왼쪽에 남는 공간이 있으면 c 값으로 채운다
- rpad(컬럼, n, c) : 컬럼값을 n자리만큼 출력하되, 오른쪽에 남는 공간이 있으면 c 값으로 채운다
- ltrim()/rtrim() : 왼쪽/오른쪽 공백을 제거한다.
- ltrim(변수1, 변수2) 

-----------------------------------------------------
select lower('Happy Birthday to you'), upper('Happy birthday to you') from dual;
select initcap(ename) from emp;
select concat('ABCD','1234') from dual; 
select empno, ename, job, concat(ename,empno), concat(ename,job) from emp;
select substr('051224-1012456',1,6) from dual;
select substr('051224-1012456',8) from dual;
select substr('051224-1012456',-7) from dual;
select substr('ABCDEFG',-4,3)from dual;

---------------------------------------------------------
-- Q-[문제] 사원 테이블에서 첫글자가 'K'보다 크고 'Y'보다 작은 사원의 사번,이름,업무,급여를 출력하세요. 단 이름순으로 정렬하세요.
select empno,ename, job, sal from emp
where substr(ename,1,1)> 'K'and substr(ename,1,1)< 'Y';

--  사원테이블에서 부서가 20번인 사원의 사번,이름,이름자릿수, 급여,급여의 자릿수를 출력하세요.	
select empno, ename, deptno, length(ename), sal, length(sal)
from emp where deptno=20;
	
--	사원테이블의 사원이름 중 6자리 이상을 차지하는 사원의이름과 이름자릿수를 보여주세요.
select ename,length(ename) from emp
where length(ename)>=6;

select ename,  lpad(ename,15,'*') from emp; -- 오른쪽 정렬
select ename,  lpad(ename,15,'*'), sal, lpad(sal,10,'#') from emp; -- 오른쪽 정렬

select dname, rpad(dname,15,'@')from dept;

select ltrim('TTTHeloow TEST', 'T'), LTRIM('TOPHELLO TEST', 'T') from dual;
select rtrim('TTTHello TEST','T') FROM DUAL;

select LTRIM('        ORACLE TEST '), RTRIM('   ORACLE TEST ') FROM DUAL;
select (RTRIM(LTRIM('      ORACLE TEST  '))) RESULT FROM DUAL;


--------------------------------------------------------------------
REPLACE(컬럼, 값1, 값2) : 컬럼값 중 값1에 해당하는 값이 있으면 값2로 변경한다.

select REPLACE('ORACLE TEST', 'TEST','HI') FROM DUAL;
--------------------------------------------------------------------
--[문제]
--	사원테이블에서 10번 부서의 사원에 대해 담당업무 중 우측에'T'를 삭제하고 급여중 우측의 0을 삭제하여 출력하세요.      
desc emp;
select ename, RTRIM(job,'T'),sal, RTRIM(SAL,0) from emp;


-- 사원테이블 JOB에서 'A'를 '$'로 바꾸어 출력하세요.
select ename,job, replace(job,'A','$')from emp;
--
--고객 테이블의 직업에 해당하는 컬럼에서 직업 정보가 학생인 정보를 모두 대학생으로 변경해 출력되게 하세요.
select name, job, replace(job, '학생','대학생'), addr from member;

/*--------------------------------------------------------------------------------
 Update 테이블명 set 컬럼명1=값1 where 조건절

--고객 테이블 주소에서 서울시를 서울특별시로 수정하세요
--------------------------------------------------------------------------------*/

select * from member;
update member set addr = '서울특별시 강북 ' where name= '홍길동'  and job = '주부';

rollback;

update member set addr = replace(addr,'서울시', '서울 특별시');

--------------------------------------------------------------------------------
[2] 숫자형 함수
- round() : 반올림 함수
- round(값), round(값,자리수) : 자리수가 양수면 소수자리를 반올림하고, 음수면 정수자리를 반올림 한다.

select round(4567.678), round(4567.678,0), round(4567.678,2),round(4567.678,-2) from dual;
----------------------------------------------------------------------------------------------
- trunc(값), trunc(값, 자리수) : 버림 함수 절삭

select trunc(4567.678),trunc(4567.678,0),trunc(4567.678,2),trunc(4567.678,-2) from dual;
----------------------------------------------------------------------------------------------
- mod(값1, 값2): 값1을 값2로 나눈 나머지값을 반환하는 함수
select mod(100,3) from dual;
----------------------------------------------------------------------------------------------
--[1] MEMBER테이블에서 고객 이름과,마일리지,나이를 출력하고, 마일리지를 나이로 나눈 값을 반올림하여 출력하세요
desc member;
select name, mileage, age, round(mileage/age) from member;
--[2] 상품 테이블의 상품 정보가운데 백원단위까지 버린 배송비를 비교하여 출력하세요.
desc products;
select trunc(trans_cost,-2) from products;
--[3] 사원테이블에서 부서번호가 10인 사원의 급여를 	30으로 나눈 나머지를 출력하세요.
desc emp;
select ename, mod(sal,30) from emp where deptno =10;

----------------------------------------------------------------------------------------------

- ceil() : 올림 함수
- floor() : 내림 함수
- abs() : 절대값을 반환
select ceil(12.001), floor(12.001) from dual;

select name, age, 40-age, abs(40-age)"40살과의 나이 차이" from member;

----------------------------------------------------------------------------------------------
[3] 날짜 함수
날짜 연산

select sysdate, sysdate+3, sysdate-3 from dual;

date- date => 일수
date + number => 며칠 뒤
date - number => 며칠 전

alter session set nls_date_format ='yy/mm/dd';

select (TO_DATE('23/05/05','YY/MM/DD') - SYSDATE) from dual;

--지금 시각에서 2시간 전과 2시간 후 시각을 출력하세요
to_char(date,'포맷문자열')
년: yy
월: mm
일: dd
시: hh => hh24 (24시간 기준)
분: mi
초: ss
select to_char(sysdate-2/24,'yy/mm/dd hh:mi:ss'), to_char(sysdate+2/24,'yy/mm/dd hh24:mi:ss') from dual;
select to_char(sysdate,'cc yyy') from dual;
select to_char(sysdate,'cc-yyy-ddd') from dual;
select to_char(sysdate,'cc-yyy-ddd dy') from dual;
select to_char(sysdate,'cc-yyy-ddd day') from dual;
ddd => 1년을 기준으로 한 날짜
dd => 1달을 기준으로 한 날짜
d => 1주일을 기준으로 한 날짜

----------------------------------------------------------------------------------------------
- months_between(d1,d2) : 두 날짜 사이의 월수를 계산
- add_months(date,number) : 날짜에 number월 만큼 더한 날짜를 반환함
- lasy_day(date)


select months_between(sysdate,(to_date('23/12/24','yy/mm/dd'))) from dual;

---------------------------------------------------------------------------------------------- 
-- 오늘부터 5달 뒤의 날짜를 출력하세요
---------------------------------------------------------------------------------------------- 
select sysdate, add_months(sysdate,5) "5달 뒤",add_months(sysdate,-5) "5달 전" from dual;

select last_day(sysdate), last_day('23/02/01'), last_day('22/02/01'),last_day('20/02/01'), last_day('24/02/01') from dual;

-- 사원 테이블에서 현재까지 근무 일수가 몇 주 몇일인가를 출력하세요 - 단 금누일수가 많은 사람순으로 출력하세요
desc emp;
select ename, hiredate,trunc((sysdate- hiredate))"근무일수", trunc((sysdate-hiredate)/365)"근속년수", 
trunc((sysdate-hiredate)/7) "weeks", trunc(mod(sysdate - hiredate,7)) "DAYS"
from emp
order by 3;

---------------------------------------------------------------------------------------------- 
[4] 변환형 함수
- to_char() 
    * to_char(날짜, 출력 형식) : date 유형을 문자열로 변환하는 함수
    * to_char(숫자, 출력 형식) : number 유형을 문자열로 변환하는 함수
---------------------------------------------------------------------------------------------- 
select to_char(sysdate) from dual;
select to_char(sysdate,'yyyy-mm-dd hh12:mi:ss') from dual;

select to_char(25000,'99,999') from dual;
select to_char(25000,'$999,999') from dual;
----------------------------------------------------------------------------------------------
--1] 상품 테이블에서 상품의 공급 금액을 가격 표시 방법으로 표시하세요.  천자리 마다 , 를 표시합니다.
select products_name, input_price, to_char(input_price,'l999g999g999')"공급 가격"
from products
order by 2;

--2] 상품 테이블에서 상품의 판매가를 출력하되 주화를 표시할 때 사용하는 방법을  사용하여 출력하세요.[예: \10,000]
select products_name, output_price, to_char(output_price,'L999g999g999')"판매 가격"
from products
order by 2;

select to_char(trans_cost,'c99999.99') from products;

----------------------------------------------------------------------------------------------     
- to_date(문자열, 출력포멧) : 문자열을 date유형으로 변환하는 함수

select sysdate-to_date('20220531','yyyymmdd') from dual;


--고객테이블의 고객 정보 중 등록일자가 2003년 6월1일 이후 등록한 고객의 정보를 보여 주세요
desc member;

select * from member
where reg_date>(to_date('2013/06/01','yyyy/mm/dd'));

-- 고객테이블에 있는 고객 정보 중 등록연도가 2013년인 고객의 정보를 보여주세요.
select * from member
where to_char(reg_date,'yyyy') = '2013';

----------------------------------------------------------------------------------------------     
- to_number(char|varchar2) : 문자열을 숫자로 변환하는 함수
- to_number(변수, 출력형식)

--select '\25,000' *5 from dual; [x]
select to_number('$25,000','$99,999') *2 from dual;

----------------------------------------------------------------------------------------------   
[5] 기타함수
- nal()
- nal2()
- decode()
- rank()
- over()

----------------------------------------------------------------------------------------------   
- ex) decode(변수, 값1,'출력값',...) : 변수 값이 값1과 같으면 출력값 1을 출력
select ename, deptno from emp;
select ename, deptno, decode(deptno,10,'회계부서',20,'연구부서',30,'영업부서','기타부서')
from emp order by deptno;

- ex) rank() over (분석절) : 분석절을 기준으로 랭킹을 매기는 함수
select * from(
select rank() over (order by sal desc) RNK, E.* from emp E)
where RNK<=3;
-- from절에서 사용된 별칭은 어디서든 참조가능 but select 절에서 사용된 별칭은 select 안에서만 사용가능

- ex) row_number() over() : 분석절을 기준으로 행번호를 붙여준다.
select row_number() over(order by hiredate) RNUM, emp.* from emp;

select * from ( select row_number() over(order by hiredate) RNUM, EMP.* FROM EMP)
WHERE RNUM BETWEEN 11 AND 20;

----------------------------------------------------------------------------------------------  
- # 그룹 함수 
: group by절과 함께 사용될 때가 많다.
: 여러 행 또는 테이블 전체에 대해 함수가 적용되어 하나의 결과를 반환하는 함수
---------------------------------------------------------------------------------------------- 
- avg() :평균관 _NULL 값 제외
- sum() : 합계 _NULL 값 제외
- min() : 최소값
- max() : 최대값
- stddev() : 표준편차
- variance() : 분산
- count()

---------------------------------------------------------------------------------------------- 
- count()
select count(empno) from emp;

select count(mgr) from emp; -- null값을 제외하고 카운팅을 함 (king_은 mgr값이 null)

select count(distinct mgr) from emp; -- 중복되지 않는 값만 반환

select count(*) from EMP; -- NULL 값도 카운팅 함

CREATE TABLE MYTAB(
    A NUMBER,
    B NUMBER,
    C NUMBER
);

DESC MYTAB;

INSERT INTO MYTAB(A,B,C) VALUES (NULL,NULL,NULL);
COMMIT;
SELECT * FROM MYTAB;

SELECT COUNT(A) FROM MYTAB; -- 0
SELECT COUNT(*) FROM MYTAB; -- 3

--------------------------------------------------------------------------------
--[1] emp테이블에서 모든 SALESMAN에 대하여 급여의 평균,최고액,최저액,합계를 구하여 출력하세요.
SELECT AVG(SAL)"평균", MAX(SAL)"최고액", MIN(SAL)"최저액", SUM(SAL)"합계" FROM EMP WHERE JOB LIKE 'SALESMAN';

--[2] EMP테이블에 등록되어 있는 인원수, 보너스에 NULL이 아닌 인원수,보너스의 평균,등록되어 있는 부서의 수를 구하여 출력하세요
DESC EMP;
SELECT COUNT(EMPNO)"인원수", COUNT(COMM)"보너스 NOT NULL", AVG(COMM)"보너스 평균", COUNT(JOB)"등록된 부서" FROM EMP;

SELECT MIN(ENAME), MAX(ENAME), MIN(HIREDATE), MAX(HIREDATE), MIN(SAL), MAX(SAL) FROM EMP;

--------------------------------------------------------------------------------
GROUP BY : 특정 컬럼이나 값을 기준으로 레코드를 묶어서 데이터를 관리할 때 사용하는 문장 (그룹함수와 함께 사용)

SELECT (GROUP BY)에서 사용된 컬럼명, 그룹함수
FROM 테이블명
GROUP BY;



--------------------------------------------------------------------------------
--[1] 고객 테이블에서 직업의 종류와 각 직업에 속한 사람의 수를 보여주시오.
SELECT JOB, COUNT(*)
FROM MEMBER
GROUP BY JOB
ORDER BY COUNT(*);

--[2] 고객 테이블에서 직업의 종류, 각 직업에 속한 최대 마일리지 정보를 보여주세요
DESC MEMBER;
SELECT JOB, MAX(MILEAGE)
FROM MEMBER
GROUP BY JOB
ORDER BY MAX(MILEAGE) DESC;

--3] 상품 테이블에서 각 상품카테고리별로 총 몇 개의 상품이 있는지 보여주세요. 또한 최대 판매가와 최소 판매가를 함께 보여주세요.
DESC PRODUCTS;

SELECT CATEGORY_FK, COUNT(*), MAX(OUTPUT_PRICE), MIN(OUTPUT_PRICE)
FROM PRODUCTS
GROUP BY CATEGORY_FK
ORDER BY CATEGORY_FK;

--	4 상품 테이블에서 각 공급업체 코드별로 공급한 상품의 평균입고가를 보여주세요.
SELECT EP_CODE_FK, ROUND(AVG(INPUT_PRICE)) "평균 입고가"
FROM PRODUCTS
GROUP BY EP_CODE_FK;

--	5] 사원 테이블에서 입사한 년도별로 사원 수를 보여주세요.
DESC EMP;

SELECT TO_CHAR(HIREDATE,'YY')"입사 년도",COUNT(*)"사원수"
FROM EMP
GROUP BY TO_CHAR(HIREDATE,'YY')
ORDER BY 1;

--	6] 사원 테이블에서 해당년도 각 월별로 입사한 사원수를 보여주세요.
SELECT TO_CHAR(HIREDATE,'YY-MM')" 해당년도 각 월" ,COUNT(*)"사원수"
FROM EMP
GROUP BY TO_CHAR(HIREDATE,'YY-MM')
ORDER BY 1;;

--	7] 사원 테이블에서 업무별 최대 연봉, 최소 연봉을 출력하세요
SELECT JOB, MAX(SAL*12),MIN(SAL*12)
FROM EMP
GROUP BY JOB;


--------------------------------------------------------------------------------
- HAVING절 
GROUP BY 절과 함께 사용
GROUP BY에 제한을 두어 데이터를 조회할 때 사용한다.


--------------------------------------------------------------------------------
SELECT JOB, COUNT(*)
FROM MEMBER
GROUP BY JOB
HAVING COUNT(*)>=2;


--1] 고객 테이블에서 직업의 종류와 각 직업에 속한 최대 마일리지 정보를 보여주세요. 단, 직업군의 최대 마일리지가 0인 경우는 제외시킵시다.
SELECT JOB, MAX(MILEAGE)
FROM MEMBER
GROUP BY JOB
HAVING MAX(MILEAGE) !=0;

--	2] 상품 테이블에서 각 카테고리별로 상품을 묶은 경우, 해당 카테고리의 상품이 2개인 상품군의 정보를 보여주세요.
DESC PRODUCTS;

SELECT CATEGORY_FK, COUNT(*)
FROM PRODUCTS
GROUP BY CATEGORY_FK
HAVING COUNT(*)=2;


--	3] 상품 테이블에서 각 공급업체 코드별로 상품 판매가의 평균값 중 단위가 100단위로 떨어지는 항목의 정보를 보여주세요
SELECT EP_CODE_FK, AVG(OUTPUT_PRICE)
FROM PRODUCTS
GROUP BY EP_CODE_FK
HAVING MOD(AVG(OUTPUT_PRICE),100)=0;


