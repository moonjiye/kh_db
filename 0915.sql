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

-- 날짜 데이터를 다루는 날짜 함수
-- SYSDATE : 운영체제의 현재 날짜와 시간 정보를 가져옴
SELECT SYSDATE FROM DUAL;

-- 날짜 데이터는 정수값으로 +,- 가능
SELECT SYSDATE AS 오늘,
    SYSDATE-1 AS 어제,
    SYSDATE+1 AS 내일
FROM DUAL;

-- 몇 개월 이후 날짜 구하는 ADD_MONTH 함수
-- 특정 날짜에 지정한 개월 수 이후의 날짜 데이터를 반환하는 함수
SELECT SYSDATE,
    ADD_MONTHS(SYSDATE, 3) -- 2번째 인자는 달수를 의미
FROM DUAL;

-- EMP테이블에서 입사 10주년이 되는 사원들 데이터 출력
SELECT EMPNO, ENAME, HIREDATE,
    ADD_MONTHS(HIREDATE, 120) AS 입사10주년
FROM EMP;

-- SYSDATE와 ADD_MONTH 함수를 사용하여 현재 날짜와 6개월 후 날짜를 출력
SELECT SYSDATE,
    ADD_MONTHS(SYSDATE, 6)
FROM DUAL;

-- 두 날짜 간의 개월 수 차이를 구하는 MONTHS_BETWEEN 함수
SELECT EMPNO, ENAME, HIREDATE, SYSDATE,
    MONTHS_BETWEEN(HIREDATE, SYSDATE) AS MONTHS1,
    MONTHS_BETWEEN(SYSDATE, HIREDATE) AS MONTH2,
    TRUNC(MONTHS_BETWEEN(SYSDATE, HIREDATE)) AS MONTH3,
    ROUND(MONTHS_BETWEEN(SYSDATE, HIREDATE)) AS MONTH4
FROM EMP;

-- 날짜 정보 추출 함수
-- EXTRACT 함수는 날짜 유형의 데이터로부터 날짜 정보를 분리하여 새로운 컬럼의 형태로 추출
SELECT EXTRACT(YEAR FROM DATE '2023-09-15'/*{YEAR| MONTH| DAY| HOUR| MINUTE| SECOND| TIMEZONE_HOUR| TIMEZONE_MINUTE| TIMEZONE_REGION| TIMEZONE_ABBR} FROM  {EXPR}*/)
FROM DUAL;

SELECT *
FROM EMP
WHERE EXTRACT(MONTH FROM HIREDATE) =12;


-- 실습 --------------------------------------------------
-- 오늘 날짜에 대한 정보 조회
SELECT SYSDATE AS 오늘 
FROM EMP;
-- EMP테이블에서 사번, 사원명, 급여 조회  (단, 급여는 100단위까지의 값만 출력 처리하고 급여 기준 내림차순 정렬)
SELECT EMPNO, ENAME, ROUND(SAL,-2)
FROM EMP
ORDER BY SAL DESC;
-- EMP테이블에서 사원번호가 홀수인 사원들을 조회
SELECT *
FROM EMP
WHERE MOD(EMPNO, 2) = 1;
-- EMP테이블에서 사원명, 입사일 조회 (단, 입사일은 년도와 월을 분리 추출해서 출력)
SELECT ENAME, EXTRACT(YEAR FROM HIREDATE) AS 년도, EXTRACT(MONTH FROM HIREDATE) AS 월
FROM EMP;
-- EMP테이블에서 9월에 입사한 직원의 정보 조회
SELECT *
FROM EMP
WHERE EXTRACT(MONTH FROM HIREDATE)=9;
-- EMP테이블에서 81년도에 입사한 직원 조회
SELECT *
FROM EMP
WHERE EXTRACT(MONTH FROM HIREDATE)=1981;
-- EMP테이블에서 이름이 'E'로 끝나는 직원 조회
SELECT *
FROM EMP
WHERE ENAME LIKE '%E';
-- EMP테이블에서 이름의 세 번째 글자가 'R'인 직원의 정보 조회
SELECT *
FROM EMP
WHERE ENAME LIKE '__R%';
-- EMP테이블에서 사번, 사원명, 입사일, 입사일로부터 40년 되는 날짜 조회
SELECT EMPNO, ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 40*12)
FROM EMP;
-- EMP테이블에서 입사일로부터 38년 이상 근무한 직원의 정보 조회
SELECT *
FROM EMP
WHERE MONTHS_BETWEEN(SYSDATE, HIREDATE) / 12 >= 38;
-- 오늘 날짜에서 년도만 추출
SELECT EXTRACT(YEAR FROM SYSDATE)
FROM DUAL;

