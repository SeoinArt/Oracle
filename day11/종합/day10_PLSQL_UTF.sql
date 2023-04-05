PL/SQL 유형
[1] Anonymous Block (익명 블럭)
[2] Subprogram (Procedure, Function)
-------------------------------------
[1] Anonymous Block (익명 블럭)
선언부
실행부
예외처리부
-------------------------------------
DECLARE
    -- 선언부
    -- 변수 선언
    MSG VARCHAR2(100);
BEGIN
    -- 실행부
    MSG := 'Hello Oracle ~';
    DBMS_OUTPUT.PUT_LINE(MSG);
    --EXCEPTION
END;
/

SET SERVEROUTPUT ON
-----------------------------------------------
--현재 시간에서 1시간 전과 3시간후를 출력하는 프로시저를 작성해보자
DECLARE
    VTIME1 TIMESTAMP;
    VTIME3 TIMESTAMP;
BEGIN
    SELECT SYSTIMESTAMP - 1/24,
           SYSTIMESTAMP + 3/24 
           INTO VTIME1, VTIME3
           FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('한 시간 전: '||VTIME1);           
    DBMS_OUTPUT.PUT_LINE('세 시간 후: '||VTIME3);           
END;
/
------------------------------------------
CREATE OR REPLACE PROCEDURE EVEN_ODD(NUM IN NUMBER)
IS
--선언부
MSG VARCHAR2(30);
BEGIN
-- 실행부
    IF MOD(NUM,2) =0 THEN
        MSG:='짝수';
    ELSE
        MSG:='홀수';
    END IF;    
    DBMS_OUTPUT.PUT_LINE(NUM||'은 '||MSG||'입니다');
END;
/
------------------------------------------------
EXECUTE EVEN_ODD(45);
EXECUTE EVEN_ODD(88);
---------------------------------------
--인 파라미터 2개를 받아서 MEMBER테이블에
--데이터를 INSERT하는 프로시저를 작성하세요
--프로시저명: MEMO_ADD

CREATE OR REPLACE PROCEDURE MEMO_ADD
(PNAME IN VARCHAR2, PMSG IN VARCHAR2)
IS
BEGIN
    INSERT INTO MEMO(NO,NAME,MSG)
    VALUES(MEMO_SEQ.NEXTVAL, PNAME, PMSG);
    COMMIT;
END;
/
-------------------------------------------------
EXECUTE MEMO_ADD('김성주','프로시저로 작성했습니다');
EXECUTE MEMO_ADD('최남주','저도 작성했어요');
SELECT * FROM MEMO;




select empno,ename,dname,job,hiredate,loc
from dept d join emp e
on d.deptno=e.deptno
where ename like '%S%';
----------------------------------------
create or replace procedure memo_edit
(pno in number, pname in varchar2, pmsg in varchar2)
is
begin
    update memo set name=pname, msg=pmsg
    where no=pno;
    commit;
end;
/
---------------------------------------
select * from memo;

execute memo_edit(4,'김수정','글과 이름을 수정했어요');
commit;




























