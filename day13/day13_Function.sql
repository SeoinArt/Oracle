-- function ����� �� �Ķ���ͷ� �ѱ�� �ش� ����� �μ����� ��ȯ�ϴ� �Լ�

create or replace function getDname
(pname in emp.ename%type)
return varchar2 -- ��ȯ Ÿ�� ����
is
vdno emp.deptno%type;
vdname dept.dname%type;
begin
    select deptno
    into vdno
    from emp where ename = upper(pname);
    
    select dname
    into vdname
    from dept where deptno = vdno;
    
    return vdname; -- ��ȯ ��
    
    exception 
    when no_data_found then 
        dbms_output.put_line(pname|| ' ����� �����ϴ� ' );
        return SQLERRM;
    when too_many_rows then   
        dbms_output.put_line(pname|| ' ��� �����Ͱ� 2�� �̻� �ֽ��ϴ�. ' );
        return SQLERRM;
    when others then
        return sqlerrm;
end;
/

-- �Լ��� ��ȯ���� �����ϱ� ���� ���ε� ���� ����
var gname varchar2;
exec :gname := getDname('1');
print gname;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
set serveroutput on;
select * from emp;

-------------------------------------------------------------------------------- ��Ű��

--[1] ��Ű�� �����
create or replace package empInfo as
procedure allEmp;
procedure allSal;
end empInfo;
/


-- [2] ��Ű�� ���� ����
create or REPLACE package body empInfo as
    -- allEmp : ��� ����� ���, �̸�, �Ի��� ������ ����ϴ� ���ν���
    procedure allEmp
    is
        cursor empCr is
        select empno, ename, hiredate from emp order by 3;
    begin
        for k in empCr loop
            dbms_output.put_line(k.empno || lpad(k.ename, 16, ' ') || 
            lpad(k.hiredate, 16, ' '));
        end loop;
    
    exception
        when others then 
            dbms_output.put_line(SQLERRM|| '���� �߻�');
    end allEmp;
    
    -- allSal : ��ü ����� �޿� �հ�, ����� ��� �޿�, �ִ� �޿�, �ּ� �޿�
    procedure allSal
    is 
    begin
        dbms_output.put_line('�޿� ����'||lpad('�����',10,' ')|| 
        lpad('��� �޿�',10,' ')|| lpad('�ִ� �޿�',10,' ')||
        lpad('�ּұ޿�',10,' '));
        dbms_output.put_line('-----------------------------------------------');
        for k in (select sum(sal) total, count(empno) cnt, 
        round(avg(sal)) av, max(sal) mx, min(sal) mn  from emp) loop
        dbms_output.put_line(k.total||lpad(k.cnt,10,' ')|| lpad(k.av,10,' ')
        || lpad(k.mx,10,' ')|| lpad(k.mn,10,' '));
        end loop;
    end allSal;
end empInfo;
/

exec ��Ű����.���ν�����(�Ķ���Ͱ�)

exec empInfo.allEmp;


-- # Trigger
-- insert, update, delete ���� ����� �� ���������� ���صǴ� ������ ���ν���
-- �μ����� ������ �� ���� �μ���� ����� �μ����� ������� ����� Ʈ���Ÿ� �ۼ��غ���

CREATE OR REPLACE TRIGGER TRG_DEPT
BEFORE UPDATE ON DEPT
FOR EACH ROW
DECLARE
    MSG VARCHAR2(20);
BEGIN
    MSG:='HI TRIGGER';
    DBMS_OUTPUT.PUT_LINE(MSG);
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : ' || :OLD.DNAME );
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : ' || :NEW.DNAME );
END;
/

SELECT * FROM DEPT;
-- function ����� �� �Ķ���ͷ� �ѱ�� �ش� ����� �μ����� ��ȯ�ϴ� �Լ�

create or replace function getDname
(pname in emp.ename%type)
return varchar2 -- ��ȯ Ÿ�� ����
is
vdno emp.deptno%type;
vdname dept.dname%type;
begin
    select deptno
    into vdno
    from emp where ename = upper(pname);
    
    select dname
    into vdname
    from dept where deptno = vdno;
    
    return vdname; -- ��ȯ ��
    
    exception 
    when no_data_found then 
        dbms_output.put_line(pname|| ' ����� �����ϴ� ' );
        return SQLERRM;
    when too_many_rows then   
        dbms_output.put_line(pname|| ' ��� �����Ͱ� 2�� �̻� �ֽ��ϴ�. ' );
        return SQLERRM;
    when others then
        return sqlerrm;
