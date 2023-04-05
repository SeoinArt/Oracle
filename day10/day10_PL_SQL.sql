PL/SQL 유형
[1] Anonymous Block (익명블럭)
[2] Subprogram (Procedure, Function)

--------------------------------------------------------------------------------
[1] Anonymous Block (익명 블럭)
DECLARE(선언부)
 변수선언
BEGIN (실행부 시작)
     EXCEPTION (예외처리 부)
END;(실행부 끝)
/

EX)
SET SERVEROUTPUT ON

DECLARE
    MSG VARCHAR2(100);
BEGIN
    MSG := 'Hello Oracle';
    DBMS_OUTPUT.PUT_LINE(MSG); 
END;
/

Q. 현재 시간에서 1시간 전과 3시간 후를 출력하는 프로시저를 작성해보자

DECLARE 
    VTIME1 TIMESTAMP;
    VTIME3 TIMESTAMP;
BEGIN 
    SELECT SYSTIMESTAMP - 1/24, SYSTIMESTAMP + 3/24 INTO VTIME1, VTIME3 
    FROM DUAL; 
    DBMS_OUTPUT.PUT_LINE('1시간 전: '|| VTIME1);
    DBMS_OUTPUT.PUT_LINE('3시간 후: '|| VTIME3);
END;
/



--------------------------------------------------------------------------------
[2] Subprogram (Procedure, Function);

--EX)
CREATE OR REPLACE PROCEDURE EVEN_ODD(NUM IN NUMBER)
IS
 -- 선언부
MSG VARCHAR2(30);
BEGIN
-- 실행부
    IF MOD(NUM,2) =0 THEN
        MSG :='짝수';
    ELSE
        MSG :='홀수';
    END IF;
    DBMS_OUTPUT.PUT_LINE(NUM||'은 '||MSG||'입니다');
END;
/

EXECUTE EVEN_ODD(45);
EXECUTE EVEN_ODD (88);

DESC MEMO;


Q. 인 파라미터 2개를 받아서 MEMBER 테이블에 데이터를 INSERT하는 프로시저를 작성하세요 
  (MEMO_ADD)

CREATE OR REPLACE PROCEDURE MEMO_ADD(PNAME IN VARCHAR2, PMSG IN VARCHAR2)
IS
BEGIN 
    INSERT INTO MEMO(NO,NAME,MSG) VALUES(MEMO_SEQ.NEXTVAL,PNAME,PMSG);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('정상적으로 삽입하였습니다');
END;
/

EXECUTE MEMO_ADD('박서인','PROCEDURE로 생성한 레코드'||100);
EXECUTE MEMO_ADD('최남주','저도 작성했어요');
SELECT * FROM MEMO;

select *from emp;
select * from dept;
desc emp;

select * from memo order by no;


--------------------------------------------------------------------------------
[실습] memo 테이블 관련 글 내용 수정을 수정하는 프로시저를 작성해봅시다.
인 파라미터( 글번호, 수정할 작성자 명, 수정할 내용)을 입력받아 
해당 글번호 글의 작성자명과 메모내용을 수정하는 프로시저를 작성하세요
프로시저명: memo_edit

DESC MEMO;
CREATE OR REPLACE PROCEDURE MEMO_EDIT ( CNO IN NUMBER, CNAME IN VARCHAR2, CMSG IN VARCHAR2)
IS
BEGIN 
    UPDATE MEMO SET NAME = CNAME, MSG = CMSG WHERE NO = CNO;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('수정되었습니다');
END;
/

EXECUTE MEMO_EDIT(1,'박서인','수정된 메모글');

SELECT * FROM MEMO ORDER BY NO;


--------------------------------------------------------------------------------
[실습] java class 명 : MemoUpdate 
memo_edit 프로시저를 호출하는 jdbc코드를 구현하세요