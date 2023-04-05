[1] 변수 유형
1) SCALAR 유형 : NUMBER , CHAR, VARCHAR2, BOOLEAN, DATE, LONG, BINARY_INTEGER
2) REFERENCE 유형 
    : %TYPE   EX) 테이블명.컬럼명%TYPE
    : %ROWTYPE  EX) 테이블명%ROWTYPE
3) COMPOSITE 유형 : 복합 자료형
4) LOB 유형


* 주의 => DBMS_OUTPUT.PUT_LINE()을 사용하기 위해서 SERVEROUTPUT 설정
SET SERVEROUTPUT ON 

--------------------------------------------------------------------------------
Q. 사번을 인 파라미터로 넘기면 해당 사원의 정보를 가져와 출력하는 프로시저

CREATE OR REPLACE PROCEDURE EMP_INFO(PNO IN EMP.EMPNO%TYPE)
IS
--    VENAME VARCHAR2(30):='아무개';
    VENAME EMP.ENAME%TYPE;
    VJOB EMP.JOB%TYPE;
    VSAL EMP.SAL%TYPE;
BEGIN
    SELECT ENAME,JOB,SAL 
    INTO VENAME, VJOB, VSAL
    FROM EMP
    WHERE EMPNO = PNO;
    DBMS_OUTPUT.PUT_LINE('사번 : ' || PNO );
    DBMS_OUTPUT.PUT_LINE('이름 : ' || VENAME );
    DBMS_OUTPUT.PUT_LINE('업무 : ' || VJOB );
    DBMS_OUTPUT.PUT_LINE('급여 : ' || VSAL ) ;
END;
/

EXEC EMP_INFO(7369);

SELECT * FROM EMP;


--------------------------------------------------------------------------------
Q. 사번을 IN PAREMETER로 넘기면 사원의 이름과 부서번호, 부서명 입사일을 
   가져오는 프로시저를 작성해보자

CREATE OR REPLACE PROCEDURE EMP_ROWTYPE(PNO IN EMP.EMPNO%TYPE)
IS
    VEMP EMP%ROWTYPE;
    VDNAME DEPT.DNAME%TYPE;
BEGIN
    SELECT ENAME, HIREDATE, DEPTNO
    INTO VEMP.ENAME, VEMP.HIREDATE, VEMP.DEPTNO 
    FROM EMP
    WHERE EMPNO=PNO;
    
    SELECT DNAME
    
    INTO VDNAME
    FROM DEPT
    WHERE DEPTNO = VEMP.DEPTNO;
    
   
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('부서번호     부서명     사원명     입사일');
    DBMS_OUTPUT.PUT_LINE(VEMP.DEPTNO||' '|| VDNAME||' ' || VEMP.ENAME|| ' ' 
                || VEMP.HIREDATE);
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE(PNO || '번 사원은 존재하지 않습니다');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('기타 에러가 발생했어요');
END;
/

SELECT EMPNO FROM EMP;

EXECUTE EMP_ROWTYPE(7521);
EXECUTE EMP_ROWTYPE(8499);
--------------------------------------------------------------------------------
프로시저 소스 확인
SELECT TEXT FROM USER_SOURCE WHERE NAME LIKE 'EMP_ROWTYPE';






--------------------------------------------------------------------------------
3) COMPOSITE TYPE (복합 데이터 타입)

1. TABLE 타입 : 배열과 유사
/*
	TYPE table_type_name IS TABLE OF
	{column_type | variable%TYPE| table.column%TYPE} [NOT NULL]
	[INDEX BY BINARY_INTEGER];
	identifier table_type_name;

	table_type_name : 테이블형의 이름
	column_type	     : 스칼라 데이터형
	identifier	     : 전체 pl/sql 테이블을 나타내는 식별자의 이름
*/

Q. 테이블 타입 예제;
: 부서번호를 IN PARAMETER로 넘기며 
  해당 부서에 소속된 사원의 이름과 담당 업무를 가져와 출력하는 프로시저

CREATE OR REPLACE PROCEDURE TABLE_TYPE (PDNO IN DEPT.DEPTNO%TYPE)
IS
    -- 테이블 선언 : ENAME들을 저장할 TABLE 유형 선언
    TYPE ENAME_TABLE IS TABLE OF EMP.ENAME%TYPE INDEX BY BINARY_INTEGER;
   -- JOB들을 저장할 TABLE 유형 선언
    TYPE JOB_TABLE IS TABLE OF EMP.JOB%TYPE
    INDEX BY BINARY_INTEGER;
    
     -- 테이블 타입의 변수 선언
    ENAME_ARR ENAME_TABLE; 
    JOB_ARR JOB_TABLE;
    
    -- 인덱스로 사용할 변수 선언
    I BINARY_INTEGER :=0; 
    