end;
/

-- �Լ��� ��ȯ���� �����ϱ� ���� ���ε� ���� ����
var gname varchar2;
exec :gname := getDname('1');
print gname;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
set serveroutput on;
select * from emp;

-------------------------------------------------------------------------------- ��Ű��

--[1] ��Ű�� �����
create or replace package empInfo as
procedure allEmp;
procedure allSal;
end empInfo;
/


-- [2] ��Ű�� ���� ����
create or REPLACE package body empInfo as
    -- allEmp : ��� ����� ���, �̸�, �Ի��� ������ ����ϴ� ���ν���
    procedure allEmp
    is
        cursor empCr is
        select empno, ename, hiredate from emp order by 3;
    begin
        for k in empCr loop
            dbms_output.put_line(k.empno || lpad(k.ename, 16, ' ') || 
            lpad(k.hiredate, 16, ' '));
        end loop;
    
    exception
        when others then 
            dbms_output.put_line(SQLERRM|| '���� �߻�');
    end allEmp;
    
    -- allSal : ��ü ����� �޿� �հ�, ����� ��� �޿�, �ִ� �޿�, �ּ� �޿�
    procedure allSal
    is 
    begin
        dbms_output.put_line('�޿� ����'||lpad('�����',10,' ')|| 
        lpad('��� �޿�',10,' ')|| lpad('�ִ� �޿�',10,' ')||
        lpad('�ּұ޿�',10,' '));
        dbms_output.put_line('-----------------------------------------------');
        for k in (select sum(sal) total, count(empno) cnt, 
        round(avg(sal)) av, max(sal) mx, min(sal) mn  from emp) loop
        dbms_output.put_line(k.total||lpad(k.cnt,10,' ')|| lpad(k.av,10,' ')
        || lpad(k.mx,10,' ')|| lpad(k.mn,10,' '));
        end loop;
    end allSal;
end empInfo;
/

exec ��Ű����.���ν�����(�Ķ���Ͱ�)

exec empInfo.allEmp;


-- # Trigger
-- insert, update, delete ���� ����� �� ���������� ���صǴ� ������ ���ν���
-- �μ����� ������ �� ���� �μ���� ����� �μ����� ������� ����� Ʈ���Ÿ� �ۼ��غ���

CREATE OR REPLACE TRIGGER TRG_DEPT
BEFORE UPDATE ON DEPT
FOR EACH ROW
DECLARE
    MSG VARCHAR2(20);
BEGIN
    MSG:='HI TRIGGER';
    DBMS_OUTPUT.PUT_LINE(MSG);
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : ' || :OLD.DNAME );
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : ' || :NEW.DNAME );
END;
/

SELECT * FROM DEPT;
UPDATE DEPT SET DNAME ='��μ�' WHERE DEPTNO =40;
UPDATE DEPT SET LOC ='����' WHERE DEPTNO =40;
ROLLBACK;
                  

UPDATE DEPT SET LOC ='����' WHERE DEPTNO =40;
ROLLBACK;

-- Ʈ���� ��Ȱ��ȭ
ALTER TRIGGER Ʈ���Ÿ� DISALBLE;

-- Ʈ���� Ȱ��ȭ
ALTER TRIGGER Ʈ���Ÿ� INABLE;

--TRG_DEPT�� ��Ȱ��ȭ�ϰ� UPDATE���� �����غ�����
ALTER TRIGGER TRG_DEPT ENABLE;

UPDATE DEPT SET DNAME ='��μ�' WHERE DEPTNO =40;
ROLLBACK;

ALTER TRIGGER TRG_DEPT ENABLE;

-- ������ �������� ��ȸ USER_TRIGGERS
SELECT * FROM USER_TRIGGERS WHERE TRIGGER_NAME='TRG_DEPT';

-- Ʈ���� ����
DROP TRIGGER TRG_DEPT;

DROP TRIGGER TRG_DEPT;

--EMP ���̺� �����Ͱ� INSERT�ǰų� UPDATE�� ��� (BEFORE)
--��ü ������� ��ձ޿��� ����ϴ� Ʈ���Ÿ� �ۼ��ϼ���.
--�׽�Ʈ�Ҷ��� ��ü ����� �޿��� 10% �λ��Ű����
-- ���Ի������ ����ϼ���(���,�����,�μ���ȣ,�޿�)


