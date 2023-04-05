--------------------------------------------------------------------------------
REVIEW
[1] view 
CREATE [OR REPLACE] VIEW VIEW_NAME
AS
(SELECT ��);


[2] VIEW OPTION
(1) WITH READ ONLY : �б� ����
(2) WITH CHECK OPTION : VIEW ���� ������ �ֿ켱 


[3] INLINE VIEW : FROM�� SUBQUERY





--------------------------------------------------------------------------------
[1] INDEX 
: NOT NULL�� COLUMNS���� ��� ����
: ������ ���� ���̺����� �ε��� X (WHERE���� ���� ���Ǵ� ���̺� ���ؼ� ����)
: ������ �ε��� ����� RUD���� ���� ������ �߻�

=> ���̺��� �۰ų� ���� ���ŵǴ� ��� INDEX�� ���ʿ��ϴ�.

(1) INDEX ���� 
- �ڵ� ���� : PK�� UNIQEW ���� ������ �����ϸ� UNIQE �ε����� �ڵ����� �����ȴ�.
- USER ���� 
 : COLUMN�� �ε����� ���� �����Ѵ�.(UNIQE | NON-UNIQEW)
 : CREATE( UNIQE | NON-UNIQUE) INDEX INDEX_NAME 
    ON TABLE_NAME(COLUMN);
    
Q. MEMBER ���̺� NAME �÷��� INDEX�� ����
    CREATE INDEX MEMBER_NAME_IDX ON MEMBER(NAME);
    
1. NAME �÷����� �� �д´�.
2. NAME �÷����� ���� �������� ������ �Ѵ�.
3. ROWID�� NAME���� �����ϱ� ���� ���� ������ �Ҵ��Ѵ�.
4. �Ҵ� �� ���� �����Ѵ�.

=> DD���� ��ȸ
- USER_OBJECTS
SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE = 'INDEX';

- USER_INDEXES
SELECT * FROM USER_INDEXES WHERE TABLE_NAME LIKE 'MEMBER';

- USER_IND_COLUMS : �ε��� �÷� ����
SELECT * FROM USER_IND_COLUMNS 
WHERE INDEX_NAME ='MEMBER_NAME_IDX';
WHERE TABLE_NAME ='MEMBER';

SELECT * FROM MEMBER WHERE NAME LIKE '%��%';




Q. ��ǰ ���̺��� �ε����� �ɾ�θ� ���� �÷��� ã�� �ε����� ���弼��

DESC PRODUCTS;

CREATE INDEX PRODUCTS_CATEGORY_FK_INDX
ON PRODUCTS(CATEGORY_FK);

CREATE INDEX PRODUCTS_EP_CODE_FK_INDX 
ON PRODUCTS(EP_CODE_FK);

SELECT * FROM USER_INDEXES WHERE TABLE_NAME = 'PRODUCTS';

SELECT* FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'PRODUCTS';



(2) INDEX ����
: ���� �Ұ���
: DROP �� �ٽ� ����



(3) INDEX ����
    DROP INDEX INDEX_NAME;
    
DROP INDEX PRODUCTS_CATEGORY_FK_INDX;











--------------------------------------------------------------------------------
[2] SYNONYM (���Ǿ�)
: ����Ŭ ��ü�� ���� ��ü�̸�(ALIAS)�� �ǹ� (��ü�� ���� ����) 
  => �ٸ� ������ ��ü�� ������ �� ���� ���
  
: ��ü�� �� �̸��� ������ �̸����� �����Ͽ� SQL�ڵ��� �ܼ�ȭ�� �� �ִ�.
: ��ü�� �����ϴ� ������� ������Ʈ�� ���� �� �־� ������ ������ �� �ִ�.

(1) SYNONYM ����
CREATE [PUBLIC] SYNONYM SYNONYM_NAME 
    FOR OBJECT_NAME;
    
PUBLIC : ��� ����ڰ� ���� ������ SYNONYN�� �����Ѵ� 
=> PUBLIC SYNONYN�� ���� �� ������ DBA���� ����


