# PL/SQL�� ���
# PL/SQL�� ���
----------------------------------------------------------------------------------- IF ANS
[1]  IF��

IF�� ���� THEN ���๮ 
ELSEIF ���� THEN ���๮
ELSE ���๮
END IF;

Q. ����� INPARAMETER�� �ѱ�� �ش� ����� �μ���ȣ, �����, �μ����� ����ϴ� ���ν���
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
    
    IF VDNO = 10 THEN VDNAME := 'ȸ��μ�';
    ELSIF VDNO = 20 THEN VDNAME := '�����μ�';
    ELSIF VDNO = 30 THEN VDNAME := '�����μ�';
    ELSE 
        VDNAME :='��μ�';
    END IF;
    DBMS_OUTPUT.PUT_LINE(PNO || '��' || VNAME || '����' || VDNO || '�� �μ� [' ||VDNAME ||'] �� �־��');
END;
/

Q. [�ǽ�];
-- IF~END IF ������ SCOTT�� ������ ����ϼ���. COMM�� ���� ���� ���� �ƴ� ��츦 ������ ����Ͽ� ����ϼ���
-- IF~END IF ������ ���Ķ�Ű�ͷ� ������� �޾� �ش� ����� ������ ����ϼ���
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
    dbms_output.put_line(pname||'���� ������ '||to_char(vtotal,'$999,999')||'�Դϴ�');
    dbms_output.put_line('�� �޿�: '||vsal||', ���ʽ�: '||vcomm);  
    exception
    when no_data_found then 
    dbms_output.put_line(pname||'���� �����ϴ�');
    when too_many_rows then
    dbms_output.put_line(pname||'���� �����Ͱ� 2�� �̻��Դϴ�');
end;
/
set serveroutput on;
exec emp_sal('king');
select * from emp;

------------------------------------------------------------------------------------ loop ��
[2] LOOP. �ݺ���
1) for��
for ���� in [reverse] ���۰� .. ���� loop
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
    for k in (select * from member where job = '�л�') loop
    -- k �� record type�� ����
        dbms_output.put_line(k.name || ':' || k.job || '  ' || k.userid);
    end loop;
end;
/
desc member;




2) loop��
loop
    exit when ���ǹ�;
    ���๮;
end loop;

Q. emp ���̺��� ��������� ����ϵ� �ݺ��� �̿��ؼ� ����� 9000������ 10�� �������Ѽ� �����ô�.
 ����� :'james'
 �Ի��� 
 9090���� �Ǹ� �ݺ��� ��Ż�ϱ�
 
 
 declare
    vno emp.empno%type :=9000;
    
 begin
    loop
        insert into emp(empno,ename,hiredate)
            values(vno,upper('JAMES'),sysdate);
        vno := vno+10;
        exit when vno >= 9090; -- exit �������� ������ ���ѷ��� ����!!
    end loop;
    dbms_output.put_line('������ ���� ���� : ' || (vno-9000)/10||'���� ������ �Է�');
 end;
 /
 rollback;
select * from emp order by 1 desc;

3) while loop��
while ���ǹ� loop
    ���๮;
    ���� ������;
end loop;

declare
cnt number(4) := 1000;
begin
    while cnt<1005 loop
        insert into emp(empno,ename, hiredate)
        values(cnt,upper('James')||cnt,sysdate);
        cnt := cnt+1;
    end loop;
    dbms_output.put_line(cnt-1000||'���� ������ �Է� �Ϸ�');
end;
/

rollback;


--------------------------------------------------------------------------------
# �Ͻ��� Ŀ�� ���
��� DML ����� select ������ �Ͻ��� Ŀ���� �����Ѵ�.
�����ڰ� ���� OPEN, FETCH, CLOSE�� ���� ������
�Ͻ��� Ŀ���� �Ӽ��� �̿��ؼ� ������ Ȱ���� �� �ִ�.

Q. ����� IN PARAMETER�� �ѱ�� �ش� ����� �޿��� 10���� �λ��Ű�� ���ν���

