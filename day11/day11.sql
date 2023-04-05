[1] ���� ����
1) SCALAR ���� : NUMBER , CHAR, VARCHAR2, BOOLEAN, DATE, LONG, BINARY_INTEGER
2) REFERENCE ���� 
    : %TYPE   EX) ���̺��.�÷���%TYPE
    : %ROWTYPE  EX) ���̺��%ROWTYPE
3) COMPOSITE ���� : ���� �ڷ���
4) LOB ����


* ���� => DBMS_OUTPUT.PUT_LINE()�� ����ϱ� ���ؼ� SERVEROUTPUT ����
SET SERVEROUTPUT ON 

--------------------------------------------------------------------------------
Q. ����� �� �Ķ���ͷ� �ѱ�� �ش� ����� ������ ������ ����ϴ� ���ν���

CREATE OR REPLACE PROCEDURE EMP_INFO(PNO IN EMP.EMPNO%TYPE)
IS
--    VENAME VARCHAR2(30):='�ƹ���';
    VENAME EMP.ENAME%TYPE;
    VJOB EMP.JOB%TYPE;
    VSAL EMP.SAL%TYPE;
BEGIN
    SELECT ENAME,JOB,SAL 
    INTO VENAME, VJOB, VSAL
    FROM EMP
    WHERE EMPNO = PNO;
    DBMS_OUTPUT.PUT_LINE('��� : ' || PNO );
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || VENAME );
    DBMS_OUTPUT.PUT_LINE('���� : ' || VJOB );
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || VSAL ) ;
END;
/

EXEC EMP_INFO(7369);

SELECT * FROM EMP;


--------------------------------------------------------------------------------
Q. ����� IN PAREMETER�� �ѱ�� ����� �̸��� �μ���ȣ, �μ��� �Ի����� 
   �������� ���ν����� �ۼ��غ���

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
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ     �μ���     �����     �Ի���');
    DBMS_OUTPUT.PUT_LINE(VEMP.DEPTNO||' '|| VDNAME||' ' || VEMP.ENAME|| ' ' 
                || VEMP.HIREDATE);
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE(PNO || '�� ����� �������� �ʽ��ϴ�');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('��Ÿ ������ �߻��߾��');
END;
/

SELECT EMPNO FROM EMP;

EXECUTE EMP_ROWTYPE(7521);
EXECUTE EMP_ROWTYPE(8499);
--------------------------------------------------------------------------------
���ν��� �ҽ� Ȯ��
SELECT TEXT FROM USER_SOURCE WHERE NAME LIKE 'EMP_ROWTYPE';






--------------------------------------------------------------------------------
3) COMPOSITE TYPE (���� ������ Ÿ��)

1. TABLE Ÿ�� : �迭�� ����
/*
	TYPE table_type_name IS TABLE OF
	{column_type | variable%TYPE| table.column%TYPE} [NOT NULL]
	[INDEX BY BINARY_INTEGER];
	identifier table_type_name;

	table_type_name : ���̺����� �̸�
	column_type	     : ��Į�� ��������
	identifier	     : ��ü pl/sql ���̺��� ��Ÿ���� �ĺ����� �̸�
*/

Q. ���̺� Ÿ�� ����;
: �μ���ȣ�� IN PARAMETER�� �ѱ�� 
  �ش� �μ��� �Ҽӵ� ����� �̸��� ��� ������ ������ ����ϴ� ���ν���

CREATE OR REPLACE PROCEDURE TABLE_TYPE (PDNO IN DEPT.DEPTNO%TYPE)
IS
    -- ���̺� ���� : ENAME���� ������ TABLE ���� ����
    TYPE ENAME_TABLE IS TABLE OF EMP.ENAME%TYPE INDEX BY BINARY_INTEGER;
   -- JOB���� ������ TABLE ���� ����
    TYPE JOB_TABLE IS TABLE OF EMP.JOB%TYPE
    INDEX BY BINARY_INTEGER;
    
     -- ���̺� Ÿ���� ���� ����
    ENAME_ARR ENAME_TABLE; 
    JOB_ARR JOB_TABLE;
    
    -- �ε����� ����� ���� ����
    I BINARY_INTEGER :=0; 
    
