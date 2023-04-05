--day07_DDL.sql
DDL: create, alter, drop, truncate, rename

# 테이블 생성 - 제약조건
<1> 컬럼 수준에서 제약하는 경우
<2> 테이블 수준에서 제약하는 경우

[1] primary key
- unique한 값 + not null

    <1> 컬럼 수준
        컬럼명 constraint 제약조건명 제약조건유형,
        ...
    create table test_tab1(
        id number(2) constraint test_tab1_id_pk primary key, 
        name varchar2(20),
        tel char(15)
    );
    
    desc test_tab1;
    insert into test_tab1 values(3,'홍길동',null);
    
    select * from test_tab1;
    
    -- 데이터 사전(data dictionary) 에서 확인
    
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME='TEST_TAB1';

    <2> 테이블 수준에서 제약
    
    CREATE TABLE TEST_TAB2(
        ID NUMBER(2),
        NAME VARCHAR2(20),
        TEL CHAR(15),
        -- 제약조건 기술
        CONSTRAINT TEST_TAB2_ID_PK PRIMARY KEY (ID)
    );
    
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME='TEST_TAB2';


CREATE TABLE TEST_TAB3(
    ID NUMBER(2) PRIMARY KEY,
    NAME VARCHAR2(20)
);
CREATE TABLE TEST_TAB4(
    ID NUMBER(2),
    NAME VARCHAR2(20),
    PRIMARY KEY(ID)
);  
    
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME='TEST_TAB4'; 
---------------------------------------------
[2] FOREIGN KEY

-- MASTER TABLE
/*
DEPTNO NUMBER(2)
DNAME CHAR(20)
LOC CHAR(15)
테이블 수준에서 DEPTNO=> pk 주기
*/

CREATE TABLE DEPT_TAB(
    DEPTNO NUMBER(2),
    DNAME CHAR(20),
    loc CHAR(15),
    CONSTRAINT DEPT_TAB_DEPTNO_PK PRIMARY KEY (DEPTNO)
);
-- DETAIL TABLE
CREATE TABLE EMP_TAB(
    EMPNO NUMBER(4) CONSTRAINT EMP_TAB_EMPNO_PK PRIMARY KEY,
    ENAME VARCHAR2(20),
    JOB VARCHAR2(10),
    -- 컬럼수준의 제약(fk)
    MGR NUMBER(4) CONSTRAINT EMP_TAB_MGR_FK REFERENCES EMP_TAB (EMPNO),
    HIREDATE DATE,
    SAL NUMBER(7,2),
    COMM NUMBER(7,2),
    DEPTNO NUMBER(2),
    --테이블 수준의 제약(fk)
    constraint emp_tab_deptno_fk foreign key(deptno) references dept_tab (deptno)
);
-- 데이터 사전에서 조회
select * from user_constraints where table_name='EMP_TAB';


ON DELETE CASCADE 옵션
-- 부모 테이블
CREATE TABLE BOARD(
NUM NUMBER(4) PRIMARY KEY,
TITLE VARCHAR2(100) NOT NULL,
CONTENT VARCHAR2(1000),
WDATE DATE DEFAULT SYSDATE);

-- 자식 테이블
CREATE TABLE REPLY(
    RNUM NUMBER(4) PRIMARY KEY,    
    RCONTENT VARCHAR2(1000),
    RWDATE DATE DEFAULT SYSDATE,
    NUM_FK NUMBER(4) REFERENCES BOARD(NUM) ON DELETE CASCADE
);

ON DELETE CASCADE 옵션을 주면 자식 레코드가 있어도
부모의 레코드를 삭제할 수 있으며, 이때 자식 레코드도 같이 삭제된다

INSERT INTO BOARD(NUM,TITLE,CONTENT)
VALUES(1,'첫 글 입니다','안녕하세요?');

INSERT INTO BOARD(NUM,TITLE,CONTENT)
VALUES(2,'두번째 글 입니다','반갑습니다');

COMMIT;
SELECT * FROM BOARD;

--1번 글에 대한 댓글 2개
INSERT INTO REPLY(RNUM,RCONTENT,NUM_FK)
VALUES(1,'댓글입니다1',1);

