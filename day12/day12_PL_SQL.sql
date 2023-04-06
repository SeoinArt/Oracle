# PL/SQL의 제어문
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

--------------------------------------------------------------------------------
여러 건의 데이터를 SELECT 하는 문장에 암시적 커서를 사용하면
TOO_MANY_ROWS 에러를 발생시킨다.
=> 이 경우는 명시적 커서를 사용해야 한다.

CREATE OR REPLACE PROCEDURE DEPT_ALL
IS 
    VNO NUMBER;
    VNAME VARCHAR2(30);
    VLOC VARCHAR2(30);
BEGIN
    SELECT DEPTNO, DNAME, LOC
    INTO VNO, VNAME, VLOC
    FROM DEPT;
END;
/
EXECUTE DEPT_ALL;


--------------------------------------------------------------------------------
명시적 커서를 이용해서 문제를 해결해봅시다
선언문에서 
CURSOR 커서명 IS SELECT ANS;

실행문에서 OPEN 커서명;
반복문을 이용해서 FETCH를 해야함
CLOSE 커서명;


CREATE OR REPLACE PROCEDURE DEPT_ALL
IS 
    VNO NUMBER;
    VNAME VARCHAR2(30);
    VLOC VARCHAR2(30);
    -- 커서 이름
    CURSOR DCR IS SELECT DEPTNO, DNAME, LOC FROM DEPT;
BEGIN
-- 커서 OPEN
OPEN DCR;
   LOOP
        FETCH DCR INTO VNO,VNAME, VLOC;
        EXIT WHEN DCR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(VNO ||'  ' ||RPAD(VNAME,12,' ') || VLOC );
    END LOOP;
CLOSE DCR;
END;
/

EXECUTE DEPT_ALL();

DESC DEPT;
DESC EMP;
--------------------------------------------------------------------------------
부서별 해당 부서의 부서명과 사원수와 평균 급여를 가져오는 프로시저 생성

CREATE OR REPLACE PROCEDURE DEPT_AVG_SAL
IS
VDNO DEPT.DEPTNO%TYPE;
VNAME DEPT.DNAME%TYPE;
VCNT NUMBER;
VAVG_SAL NUMBER;

CURSOR DCR IS
    SELECT DNAME, COUNT(*), ROUND(AVG(SAL),2)
    FROM EMP E JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
    GROUP BY DNAME;        
BEGIN
    OPEN DCR;
    LOOP
        FETCH DCR INTO VNAME, VCNT, VAVG_SAL;
        EXIT WHEN DCR%NOTFOUND;
        SELECT DEPTNO INTO VDNO
        FROM DEPT WHERE DNAME=VNAME;
        
        DBMS_OUTPUT.PUT_LINE('부서명:  ' || VNAME || '  사원수 : '||VCNT || ' 부서번호: ' || VDNO || ' 평균 급여: '|| VAVG_SAL);
    END LOOP;
    CLOSE DCR;
END;
/
EXECUTE DEPT_AVG_SAL;

--------------------------------------------------------------------------------
- for 루프에서 커서 사용
- for 루프에서 서브 쿼리 사용

create or replace procedure forcut
()
is
-- 커서 선언
cursor pcr is 
select  products_name, output_price
from products 
order by 1;
--vname products.products_name%type; 
--vprice number;
begin
-- for 루프에서 커서 사용(open, fetch, close를 알아서 함)
    for p in pcr loop -- p qustn recode 타입
        dbms_output.put_line(rpad(p.products_name,14,' ')||to_char(p.output_price,'l999,999,999'));
    end loop;
end;
/

exec forcur();


--------------------------------------------------------------------------------
for in 루프문에 subquery 사용
- cursor를 선언할 필요가 없음
- for 변수 in(subquery)loop 
    실행문
  end loop;
  
  
--------------------------------------------------------------------------------
미리 정의된 예외처리

CREATE OR REPLACE PROCEDURE EXCEPT_TEST
(VDNO IN NUMBER, VENO IN NUMBER, VNAME IN VARCHAR2)
IS
    VEMP EMP%ROWTYPE;
BEGIN
    INSERT INTO EMP(EMPNO,ENAME,DEPTNO)
    VALUES(VENO, VNAME, VDNO);
    
   /* SELECT EMPNO,ENAME,DEPTNO
    INTO VEMP.EMPNO, VEMP.ENAME, VEMP.DEPTNO
    FROM EMP
    WHERE DEPTNO = VDNO;        */
    FOR K IN (SELECT EMPNO,ENAME,DEPTNO FROM EMP WHERE DEPTNO=VDNO) LOOP    
        DBMS_OUTPUT.PUT_LINE('--------------------------');
        DBMS_OUTPUT.PUT_LINE('사번: '||K.EMPNO);
        DBMS_OUTPUT.PUT_LINE('이름: '||K.ENAME);
        DBMS_OUTPUT.PUT_LINE('부서번호: '||K.DEPTNO);    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(10/0);
    EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('데이터가 2건 이상이에요. 커서를 이용하세요');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE(VENO||'번 사원은 이미 있습니다');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 에러 발생: ' || SQLERRM || ' ' || SQLCODE);
        
END;
/
DESC EMP;
EXEC EXCEPT_TEST(10,1000,'PETER');
EXEC EXCEPT_TEST(10,1001,'SUSAN');
DELETE EMP WHERE EMPNO =8100;
COMMIT;
SELECT * FROM EMP WHERE DEPTNO = 10;
SELECT * FROM EMP ORDER BY EMPNO;
ALTER TABLE EMP ADD CONSTRAINT EMP_EMPNO_UK UNIQUE(EMPNO);