BEGIN
    -- 반복문 돌면서 EMP에서 데이터를 가져와 ENAME_ARR에 저장한다.
    FOR K IN (SELECT ENAME,JOB FROM EMP WHERE DEPTNO = PDNO) LOOP
    I := I+1;
    ENAME_ARR(I) := K.ENAME;
    JOB_ARR(I) := K.JOB;
    END LOOP;
    
    -- 테이블 타입 변수에 저장된 값 출력하기
    DBMS_OUTPUT.PUT_LINE(PDNO|| '번 부서');
    FOR J IN 1 .. I LOOP -- 1부터 I 값까지 1씩 증가
        DBMS_OUTPUT.PUT_LINE(RPAD(ENAME_ARR(J),16,' ')|| JOB_ARR(J));
    END LOOP;
END;
/



------------------------------------------------------------------------------------------------------------- RECORD TYPE
[2] RECORD 타입 : 자바의 클래스와 유사
/*
    TYPE record_type_name is RECORD
    (field_name1 {scalar_datatype|record_type} [NOT NULL] [{:= | DEFAULT} expr],
    (field_name2 {scalar_datatype|record_type} [NOT NULL] [{:= | DEFAULT} expr],
    ...);
    identifier  record_type_name;
*/

Q. 사원명을 IN PARAMETER로 전달하면 해당 사원 정보를 출력하는 프로시저
(사원, 업무, 급여)
CREATE OR REPLACE PROCEDURE RECORD_TYPE (PNAME IN EMP.ENAME%TYPE)
IS
   /* 레코드 생성 */
    TYPE EMP_RECORD IS RECORD(
        VNO EMP.EMPNO%TYPE,
        VNAME EMP.ENAME%TYPE,
        VJOB EMP.JOB%TYPE,
        VMGR EMP.MGR%TYPE,
        VDATE EMP.HIREDATE%TYPE,
        VSAL EMP.SAL%TYPE,
        VCOMM EMP.COMM%TYPE,
        VDNO EMP.DEPTNO%TYPE
 );
    /* 레코드 타입의 변수 선언 */
    EMP_REC EMP_RECORD;
BEGIN
    SELECT * INTO EMP_REC FROM EMP WHERE ENAME = UPPER(PNAME);

    /* 출력하기 */
    DBMS_OUTPUT.PUT_LINE('---'||PNAME||'님 정보---');
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP_REC.VNO);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP_REC.VNAME);
    DBMS_OUTPUT.PUT_LINE('업무 : ' || EMP_REC.VJOB);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || EMP_REC.VSAL);
    
   /* 예외처리 */
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(PNAME|| '님은 사원이 아닙니다!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 오류입니다!');
END;
/

EXECUTE RECORD_TYPE('SMITH');
SELECT * FROM EMP;


------------------------------------------------------------------------------------------------------------- BIND 변수
[3]. BIND 변수
: 호스트 환경에서 선언된 변수
: 하나 이상의 PL/SQL프로그램 내부나 외부에 전달하기 위해 사용한다.
VARIABLE 변수명 자료형;


VARIABLE MYVAR NUMBER
DECLARE
BEGIN
    /*바인드 변수를 참조할때는 앞에 클론을 접두어로 붙인다*/
    :MYVAR :=100;
END;
/
PRINT MYVAR;



------------------------------------------------------------------------------------------------------------- PROCEDURE PARAMETER 종류
[4]. PROCEDURE PARAMETER 종류

1) IN PARAMETER : DEFAULT
: 호출자에 의해 프로시저에 전달되는 파라미터. 
: 파라미터의 디폴트 값으로 파라미터 앞에 아무것도 표시하지 않으면 IN 파라미터다.
: 프로시저에서 IN 파라미터의 값을 변경할 수 없다


Q. IN PARAMETHER 예제
CREATE OR REPLACE PROCEDURE  DEPT_ADD (
    VNO IN NUMBER DEFAULT 99, 
    VNAME IN DEPT.DNAME%TYPE,
    VLOC IN DEPT.LOC%TYPE)
IS
BEGIN
    INSERT INTO DEPT(DEPTNO, DNAME, LOC)
    VALUES ( VNO, VNAME, VLOC);
END;
/

EXEC DEPT_ADD(51,'EDUCATION','SEOUL');
SELECT * FROM DEPT;
EXEC DEPT_ADD(VNAME=>'PLANNING',VLOC=>'SUWON'); -- PARAMETER를 지정해서 추가 가능
ROLLBACK;



2) OUT PARAMETER
: 프로시저가 사용자에게 넘겨주는 값
: 프로시저에서 값을 변경할 수 있다.
: 디폴트 값을 지정할 수 없다

Q. OUTP PARAMETER 예제 
: 사번을 인 파라미터로 넘기면 해당 사원의 이름을 아웃 파라미터로 내보내는 프로시저
CREATE OR REPLACE PROCEDURE ENAME_FIND(
    PNO IN EMP.EMPNO%TYPE,
    ONAME OUT EMP.ENAME%TYPE)
IS
BEGIN
    SELECT ENAME 
    INTO ONAME
    FROM EMP 
    WHERE EMPNO = PNO;
