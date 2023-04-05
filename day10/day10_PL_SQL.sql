PL/SQL ����
[1] Anonymous Block (�͸��)
[2] Subprogram (Procedure, Function)

--------------------------------------------------------------------------------
[1] Anonymous Block (�͸� ��)
DECLARE(�����)
 ��������
BEGIN (����� ����)
     EXCEPTION (����ó�� ��)
END;(����� ��)
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

Q. ���� �ð����� 1�ð� ���� 3�ð� �ĸ� ����ϴ� ���ν����� �ۼ��غ���

DECLARE 
    VTIME1 TIMESTAMP;
    VTIME3 TIMESTAMP;
BEGIN 
    SELECT SYSTIMESTAMP - 1/24, SYSTIMESTAMP + 3/24 INTO VTIME1, VTIME3 
    FROM DUAL; 
    DBMS_OUTPUT.PUT_LINE('1�ð� ��: '|| VTIME1);
    DBMS_OUTPUT.PUT_LINE('3�ð� ��: '|| VTIME3);
END;
/



--------------------------------------------------------------------------------
[2] Subprogram (Procedure, Function);

--EX)
CREATE OR REPLACE PROCEDURE EVEN_ODD(NUM IN NUMBER)
IS
 -- �����
MSG VARCHAR2(30);
BEGIN
-- �����
    IF MOD(NUM,2) =0 THEN
        MSG :='¦��';
    ELSE
        MSG :='Ȧ��';
    END IF;
    DBMS_OUTPUT.PUT_LINE(NUM||'�� '||MSG||'�Դϴ�');
END;
/

EXECUTE EVEN_ODD(45);
EXECUTE EVEN_ODD (88);

DESC MEMO;


Q. �� �Ķ���� 2���� �޾Ƽ� MEMBER ���̺� �����͸� INSERT�ϴ� ���ν����� �ۼ��ϼ��� 
  (MEMO_ADD)

CREATE OR REPLACE PROCEDURE MEMO_ADD(PNAME IN VARCHAR2, PMSG IN VARCHAR2)
IS
BEGIN 
    INSERT INTO MEMO(NO,NAME,MSG) VALUES(MEMO_SEQ.NEXTVAL,PNAME,PMSG);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('���������� �����Ͽ����ϴ�');
END;
/

EXECUTE MEMO_ADD('�ڼ���','PROCEDURE�� ������ ���ڵ�'||100);
EXECUTE MEMO_ADD('�ֳ���','���� �ۼ��߾��');
SELECT * FROM MEMO;

select *from emp;
select * from dept;
desc emp;

select * from memo order by no;


--------------------------------------------------------------------------------
[�ǽ�] memo ���̺� ���� �� ���� ������ �����ϴ� ���ν����� �ۼ��غ��ô�.
�� �Ķ����( �۹�ȣ, ������ �ۼ��� ��, ������ ����)�� �Է¹޾� 
�ش� �۹�ȣ ���� �ۼ��ڸ�� �޸𳻿��� �����ϴ� ���ν����� �ۼ��ϼ���
���ν�����: memo_edit

DESC MEMO;
CREATE OR REPLACE PROCEDURE MEMO_EDIT ( CNO IN NUMBER, CNAME IN VARCHAR2, CMSG IN VARCHAR2)
IS
BEGIN 
    UPDATE MEMO SET NAME = CNAME, MSG = CMSG WHERE NO = CNO;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('�����Ǿ����ϴ�');
END;
/

EXECUTE MEMO_EDIT(1,'�ڼ���','������ �޸��');

SELECT * FROM MEMO ORDER BY NO;


--------------------------------------------------------------------------------
[�ǽ�] java class �� : MemoUpdate 
memo_edit ���ν����� ȣ���ϴ� jdbc�ڵ带 �����ϼ���