1) SYSTEM���� �����Ͽ� ����� MYSTAR�� �����ϰ� ������ �ش�.
CONN SYSTEM/Abcd1234;
CREATE USER MYSTAR IDENTIFIED BT MTSTAR;
GRAND CONNECT, RESOURCE TO MYSTAR;


2) MYSTAR�� �����Ͽ� NOTE��� ���̺� ��ü�� �����ϰ� ���ڵ带 INSERT �Ѵ�.
CONN MYSTAR/MYSTAR
CREATE TABLE NOTE(
    NO NUMBER,
    MSG VARCHAR2(30)
    );
INSERT INTO NOTE VALUES(1,'�ȳ��ϼ���');
INSERT INTO NOTE VALUES(2,'�氡 �氡^^');
COMMIT;

3) MYSTAR ����ڰ� SCOTT����ڿ��� NOTE���̺� ������ ������ �ش�.(OBJECT)
GRANT ALL ON NOTE TO SCOTT;

CREATE SYNONYM A FOR MYSTAR.NOTE;

4) SCOTT�� �����ؼ� NOTE�� ��ȸ�Ѵ�.
SELECT * FROM MYST.NOTE

4) SYSTEM���� �����Ͽ� SCOTT���� ���Ǿ ������ ������ �ش�.
CONN SYSTEM/Abcd1234
GRANT CREATE SYNONYM TO SCOTT

5) SCOTT�� �����Ͽ� MYSTAR�� NOTE���̺� ���� ���Ǿ �����Ѵ�.
CREATE SYNONYM A FOR MYSTAR.NOTE;
=> MYSTAR ������� NOTE���̺� SCOTT����ڰ� A��� ���Ǿ�� ����ϰڴٴ� �ǹ�

6) ���Ǿ �̿��� ���� ����
SELECT * FROM A; == SELECT * FROM MYSTAR.NOTE;

7) DD���� ��ȸ
SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE = UPPER('SYNONYM');

8) SYNONYM ����
DROP SYNONYM SYNONYM_NAME







--------------------------------------------------------------------------------
[3] ���� �ο�
�ý��� ���� �ο� ����
conn system/Abcd1234;

(1) WITH ADMIN OPTION 
: ������ �ο� ���� ����ڵ� �ο� ���� ������ �ٸ� ����� �Ǵ� ���ҷ� �ο��� �� �ְ� �Ǹ�, 
  ���� ����ڰ� WITH ADMIN OPTION�� ���� ������ �ο� �޴´ٸ� �ο��� ������ �� ����ڿ� ���� ���� �Ǵ� ���� �� �� �ֽ��ϴ�. 

1) �ý��� �ο� WITH ADMIN OPTION�� �־� �ο��غ���;
GRANT CREATE USER, ALTER USER, DROP USER TO MYSTAR WITH ADMIN OPTION;

2) mystar�� �����ؼ� �ٸ� user�� �����غ���
conn mystar/mystar;

CREATE USER storm identified by storm;
=> storm�� �ٸ� user�� ������ ������ ���´�.

3) mystar�� storm user�� ��й�ȣ�� �����غ���
ALTER USER STORM IDENTIFIED BY TIGER;

4) MYSTAR�� STORM USER�� �����غ���
DROP USER STORM;




--------------------------------------------------------------------------------
[4] ���� ȸ��
REVOKE ����|�� FROM USER |��


1) SYSTEM���� �����ؼ� MYSTAR�� ���� �� ALTER USER, DROP USER�� ������ ȸ���غ���
CONN SYSTEM/Abcd1234;
SHOW USER;
REVOKE ALTER USER, DROP USER FROM MYSTAR;

2) MYSTAR�� �����ؼ� STORM�� �ٽ� �����غ���. 
CONN mystar/mystar;
CREATE USER STORM IDENTIFIED BY STORM;

3) STORM�� ��й�ȣ�� TIGER�� �����غ���
ALTER USER STROM IDENTIFIED BY TIGER;


Q. �ó�����
1) DBA�� STORM���� WITH ADMIN OPTION�� ����Ͽ� CREATE TABLE, CREATE SESSTION �ý��� ������ �ο� �մϴ�. 
GRANT CREATE TABLE, CREATE SESSTION TO STORM WITH ADMIN OPTION

