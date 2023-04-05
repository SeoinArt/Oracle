select * from tab;
-- 단문 주석
/* 복문 주석 c:/myjava/sql/day01.sql */ 

-- 인사관리 시스템
select * from dept;
select dname, loc, deptno from dept;
select * from emp;
select * from salgrade;

-- 쇼핑몰 시스템
select * FROM member; -- 회원
select * from category; -- 카테고리
select * from products; -- 상품
select * from SUPPLY_COMP; -- 공급 업체


-- 학생 테이블 : 학번, 이름, 주소, 연락처, 등록일, 학급명, 교실
create table student(
num number(4) primary key, -- unique + n ot null
name varchar2(30) not null,
addr varchar2(100) not null,
tel varchar2(15) not null,
indate date default sysdate, -- 시스템의 현재 날짜를 디폴트값으로 설정
cname varchar2(50),
croom number(3)
);

select * from student;


/* insert into 테이블명(컬럼명1,컬럼명2,...) values(값1,값2,...) */

insert into student(num,name,addr,tel,cname, croom) values(1,'홍길동','서울 마포구', '010-1111-1111','백엔드 개발자반', 201);
commit; -- db에 영구히 저장

insert into student(num,addr,name,tel,cname,croom) values(2,'인천광역시 남동구','김길동','010-2222-2222','백엔드 개발자반',201);

rollback; -- 취소
commit;

insert into student(num,name,addr,tel) values (3,'최영자', '고양시 일산동구','010-3333-3333');
insert into student values(4,'이길자','수원','010-9999-9999','23/03/21','빅데이터반',202);
insert into student values(5,'빅빅이', '고양시','010-8888-8888','23/03/21','빅데이터반',202);
insert into student values(6,'데이티', '화전시','010-7777-7777','23/03/21','빅데이터반',202);
insert into student values(7,'김지연', '찬동시','010-6666-6666','23/03/21','AI 서비스 개발자반',203);
insert into student values(8,'최한길', '울산광역시','010-5555-5555','23/03/21','AI 서비스 개발자반',203);
insert into student values(9,'윤원용', '김해시','010-5555-5555','23/03/21','AI 서비스 개발자반',203);
select * from student;

-- 데이터 수정
-- update 테이블명 set 컬럼명 = 값, ... where 조건절
update student set addr = '대구광역시' where name like '최한%';
update student set cname='백엔드 개발자반', croom=202 where num=3;

-- 이름이 홍길동인 학생의 연락처를 010-1234-5678 수정
update student set tel='010-1234-5678' where name ='홍길동';
select * from student;
commit;

-- 데이터 삭제
-- delete from 테이블명 where 조건절;
select * from student;
DELETE FROM student;
ROLLBACK;

delete from student where num =2;
delete from student where name='김지연';

insert into student values(10,'유재석','서울 강북구','010-7878-8989', sysdate,'백엔드반','301');
select * from student where croom=201;

-- 테이블 삭제 : DDL
-- drop table 테이블명
drop table student;
 

-- 학습 테이블
create table sclass(
    snum number(4) primary key, -- 학급번호
    sname varchar2(50) not null, -- 학급명
    sroom number(3)
);
desc sclass
commit;

create table student(
    num number(4) primary key,
    name varchar2(30) not null,
    addr varchar2(100) not null,
    tel varchar2(15) not null,
    indate date default sysdate,
    snum_fk number(4) references sclass(snum)
)
desc student;

-- 학급 데이터를 삽입하세요
/*  10 백엔드 개발자반 201
    20 빅데이터반 202
    30 AI 서비스 개발자반 203 */

insert into sclass VALUES( 10 ,'백엔드 개발자반', 201);
insert into sclass VALUES( 20 ,'빅데이터반', 202);
insert into sclass VALUES( 30 ,'AI 서비스 개발자반', 203);
select * from sclass;
commit;

-- 학생 데이터 삽입
insert into student(num,name,addr,tel,snum_fk) values(1,'홍길동','서울 마포구','010-0000-0000',10);
insert into student(num,name,addr,tel,snum_fk) values(2,'김길동','인천 남동구','010-1111-1111',10);
insert into student(num,name,addr,tel,snum_fk) values(3,'최영자','고양시 일산동구','010-2222-2222',10);

insert into student(num,name,addr,tel,snum_fk) values(4,'이길자','서울 강남구','010-3333-3333',20);
insert into student(num,name,addr,tel,snum_fk) values(5,'이명길','서울 강동구','010-4444-4444',20);
insert into student(num,name,addr,tel,snum_fk) values(6,'김자영','서울 강서구','010-5555-5555',20);

insert into student(num,name,addr,tel,snum_fk) values(7,'김동길','서울 강북구','010-6666-6666',30);
insert into student(num,name,addr,tel,snum_fk) values(8,'김수정','서울 남평동','010-7777-7777',30);
insert into student(num,name,addr,tel,snum_fk) values(9,'최재우','서울 혜화동','010-8888-8888',30);

select * from student;
commit;

-- 삽입 이상 
insert into student values(10,'아무개', '서울 서대문구', '010-2323-2222','23-03-21',40);

-- 갱신 이상
-- 1번 학생의 학급 변경하되 30번 학급으로 변경하세요
update student set snum_fk=30 where num=1;

-- 2번 학생의 학급 변경하되 40번 학급으로 변경하세요
update student set snum_fk=40 where num=1;

-- 삭제 이상 방지
delete from sclass where snum =10; -- 외래키로 참조하는 데이터가 자식 테이블에 있다면 삭제할 수 없음

select * from student;

-- join ans
select snum, sname,name, tel, indate,snum_fk
from sclass join student 
on sclass.snum = student.snum_fk
order by snum asc;

-- *******************************************************************************
select * from dept; -- 부모 테이블 : PK.deption (Unique + not null)
SELECT * FROM emp; -- 자식 테이블 : FK.deption 

SELECT empno, ename, sal FROM emp;

SELECT empno, ename, sal, sal+300 as sal_up FROM emp; -- alias. 별칭 :  as || ""

-- emp에서 사번, 사원명, 급여, 보너스, 급여*12+보너스 year_sal
SELECT EMPNO, ENAME, SAL, COMM, SAL*12+COMM AS YEAR_SAL FROM EMP;

-- NVL(컬럼명, 값) 함수 : 컬럼이 null일 경우 주어진 값으로 대체해서 반환한다.
SELECT empno, ename, sal, comm, sal*12+nvl(comm,0)"연봉" FROM emp;

-- NVL2(EXPR, EXPR1, EXPR2) : EXPR값이 null이 아닐 경우 EXPR1 값을 반환하고, NULL일 경우 EXPR2값을 반환한다.

-- Q. emp 테이블에서 관리자(MGR)가 있을 경우에는 1, 없으면 0을 출력되도록 하세요
SELECT EMPNO, ENAME,MGR,NVL2(MGR,1,0) "관리자 존재 여부" FROM emp;

SELECT EMPNO, JOB, SAL FROM EMP WHERE ENAME =   upper('scott');

commit;


