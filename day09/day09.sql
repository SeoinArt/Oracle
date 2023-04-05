--------------------------------------------------------------------------------
REVIEW
[1] view 
CREATE [OR REPLACE] VIEW VIEW_NAME
AS
(SELECT 절);


[2] VIEW OPTION
(1) WITH READ ONLY : 읽기 전용
(2) WITH CHECK OPTION : VIEW 생성 조건절 최우선 


[3] INLINE VIEW : FROM절 SUBQUERY





--------------------------------------------------------------------------------
[1] INDEX 
: NOT NULL인 COLUMNS에만 사용 가능
: 수정이 많은 테이블에서는 인덱싱 X (WHERE절이 자주 사용되는 테이블에 대해서 생성)
: 과도한 인덱스 사용은 RUD에서 많은 과부하 발생

=> 테이블이 작거나 자주 갱신되는 경우 INDEX가 불필요하다.

(1) INDEX 생성 
- 자동 생성 : PK나 UNIQEW 제약 조건을 정의하면 UNIQE 인덱스가 자동으로 생성된다.
- USER 생성 
 : COLUMN에 인덱스를 직접 생성한다.(UNIQE | NON-UNIQEW)
 : CREATE( UNIQE | NON-UNIQUE) INDEX INDEX_NAME 
    ON TABLE_NAME(COLUMN);
    
Q. MEMBER 테이블에 NAME 컬럼에 INDEX를 생성
    CREATE INDEX MEMBER_NAME_IDX ON MEMBER(NAME);
    
1. NAME 컬럼값을 다 읽는다.
2. NAME 컬럼값에 대해 오름차순 정렬을 한다.
3. ROWID와 NAME값을 저장하기 위한 저장 공간을 할당한다.
4. 할당 후 값을 저장한다.

=> DD에서 조회
- USER_OBJECTS
SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE = 'INDEX';

- USER_INDEXES
SELECT * FROM USER_INDEXES WHERE TABLE_NAME LIKE 'MEMBER';

- USER_IND_COLUMS : 인덱스 컬럼 정보
SELECT * FROM USER_IND_COLUMNS 
WHERE INDEX_NAME ='MEMBER_NAME_IDX';
WHERE TABLE_NAME ='MEMBER';

SELECT * FROM MEMBER WHERE NAME LIKE '%동%';




Q. 상품 테이블에서 인덱스를 걸어두면 좋을 컬럼을 찾아 인덱스를 만드세요

DESC PRODUCTS;

CREATE INDEX PRODUCTS_CATEGORY_FK_INDX
ON PRODUCTS(CATEGORY_FK);

CREATE INDEX PRODUCTS_EP_CODE_FK_INDX 
ON PRODUCTS(EP_CODE_FK);

SELECT * FROM USER_INDEXES WHERE TABLE_NAME = 'PRODUCTS';

SELECT* FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'PRODUCTS';



(2) INDEX 수정
: 수정 불가능
: DROP 후 다시 생성



(3) INDEX 삭제
    DROP INDEX INDEX_NAME;
    
DROP INDEX PRODUCTS_CATEGORY_FK_INDX;











--------------------------------------------------------------------------------
[2] SYNONYM (동의어)
: 오라클 객체에 대한 대체이름(ALIAS)을 의미 (객체에 대한 참조) 
  => 다른 유저의 객체를 참조할 때 많이 사용
  
: 객체의 긴 이름을 간편한 이름으로 참조하여 SQL코딩을 단순화할 수 있다.
: 객체를 참조하는 사용자의 오브젝트를 감출 수 있어 보안을 유지할 수 있다.

(1) SYNONYM 생성
CREATE [PUBLIC] SYNONYM SYNONYM_NAME 
    FOR OBJECT_NAME;
    
PUBLIC : 모든 사용자가 접근 가능한 SYNONYN을 생성한다 
=> PUBLIC SYNONYN의 생성 및 삭제는 DBA만이 가능


1) SYSTEM으로 연결하여 사용자 MYSTAR를 생성하고 권한을 준다.
CONN SYSTEM/Abcd1234;
CREATE USER MYSTAR IDENTIFIED BT MTSTAR;
GRAND CONNECT, RESOURCE TO MYSTAR;


2) MYSTAR에 연결하여 NOTE라는 테이블 객체를 생성하고 레코드를 INSERT 한다.
CONN MYSTAR/MYSTAR
CREATE TABLE NOTE(
    NO NUMBER,
    MSG VARCHAR2(30)
    );
INSERT INTO NOTE VALUES(1,'안녕하세요');
INSERT INTO NOTE VALUES(2,'방가 방가^^');
COMMIT;

3) MYSTAR 사용자가 SCOTT사용자에게 NOTE테이블 조작할 권한을 준다.(OBJECT)
GRANT ALL ON NOTE TO SCOTT;

CREATE SYNONYM A FOR MYSTAR.NOTE;

4) SCOTT로 연결해서 NOTE를 조회한다.
SELECT * FROM MYST.NOTE