BEGIN
    -- �ݺ��� ���鼭 EMP���� �����͸� ������ ENAME_ARR�� �����Ѵ�.
    FOR K IN (SELECT ENAME,JOB FROM EMP WHERE DEPTNO = PDNO) LOOP
    I := I+1;
    ENAME_ARR(I) := K.ENAME;
    JOB_ARR(I) := K.JOB;
    END LOOP;
    
    -- ���̺� Ÿ�� ������ ����� �� ����ϱ�
    DBMS_OUTPUT.PUT_LINE(PDNO|| '�� �μ�');
    FOR J IN 1 .. I LOOP -- 1���� I ������ 1�� ����
        DBMS_OUTPUT.PUT_LINE(RPAD(ENAME_ARR(J),16,' ')|| JOB_ARR(J));
    END LOOP;
END;
/



------------------------------------------------------------------------------------------------------------- RECORD TYPE
[2] RECORD Ÿ�� : �ڹ��� Ŭ������ ����
/*
    TYPE record_type_name is RECORD
    (field_name1 {scalar_datatype|record_type} [NOT NULL] [{:= | DEFAULT} expr],
    (field_name2 {scalar_datatype|record_type} [NOT NULL] [{:= | DEFAULT} expr],
    ...);
    identifier  record_type_name;
*/

Q. ������� IN PARAMETER�� �����ϸ� �ش� ��� ������ ����ϴ� ���ν���
(���, ����, �޿�)
CREATE OR REPLACE PROCEDURE RECORD_TYPE (PNAME IN EMP.ENAME%TYPE)
IS
   /* ���ڵ� ���� */
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
    /* ���ڵ� Ÿ���� ���� ���� */
    EMP_REC EMP_RECORD;
BEGIN
    SELECT * INTO EMP_REC FROM EMP WHERE ENAME = UPPER(PNAME);

    /* ����ϱ� */
    DBMS_OUTPUT.PUT_LINE('---'||PNAME||'�� ����---');
    DBMS_OUTPUT.PUT_LINE('��� : ' || EMP_REC.VNO);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || EMP_REC.VNAME);
    DBMS_OUTPUT.PUT_LINE('���� : ' || EMP_REC.VJOB);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || EMP_REC.VSAL);
    
   /* ����ó�� */
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(PNAME|| '���� ����� �ƴմϴ�!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��Ÿ �����Դϴ�!');
END;
/

EXECUTE RECORD_TYPE('SMITH');
SELECT * FROM EMP;


------------------------------------------------------------------------------------------------------------- BIND ����
[3]. BIND ����
: ȣ��Ʈ ȯ�濡�� ����� ����
: �ϳ� �̻��� PL/SQL���α׷� ���γ� �ܺο� �����ϱ� ���� ����Ѵ�.
VARIABLE ������ �ڷ���;


VARIABLE MYVAR NUMBER
DECLARE
BEGIN
    /*���ε� ������ �����Ҷ��� �տ� Ŭ���� ���ξ�� ���δ�*/
    :MYVAR :=100;
END;
/
PRINT MYVAR;



------------------------------------------------------------------------------------------------------------- PROCEDURE PARAMETER ����
[4]. PROCEDURE PARAMETER ����

1) IN PARAMETER : DEFAULT
: ȣ���ڿ� ���� ���ν����� ���޵Ǵ� �Ķ����. 
: �Ķ������ ����Ʈ ������ �Ķ���� �տ� �ƹ��͵� ǥ������ ������ IN �Ķ���ʹ�.
: ���ν������� IN �Ķ������ ���� ������ �� ����


Q. IN PARAMETHER ����
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
EXEC DEPT_ADD(VNAME=>'PLANNING',VLOC=>'SUWON'); -- PARAMETER�� �����ؼ� �߰� ����
ROLLBACK;