-- 자료형을 변환하는 형 변환 함수
-- 자동 형변환 : 숫자 + 문자타입 => 숫자타입으로 자동 변환
SELECT EMPNO, ENAME, EMPNO+'500'
FROM EMP
WHERE ENAME = 'FORD';

SELECT EMPNO, ENAME, EMPNO + 'ABCD'
FROM EMP
WHERE ENAME = 'FORD';

-- 날짜, 숫자를 문자로 변환하는 TO_CHAR 함수
-- 주로 날짜 데이터를 문자 데이터로 변환하는데 사용
-- 자바의 SimpleDateFormat()과0 유사
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') AS "현재 날짜 시간" -- 별칭에 띄어쓰기 넣을때 쌍따옴표("")이용
FROM DUAL;

SELECT SYSDATE,
    TO_CHAR(SYSDATE, 'CC') AS 세기,
    TO_CHAR(SYSDATE, 'YY') AS 연도,
    TO_CHAR(SYSDATE, 'YYYY/MM/DD PM HH:MI:SS ') AS "년/월/일 시:분:초",
    TO_CHAR(SYSDATE, 'Q') AS 쿼터,
    TO_CHAR(SYSDATE, 'DD') AS 일,
    TO_CHAR(SYSDATE, 'DDD') AS 경과일,
    TO_CHAR(SYSDATE, 'HH') AS "12시간제",
    TO_CHAR(SYSDATE, 'HH12') AS "12시간제",
    TO_CHAR(SYSDATE, 'HH24') AS "24시간제",
    TO_CHAR(SYSDATE, 'W') AS 몇주차
FROM DUAL;


SELECT SYSDATE,
     TO_CHAR(SYSDATE, 'MM') AS MM,
     TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = KOREAN' ) AS MON_KOR,
     TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = JAPANESE') AS MON_JPN,
     TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS MON_ENG,
     TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = KOREAN' ) AS MONTH_KOR,
     TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = JAPANESE') AS MONTH_JPN,
     TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS MONTH_ENG
FROM DUAL;


SELECT SYSDATE,
     TO_CHAR(SYSDATE, 'MM') AS MM,
     TO_CHAR(SYSDATE, 'DD') AS DD,
     TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = KOREAN' ) AS DY_KOR,
     TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = JAPANESE') AS DY_JPN,
     TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS DY_ENG,
     TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = KOREAN' ) AS DAY_KOR,
     TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = JAPANESE') AS DAY_JPN,
     TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS DAY_ENG
FROM DUAL;

SELECT SYSDATE,
     TO_CHAR(SYSDATE, 'HH24:MI:SS') AS HH24MISS,
     TO_CHAR(SYSDATE, 'HH12:MI:SS AM') AS HHMISS_AM,
     TO_CHAR(SYSDATE, 'HH:MI:SS P.M.') AS HHMISS_PM
FROM DUAL;

SELECT SAL,
     TO_CHAR(SAL, '$999,999') AS SAL_$,
     TO_CHAR(SAL, 'L999,999') AS SAL_L,
     TO_CHAR(SAL, '999,999.00') AS SAL_1,
     TO_CHAR(SAL, '000,999,999.00') AS SAL_2,
     TO_CHAR(SAL, '000999999.99') AS SAL_3,
     TO_CHAR(SAL, '999,999,00') AS SAL_4
FROM EMP;
 -- 보여주는건 프론트엔드의 영역? 데이터분석에서는 중요할 수 있어도 백엔드에서는 중요하지 않음.


-- TO_NUMBER() : NUMBER 타입으로 형 변환
SELECT TO_NUMBER('1300')-'1500'
FROM DUAL;

--TO_DATE() : 문자열로 명시된 날짜를 날짜 타입으로 형변환
SELECT TO_DATE('22/08/20','YY/MM/DD')
FROM DUAL;

-- 1981년 6월 1일 이후에 입사한 사원 정보 출력
SELECT * FROM EMP
WHERE HIREDATE > TO_DATE('1981/06/06', 'YYYY/MM/DD');

-- NULL 처리 함수 : NULL은 값이 없음. 즉, 할당되지 않음을 의미
-- NULL은 0이나 공백과는 다른 의미, 연산불가
-- NVL (NULL인지를 검사할 열, 앞의 열 데이터가 NULL인 경우 반환할 데이터)
SELECT EMPNO, ENAME, SAL, COMM, SAL+COMM,
NVL(COMM, 0), SAL+NVL(COMM,0)
FROM EMP;