4) SYSTEM으로 연결하여 SCOTT에게 동의어를 생성할 권한을 준다.
CONN SYSTEM/Abcd1234
GRANT CREATE SYNONYM TO SCOTT

5) SCOTT에 연결하여 MYSTAR의 NOTE테이블에 대한 동의어를 생성한다.
CREATE SYNONYM A FOR MYSTAR.NOTE;
=> MYSTAR 사용자의 NOTE테이블에 SCOTT사용자가 A라는 동의어로 사용하겠다는 의미

6) 동의어를 이용한 쿼리 전송
SELECT * FROM A; == SELECT * FROM MYSTAR.NOTE;

7) DD에서 조회
SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE = UPPER('SYNONYM');

8) SYNONYM 삭제
DROP SYNONYM SYNONYM_NAME







--------------------------------------------------------------------------------
[3] 권한 부여
시스템 권한 부여 예제
conn system/Abcd1234;

(1) WITH ADMIN OPTION 
: 권한을 부여 받은 사용자도 부여 받은 권한을 다른 사용자 또는 역할로 부여할 수 있게 되며, 
  만약 사용자가 WITH ADMIN OPTION과 같이 역할을 부여 받는다면 부여된 역할은 그 사용자에 의해 변경 또는 삭제 될 수 있습니다. 

1) 시스템 부여 WITH ADMIN OPTION을 주어 부여해보자;
GRANT CREATE USER, ALTER USER, DROP USER TO MYSTAR WITH ADMIN OPTION;

2) mystar로 접속해서 다른 user를 생성해보자
conn mystar/mystar;

CREATE USER storm identified by storm;
=> storm도 다른 user를 생성할 권한을 갖는다.

3) mystar가 storm user의 비밀번호을 변경해보자
ALTER USER STORM IDENTIFIED BY TIGER;

4) MYSTAR가 STORM USER를 삭제해보자
DROP USER STORM;




--------------------------------------------------------------------------------
[4] 권한 회수
REVOKE 권한|룰 FROM USER |룰


1) SYSTEM으로 접속해서 MYSTAR의 권한 중 ALTER USER, DROP USER의 권한을 회수해보자
CONN SYSTEM/Abcd1234;
SHOW USER;
REVOKE ALTER USER, DROP USER FROM MYSTAR;

2) MYSTAR로 접속해서 STORM을 다시 생성해본다. 
CONN mystar/mystar;
CREATE USER STORM IDENTIFIED BY STORM;

3) STORM의 비밀번호를 TIGER로 변경해보자
ALTER USER STROM IDENTIFIED BY TIGER;


Q. 시나리오
1) DBA가 STORM에게 WITH ADMIN OPTION을 사용하여 CREATE TABLE, CREATE SESSTION 시스템 권한을 부여 합니다. 
GRANT CREATE TABLE, CREATE SESSTION TO STORM WITH ADMIN OPTION

2) STORM이 테이블을 생성 합니다. (NOTE NO(NUMBER), MSG(VARCHAR2(30))
=> ORA-01950: no privileges on tablespace 'SYSTEM'
=> 생성 권한은 있지만 자원에 대한 권한을 부여받지 않음

CONN SYSTEM/Abcd1234
ALTER USER STORM QUOTA 2M ON SYSTEM
=> 2M 할당

CREATE TABLE NOTE(
  NO NUMBER,
  MSG VARCHAR2(30)
);

3) SYSTEM으로 접속해서 MILLER USER를 생성하고, MILLER에게 CREATE SESSION 권한을 부여한다
CONN SYSTEM/Abcd1234
CREATE USER miller IDENTIFIED BY miller;
GRANT CREATE SESSION TO miller;

ALTER USER miller QUOTA UNLIMITED ON SYSTEM; 
=> 저장 공간을 무제한으로 사용할 수 있도록 설정


4) STORM이 CREATE TABLE 시스템 권한을 MILLER에게 부여 합니다
conn STORM/STORM
grant create table to miller;

5) MILLER가 테이블을 생성 합니다. 
CONN miller/miller
create table note(
  no number,
  msg varchar2(30)
  );

6) DBA가 STORM에게 부여한 CREATE TABLE 시스템 권한을 취소 합니다.
CONN SYSTEM/Abcd1234
REVOKE CREATE TABLE FROM STORM;

5) STORM이 CREATE TABLE 시스템 권한을 MILLER에게 부여 합니다. 
CONN STORM/STROM
GRANT CREATE TABLE TO miller;

6) MILLER가 테이블을 생성 합니다. ( MILLER의 CREATE TABLE 권한은? 그대로 존재함)
conn miller/miller
CREATE TABLE 

결론 : WITH ADMIN OPTION 으로 주웠던 권한을 STORM에게 취소를 해도 MILLER의 CREATE TABLE 권한은 취소되지 않는다!.








--------------------------------------------------------------------------------
[5] 객체 권한 Object Privileges
: 객체 권한은 유저가 소유하고 있는 특정한 객체를 다른 사용자들이 엑세스 하거나 조작 할 수 있게 하기 위해서 생성을 합니다. 
: 테이블이나 뷰, 시퀀스, 프로시저, 함수, 또는 패키지 중 지정된 한 오브젝트에 특별한 작업을 수행 할 수 있게 합니다. 

