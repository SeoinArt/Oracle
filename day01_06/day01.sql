select * from tab;
-- �ܹ� �ּ�
/* ���� �ּ� c:/myjava/sql/day01.sql */ 

-- �λ���� �ý���
select * from dept;
select dname, loc, deptno from dept;
select * from emp;
select * from salgrade;

-- ���θ� �ý���
select * FROM member; -- ȸ��
select * from category; -- ī�װ�
select * from products; -- ��ǰ
select * from SUPPLY_COMP; -- ���� ��ü


-- �л� ���̺� : �й�, �̸�, �ּ�, ����ó, �����, �б޸�, ����
create table student(
num number(4) primary key, -- unique + n ot null
name varchar2(30) not null,
addr varchar2(100) not null,
tel varchar2(15) not null,
indate date default sysdate, -- �ý����� ���� ��¥�� ����Ʈ������ ����
cname varchar2(50),
croom number(3)
);

select * from student;


/* insert into ���̺��(�÷���1,�÷���2,...) values(��1,��2,...) */

insert into student(num,name,addr,tel,cname, croom) values(1,'ȫ�浿','���� ������', '010-1111-1111','�鿣�� �����ڹ�', 201);
commit; -- db�� ������ ����

insert into student(num,addr,name,tel,cname,croom) values(2,'��õ������ ������','��浿','010-2222-2222','�鿣�� �����ڹ�',201);

rollback; -- ���
commit;

insert into student(num,name,addr,tel) values (3,'�ֿ���', '���� �ϻ굿��','010-3333-3333');
insert into student values(4,'�̱���','����','010-9999-9999','23/03/21','�����͹�',202);
insert into student values(5,'�����', '����','010-8888-8888','23/03/21','�����͹�',202);
insert into student values(6,'����Ƽ', 'ȭ����','010-7777-7777','23/03/21','�����͹�',202);
insert into student values(7,'������', '������','010-6666-6666','23/03/21','AI ���� �����ڹ�',203);
insert into student values(8,'���ѱ�', '��걤����','010-5555-5555','23/03/21','AI ���� �����ڹ�',203);
insert into student values(9,'������', '���ؽ�','010-5555-5555','23/03/21','AI ���� �����ڹ�',203);
select * from student;

-- ������ ����
-- update ���̺�� set �÷��� = ��, ... where ������
update student set addr = '�뱸������' where name like '����%';
update student set cname='�鿣�� �����ڹ�', croom=202 where num=3;

-- �̸��� ȫ�浿�� �л��� ����ó�� 010-1234-5678 ����
update student set tel='010-1234-5678' where name ='ȫ�浿';
select * from student;
commit;

-- ������ ����
-- delete from ���̺�� where ������;
select * from student;
DELETE FROM student;
ROLLBACK;

delete from student where num =2;
delete from student where name='������';

insert into student values(10,'���缮','���� ���ϱ�','010-7878-8989', sysdate,'�鿣���','301');
select * from student where croom=201;

-- ���̺� ���� : DDL
-- drop table ���̺��
drop table student;
 

-- �н� ���̺�
create table sclass(
    snum number(4) primary key, -- �б޹�ȣ
    sname varchar2(50) not null, -- �б޸�
    sroom number(3)
);
desc sclass
commit;

create table student(
    num number(4) primary key,
    name varchar2(30) not null,
    addr varchar2(100) not null,
    tel varchar2(15) not null,
    indate date default sysdate,
    snum_fk number(4) references sclass(snum)
)
desc student;

-- �б� �����͸� �����ϼ���
/*  10 �鿣�� �����ڹ� 201
    20 �����͹� 202
    30 AI ���� �����ڹ� 203 */

insert into sclass VALUES( 10 ,'�鿣�� �����ڹ�', 201);
insert into sclass VALUES( 20 ,'�����͹�', 202);
insert into sclass VALUES( 30 ,'AI ���� �����ڹ�', 203);
select * from sclass;
commit;

-- �л� ������ ����
insert into student(num,name,addr,tel,snum_fk) values(1,'ȫ�浿','���� ������','010-0000-0000',10);
insert into student(num,name,addr,tel,snum_fk) values(2,'��浿','��õ ������','010-1111-1111',10);
insert into student(num,name,addr,tel,snum_fk) values(3,'�ֿ���','���� �ϻ굿��','010-2222-2222',10);

insert into student(num,name,addr,tel,snum_fk) values(4,'�̱���','���� ������','010-3333-3333',20);
insert into student(num,name,addr,tel,snum_fk) values(5,'�̸��','���� ������','010-4444-4444',20);
insert into student(num,name,addr,tel,snum_fk) values(6,'���ڿ�','���� ������','010-5555-5555',20);

insert into student(num,name,addr,tel,snum_fk) values(7,'�赿��','���� ���ϱ�','010-6666-6666',30);
insert into student(num,name,addr,tel,snum_fk) values(8,'�����','���� ����','010-7777-7777',30);
insert into student(num,name,addr,tel,snum_fk) values(9,'�����','���� ��ȭ��','010-8888-8888',30);

select * from student;
commit;

-- ���� �̻� 
insert into student values(10,'�ƹ���', '���� ���빮��', '010-2323-2222','23-03-21',40);

-- ���� �̻�
-- 1�� �л��� �б� �����ϵ� 30�� �б����� �����ϼ���
update student set snum_fk=30 where num=1;

-- 2�� �л��� �б� �����ϵ� 40�� �б����� �����ϼ���
update student set snum_fk=40 where num=1;

-- ���� �̻� ����
delete from sclass where snum =10; -- �ܷ�Ű�� �����ϴ� �����Ͱ� �ڽ� ���̺� �ִٸ� ������ �� ����

select * from student;

-- join ans
select snum, sname,name, tel, indate,snum_fk
from sclass join student 
on sclass.snum = student.snum_fk
order by snum asc;

-- *******************************************************************************
select * from dept; -- �θ� ���̺� : PK.deption (Unique + not null)
SELECT * FROM emp; -- �ڽ� ���̺� : FK.deption 

SELECT empno, ename, sal FROM emp;

SELECT empno, ename, sal, sal+300 as sal_up FROM emp; -- alias. ��Ī :  as || ""

-- emp���� ���, �����, �޿�, ���ʽ�, �޿�*12+���ʽ� year_sal
SELECT EMPNO, ENAME, SAL, COMM, SAL*12+COMM AS YEAR_SAL FROM EMP;

-- NVL(�÷���, ��) �Լ� : �÷��� null�� ��� �־��� ������ ��ü�ؼ� ��ȯ�Ѵ�.
SELECT empno, ename, sal, comm, sal*12+nvl(comm,0)"����" FROM emp;

-- NVL2(EXPR, EXPR1, EXPR2) : EXPR���� null�� �ƴ� ��� EXPR1 ���� ��ȯ�ϰ�, NULL�� ��� EXPR2���� ��ȯ�Ѵ�.

-- Q. emp ���̺��� ������(MGR)�� ���� ��쿡�� 1, ������ 0�� ��µǵ��� �ϼ���
SELECT EMPNO, ENAME,MGR,NVL2(MGR,1,0) "������ ���� ����" FROM emp;

SELECT EMPNO, JOB, SAL FROM EMP WHERE ENAME =   upper('scott');

commit;