CREATE OR REPLACE TRIGGER TRG_EMP_AVG
BEFORE INSERT OR UPDATE ON EMP
--FOR EACH ROW
DECLARE
AVG_SAL NUMBER(10);
BEGIN
    SELECT AVG(SAL) INTO AVG_SAL FROM EMP;
    DBMS_OUTPUT.PUT_LINE('��� �޿� : ' || AVG_SAL);
    END;
/
ROLLBACK;
SELECT * FROM USER_TRIGGERS;
INSERT INTO EMP(EMPNO,ENAME, DEPTNO,SAL) VALUES(9002,'TOM',20,4000);

UPDATE EMP SET SAL =SAL*1.1;



------------------------------------------
--[Ʈ���� �ǽ� 1] �� Ʈ����
--�԰� ���̺� ��ǰ�� �԰�� ���
--��ǰ ���̺� ��ǰ ���������� �ڵ����� ����Ǵ� 
--Ʈ���Ÿ� �ۼ��غ��ô�.
-- ��ǰ ���̺� : MYPRODUCT
-- �԰� ���̺� : MYINPUT


create table myproduct(
    pcode char(6) primary key,
    pname varchar2(20) not null,
    pcompany varchar2(20),
    price number(8),
    pqty number default 0
);
desc myproduct;

create sequence myproduct_seq
start with 1
increment by 1
nocache;

insert into myproduct values('A00'||myproduct_seq.nextval,'��Ʈ��', 'A��','800000',10);
insert into myproduct values('A00'||myproduct_seq.nextval,'TV', 'B��','1000000',20);
insert into myproduct values('A00'||myproduct_seq.nextval,'ű����', 'C��','700000',30);
select * from myproduct;
commit;


create table myinput(
    incode number primary key, -- �԰��ȣ
    pcode_fk char(6) references myproduct(pcode), -- �԰� ��ǰ �ڵ�
    indate date default sysdate,
    inqty number(6), -- �԰� ����
    inprice number(8) -- �԰� ����
);
desc myinput;

create sequence myinput_seq nocache;


-- �԰� ���̺� ��ǰ�� �԰�Ǹ� ��ǰ ���̺��� ���� ����(pqty)�� �����ϴ� Ʈ���Ÿ� �ۼ�


CREATE OR REPLACE TRIGGER TRG_INPUT_PRODUCT
AFTER INSERT ON MYINPUT
FOR EACH ROW
DECLARE
BEGIN
    UPDATE MYPRODUCT SET PQTY=PQTY+:NEW.INQTY 
    WHERE PCODE = :NEW.PCODE_FK;
    DBMS_OUTPUT.PUT_LINE(:NEW.PCODE_FK||'�� ��ǰ�� �߰��� '||:NEW.INQTY||'�� ����');
END;
/


INSERT INTO MYINPUT(INCODE,PCODE_FK,INQTY,INPRICE)
VALUES(MYINPUT_SEQ.NEXTVAL,'A001',20,500000);

INSERT INTO MYINPUT VALUES(MYINPUT_SEQ.NEXTVAL,'A002',SYSDATE,8,700000);
COMMIT;

SELECT * FROM MYINPUT;
SELECT * FROM MYPRODUCT;



--[�ǽ�1] �԰� ���̺��� ������ ����� ���-UPDATE���� ����� ��
--��ǰ ���̺��� ������ �����ϴ� Ʈ���Ÿ� �ۼ��ϼ���
-- :OLD.INQTY �����ϰ�, :NEW.INQTY ���ϴ�

create or replace trigger trg_myinput_update
after update on myinput
for each row
declare
begin
    update myproduct set pqty = pqty+:new.inqty - :old.inqty
    where pcode = :new.pcode_fk;
    DBMS_OUTPUT.PUT_LINE('�����Ǿ����ϴ�');
end;
/

update myinput set inqty =7 where incode =2;
select * from my

--[�ǽ�2] �԰� ���̺� �����Ͱ� ������ ���-DELETE���� ����� ��
--��ǰ ���̺��� ������ �����ϴ� Ʈ���Ÿ� �ۼ��ϼ���
-- :OLD.INQTY�� ������

create or replace trigger trg_myinput_delete
after delete on myinput
for each row
declare
begin
    update myproduct set pqty = pqty - :old.inqty
    where pcode = :new.pcode_fk;
    DBMS_OUTPUT.PUT_LINE('�����Ǿ����ϴ�');
end;
/

select * from myinput;
DELETE FROM MYINPUT WHERE PCODE_FK = 'A001';
select * from myproduct;