: Object 소유자는 다른 사용자에게 특정 Object Privileges를 부여 할 수 있습니다. 
: PUBLIC으로 권한을 부여하면 회수할 때도 PUBLIC으로 해야 합니다. 
: Object Privileges는 Object Type에 따라서 다릅니다. 
: 기본적으로 소유한 오브젝트에 대한 모든 권한이 자동적으로 획득됩니다
: WITH GRANT OPTION 옵션은 '롤' 에 권한을 부여할 때는 사용할 수 없습니다


* Object에 따른 Privileges
----------------------------------------------------------------
객체권한	    테이블	     뷰	        Sequence	  Procedure
---------------------------------------------------------------- 
ALTER	     ○	         ○
----------------------------------------------------------------

DELETE       ○		     ○
----------------------------------------------------------------

EXECUTE							                      ○
----------------------------------------------------------------

INDEX	     ○  
----------------------------------------------------------------  
INSERT	     ○		     ○
----------------------------------------------------------------
REFERENCES   ○
----------------------------------------------------------------
SELECT	     ○		     ○           ○
----------------------------------------------------------------  
UPDATE	     ○		     ○
----------------------------------------------------------------  

  위의 표에서 맨 왼쪽에 있는 ALTER, DELETE, EXECUTE.. 등등은 object_privilege란에 오면 되고, 
맨 윗줄에 있는 테이블, 뷰, 시퀀스, 프로시져 등등은 ON 다음에 있는 object에 입력하면 됨. 

(1) 구문(Syntax)
GRANT object_privilege [column] ON object
  TO {user[,user] | role |PUBLIC]
  [WITH GRANT OPTION]

실습. 객체 권한
1) scott 접속 
grant select, insert on emp to STORM with grant option;

2) STORM 접속
select ename,job from scott.emp;
insert into scott.emp(empno,ename,job) values(8100,'JAMES','MANAGER');
commit;

3) STORM이 SCOTT.EMP 테이블에 select하는 권한을 MILLER에게 부여를 해본다.
grant select on scott.emp to miller;

4) miller로 접속한 후 scott.emp 테이블을 조회해본다.
conn miller/miller;
select ename, job from scott.emp;

5) scott이 STORM에게 부여했던 select, insert on emp에 대한 권한을 회수한다.
revoke select, insert on emp from STORM;

6) STORM으로 접속하여 select문 실행
conn STORM/STORM
select ename from scott.emp; 
=> ERROR 발생 ORA-00942: table or view does not exist

7) miller로 접속하여 select 문 실행
conn miller/miller
select ename from scott.emp;
=> ERROR 발생 ORA-00942: table or view does not exist

결론
: WITH GRANT OPTION을 사용하여 객체 권한 취소
: WITH GRANT OPTION을 사용하여 부여한 객체 권한을 취소하면 취소 작업이 연쇄적으로 수행 됩니다.





--------------------------------------------------------------------------------
[6] ROLE
: 사용자에게 허가할 수 있는 권한들의 집합

: ROLE을 이용하면 권한 부여와 회수를 쉽게 할 수 있습니다. 
: ROLE은 Create Role권한을 가진 User에 의해서 생성 됩니다.　 
: 한 사용자가 여러개의 ROLL을 ACCESS할 수 있고,  여러 사용자에게 같은 ROLE을 부여할 수 있습니다. 
: 시스템 권한을 부여하고, 취소할 때와 동일한 명령을 사용하여 사용자에게 부여하고, 취소 합니다. 
: 사용자는 ROLE에 ROLE을 부여할 수 있습니다. 
: 오라클 데이터베이스를 설치하면 기본적으로 CONNECT, RESOURCE, DBA ROLE이 제공됩니다.

=> 아래의 그림처럼 DBA가 유저들에게 권한을 부여할 때 일일이 권한 하나하나씩을 지정을 한다면 몹시 불편할 것 입니다. 
   DBA가 USER의 역할에 맞도록 Role을 생성하여서 Role만 유저에게 지정을 한다면 보다 효율적으로 유저들의 권한을 관리 할 수 있습니다. 
   
(1) ROLE 생성 및 부여

1) ROLE의 생성 : CREATE ROLE ROLE_NAME;
CREATE ROLE manager;

2) ROLE에 권한 부여 : GRANT 권한1,권한2 TO ROLE_NAME; (USER_NAME : SYSTEM)

Q. manager ROLE에 CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SYNONYM 권한을 부여하라.
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SYNONYM 
TO manager;

=> DD에서 조회
- DBA_ROLES
SELECT * FROM DBA_ROLES;
- DBA_SYS_PRIVS
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'MANAGER';
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'CONNECT';
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RESOURCE';


3) ROLE을 사용자에게 부여 : GRANT ROLE_NAME TO USER_NAME;
Q. manager ROLE을 miller에게 부여해보자
grant manager to miller;


4) 사용자에서 확인해보기
conn miller/miller
create view miller_view as select * from note;
=> 정상적으로 VIEW 생성

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'DBA';















