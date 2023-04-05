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











