-- day2.sql
-- select 문 실습

select * from dept;
select * from emp;

select DEPTNO, DNAME, LOC FROM DEPT;
SELECT ENAME, JOB, COMM,SAL*12+NVL(comm,0) "연 봉" FROM EMP;
SELECT ENAME, MGR, NVL2(MGR,'관리자 있음','관리자 없음')"관리자 존재 여부" FROM EMP;


-- '||'  : 문자열 결함 연산자
SELECT ENAME || ' '|| 'IS A'|| JOB FROM EMP;

-- Q. 문제 EMP테이블에서 이름과 연봉을 "KING: 1 YEAR SALARY = 60000" 형식으로 출력하라.
SELECT ENAME|| ' : 1 TEAR SALARY = '|| (sal*12+NVL(comm,0)) "사원의 연봉" from emp order by sal DESC;



-- distinct : 중복 행 제거하고 1번만 보여줌
-- uniqe : distinct와 같은 역할
select job from emp;
select distinct job from emp;



-- emp에서 사원들이 담당하고 있는 업무의 종류를 보여주세요
select distinct job from emp;

select distinct deptno from emp;
select distinct deptno, job from emp order by deptno asc;
select distinct name, job from member;



--Q2. MEMBER테이블에서 회원의 이름과 나이 직업을 보여주세요.
select name,age from member;
select * from member;
--Q3. CATEGORY 테이블에 저장된 모든 내용을 보여주세요.
select * from category;
--Q4. MEMBER테이블에서 회원의 이름과 적립된 마일리지를 보여주되, 마일리지에 13을 곱한 결과를 "MILE_UP"이라는 별칭으로 함께 보여주세요.
select  name, mileage ,mileage*13 "MILE_UP" from member;



-- where 절 : 조건절
select * from emp where sal>=3000;

-- Q5. EMP테이블에서 담당업무가 MANAGER인 사원의 정보를 사원번호,이름,업무,급여,부서번호로 출력하세요.
select * from emp;
select empno,ename,job,sal,deptno from emp where job = upper('manager');

-- Q6. EMP테이블에서 1982년 1월1일 이후에 입사한 사원의 사원번호,성명,업무,급여,입사일자를 출력하세요.
select empno, ename, job, sal, hiredate from emp where hiredate > '82/01/01';


-- Q7. emp테이블에서 급여가 1300에서 1500사이의 사원의 이름,업무,급여,부서번호를 출력하세요.
select empno, ename, job, sal, deptno from emp where sal between 1300 and 1500;
	
--	Q8. emp테이블에서 사원번호가 7902,7788,7566인 사원의 사원번호,이름,업무,급여,입사일자를 출력하세요.
select empno, ename, job, sal, hiredate from emp where empno in(7902,7788,7566);
-- where empno = 7902 or empno = 7788 or empno =7566

--	Q9. 10번 부서가 아닌 사원의 이름,업무,부서번호를 출력하세요
select ename, job, deptno from emp where deptno <> 10;
select ename, job, deptno from emp where deptno != 10;
select ename, job, deptno from emp where deptno not like 10;
desc emp;



-- # LIKE 연산자
-- Q10. EMP테이블에서 이름이 S로 시작되는 사람의 정보를 보여주세요.
select * from emp where ename like upper('s%');

-- Q11. 이름 중 S자가 들어가는 사람의 정보를 보여주세요.
select * from emp where ename like upper('%s%');

-- Q12. 이름의 두번 째에 O자가 들어가는 사람의 정보를 보여주세요.
select * from emp where ename like upper('_o%');


desc member;
--	Q13. 고객 테이블 가운데 성이 김씨인 사람의 정보를 보여주세요.
select * from member where name like '김%';
--	Q14. 고객 테이블 가운데 '강남구'가 포함된 정보를 보여주세요.
select * from member where addr like '%강북%';
--	Q15. 카테고리 테이블 가운데 category_code가 0000로 끝는 상품정보를 보여주세요.

select * from category where category_code like '%0000';


--	Q16. 82년도에 입사한 사원 정보를 보여주세요
select * from emp where hiredate like '82%';




-- 날짜 형식 바꾸기
alter session set nls_date_format='DD-mm-yy';
alter session set nls_date_format='yyyy-mm-dd';
select * from emp where hiredate like '%82';

--	Q17. comm이 null인 사원의 이름 업무 급여 보너스를 출력하세요
desc emp;
select ename, job, sal, comm from emp where comm is null;

-- null값은 equal(=)로 비교하면 안되고 is null || is not null

-- 논리 연산자 AND OR NOT


--- Q18. EMP테이블에서 급여가 1100이상이고 JOB이 MANAGER인 사원의 사번,이름,업무,급여를 출력하세요.
desc emp;
select empno, ename, job, sal from emp where sal>=1100 and job ='MANAGER';	

--	Q19. EMP테이블에서 급여가 1100이상이거나 JOB이 MANAGER인 사원의 사번,이름,업무,급여를 출력하세요.
select empno, ename,job,sal from emp where sal>=1100 or job = 'MANAGER';

--	Q20. EMP테이블에서 JOB이 MANAGER,CLERK,ANALYST가 아닌 사원의 사번,이름,업무,급여를 출력하세요.
select empno, ename,job,sal from emp where job != 'MANAGER' and  job <> 'CLERK' and job != 'ANALYST';
select empno, ename,job,sal from emp where job not in('MANAGER','CLERK','ANALYST');



-- order by 절
-- 오름정렬 asc (default)
-- 내림정렬 desc

--	Q21. 사원테이블에서 입사일자 순으로 정렬하여 사번,이름,업무,급여,입사일자를 출력하세요.
desc emp;
select empno, ename, job, sal, hiredate from emp order by hiredate;
select empno, ename, job, sal, hiredate from emp order by hiredate desc;

select empno, ename, job, sal, sal*12 ANNSAL from emp order by sal*12 asc;
select empno, ename, job, sal, sal*12 ANNSAL from emp order by ANNSAL desc;


--	Q22.사원 테이블에서 부서번호로 정렬한 후 부서번호가 같을 경우 급여가 많은 순으로 정렬하여 사번,이름,업무,부서번호,급여를 출력하세요.
select empno, ename, job, deptno, sal from emp order by deptno, sal desc; 

--	Q23.사원 테이블에서 첫번째 정렬은 부서번호로, 두번째 정렬은 업무로, 세번째 정렬은 급여가 많은 순으로 정렬하여 사번,이름,입사일자,부서번호,업무,급여를 출력하세요
select empno, ename, job, deptno, sal from emp order by deptno, job, sal desc; 


select * from tab;
desc products;

-- Q24. 상품 테이블에서 판매 가격이 저렴한 순서대로 상품을 정렬해서 보여주세요.
select * from products order by output_price;


-- Q25. 고객 테이블의 정보를 이름의 가나다 순으로 정렬해서 보여주세요. 단, 이름이 같을 경우에는 나이가 많은 순서대로 보여주세요.
select * from member order by name, age desc;
desc member;


-- Q26. 고객 테이블에서 직업의 종류와 각 직업에 속한 사람의 수가 많은 순서대로 보여주세요.
select job, count(*) 
from member 
group by job 
order by count(*) desc;


-- Q27. 상품테이블에서 공급업체별로 평균판매가를 구하되 평균판매가 오름차순으로 보여주세요
select ep_code_fk, round(avg(output_price))"평균 판매가" 
from products 
group by ep_code_fk 
order by "평균 판매가" asc;













