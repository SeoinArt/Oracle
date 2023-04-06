-- function 사번을 인 파라미터로 넘기면 해당 사원의 부서명을 반환하는 함수

create or replace function getDname
(pname in emp.ename%type)
return varchar2 -- 반환 타입 지정
is
vdno emp.deptno%type;
vdname dept.dname%type;
begin
    select deptno
    into vdno
    from emp where ename = upper(pname);
    
    select dname
    into vdname
    from dept where deptno = vdno;
    
    return vdname; -- 반환 값
    
    exception 
    when no_data_found then 
        dbms_output.put_line(pname|| ' 사원은 없습니다 ' );
        return SQLERRM;
    when too_many_rows then   
        dbms_output.put_line(pname|| ' 사원 데이터가 2권 이상 있습니다. ' );
        return SQLERRM;
    when others then
        return sqlerrm;
end;
/

-- 함수의 반환값을 저장하기 위한 바인드 변수 선언
var gname varchar2;
exec :gname := getDname('1');
print gname;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
set serveroutput on;
select * from emp;

-------------------------------------------------------------------------------- 패키지

--[1] 패키지 선언부
create or replace package empInfo as
procedure allEmp;
procedure allSal;
end empInfo;
/


-- [2] 패키지 변수 선언
create or REPLACE package body empInfo as
    -- allEmp : 모든 사원의 사번, 이름, 입사일 가져와 출력하는 프로시저
    procedure allEmp
    is
        cursor empCr is
        select empno, ename, hiredate from emp order by 3;
    begin
        for k in empCr loop
            dbms_output.put_line(k.empno || lpad(k.ename, 16, ' ') || 
            lpad(k.hiredate, 16, ' '));
        end loop;
    
    exception
        when others then 
            dbms_output.put_line(SQLERRM|| '에러 발생');
    end allEmp;
    
    -- allSal : 전체 사원의 급여 합계, 사원수 평균 급여, 최대 급여, 최소 급여
    procedure allSal
    is 
    begin
        dbms_output.put_line('급여 총합'||lpad('사원수',10,' ')|| 
        lpad('평균 급여',10,' ')|| lpad('최대 급여',10,' ')||
        lpad('최소급여',10,' '));
        dbms_output.put_line('-----------------------------------------------');
        for k in (select sum(sal) total, count(empno) cnt, 
        round(avg(sal)) av, max(sal) mx, min(sal) mn  from emp) loop
        dbms_output.put_line(k.total||lpad(k.cnt,10,' ')|| lpad(k.av,10,' ')
        || lpad(k.mx,10,' ')|| lpad(k.mn,10,' '));
        end loop;
    end allSal;
end empInfo;
/

exec 패키지명.프로시저명(파라미터값)

exec empInfo.allEmp;


-- # Trigger
-- insert, update, delete 문이 실행될 때 묵시적으로 수해되는 일종의 프로시저
-- 부서명이 수정될 때 이전 부서명과 변경된 부서명을 기록으로 남기는 트리거를 작성해보자

CREATE OR REPLACE TRIGGER TRG_DEPT
BEFORE UPDATE ON DEPT
FOR EACH ROW
DECLARE
    MSG VARCHAR2(20);
BEGIN
    MSG:='HI TRIGGER';
    DBMS_OUTPUT.PUT_LINE(MSG);
    DBMS_OUTPUT.PUT_LINE('변경 전 컬럼 값 : ' || :OLD.DNAME );
    DBMS_OUTPUT.PUT_LINE('변경 후 컬럼 값 : ' || :NEW.DNAME );
END;
/

SELECT * FROM DEPT;
-- function 사번을 인 파라미터로 넘기면 해당 사원의 부서명을 반환하는 함수

create or replace function getDname
(pname in emp.ename%type)
return varchar2 -- 반환 타입 지정
is
vdno emp.deptno%type;
vdname dept.dname%type;
begin
    select deptno
    into vdno
    from emp where ename = upper(pname);
    
    select dname
    into vdname
    from dept where deptno = vdno;
    
    return vdname; -- 반환 값
    
    exception 
    when no_data_found then 
        dbms_output.put_line(pname|| ' 사원은 없습니다 ' );
        return SQLERRM;
    when too_many_rows then   
        dbms_output.put_line(pname|| ' 사원 데이터가 2권 이상 있습니다. ' );
        return SQLERRM;
    when others then
        return sqlerrm;
