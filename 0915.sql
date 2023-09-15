-- 문자 함수 : 문자 데이터를 가공하는것
SELECT ENAME, UPPER(ENAME), LOWER(ENAME),INITCAP(ENAME)
FROM EMP;

SELECT * 
FROM EMP
WHERE UPPER(ENAME) = UPPER('james');

-- LENGTH : 문자열 길이를 반환
-- LENGTHB : 문자열의 바이트 수 반환
SELECT LENGTH('한글'), LENGTHB('한글')
FROM DUAL;

-- SUBSTR / SUBSTRB : 문자열을 자름
-- 데이터베이스 시작 위치가 0이 아님, 2번째 매개변수는 길이, 3번째 매개변수를 생략하면 끝까지
SELECT JOB, SUBSTR(JOB, 1, 2), SUBSTR(JOB,3,2), SUBSTR(JOB, 5)
FROM EMP;

SELECT JOB,
SUBSTR(JOB, -LENGTH(JOB)),  -- 음수는 뒤에서 계산, 길이에 대한 음수값으로 역순 접근
SUBSTR(JOB, -LENGTH(JOB),2), -- SALESMAN, -8이면 S위치에서 길이가 2만큼 출력
SUBSTR(JOB, -3)
FROM EMP;

-- INSTR : 문자열 데이터 안에 특정 문자나 문자열이 어디에 포함되어 있는지 알고자 할 때 사용
SELECT INSTR('HELLO, ORACLE!','L') AS INSTR_1,
    INSTR('HELLO, ORACLE!','L',5) AS INSTR_2, -- 3번째 인자로 찾을 시작 위치 지정
    INSTR('HELLO, ORACLE!', 'L',2,2) AS INSTR_3 -- 3번째 인자는 시작위치, 4번째 인자는 몇번째 인지
FROM DUAL;

-- 특정 문자가 포함된 행 찾기
SELECT *
FROM EMP
WHERE INSTR(ENAME, 'S') > 0; -- 인덱스로 반환.

SELECT * FROM EMP
WHERE ENAME LIKE '%S%';

-- REPLACE : 특정 문자열 데이터에 포함된 문자를 다른 문자로 대체할 경우 사용
-- 대체할 문자를 넣지 않으면 해당 문자 삭제
SELECT '010-1234-5678' AS REPLACE_BEFORE,
    REPLACE('010-1234-5678','-',' ') AS REPLACE_1,  -- 공백으로 대체
    REPLACE('010-1234-5678','-') AS REPLACE_2 -- 해당 문자 삭제
FROM DUAL;

-- LPAD / RPAD : 기준 공간의 칸 수를 특정 문자로 채우는 함수나
SELECT LPAD('ORACLE', 10, '+')
FROM DUAL;
SELECT RPAD('ORACLE', 10, '+')
FROM DUAL;

SELECT 'ORACLE',
    LPAD('ORACLE',10,'#') AS LPAD_1,
    RPAD('ORACLE',10,'*') AS RPAD_1,
    LPAD('ORACLE',10) AS LPAD_2,
    RPAD('ORACLE',10) AS RPAD_2
FROM DUAL;

-- 개인정보 뒷자리 *표시로 출력하기
SELECT
    RPAD('971225-', 14, '*') AS RPAD_JMNO,
    RPAD('010-1234-',13, '*') AS RPAD_PHONE
FROM DUAL;

-- 두 문자열을 합치는 CONCAT 함수
SELECT CONCAT(EMPNO, ENAME),
    CONCAT(EMPNO, CONCAT(' : ', ENAME))
FROM EMP
WHERE ENAME = 'JAMES';

-- TRIM / LTRIM / RTRIM : 문자열 내에서 특정 문자열을 지우기 위해 사용
-- 삭제할 문자를 지정하지 않으면 공백 제거( 공백 제거 용도로는 괜찮음)
-- 특정한 문자열을 지울 수 없음
SELECT '[' || TRIM(' _Oracle_ ')|| ']' AS TRIM,
'[' || LTRIM(' _Oracle_ ') || ']' AS LTRIM,
'[' || LTRIM('<_Oracle_>', '<_') || ']' AS LTRIM_2,
'[' || RTRIM(' _Oracle_ ') || ']' AS RTRIM,
'[' || RTRIM('<_Oracle_>', '_>') || ']' AS RTRIM_2
FROM DUAL;

SELECT LTRIM('             ASDFASDFASDF                   ', 'S')
FROM DUAL;