��������
1. scalar ����: number, char,varchar2, boolean, date, long, binary_integer
2. reference ����
    - %type : ���̺��.�÷���%type
    - %rowtype : ���̺��%rowtype
3. composite ����
    - �����ڷ���
4. lob����
-----------------------------------------------------------
-- ����� �� �Ķ���ͷ� �ѱ�� �ش� ����� ������ ������ ����ϴ� ���ν���
create or replace procedure emp_info
(pno in emp.empno%type)
is
    --vename varchar2(30):='�ƹ���';
    vename emp.ename%type;
    vjob emp.job%type;
    vsal emp.sal%type;
begin
 -- select �÷�1,�÷�2
 -- into ����1,����2
 -- from ���̺��;
    SELECT ename,job,sal
    INTO vename,vjob,vsal
    FROM emp
    WHERE empno=pno;
    dbms_output.put_line('��  ��: '||pno);
    dbms_output.put_line('�����: '||vename);
    dbms_output.put_line('��  ��: '||vjob);
    dbms_output.put_line('��  ��: '||vsal);
end;
/
set serveroutput on
exec emp_info(7369);
exec emp_info(7788);
------------------------------------------
-- ����� in �Ķ���ͷ� �ѱ��
-- ����� �̸��� �Ի���, �μ���ȣ, �μ����� �������� ���ν����� �ۼ��غ���
create or replace procedure emp_rowtype
(pno in emp.empno%type)
is
  vemp  emp%rowtype; -- %rowtype
  vdname dept.dname%type;
begin
    select ename,hiredate,deptno
    into vemp.ename,vemp.hiredate, vemp.deptno
    from emp
    where empno=pno;    
    select dname
    into vdname
    from dept
    where deptno=vemp.deptno;    
    dbms_output.put_line('---------------------------------');
    dbms_output.put_line('�μ���ȣ  �μ���     �����    �Ի���');
    dbms_output.put_line('----------------------------------');
    dbms_output.put_line(vemp.deptno||' '||vdname||'  '||vemp.ename||'  '||vemp.hiredate);
    dbms_output.put_line('-----------------------------------');
    -- ���� ó����
    exception
        when no_data_found then
            dbms_output.put_line(pno||'�� ����� �������� �ʽ��ϴ�');
        when others then
            dbms_output.put_line('��Ÿ ���� �߻��߾��');
end;
/
-------------------------------------------------
select empno from emp;
exec emp_rowtype(7521);
exec emp_rowtype(7499);
exec emp_rowtype(8499);
-------------------------------------------------
-- ���ν��� �ҽ� Ȯ��
select * from user_source;

select text from user_source
where name='EMP_ROWTYPE';
-------------------------------------------------
# COMPOSITE TYPE (���� ������ Ÿ��)
- TABLE Ÿ��  ==> �ڹ��� �迭�� ����
- RECORD Ÿ�� ==> �ڹ��� CLASS�� ����
-------------------------------------------------
-- ���̺� Ÿ��
-- �μ���ȣ�� IN �Ķ���ͷ� �ѱ�� �ش� �μ��� �Ҽӵ�
-- ����� �̸��� �������� ������ ����ϴ� ���ν���
CREATE OR REPLACE PROCEDURE TABLE_TYPE
(PDNO IN DEPT.DEPTNO%TYPE)
IS
-- ���̺� ����
-- ENAME���� ������ TABLE ���� ����
TYPE ENAME_TABLE IS TABLE OF EMP.ENAME%TYPE
INDEX BY BINARY_INTEGER;
-- JOB����  ������ TABLE ���� ����
TYPE JOB_TABLE IS TABLE OF EMP.JOB%TYPE
INDEX BY BINARY_INTEGER;