end;
/

-- 함수의 반환값을 저장하기 위한 바인드 변수 선언
var gname varchar2;
exec :gname := getDname('1');
print gname;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
set serveroutput on;
select * from emp;

-------------------------------------------------------------------------------- 패키지

--[1] 패키지 선언부
create or replace package empInfo as
procedure allEmp;
procedure allSal;
end empInfo;
/


-- [2] 패키지 변수 선언
create or REPLACE package body empInfo as
    -- allEmp : 모든 사원의 사번, 이름, 입사일 가져와 출력하는 프로시저
    procedure allEmp
    is
        cursor empCr is
        select empno, ename, hiredate from emp order by 3;
    begin
        for k in empCr loop
            dbms_output.put_line(k.empno || lpad(k.ename, 16, ' ') || 
            lpad(k.hiredate, 16, ' '));
        end loop;
    
    exception
        when others then 
            dbms_output.put_line(SQLERRM|| '에러 발생');
    end allEmp;
    
    -- allSal : 전체 사원의 급여 합계, 사원수 평균 급여, 최대 급여, 최소 급여
    procedure allSal
    is 
    begin
        dbms_output.put_line('급여 총합'||lpad('사원수',10,' ')|| 
        lpad('평균 급여',10,' ')|| lpad('최대 급여',10,' ')||
        lpad('최소급여',10,' '));
        dbms_output.put_line('-----------------------------------------------');
        for k in (select sum(sal) total, count(empno) cnt, 
        round(avg(sal)) av, max(sal) mx, min(sal) mn  from emp) loop
        dbms_output.put_line(k.total||lpad(k.cnt,10,' ')|| lpad(k.av,10,' ')
        || lpad(k.mx,10,' ')|| lpad(k.mn,10,' '));
        end loop;
    end allSal;
end empInfo;
/

exec 패키지명.프로시저명(파라미터값)

exec empInfo.allEmp;


-- # Trigger
-- insert, update, delete 문이 실행될 때 묵시적으로 수해되는 일종의 프로시저
-- 부서명이 수정될 때 이전 부서명과 변경된 부서명을 기록으로 남기는 트리거를 작성해보자

CREATE OR REPLACE TRIGGER TRG_DEPT
BEFORE UPDATE ON DEPT
FOR EACH ROW
DECLARE
    MSG VARCHAR2(20);
BEGIN
    MSG:='HI TRIGGER';
    DBMS_OUTPUT.PUT_LINE(MSG);
    DBMS_OUTPUT.PUT_LINE('변경 전 컬럼 값 : ' || :OLD.DNAME );
    DBMS_OUTPUT.PUT_LINE('변경 후 컬럼 값 : ' || :NEW.DNAME );
END;
/

SELECT * FROM DEPT;
UPDATE DEPT SET DNAME ='운영부서' WHERE DEPTNO =40;
UPDATE DEPT SET LOC ='서울' WHERE DEPTNO =40;
ROLLBACK;
                  

UPDATE DEPT SET LOC ='서울' WHERE DEPTNO =40;
ROLLBACK;

-- 트리거 비활성화
ALTER TRIGGER 트리거명 DISALBLE;

-- 트리거 활성화
ALTER TRIGGER 트리거명 INABLE;

--TRG_DEPT를 비활성화하고 UPDATE문을 수행해보세요
ALTER TRIGGER TRG_DEPT ENABLE;

UPDATE DEPT SET DNAME ='운영부서' WHERE DEPTNO =40;
ROLLBACK;

ALTER TRIGGER TRG_DEPT ENABLE;

-- 데이터 사전에서 조회 USER_TRIGGERS
SELECT * FROM USER_TRIGGERS WHERE TRIGGER_NAME='TRG_DEPT';

-- 트리거 삭제
DROP TRIGGER TRG_DEPT;

DROP TRIGGER TRG_DEPT;

--EMP 테이블에 데이터가 INSERT되거나 UPDATE될 경우 (BEFORE)
--전체 사원들의 평균급여를 출력하는 트리거를 작성하세요.
--테스트할때는 전체 사원의 급여를 10% 인상시키세요
-- 신입사원정보 등록하세요(사번,사원명,부서번호,급여)