INSERT INTO REPLY(RNUM,RCONTENT,NUM_FK)
VALUES(2,'댓글입니다2',1);

2번 글에 대한 댓글 1개
INSERT INTO REPLY(RNUM,RCONTENT,NUM_FK)
VALUES(3,'저도 반가워요~',2);

SELECT * FROM REPLY;

BOARD 와 REPLY JOIN해서 보여주세요

SELECT B.*, R.*
FROM BOARD B LEFT OUTER JOIN REPLY R
ON B.NUM = R.NUM_FK;

-- BOARD테이블에서 1번 게시글을 삭제하세요
DELETE FROM BOARD WHERE NUM=1;
------------------------------------------
[3] UNIQUE KEY 

<1> 컬럼 수준 제약

CREATE TABLE UNI_TAB1(
    NO NUMBER(2) PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    USERID VARCHAR2(16) CONSTRAINT UNI_TAB1_USERID_UK UNIQUE,
    TEL CHAR(15)
);

CREATE TABLE UNI_TAB22(
    NO NUMBER(2) PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    USERID VARCHAR2(16) CONSTRAINT UNI_TABLE_USERID_UK22 UNIQUE,
    TEL CHAR(15)
);

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME='UNI_TAB1';

INSERT INTO UNI_TAB1
VALUES(1,'홍길동','HONG',NULL);

INSERT INTO UNI_TAB1
VALUES(2,'홍영희','HONG2',NULL);

INSERT INTO UNI_TAB1
VALUES(4,'이길동',NULL,NULL);

SELECT * FROM UNI_TAB1;
COMMIT;

<2> 테이블 수준의 제약
CREATE TABLE UNI_TAB2(
    NO NUMBER(4) PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    USERID VARCHAR2(16),
    TEL CHAR(15),
    CONSTRAINT UNI_TAB2_USERID_UK UNIQUE (USERID)
);
-----------------------------------------------------------
[4] NOT NULL
- 컬럼수준에서만 제약 가능하다.

create table nn_tab(
    deptno number(2) primary key, -- unique + not null
    dname varchar2(20) constraint nn_tab_dname_nn not null,
    loc varchar2(30) not null
);

select * from user_constraints where table_name='NN_TAB';
INSERT INTO NN_TAB VALUES(10,'ACCOUNTING','NEW YORK');
COMMIT;
SELECT * FROM NN_TAB;

[5] CHECK
<1> 컬럼 수준의 제약
CREATE TABLE CK_TAB1(
    DEPTNO NUMBER(2) CONSTRAINT CK_TAB1_DEPTNO_CK CHECK ( DEPTNO>0 AND DEPTNO <21),
    DNAME CHAR(20),
    LOC CHAR(20)
);
select * from user_constraints where table_name='CK_TAB1';

INSERT INTO CK_TAB1 VALUES(20,'ACCOUNTING','LA');
COMMIT;
SELECT * FROM CK_TAB1;

<2> 테이블 수준의 제약 : CK_TAB2
--DEPTNO값은 10,20,30,40 값만 갖도록 CHECK제약조건을 테이블 수준에서 주세요
CREATE TABLE CK_TAB2(
    DEPTNO NUMBER(2),
    DNAME CHAR(20),
    LOC CHAR(20),
    CONSTRAINT CK_TAB2_DEPTNO_CK CHECK ( DEPTNO IN (10,20,30,40))
);
INSERT INTO CK_TAB2 VALUES(11,'SALES','SEOUL');

SELECT * FROM CK_TAB2;

------------------------------------------
ALTER 문장

[1] 제약조건 추가
ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건유형 (컬럼명);

CREATE TABLE USER_TAB(
    ID NUMBER(4),
    NAME VARCHAR2(20),
    TEL CHAR(15)
);
DESC USER_TAB;

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER_TAB';

USER_TAB에 ID 컬럼에 PRIMARY KEY 제약조건을 추가하세요

ALTER TABLE USER_TAB
ADD CONSTRAINT USER_TAB_ID_PK PRIMARY KEY (ID);