2) STORM�� ���̺��� ���� �մϴ�. (NOTE NO(NUMBER), MSG(VARCHAR2(30))
=> ORA-01950: no privileges on tablespace 'SYSTEM'
=> ���� ������ ������ �ڿ��� ���� ������ �ο����� ����

CONN SYSTEM/Abcd1234
ALTER USER STORM QUOTA 2M ON SYSTEM
=> 2M �Ҵ�

CREATE TABLE NOTE(
  NO NUMBER,
  MSG VARCHAR2(30)
);

3) SYSTEM���� �����ؼ� MILLER USER�� �����ϰ�, MILLER���� CREATE SESSION ������ �ο��Ѵ�
CONN SYSTEM/Abcd1234
CREATE USER miller IDENTIFIED BY miller;
GRANT CREATE SESSION TO miller;

ALTER USER miller QUOTA UNLIMITED ON SYSTEM; 
=> ���� ������ ���������� ����� �� �ֵ��� ����


4) STORM�� CREATE TABLE �ý��� ������ MILLER���� �ο� �մϴ�
conn STORM/STORM
grant create table to miller;

5) MILLER�� ���̺��� ���� �մϴ�. 
CONN miller/miller
create table note(
  no number,
  msg varchar2(30)
  );

6) DBA�� STORM���� �ο��� CREATE TABLE �ý��� ������ ��� �մϴ�.
CONN SYSTEM/Abcd1234
REVOKE CREATE TABLE FROM STORM;

5) STORM�� CREATE TABLE �ý��� ������ MILLER���� �ο� �մϴ�. 
CONN STORM/STROM
GRANT CREATE TABLE TO miller;

6) MILLER�� ���̺��� ���� �մϴ�. ( MILLER�� CREATE TABLE ������? �״�� ������)
conn miller/miller
CREATE TABLE 

��� : WITH ADMIN OPTION ���� �ֿ��� ������ STORM���� ��Ҹ� �ص� MILLER�� CREATE TABLE ������ ��ҵ��� �ʴ´�!.








--------------------------------------------------------------------------------
[5] ��ü ���� Object Privileges
: ��ü ������ ������ �����ϰ� �ִ� Ư���� ��ü�� �ٸ� ����ڵ��� ������ �ϰų� ���� �� �� �ְ� �ϱ� ���ؼ� ������ �մϴ�. 
: ���̺��̳� ��, ������, ���ν���, �Լ�, �Ǵ� ��Ű�� �� ������ �� ������Ʈ�� Ư���� �۾��� ���� �� �� �ְ� �մϴ�. 

: Object �����ڴ� �ٸ� ����ڿ��� Ư�� Object Privileges�� �ο� �� �� �ֽ��ϴ�. 
: PUBLIC���� ������ �ο��ϸ� ȸ���� ���� PUBLIC���� �ؾ� �մϴ�. 
: Object Privileges�� Object Type�� ���� �ٸ��ϴ�. 
: �⺻������ ������ ������Ʈ�� ���� ��� ������ �ڵ������� ȹ��˴ϴ�
: WITH GRANT OPTION �ɼ��� '��' �� ������ �ο��� ���� ����� �� �����ϴ�


* Object�� ���� Privileges
----------------------------------------------------------------
��ü����	    ���̺�	     ��	        Sequence	  Procedure
---------------------------------------------------------------- 
ALTER	     ��	         ��
----------------------------------------------------------------

DELETE       ��		     ��
----------------------------------------------------------------

EXECUTE							                      ��
----------------------------------------------------------------

INDEX	     ��  
----------------------------------------------------------------  
INSERT	     ��		     ��
----------------------------------------------------------------
REFERENCES   ��
----------------------------------------------------------------
SELECT	     ��		     ��           ��
----------------------------------------------------------------  
UPDATE	     ��		     ��
----------------------------------------------------------------  

  ���� ǥ���� �� ���ʿ� �ִ� ALTER, DELETE, EXECUTE.. ����� object_privilege���� ���� �ǰ�, 