CREATE OR REPLACE TRIGGER TRG_EMP_AVG
BEFORE INSERT OR UPDATE ON EMP
--FOR EACH ROW
DECLARE
AVG_SAL NUMBER(10);
BEGIN
    SELECT AVG(SAL) INTO AVG_SAL FROM EMP;
    DBMS_OUTPUT.PUT_LINE('평균 급여 : ' || AVG_SAL);
    END;
/
ROLLBACK;
SELECT * FROM USER_TRIGGERS;
INSERT INTO EMP(EMPNO,ENAME, DEPTNO,SAL) VALUES(9002,'TOM',20,4000);

UPDATE EMP SET SAL =SAL*1.1;



------------------------------------------
--[트리거 실습 1] 행 트리거
--입고 테이블에 상품이 입고될 경우
--상품 테이블에 상품 보유수량이 자동으로 변경되는 
--트리거를 작성해봅시다.
-- 상품 테이블 : MYPRODUCT
-- 입고 테이블 : MYINPUT


create table myproduct(
    pcode char(6) primary key,
    pname varchar2(20) not null,
    pcompany varchar2(20),
    price number(8),
    pqty number default 0
);
desc myproduct;

create sequence myproduct_seq
start with 1
increment by 1
nocache;

insert into myproduct values('A00'||myproduct_seq.nextval,'노트북', 'A사','800000',10);
insert into myproduct values('A00'||myproduct_seq.nextval,'TV', 'B사','1000000',20);
insert into myproduct values('A00'||myproduct_seq.nextval,'킥보드', 'C사','700000',30);
select * from myproduct;
commit;


create table myinput(
    incode number primary key, -- 입고번호
    pcode_fk char(6) references myproduct(pcode), -- 입고 상품 코드
    indate date default sysdate,
    inqty number(6), -- 입고 수량
    inprice number(8) -- 입고 가격
);
desc myinput;

create sequence myinput_seq nocache;


-- 입고 테이블에 상품이 입고되면 상품 테이블의 보유 수량(pqty)을 변경하는 트리거를 작성


CREATE OR REPLACE TRIGGER TRG_INPUT_PRODUCT
AFTER INSERT ON MYINPUT
FOR EACH ROW
DECLARE
BEGIN
    UPDATE MYPRODUCT SET PQTY=PQTY+:NEW.INQTY 
    WHERE PCODE = :NEW.PCODE_FK;
    DBMS_OUTPUT.PUT_LINE(:NEW.PCODE_FK||'번 상품이 추가로 '||:NEW.INQTY||'개 들어옴');
END;
/


INSERT INTO MYINPUT(INCODE,PCODE_FK,INQTY,INPRICE)
VALUES(MYINPUT_SEQ.NEXTVAL,'A001',20,500000);

INSERT INTO MYINPUT VALUES(MYINPUT_SEQ.NEXTVAL,'A002',SYSDATE,8,700000);
COMMIT;

SELECT * FROM MYINPUT;
SELECT * FROM MYPRODUCT;



--[실습1] 입고 테이블의 수량이 변경될 경우-UPDATE문이 실행될 때
--상품 테이블의 수량을 수정하는 트리거를 작성하세요
-- :OLD.INQTY 차감하고, :NEW.INQTY 더하는

create or replace trigger trg_myinput_update
after update on myinput
for each row
declare
begin
    update myproduct set pqty = pqty+:new.inqty - :old.inqty
    where pcode = :new.pcode_fk;
    DBMS_OUTPUT.PUT_LINE('수정되었습니다');
end;
/

update myinput set inqty =7 where incode =2;
select * from my

--[실습2] 입고 테이블에 데이터가 삭제될 경우-DELETE문이 실행될 때
--상품 테이블의 수량을 수정하는 트리거를 작성하세요
-- :OLD.INQTY를 차감함

create or replace trigger trg_myinput_delete
after delete on myinput
for each row
declare
begin
    update myproduct set pqty = pqty - :old.inqty
    where pcode = :new.pcode_fk;
    DBMS_OUTPUT.PUT_LINE('수정되었습니다');
end;
/

select * from myinput;
DELETE FROM MYINPUT WHERE PCODE_FK = 'A001';
select * from myproduct;