-- ���̺� Ÿ���� ���� ����
ENAME_ARR ENAME_TABLE;
JOB_ARR JOB_TABLE;
-- �ε����� ����� ���� ����
I BINARY_INTEGER :=0;
BEGIN
   -- �ݺ��� ���鼭 EMP���� �����͸� �����ͼ� ENAME_ARR�� �����Ѵ�
   FOR K IN (SELECT ENAME,JOB FROM EMP WHERE DEPTNO=PDNO) LOOP
       I := I+1;
       ENAME_ARR(I) := K.ENAME;
       -- JOB�� ���� 
       JOB_ARR(I) := K.JOB;
   END LOOP;
   
   -- ���̺� Ÿ�� ������ ����� �� ����ϱ�
   DBMS_OUTPUT.PUT_LINE('------'||PDNO||'�� �μ�--------');
   FOR J IN 1 .. I LOOP -- 1���� I������ 1�������ϸ鼭 �ݺ����� �����Ѵ�
       DBMS_OUTPUT.PUT_LINE( RPAD(ENAME_ARR(J), 16,' ')||JOB_ARR(J));
   END LOOP;
END;
/
-------------------------------------------------------
SET SERVEROUTPUT ON
EXEC TABLE_TYPE(10);
EXEC TABLE_TYPE(20);
EXEC TABLE_TYPE(30);
-------------------------------------------------------
-- RECORD Ÿ��
-- ������� IN �Ķ���ͷ� �����ϸ� �ش� ��� ������ ����ϴ� ���ν���
-- ���,����,�޿�
CREATE OR REPLACE PROCEDURE RECORD_TYPE
(PNAME IN EMP.ENAME%TYPE)
IS
 -- ���ڵ� Ÿ�� ����
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
 
 --���ڵ�Ÿ���� ���� ����
 EMP_REC EMP_RECORD;
 BEGIN
  SELECT *  INTO EMP_REC FROM EMP WHERE ENAME=UPPER(PNAME);
 -- ����ϱ�
    DBMS_OUTPUT.PUT_LINE('---'||PNAME||'�� ����---');
    DBMS_OUTPUT.PUT_LINE('��� : '||EMP_REC.VNO);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||EMP_REC.VNAME);
    DBMS_OUTPUT.PUT_LINE('���� : '||EMP_REC.VJOB);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||EMP_REC.VSAL);    
 -- ���� ó�� �ϱ�
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(PNAME||'����� �����ϴ�');
END;
/

EXEC RECORD_TYPE('KING');
EXEC RECORD_TYPE('BLAKE');
EXEC RECORD_TYPE('QUEEN');
-------------------------------------------------
# BIND ����
VARIABLE ������ �ڷ���
-----------------------------------------------
VARIABLE MYVAR NUMBER

DECLARE
BEGIN
    --���ε庯���� ������ ���� �տ� �ݷ�(:)�� ���ξ�� ���δ�
    :MYVAR :=500;
END;
/

PRINT MYVAR
------------------------------------
# ���ν��� �Ķ���� ����
[1] IN PARAMETER  : ����Ʈ 
[2] OUT PARAMETER
[3] IN OUT PARAMETER
-----------------------------------
-- IN PARAMETER

CREATE OR REPLACE PROCEDURE DEPT_ADD
(VNO IN NUMBER DEFAULT 99,
 VNAME IN DEPT.DNAME%TYPE,
 VLOC IN DEPT.LOC%TYPE)
 IS
 BEGIN
    INSERT INTO DEPT(DEPTNO,DNAME,LOC)
    VALUES(VNO,VNAME,VLOC);    
 END;
 /
EXEC DEPT_ADD(51,'EDUCATION','SEOUL');
EXEC DEPT_ADD(VNAME=>'PLANNING',VLOC=>'SUWON');
SELECT * FROM DEPT;
ROLLBACK;
--------------------------------------------
-- OUT PARAMETER
-- ���ν����� ȣ���ڿ��� �Ѱ��ִ� ��
-- ����Ʈ�� ���� �Ұ�

-- ����� �� �Ķ���ͷ� �ѱ�� �ش� ����� �̸��� �ƿ� �Ķ���ͷ�
-- �������� ���ν���
create or replace procedure ename_find
(
    pno in emp.empno%type,
    oname out emp.ename%type
)
is
begin
    select ename into oname
    from emp
    where empno=pno;
end;
/
--------------------------------
-- out �Ķ���͸� �޾��� ���ε� ������ ��������
var fname varchar2(30);

execute ename_find(7499,:fname);