CREATE OR REPLACE PROCEDURE IMPLICIT_CUSOR (PNO IN EMP.EMPNO%TYPE)
IS
    VSAL EMP.SAL%TYPE;
    VROW NUMBER;
BEGIN
    SELECT SAL 
    INTO VSAL
    FROM EMP WHERE EMPNO = PNO;
    -- �����Ͱ� �߰ߵ� ����� �޿��� 10% �λ��Ű��
    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�˻��� �����Ͱ� �־�� : �޿� =>'|| VSAL);
    END IF;
    
    UPDATE EMP SET SAL = SAL*1.1 WHERE EMPNO = PNO;
    -- ������ ������ ���� VROW�� ����
    VROW := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('�޿��� �λ�� ��� : '||VROW);
    
     SELECT SAL 
    INTO VSAL
    FROM EMP WHERE EMPNO = PNO;
    -- �����Ͱ� �߰ߵ� ����� �޿��� 10% �λ��Ű��
    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('10% �޿� �λ� �� : �޿� =>'|| VSAL);
    END IF;
END;
/

EXECUTE IMPLICIT_CUSOR(7788);

ROLLBACK;

--------------------------------------------------------------------------------
���� ���� �����͸� SELECT �ϴ� ���忡 �Ͻ��� Ŀ���� ����ϸ�
TOO_MANY_ROWS ������ �߻���Ų��.
=> �� ���� ����� Ŀ���� ����ؾ� �Ѵ�.

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
����� Ŀ���� �̿��ؼ� ������ �ذ��غ��ô�
���𹮿��� 
CURSOR Ŀ���� IS SELECT ANS;

���๮���� OPEN Ŀ����;
�ݺ����� �̿��ؼ� FETCH�� �ؾ���
CLOSE Ŀ����;


CREATE OR REPLACE PROCEDURE DEPT_ALL
IS 
    VNO NUMBER;
    VNAME VARCHAR2(30);
    VLOC VARCHAR2(30);
    -- Ŀ�� �̸�
    CURSOR DCR IS SELECT DEPTNO, DNAME, LOC FROM DEPT;
BEGIN
-- Ŀ�� OPEN
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
�μ��� �ش� �μ��� �μ���� ������� ��� �޿��� �������� ���ν��� ����

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
        
        DBMS_OUTPUT.PUT_LINE('�μ���:  ' || VNAME || '  ����� : '||VCNT || ' �μ���ȣ: ' || VDNO || ' ��� �޿�: '|| VAVG_SAL);
    END LOOP;
    CLOSE DCR;
END;
/
EXECUTE DEPT_AVG_SAL;

--------------------------------------------------------------------------------
- for �������� Ŀ�� ���
- for �������� ���� ���� ���

create or replace procedure forcut
()
is
-- Ŀ�� ����
cursor pcr is 
select  products_name, output_price
from products 
order by 1;
--vname products.products_name%type; 
--vprice number;
begin
-- for �������� Ŀ�� ���(open, fetch, close�� �˾Ƽ� ��)
    for p in pcr loop -- p qustn recode Ÿ��
        dbms_output.put_line(rpad(p.products_name,14,' ')||to_char(p.output_price,'l999,999,999'));
    end loop;
end;
/

exec forcur();


--------------------------------------------------------------------------------
for in �������� subquery ���
- cursor�� ������ �ʿ䰡 ����
- for ���� in(subquery)loop 
    ���๮
  end loop;
  
  
--------------------------------------------------------------------------------
�̸� ���ǵ� ����ó��

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
        DBMS_OUTPUT.PUT_LINE('���: '||K.EMPNO);
        DBMS_OUTPUT.PUT_LINE('�̸�: '||K.ENAME);
        DBMS_OUTPUT.PUT_LINE('�μ���ȣ: '||K.DEPTNO);    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(10/0);
    EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('�����Ͱ� 2�� �̻��̿���. Ŀ���� �̿��ϼ���');
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE(VENO||'�� ����� �̹� �ֽ��ϴ�');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��Ÿ ���� �߻�: ' || SQLERRM || ' ' || SQLCODE);
        
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