-- NVL2() : NULL이 아닌 경우와 NULL이 ㄴ경우 모두에 대해서 값을 지정할 수 있음
SELECT EMPNO, ENAME, COMM,SAL,
    NVL2(COMM, 'O', 'X') AS 성과급유무,
    NVL2(COMM, SAL*12+COMM, SAL*12) AS 연봉
FROM EMP;

-- NULLIF() : 두 값이 동일하면 NULL 반환, 아니면 첫 번째 값 반환
SELECT NULLIF(10,10), NULLIF('A','B')
FROM DUAL;

-- DECODE : 주어진 데이터 값이 조건 값과 일치하는 값 출력
-- 일치하는 값이 없으면 기본값 출력
SELECT EMPNO, ENAME, JOB, SAL,
    DECODE(JOB, 
        'MANAGER', SAL*1.1,
        'SALESMAN', SAL*1.05,
        'ANALYST', SAL,
        SAL*1.03) AS 연봉인상
FROM EMP;

-- CASE문
SELECT EMPNO, ENAME, JOB, SAL,
    CASE JOB
        WHEN 'MANGER' THEN SAL*1.1
        WHEN 'SALESMAN' THEN SAL*1.05
        WHEN 'ANALYST' THEN SAL
        ELSE SAL*1.03
    END AS 연봉인상
FROM EMP;

-- 열 값에 따라서 출력 값이 달라지는 CASE문
SELECT EMPNO, ENAME, 
    CASE
        WHEN COMM IS NULL THEN '해당사항없음' --실제 인스턴스 값부분에 찍는것이기 때문에 문자열로 들어감
        WHEN COMM = 0 THEN '수당 없음'
        WHEN COMM > 0 THEN '수당 : ' || COMM
    END AS 성과급기준
 FROM EMP;



-- 함수 실습 --------------------------------------------------
--1.
SELECT EMPNO,
    RPAD(SUBSTR(EMPNO, 1, 2), 4, '*') AS MASKING_EMPNO,
    ENAME,
    RPAD(SUBSTR(ENAME, 1, 1), LENGTH(ENAME), '*') AS MASKING_ENAME
FROM  EMP
WHERE LENGTH(ENAME) >= 5 AND LENGTH(ENAME) < 6;

--2.
SELECT EMPNO, ENAME, SAL,
    TRUNC(SAL / 21.5, 2) AS DAY_PAY,
    ROUND(SAL / 21.5 / 8, 1) AS TIME_PAY
FROM EMP;


--3.
-- NEXT_DAY(기준일자, 찾을 요일) : 기준일자 다음에 나오는 날짜를 구하는 함수
-- 기준일자 : 3개월이 지난 // 찾을 요일 : 그냥 넣어
SELECT EMPNO, ENAME, HIREDATE,
    TO_CHAR(NEXT_DAY(ADD_MONTHS(HIREDATE, 3), 'MON'), 'YYYY-MM-DD') AS R_JOB, --정직원진급
    NVL(TO_CHAR(COMM), 'N/A') AS COMM -- 바꿔야하는 이유? 없는애들중. 같은 열(타입)에 대한 값들을 둘다 문자열로 바꿔줘야함?
FROM EMP; --N/A:문자열, COMM의 값들은 숫자이므로 둘다 같은 문자열로 바꿔줘야 계산이 가능함.

--4.
SELECT EMPNO, ENAME, MGR,
    CASE
        WHEN MGR IS NULL THEN 0000
        WHEN SUBSTR(MGR, 1, 2) = '78' THEN 8888
        WHEN SUBSTR(MGR, 1, 2) = '77' THEN 7777
        WHEN SUBSTR(MGR, 1, 2) = '76' THEN 6666
        WHEN SUBSTR(MGR, 1, 2) = '75' THEN 5555
        ELSE MGR
    END AS CHG_MGR
FROM EMP;

-- 다중행 함수 : 여러 행에 대해 함수가 적용되어 하나의 결과를 나타내는 함수 (집계함수)
-- 여러 행이 입력되어 결과가 하나의 행으로 출력
SELECT SUM(SAL)
FROM EMP;

SELECT SUM(SAL), EMPNO
FROM EMP
GROUP BY ENAME;

-- GROUP BY : 그룹으로 묶을때
-- 부서별 집계
SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY DEPTNO;     -- >>> 집계 SUM 총집합 급여에 대한 총합 GROUP BY 사용\ 그룹에 대한 SUM을 먼저 정의
                    -- 내가 묶은거에 대한 총합// 모든 행에 걸쳐서 다 존재하는애는 묶지마. 


SELECT DEPTNO, SUM(SAL), COUNT(*), ROUND(AVG(SAL),2), MAX(SAL), MIN(SAL)
FROM EMP
GROUP BY DEPTNO;