END;
/

=> OUT PARAMETER를 받아줄 바인드 변수가 필요
VAR FNAME VARCHAR2(30);

EXECUTE ENAME_FIND(7499,:FNAME);

PRINT FNAME;



3) IN OUT PARAMETER 
: 프로시저가 읽고 쓰는 작업을 동시에 할 수 있는 파라미터

Q. IN OUT PARAMETER를 이용하는 예제

CREATE OR REPLACE PROCEDURE INOUT_TEST(
    A1 IN NUMBER,
    A2 IN VARCHAR2,
    A3 IN OUT VARCHAR2,
    A4 OUT VARCHAR2
    )
IS
    MSG VARCHAR2(30) :='';
BEGIN
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    DBMS_OUTPUT.PUT_LINE('프로시저 시작 전');
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    DBMS_OUTPUT.PUT_LINE('A1: '|| TO.CHAR(A1),'999,999'); -- IN
    DBMS_OUTPUT.PUT_LINE('A2: '|| A2); -- IN
    DBMS_OUTPUT.PUT_LINE('A3: '|| A3); -- IN OUT
    DBMS_OUTPUT.PUT_LINE('A4: '|| A4); -- OUT
    
    A3 :='프로시저 바깥에서 이 값을 받을 수 있을까?';
    MSG :='당연하지!!';
    A4 := A3;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    DBMS_OUTPUT.PUT_LINE('프로시저 시작  후');
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    DBMS_OUTPUT.PUT_LINE('A1: '|| TO.CHAR(A1),'999,999'); -- IN
    DBMS_OUTPUT.PUT_LINE('A2: '|| A2); -- IN
    DBMS_OUTPUT.PUT_LINE('A3: '|| A3); -- IN OUT
    DBMS_OUTPUT.PUT_LINE('A4: '|| A4); -- OUT

END;
/

VAR C VARCHAR2(100);
EXEC :C:='IN TEST'; -- 초기값 설정
VAR D VARCHAR2(100);

EXEC INOUT_TEST(50000,'Hi',:C,:D);






------------------------------------------------------------------------------------------------------------- SELECT 문 (LOOP문 실습)
Q. SELECT문을 수행하는 프로시저
: 인 파라미터로 JOB을 넘기면 해당 업무를 수행하는 사원 정보를 가져오는 프로시저 생성
프로시저 명: EMP_JOB_INFO
사원 정보를 받을 변수 : %TYPE;



CREATE OR REPLACE PROCEDURE EMP_JOB_INFO(
    IN_JOB IN EMP.JOB%TYPE
)
IS
    VEMP EMP%ROWTYPE;
    
    -- 커서 선언
    CURSOR EMP_CR 
    IS 
    SELECT * FROM EMP 
    WHERE JOB = UPPER(IN_JOB);
    
BEGIN
    -- 커서를 열고 반복문을 돌면서 데이터 인출(FETCH)
    OPEN EMP_CR;
    DBMS_OUTPUT.PUT_LINE('----' || UPPER(IN_JOB) || '-----');
    LOOP 
        FETCH EMP_CR INTO VEMP;
        EXIT WHEN EMP_CR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(RPAD(VEMP.ENAME,14,' ')|| VEMP.SAL );
    END LOOP;
  -- 커서 닫기 (CLOSE)
    CLOSE EMP_CR;
END;
/

EXEC EMP_JOB_INFO('MANAGER');

ORA-01422: exact fetch returns more than requested number of rows
결과값이 다중행을 반환할 때는 커서를 이용해야 한다.



Q. 부서번호를 IN 파라미터로 전달하면 해당 부서의 사원정보를
   OUT 파라미터로 내보내는 프로시저를 작성해서 JAVA와 연동해봅시다
=> 이름, 업무, 부서명, 근무자, 입사일


CREATE OR REPLACE PROCEDURE EMP_FORJAVA (
    PDNO IN EMP.DEPTNO%TYPE,
    MYCR OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN MYCR FOR
    select ename,job,dname,loc,hiredate from
    (SELECT * FROM EMP WHERE DEPTNO = PDNO) A JOIN DEPT D
     ON A.DEPTNO = D.DEPTNO;
END;
/


Q. memo 검색어 프로시저

DESC MEMO;

CREATE OR REPLACE PROCEDURE MEMO_SE(
    CMSG IN MEMO.MSG%TYPE,
    MOCR OUT SYS_REFCURSOR)
IS 
BEGIN
    OPEN MOCR FOR
    SELECT no,name,msg,wdate 
    FROM MEMO 
    WHERE MSG LIKE '%'||CMSG||'%';
END;
/

select * from memo;


create or replace procedure memo_find
(jmsg in MEMO.msg%type,
mycr out sys_refcursor
    )
is
begin
    open mycr for
    select no,name,MSG,wdate
    from memo where MSG like '%'||jmsg||'%';
end;
/
commit;





