# ����� ���� ���� ����
Q. JOB���� ��� ���� 4���� ������ ����� ���� ���ܸ� �߻����� ����
- IN PARAMETER�� JOB�� �޾Ƽ� �ο��� 4�� �̸��̸� ������ �߻���Ų��.

SELECT JOB,COUNT(*)FROM EMP GROUP BY JOB;

CREATE OR REPLACE PROCEDURE USER_EXCEPT
(PJOB IN EMP.JOB%TYPE)
IS
-- ����� ���� ���� ���� [1]
BEGIN

-- RAISE ���� �̿��� ���� �߻�[2]
EXCEPTION
-- ���� ó�� �ܰ� RAISE_APPLICATION_ERROR() �Լ� Ȱ��
END;
/

select * from memo;
