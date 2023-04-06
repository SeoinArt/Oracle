-- function 사번을 인 파라미터로 넘기면 해당 사원의 부서명을 반환하는 함수

create or replace function getDname
(pname in emp.ename%type)
return varchar2 -- 반환 타입 지정
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
    
    return vdname; -- 반환 값
    
    exception 
    when no_data_found then 
        dbms_output.put_line(pname|| ' 사원은 없습니다 ' );
        return SQLERRM;
    when too_many_rows then   
        dbms_output.put_line(pname|| ' 사원 데이터가 2권 이상 있습니다. ' );
        return SQLERRM;
    when others then
        return sqlerrm;
end;
/

-- 함수의 반환값을 저장하기 위한 바인드 변수 선언
var gname varchar2;
exec :gname := getDname('1');
print gname;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
set serveroutput on;
select * from emp;

-------------------------------------------------------------------------------- 패키지

--[1] 패키지 선언부
create or replace package empInfo as
procedure allEmp;
procedure allSal;
end empInfo;
/


-- [2] 패키지 변수 선언
create or REPLACE package body empInfo as
    -- allEmp : 모든 사원의 사번, 이름, 입사일 가져와 출력하는 프로시저
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
            dbms_output.put_line(SQLERRM|| '에러 발생');
    end allEmp;
    
    -- allSal : 전체 사원의 급여 합계, 사원수 평균 급여, 최대 급여, 최소 급여
    procedure allSal
    is 
    begin
        dbms_output.put_line('급여 총합'||lpad('사원수',10,' ')|| 
        lpad('평균 급여',10,' ')|| lpad('최대 급여',10,' ')||
        lpad('최소급여',10,' '));
        dbms_output.put_line('-----------------------------------------------');
        for k in (select sum(sal) total, count(empno) cnt, 
        round(avg(sal)) av, max(sal) mx, min(sal) mn  from emp) loop
        dbms_output.put_line(k.total||lpad(k.cnt,10,' ')|| lpad(k.av,10,' ')
        || lpad(k.mx,10,' ')|| lpad(k.mn,10,' '));
        end loop;
    end allSal;
end empInfo;
/

exec 패키지명.프로시저명(파라미터값)

exec empInfo.allEmp;

    
