DESC MEMO;
SELECT * FROM MEMO;

-- �Ϸù�ȣ�� �����ϴ� ��ü : SEQUENCE          

CREATE SEQUENCE �������� 
START WITH ���ۼ�
INCREMENT BY ������;
[�� �� �ɼ�]

CREATE SEQUENCE MEMO_SEQ
START WITH 1
INCREMENT BY 1;

-- ������ �Ӽ� 
-- NEXTVAL : ������ ������ ���� ��ȯ
-- CURRVAL : ���� ������ �ִ� ���� ��ȯ => CURRVAL�� ���� NEXTVAL�� ȣ��� �Ŀ� ����� �� �ִ�.

INSERT INTO MEMO(NO,NAME,MSG) VALUES (MEMO_SEQ.NEXTVAL,'��ö��','�ݰ����ϴ�'); 
INSERT INTO MEMO(NO,NAME,MSG) VALUES (MEMO_SEQ.NEXTVAL,'��ö��','�ݰ����ϴ�'); 
SELECT * FROM MEMO;

SELECT MEMO_SEQ.CURRVAL FROM DUAL;
COMMIT;