# 사용자 정의 예외 예제
Q. JOB별로 사원 수가 4보다 적으면 사용자 정의 예외를 발생시켜 보자
- IN PARAMETER로 JOB을 받아서 인원이 4명 미만이면 에러를 발생시킨다.

SELECT JOB,COUNT(*)FROM EMP GROUP BY JOB;

CREATE OR REPLACE PROCEDURE USER_EXCEPT
(PJOB IN EMP.JOB%TYPE)
IS
-- 사용자 정의 예외 선언 [1]
BEGIN

-- RAISE 문을 이용해 예외 발생[2]
EXCEPTION
-- 예외 처리 단계 RAISE_APPLICATION_ERROR() 함수 활용
END;
/

select * from memo;
