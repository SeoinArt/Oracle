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

    