print fname;
----------------------------------
-- IN OUT PARAMETER : IN�� �ϰ� OUT�� �ϴ� �Ķ����
CREATE OR REPLACE PROCEDURE INOUT_TEST
(
A1 IN NUMBER,
A2 IN VARCHAR2,
A3 IN OUT VARCHAR2,
A4 OUT VARCHAR2
)
IS
    MSG VARCHAR2(30) :='';
BEGIN
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('���ν��� ���� �� ');
    DBMS_OUTPUT.PUT_LINE('----------------------');
    DBMS_OUTPUT.PUT_LINE('A1: '||TO_CHAR(A1,'999,999')); -- IN
    DBMS_OUTPUT.PUT_LINE('A2: '||A2); -- IN
    DBMS_OUTPUT.PUT_LINE('A3: '||A3); -- IN OUT
    DBMS_OUTPUT.PUT_LINE('A4: '||A4); -- OUT
    
    A3:='���ν��� �ٱ����� �̰��� ���� �� ������?';
    MSG:='�翬����!!';
    A4 := MSG;
    
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('���ν��� ���� �� ');
    DBMS_OUTPUT.PUT_LINE('----------------------');
    DBMS_OUTPUT.PUT_LINE('A1: '||TO_CHAR(A1,'999,999')); -- IN
    DBMS_OUTPUT.PUT_LINE('A2: '||A2); -- IN
    DBMS_OUTPUT.PUT_LINE('A3: '||A3); -- IN OUT
    DBMS_OUTPUT.PUT_LINE('A4: '||A4); -- OUT    
END;
/

VAR C VARCHAR2(100);
VAR D VARCHAR2(100);
exec :c :='in test';

exec inout_test(50000,'Hi',:c,:d);

print c;
print d;
------------------------------------------------
--# select���� �����ϴ� ���ν���
--�� �Ķ���ͷ� job�� �ѱ��
--�ش� ������ �����ϴ� ��������� �������� ���ν���

-- ���ν�����: emp_job_info
-- ��������� ���� ����: %rowtype

create or replace procedure emp_job_info
(pjob in emp.job%type)
is
vemp emp%rowtype;
begin
    select * into vemp
    from emp
    where job=upper(pjob);
    dbms_output.put_line('---'||pjob||'----');
    dbms_output.put_line('�̸�: '||vemp.ename);
end;
/
exec emp_job_info('manager');

-- ORA-01422: exact fetch returns more than requested number of rows
-- ������� �������� ��ȯ�� ���� Ŀ���� �̿��ؾ� �Ѵ�
--------------------------------------------------------
create or replace procedure emp_job_info
(pjob in emp.job%type)
is
vemp emp%rowtype;
-- Ŀ�� ����
cursor emp_cr is
select * from emp where job=upper(pjob);
begin
    -- Ŀ�� ���� open
    open emp_cr;
    -- �ݺ��� ���鼭 ������ ����(fetch)
    dbms_output.put_line('---'||upper(pjob)||'----');
    loop
    -- ������ ����
    fetch emp_cr into vemp;
    exit when emp_cr%notfound; --�ݺ����� �����    
    dbms_output.put_line(rpad(vemp.ename,14,' ')||vemp.sal);
    end loop;
    -- Ŀ�� �ݱ� close
    close emp_cr;    
    dbms_output.put_line('�̸�: '||vemp.ename);
end;
/
------------------------------------------
exec emp_job_info('manager');
exec emp_job_info('salesman');
----------------------------------------------------------
--�μ���ȣ�� in �Ķ���ͷ� �����ϸ�
--�ش� �μ��� ��������� out�Ķ���ͷ� �������� ���ν��� �ۼ��ؼ�
--java�� �����غ��ô�
--�̸�, ����, �μ���, �ٹ���, �Ի���

create or replace procedure emp_forjava
(
    pdno in emp.deptno%type,
    mycr out sys_refcursor
)
is
begin
    /*
    open mycr for
    select ename,job, dname, loc, hiredate
    from dept d join emp e
    on d.deptno = e.deptno and e.deptno=pdno;*/
    open mycr for
    select ename,job, dname,loc,hiredate from
    (select * from emp where deptno=pdno) A join dept d
    on a.deptno=d.deptno;    
end;
/
----------------------------------------------------------
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
------------------------------------------