[2] 제약조건 이름 변경
ALTER TABLE 테이블명 RENAME CONSTRAINT 기존제약조건명 TO 새 제약조건명;
--USER_TAB_ID_PK 이름을을 USER_TAB_PK로 변경하세요
ALTER TABLE USER_TAB RENAME CONSTRAINT USER_TAB_ID_PK TO USER_TAB_PK;

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER_TAB';

[3] 제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

--USER_TAB에 PRIMARY KEY 제약조건을 삭제하세요

ALTER TABLE USER_TAB DROP CONSTRAINT USER_TAB_PK;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='USER_TAB';
------------------------------------------------------------
# 컬럼 추가/변경/삭제

	- ALTER TABLE 테이블명 ADD (추가할 컬럼 정보 [default expr])
	- ALTER TABLE 테이블명 MODIFY (변경할 컬럼 정보 [default expr])
	- ALTER TABLE 테이블명 DROP (column 삭제할 컬럼명)
    - ALTER TABLE 테이블명 RENAME COLUMN OLD컬럼명 TO NEW컬럼명  
    
CREATE TABLE BOARD_TAB(
    NO NUMBER
);

DESC BOARD_TAB;
--
--[1] BOARD_TAB에 TITLE VARCHAR2(100) NOT NULL  컬럼을 추가하세요
ALTER TABLE BOARD_TAB ADD TITLE VARCHAR2(100) NOT NULL;
--[2] BOARD_TAB에 NAME VARCHAR2(20) 컬럼을 추가하세요
ALTER TABLE BOARD_TAB ADD NAME VARCHAR2(20);
--[3] NO컬럼명을 NUM으로 수정하세요
ALTER TABLE BOARD_TAB RENAME COLUMN NO TO NUM;
--[4] NUM의 컬럼 자료형을 CHAR(10)으로 수정하세요
ALTER TABLE BOARD_TAB MODIFY NUM CHAR(10);
--[5] NAME컬럼을 삭제하세요
ALTER TABLE BOARD_TAB DROP COLUMN NAME;

DESC BOARD_TAB;


--# 객체 이름 변경=> 테이블 이름 변경
--RENAME OLD_NAME TO NEW_NAME

--BOARD_TAB 테이블 이름을 BBS_TAB으로 변경하세요
RENAME BOARD_TAB TO BBS_TAB;
DESC BOARD_TAB;
DESC BBS_TAB;

SELECT * FROM TAB;
SELECT * FROM USER_OBJECTS WHERE OBJECT_TYPE='TABLE';

# 테이블 삭제
DROP TABLE 테이블명 [CASCADE CONSTRAINT]

BBS_TAB을 삭제하세요

DROP TABLE BBS_TAB CASCADE CONSTRAINT;
SELECT * FROM TAB;

--DROP TABLE 테이블명 PURGE;

# TRUNCATE TABLE 테이블명;
DELETE TABLE과 유사함

SELECT * FROM EMP2;

DELETE FROM EMP2;

ROLLBACK;

truncate table emp2;
-- 테이블 구조는 남기고 데이터가 모두 삭제됨
-- ddl 문장이므로 rollback이 안된다
rollback;

CREATE TABLE zipcode(
    post1 CHAR(3),
    post2 CHAR(3), 
    addr VARCHAR2(60) CONSTRAINT zipcode_addr_nn NOT NULL,
    CONSTRAINT zipcode_post_pk PRIMARY KEY (post1, post2)
);

CREATE TABLE member_tab(
    id NUMBER(4,0) CONSTRAINT member_tab_id_pk PRIMARY KEY,
    name VARCHAR2(10), 
    gender CHAR(1) 
    CONSTRAINT member_tab_gender_ck CHECK(gender IN ('F', 'M')),
    jumin1 CHAR(6),
    jumin2 CHAR(7),
    tel VARCHAR2(15),
    post1 CHAR(3),
    post2 CHAR(3),
    addr VARCHAR2(60),
    CONSTRAINT member_tab_jumin_uk UNIQUE(jumin1, jumin2),
    CONSTRAINT member_tab_post_fk FOREIGN KEY (post1, post2)
    REFERENCES zipcode (post1, post2)
);