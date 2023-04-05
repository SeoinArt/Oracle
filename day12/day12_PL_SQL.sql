# PL/SQL의 제어문
----------------------------------------------------------------------------------- IF ANS
[1]  IF문

IF문 조건 THEN 실행문 
ELSEIF 조건 THEN 실행문
ELSE 실행문
END IF;

Q. 사번을 INPARAMETER로 넘기면 해당 사원의 부서번호, 사원명, 부서명을 출력하는 프로시저
CREATE OR REPLACE PROCEDURE DEPT_SEARCH(PNO IN NUMBER)
IS
VDNO EMP.DEPTNO%TYPE;
VNAME EMP.ENAME%TYPE;
VDNAME VARCHAR2(20);
BEGIN
    SELECT DEPTNO, ENAME
    INTO VDNO,VNAME
    FROM EMP 
    WHERE EMPNO = PNO;
    
    IF VDNO = 10 THEN VDNAME := '회계부서';
    ELSIF VDNO = 20 THEN VDNAME := '연구부서';
    ELSIF VDNO = 30 THEN VDNAME := '영업부서';
    ELSE 
        VDNAME :='운영부서';
    END IF;
    DBMS_OUTPUT.PUT_LINE(PNO || '번' || VNAME || '님은' || VDNO || '번 부서 [' ||VDNAME ||'] 에 있어요');
END;
/

Q. [실습];
-- IF~END IF 문으로 SCOTT의 연봉을 계산하세요. COMM이 널일 경우와 널이 아닐 경우를 나눠서 계산하여 출력하세요
-- IF~END IF 문으로 인파라키터로 사원명을 받아 해당 사원의 연봉을 계산하세요
create or replace procedure emp_sal
(pname in varchar2)
is
vsal emp.sal%type;
vcomm emp.comm%type;
vtotal number;
begin
    select sal,comm
    into vsal,vcomm
    from emp where ename=upper(pname);
    if vcomm is null then vtotal:=vsal*12;
    else vtotal:=vsal*12+vcomm;
    end if;
    dbms_output.put_line(pname||'님의 연봉은 '||to_char(vtotal,'$999,999')||'입니다');
    dbms_output.put_line('월 급여: '||vsal||', 보너스: '||vcomm);  
    exception
    when no_data_found then 
    dbms_output.put_line(pname||'님은 없습니다');
    when too_many_rows then
    dbms_output.put_line(pname||'님의 데이터가 2건 이상입니다');
end;
/
set serveroutput on;
exec emp_sal('king');
select * from emp;

------------------------------------------------------------------------------------ loop 문
[2] LOOP. 반복문
1) for문
for 변수 in [reverse] 시작값 .. 끝값 loop
end loop;

declare
begin
    for i in 10 .. 20 loop
        dbms_output.put_line('Hello' || i);
    end loop;
end;
/

declare
begin
    for i in reverse 10 .. 20 loop
        dbms_output.put_line('Hello' || i);
    end loop;
end;
/

declare
begin
    for k in (select * from member where job = '학생') loop
    -- k 는 record type의 변수
        dbms_output.put_line(k.name || ':' || k.job || '  ' || k.userid);
    end loop;
end;
/
desc member;




2) loop문
loop
    exit when 조건문;
    실행문;
end loop;

Q. emp 테이블의 사원정보를 등록하되 반복문 이용해서 사번을 9000번에서 10씩 증가시켜서 넣읍시다.
 사원명 :'james'
 입사일 
 9090번이 되면 반복문 이탈하기
 
 
 declare
    vno emp.empno%type :=9000;
    
 begin
    loop
        insert into emp(empno,ename,hiredate)
            values(vno,upper('JAMES'),sysdate);
        vno := vno+10;
        exit when vno >= 9090; -- exit 조건절이 없으면 무한루프 주의!!
    end loop;
    dbms_output.put_line('데이터 삽입 성공 : ' || (vno-9000)/10||'건의 데이터 입력');
 end;
 /
 rollback;
select * from emp order by 1 desc;

3) while loop문
while 조건문 loop
    실행문;
    변수 증감식;
end loop;

declare
cnt number(4) := 1000;
begin
    while cnt<1005 loop
        insert into emp(empno,ename, hiredate)
        values(cnt,upper('James')||cnt,sysdate);
        cnt := cnt+1;
    end loop;
    dbms_output.put_line(cnt-1000||'건의 데이터 입력 완료');
end;
/

rollback;


--------------------------------------------------------------------------------
# 암시적 커서 사용
모든 DML 문장과 select 문에는 암시적 커서가 존재한다.
개발자가 직접 OPEN, FETCH, CLOSE할 수는 없지만
암시적 커서의 속성을 이용해서 정보를 활용할 수 있다.

Q. 사번을 IN PARAMETER로 넘기면 해당 사원의 급여를 10프로 인상시키는 프로시저

CREATE OR REPLACE PROCEDURE IMPLICIT_CUSOR (PNO IN EMP.EMPNO%TYPE)
IS
    VSAL EMP.SAL%TYPE;
    VROW NUMBER;
BEGIN
    SELECT SAL 
    INTO VSAL
    FROM EMP WHERE EMPNO = PNO;
    -- 데이터가 발견된 경우라면 급여를 10% 인상시키자
    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('검색한 데이터가 있어요 : 급여 =>'|| VSAL);
    END IF;
    
    UPDATE EMP SET SAL = SAL*1.1 WHERE EMPNO = PNO;
    -- 수정한 데이터 수를 VROW에 저장
    VROW := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('급여가 인상된 사원 : '||VROW);
    
     SELECT SAL 
    INTO VSAL
    FROM EMP WHERE EMPNO = PNO;
    -- 데이터가 발견된 경우라면 급여를 10% 인상시키자
    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('10% 급여 인상 후 : 급여 =>'|| VSAL);
    END IF;
END;
/

EXECUTE IMPLICIT_CUSOR(7788);

ROLLBACK;











