-- 정렬을 위한 ORDER BY 절
SELECT * FROM EMP
ORDER BY SAL asc; -- ASC 는 오름차순

-- 사원번호 기준으로 오름차순 정렬
SELECT * FROM EMP
ORDER BY SAL DESC;

-- 여러 컬럼 기준으로 정렬하기
-- 정렬 조건이 없으면 기본적으로 오름차순
-- 급여순으로 정렬하고 급여가 같은 경우 이름순 정렬
SELECT * FROM EMP
ORDER BY SAL, ENAME DESC; -- 오름차순 정렬 이후 이름 기준 내림 차순

-- 연결 연산자 : SELECT 문 조회 시 컬럼 사이에 특정한 문자를 넣고 싶을 때 사용
SELECT ENAME || 'S JOB IS ' || JOB as EMPLOYEE
FROM emp;

--  실습문제 ----------------------------------------------------------------
-- 1. 사원이름이 S로 끝나는 사원 데이터 출력
SELECT * FROM EMP
WHERE ENAME LIKE '%S';

-- 2. 30번 부서에서 근무하는 사원 중 직책이 
--    SALESMAN인 사원의 사원번호, 이름, 직책, 급여, 부서번호 출력
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
from EMP
WHERE DEPTNO = 30 AND JOB = 'SALESMAN';

-- 3. 20번, 30번 부서에 근무하는 사원 중 급여 2000 초과인 사원의
--    사원번호, 이름, 급여, 부서 번호 출력
SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO IN (20, 30) AND SAL > 2000;

-- 4. BETWEEEN 연산자 사용하지 않고 급여가 2000이상 3000이하 데이터 출력
SELECT * FROM EMP
WHERE SAL >= 2000 and sal <= 3000; 

-- 5. 사원 이름에 E가 포함되어 있는 30번 부서의 사원 중 급여가 
--    1000 ~ 2000 사이가 아닌 사원 이름, 사원 번호, 급여, 부서 번호 출력
SELECT ENAME, EMPNO, SAL, DEPTNO 
FROM EMP
WHERE DEPTNO = 30
AND ENAME LIKE '%E%'
AND SAL NOT BETWEEN 1000 AND 2000;

-- 6. 추가 수당이 존재하지 않고, 상급자가 있고, 직책이 MANAGER, CLERK인 사원에서
--    사원 이름의 두 번째 글자가 L이 아닌 사원의 정보를 출력
SELECT * FROM EMP
WHERE COMM is NULL
and MGR is not NULL
and job IN ('MANAGER', 'CLERK')
and ename not like '_L%';

-- 1. EMP테이블에서 COMM 의 값이 NULL이 아닌 정보 조회
SELECT * FROM EMP
WHERE COMM IS NOT NULL;
-- 2. EMP테이블에서 커미션을 받지 못하는 직원 조회
SELECT *
FROM EMP
WHERE COMM IS NULL OR COMM = 0;
-- 3. EMP테이블에서 관리자(MGR)가 없는 직원 정보 조회
SELECT *
FROM EMP
WHERE MGR IS NULL;
-- 4. EMP테이블에서 급여를 많이 받는 직원 순으로 조회
SELECT *
FROM EMP
ORDER BY SAL DESC;
-- 5. EMP테이블에서 급여가 같을 경우 커미션을 내림차순 정렬 조회
SELECT *
FROM EMP
ORDER BY SAL DESC, COMM DESC;
-- 6. EMP테이블에서 사원번호, 사원명, 직급, 입사일 조회 (단, 입사일을 오름차순 정렬 처리)
SELECT EMPNO, ENAME, JOB, HIREDATE
FROM EMP
ORDER BY HIREDATE;
-- 7. EMP테이블에서 사원번호, 사원명 조회 (사원번호 기준 내림차순 정렬)
SELECT EMPNO, ENAME
FROM EMP
ORDER BY EMPNO DESC;
-- 8. EMP테이블에서 사번, 입사일, 사원명, 급여 조회  
--    (부서번호가 빠른 순으로, 같은 부서번호일 때는 최근 입사일 순으로 처리)
SELECT EMPNO, HIREDATE, ENAME, SAL, DEPTNO
from EMP
ORDER BY DEPTNO, HIREDATE DESC;

-- 함수 --
-- 오라클에서 함수는 내장 함수 사용자 정의 함수로 나누어 짐
-- 내장 함수는 단일행 함수와 다중행(집계)함수로 나누어 짐
-- DUAL 테이블 : 오라클의 SYS 계정에서 제공하는 테이블로 함수나 
-- 계산식에서 테이블 참조없이 실행해 보기 위해 제공 됨 (DUMMY 테이블)

-- ABS : 절대값을 구하는 함수
SELECT -10, abs(-10) from DUAL;

-- ROUND : 반올림한 결과를 반환하는 함수 : ROUND(숫자, 반올림 위치), 위치는 음수값도 줄수
SELECT ROUND(1234.5678) as ROUND, 
    ROUND(1234.5678, 0) as ROUND_0,
    ROUND(1234.5678, 1) as ROUND_1, 
    ROUND(1234.5678, 2) as ROUND_2,
    ROUND(1234.5678, -1) as ROUND_MINUS1,
    ROUND(1234.5678, -2) as ROUND_MINUS2
from DUAL;

-- TRUNC : 버림한 결과를 반환하는 함수
SELECT TRUNC(1234.5678) as TRUNC, 
    TRUNC(1234.5678, 0) as TRUNC_0,
    TRUNC(1234.5678, 1) as TRUNC_1, 
    TRUNC(1234.5678, 2) as TRUNC_2,
    TRUNC(1234.5678, -1) as TRUNC_MINUS1,
    TRUNC(1234.5678, -2) as TRUNC_MINUS2
from DUAL;

-- MOD : 나누기한 나머지를 출력하는 함수
SELECT MOD(21, 5) FROM dual;

-- CEIL : 소수점 이하를 무조건 올림
SELECT CEIL(12.0000001) FROM dual;

-- FLOOR : 소수점 이하를 모조건 내림
SELECT FLOOR(12.99999999) FROM dual;

-- POWER : 정수A를 정수 B만큼 제곱하는 함수 (3, 4)
SELECT POWER(3, 4) FROM DUAL;