2) OUT PARAMETER
: ���ν����� ����ڿ��� �Ѱ��ִ� ��
: ���ν������� ���� ������ �� �ִ�.
: ����Ʈ ���� ������ �� ����

Q. OUTP PARAMETER ���� 
: ����� �� �Ķ���ͷ� �ѱ�� �ش� ����� �̸��� �ƿ� �Ķ���ͷ� �������� ���ν���
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

=> OUT PARAMETER�� �޾��� ���ε� ������ �ʿ�
VAR FNAME VARCHAR2(30);

EXECUTE ENAME_FIND(7499,:FNAME);

PRINT FNAME;



3) IN OUT PARAMETER 
: ���ν����� �а� ���� �۾��� ���ÿ� �� �� �ִ� �Ķ����

Q. IN OUT PARAMETER�� �̿��ϴ� ����

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
    DBMS_OUTPUT.PUT_LINE('���ν��� ���� ��');
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    DBMS_OUTPUT.PUT_LINE('A1: '|| TO.CHAR(A1),'999,999'); -- IN
    DBMS_OUTPUT.PUT_LINE('A2: '|| A2); -- IN
    DBMS_OUTPUT.PUT_LINE('A3: '|| A3); -- IN OUT
    DBMS_OUTPUT.PUT_LINE('A4: '|| A4); -- OUT
    
    A3 :='���ν��� �ٱ����� �� ���� ���� �� ������?';
    MSG :='�翬����!!';
    A4 := A3;
    
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    DBMS_OUTPUT.PUT_LINE('���ν��� ����  ��');
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    DBMS_OUTPUT.PUT_LINE('A1: '|| TO.CHAR(A1),'999,999'); -- IN
    DBMS_OUTPUT.PUT_LINE('A2: '|| A2); -- IN
    DBMS_OUTPUT.PUT_LINE('A3: '|| A3); -- IN OUT
    DBMS_OUTPUT.PUT_LINE('A4: '|| A4); -- OUT

END;
/

VAR C VARCHAR2(100);
EXEC :C:='IN TEST'; -- �ʱⰪ ����
VAR D VARCHAR2(100);

EXEC INOUT_TEST(50000,'Hi',:C,:D);






------------------------------------------------------------------------------------------------------------- SELECT �� (LOOP�� �ǽ�)
Q. SELECT���� �����ϴ� ���ν���
: �� �Ķ���ͷ� JOB�� �ѱ�� �ش� ������ �����ϴ� ��� ������ �������� ���ν��� ����
���ν��� ��: EMP_JOB_INFO
��� ������ ���� ���� : %TYPE;



CREATE OR REPLACE PROCEDURE EMP_JOB_INFO(
    IN_JOB IN EMP.JOB%TYPE
)
IS
    VEMP EMP%ROWTYPE;
    
    -- Ŀ�� ����
    CURSOR EMP_CR 
    IS 
    SELECT * FROM EMP 
    WHERE JOB = UPPER(IN_JOB);
    
BEGIN
    -- Ŀ���� ���� �ݺ����� ���鼭 ������ ����(FETCH)
    OPEN EMP_CR;
    DBMS_OUTPUT.PUT_LINE('----' || UPPER(IN_JOB) || '-----');
    LOOP 
        FETCH EMP_CR INTO VEMP;
        EXIT WHEN EMP_CR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(RPAD(VEMP.ENAME,14,' ')|| VEMP.SAL );
    END LOOP;
  -- Ŀ�� �ݱ� (CLOSE)
    CLOSE EMP_CR;
END;
/

EXEC EMP_JOB_INFO('MANAGER');

ORA-01422: exact fetch returns more than requested number of rows
������� �������� ��ȯ�� ���� Ŀ���� �̿��ؾ� �Ѵ�.



Q. �μ���ȣ�� IN �Ķ���ͷ� �����ϸ� �ش� �μ��� ���������
   OUT �Ķ���ͷ� �������� ���ν����� �ۼ��ؼ� JAVA�� �����غ��ô�
=> �̸�, ����, �μ���, �ٹ���, �Ի���


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


Q. memo �˻��� ���ν���

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