�� ���ٿ� �ִ� ���̺�, ��, ������, ���ν��� ����� ON ������ �ִ� object�� �Է��ϸ� ��. 

(1) ����(Syntax)
GRANT object_privilege [column] ON object
  TO {user[,user] | role |PUBLIC]
  [WITH GRANT OPTION]

�ǽ�. ��ü ����
1) scott ���� 
grant select, insert on emp to STORM with grant option;

2) STORM ����
select ename,job from scott.emp;
insert into scott.emp(empno,ename,job) values(8100,'JAMES','MANAGER');
commit;

3) STORM�� SCOTT.EMP ���̺� select�ϴ� ������ MILLER���� �ο��� �غ���.
grant select on scott.emp to miller;

4) miller�� ������ �� scott.emp ���̺��� ��ȸ�غ���.
conn miller/miller;
select ename, job from scott.emp;

5) scott�� STORM���� �ο��ߴ� select, insert on emp�� ���� ������ ȸ���Ѵ�.
revoke select, insert on emp from STORM;

6) STORM���� �����Ͽ� select�� ����
conn STORM/STORM
select ename from scott.emp; 
=> ERROR �߻� ORA-00942: table or view does not exist

7) miller�� �����Ͽ� select �� ����
conn miller/miller
select ename from scott.emp;
=> ERROR �߻� ORA-00942: table or view does not exist

���
: WITH GRANT OPTION�� ����Ͽ� ��ü ���� ���
: WITH GRANT OPTION�� ����Ͽ� �ο��� ��ü ������ ����ϸ� ��� �۾��� ���������� ���� �˴ϴ�.





--------------------------------------------------------------------------------
[6] ROLE
: ����ڿ��� �㰡�� �� �ִ� ���ѵ��� ����

: ROLE�� �̿��ϸ� ���� �ο��� ȸ���� ���� �� �� �ֽ��ϴ�. 
: ROLE�� Create Role������ ���� User�� ���ؼ� ���� �˴ϴ�.�� 
: �� ����ڰ� �������� ROLL�� ACCESS�� �� �ְ�,  ���� ����ڿ��� ���� ROLE�� �ο��� �� �ֽ��ϴ�. 
: �ý��� ������ �ο��ϰ�, ����� ���� ������ ����� ����Ͽ� ����ڿ��� �ο��ϰ�, ��� �մϴ�. 
: ����ڴ� ROLE�� ROLE�� �ο��� �� �ֽ��ϴ�. 
: ����Ŭ �����ͺ��̽��� ��ġ�ϸ� �⺻������ CONNECT, RESOURCE, DBA ROLE�� �����˴ϴ�.

=> �Ʒ��� �׸�ó�� DBA�� �����鿡�� ������ �ο��� �� ������ ���� �ϳ��ϳ����� ������ �Ѵٸ� ���� ������ �� �Դϴ�. 
   DBA�� USER�� ���ҿ� �µ��� Role�� �����Ͽ��� Role�� �������� ������ �Ѵٸ� ���� ȿ�������� �������� ������ ���� �� �� �ֽ��ϴ�. 
   
(1) ROLE ���� �� �ο�

1) ROLE�� ���� : CREATE ROLE ROLE_NAME;
CREATE ROLE manager;

2) ROLE�� ���� �ο� : GRANT ����1,����2 TO ROLE_NAME; (USER_NAME : SYSTEM)

Q. manager ROLE�� CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SYNONYM ������ �ο��϶�.
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SYNONYM 
TO manager;

=> DD���� ��ȸ
- DBA_ROLES
SELECT * FROM DBA_ROLES;
- DBA_SYS_PRIVS
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'MANAGER';
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'CONNECT';
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RESOURCE';


3) ROLE�� ����ڿ��� �ο� : GRANT ROLE_NAME TO USER_NAME;
Q. manager ROLE�� miller���� �ο��غ���
grant manager to miller;


4) ����ڿ��� Ȯ���غ���
conn miller/miller
create view miller_view as select * from note;
=> ���������� VIEW ����

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'DBA';















