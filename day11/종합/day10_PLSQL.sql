PL/SQL ����
[1] Anonymous Block (�͸� ��)
[2] Subprogram (Procedure, Function)
-------------------------------------
[1] Anonymous Block (�͸� ��)
�����
�����
����ó����
-------------------------------------
DECLARE
    -- �����
    -- ���� ����
    MSG VARCHAR2(100);
BEGIN
    -- �����
    MSG := 'Hello Oracle ~';
    DBMS_OUTPUT.PUT_LINE(MSG);
    --EXCEPTION
END;
/

SET SERVEROUTPUT ON
-----------------------------------------------
--���� �ð����� 1�ð� ���� 3�ð��ĸ� ����ϴ� ���ν����� �ۼ��غ���
DECLARE
    VTIME1 TIMESTAMP;
    VTIME3 TIMESTAMP;
BEGIN
    SELECT SYSTIMESTAMP - 1/24,
           SYSTIMESTAMP + 3/24 
           INTO VTIME1, VTIME3
           FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('�� �ð� ��: '||VTIME1);           
    DBMS_OUTPUT.PUT_LINE('�� �ð� ��: '||VTIME3);           
END;
/
------------------------------------------
CREATE OR REPLACE PROCEDURE EVEN_ODD(NUM IN NUMBER)
IS
--�����
MSG VARCHAR2(30);
BEGIN
-- �����
    IF MOD(NUM,2) =0 THEN
        MSG:='¦��';
    ELSE
        MSG:='Ȧ��';
    END IF;    
    DBMS_OUTPUT.PUT_LINE(NUM||'�� '||MSG||'�Դϴ�');
END;
/
------------------------------------------------
EXECUTE EVEN_ODD(45);
EXECUTE EVEN_ODD(88);
---------------------------------------
--�� �Ķ���� 2���� �޾Ƽ� MEMBER���̺�
--�����͸� INSERT�ϴ� ���ν����� �ۼ��ϼ���
--���ν�����: MEMO_ADD

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
EXECUTE MEMO_ADD('�輺��','���ν����� �ۼ��߽��ϴ�');
EXECUTE MEMO_ADD('�ֳ���','���� �ۼ��߾��');
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

execute memo_edit(4,'�����','�۰� �̸��� �����߾��');
commit;




























