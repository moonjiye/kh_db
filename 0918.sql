-- GROUP BY : 여러 데이터에서 의미있는 하나의 결과를 특정 열 값별로 묶어서 출력할때 사용
SELECT ROUND(AVG(SAL),2) AS 사원전체평균
FROM EMP;

-- 부서별 사원 평균
SELECT DEPTNO, ROUND(AVG(SAL),2) AS 부서별평균
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- GROUP BY 절 없이 구현한다면?
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 10;
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 20;
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 30;

-- 집합연산자를 사용하여 구현하기
SELECT AVE(SAL) FROM EMP WHERE DEPTNO = 10;
UNION ALL
SELECT AVE(SAL) FROM EMP WHERE DEPTNO = 20;
UNION ALL
SELECT AVE(SAL) FROM EMP WHERE DEPTNO = 30;

-- 부서코드, 급여 합계, 부서 평균, 부서 코드 순 정렬
SELECT DEPTNO AS 부서코드,
    SUM(SAL) AS 합계,
    ROUND(AVG(SAL), 2) AS 평균,
    COUNT(*) AS 인원수 /* 각 부서별 인원 수 */
GROUP BY DEPTNO
ORDER BY DEPTNO; 

-- HAVING 절 : GROUP BY 절이 존재하는 경우에만 사용 가능
-- GROUP BY 절을 통해 그룹화된 결과 같의 범위를 제한할 때 사용 
-- 먼저 부서별, 직책별로 그룹화하여 평균을 구함
-- 그다음 각 그룹별 급여 평균이 2000이 넘는 그룹을 출력함
SELECT DEPTNO, JOB, ROUND(AVG(SAL), 2)
FROM EMP
GROUP BY DEPTNO, JOB -- 각자의 그룹핑 느낌
    HAVING AVG(SAL) >= 2000
ORDER BY DEPTNO, JOB; 
/* 존재하는 각 부서별로, 직업별로, 그룹핑별로 묶고 HAVING 절의 조건에 해당하는것 출력
HAVING 절에는 그룹에 묶여있는 집계함수가 아닌 건 넣어주면 안됨.  */


-- WHERE 절을 사용하는 경우
-- 먼저 급여가 2000 이상인 사원들을 골라냄
-- 조건에 맞는 사원 중에서 부서별, 직책별, 급여의 평균을 구해서 출력
SELECT DEPTNO, JOB, ROUND(AVG(SAL), 2)
FROM EMP
WHERE SAL >= 2000
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, JOB; 
-- FROM 절 -> 부서별-> 직책 (그룹) -> 평균 -> 
-- 다 골라내고 각 2000이상인 사람만 그룹으로 묶음


-- 1. 부서별 직책의 평균 급여가 500 이상인 사원들의 부서번호, 직책, 부서별 직책의 평균 급여 출력
SELECT DEPTNO, JOB, AVG(SAL)
FROM EMP
GROUP BY DEPTNO, JOB
HAVING AVG(SAL) >= 500
ORDER BY DEPTNO, JOB;

-- 2. 부서번호, 평균급여, 최고급여, 최저급여, 사원수를 출력
-- (단, 평균 급여를 출력 할 때는 소수점 제외하고 부서 번호별로 출력)
SELECT DEPTNO AS "부서번호", 
    TRUNC(AVG(SAL)) AS "평균 급여",
    MAX(SAL) AS "최고 급여",
    MIN(SAL) AS "최저 급여",
    COUNT(*) AS "사원수"
FROM EMP
GROUP BY DEPTNO;

-- 3. 같은 직책에 종사하는 사원이 3명 이상인 직책과 인원을 출력
SELECT JOB AS "직업",
    COUNT(*) AS "사원수"
FROM EMP
GROUP BY JOB
HAVING COUNT(*) >= 3;

-- 4. 사원들의 입사 연도를 기준으로 부서별로 몇 명이 입사했는지 출력
SELECT
    -- EXTRACT(YEAR FROM HIREDATE) "입사일"
    TO_CHAR(HIREDATE, 'YYYY') AS "입사일",
    DEPTNO AS "부서번호",
    COUNT(*) AS "사원수"
FROM EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY'), DEPTNO
ORDER BY TO_CHAR(HIREDATE, 'YYYY');

-- 5. 추가 수당을 받는 사원 수와 받지 않는 사원수를 출력 (O, X로 표기 필요)
SELECT NVL2(COMM, 'O', 'X') AS "추가수당", -- NULL이 아닌경우, 맞는경우
    COUNT(*) AS "사원수"
FROM EMP
GROUP BY NVL2(COMM, 'O', 'X');

-- 6. 각 부서의 입사 연도별 사원 수, 최고 급여, 급여 합, 평균 급여를 출력
SELECT DEPTNO,
    TO_CHAR(HIREDATE, 'YYYY') AS "입사년도",
    COUNT(*) AS "사원수",
    MAX(SAL) AS "최고급여",
    SUM(SAL) AS "합계",
    TRUNC(AVG(SAL)) AS "평균급여"
FROM EMP
GROUP BY DEPTNO, TO_CHAR(HIREDATE, 'YYYY')
ORDER BY DEPTNO,TO_CHAR(HIREDATE, 'YYYY');                                                                                                                    

-- 그룹화와 관련된 여러 함수 : ROLLUP, CUBE ...
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY DEPTNO, JOB;
ORDER BY DEPTNO, JOB;

--ROLLUP : 명시한 열을 소그룹부터 대그룹의 순서로 
-- 각 그룹별 결과를 출력하고 마지막에 총 데이터 결과를 출력
-- 각 부서별 중간 결과를 보여줌
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB);

-- JOIN : 두 개 이상의 테이블에서 데이터를 가져와서 연결하는데 사용하는 SQL의 기능
-- RDMS에서는 테이블 설계시 무결성 원칙으로 인해 동일한 정보가 여러 군데 존재하면 안되기 때문에
-- 필연적으로 테이블을 관리 목적에 맞게 설계함.
SELECT * FROM EMP, DEPT; -- 부서테이블, JOIN을 하지 않으면 모든 열이 결합

-- 열 이름을 비교하는 조건식으로 조인하기
-- 같은 역할을 하는 놈 쪼인
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO -- 기준열, 모든 열에 대한 단합
ORDER BY EMPNO; 

-- 테이블 별칭 사용하기
SELECT * --3
FROM EMP E, DEPT D --1
WHERE E.DEPTNO = D.DEPTNO --2
ORDER BY EMPNO; --4

-- 조인 종류 : 두 개 이상의 테이블을 하나의 테이블처럼 가로로 늘려서 출력하기 위해 사용
-- 조인은 대상 데이터를 어떻게 연결하느냐에 따라 등가, 비등가, 자체, 외부 조인으로 구분
-- 등가 조인 : 테이블을 연결한 후 출력행을 각 테이블의 특정 열에 일치한 데이터를 기준으로 선정하는 방식
-- 등가 조인에는 안시(ANSI) 조인과 오라클 조인이 있다.
-- 안시 : 아메리칸 표준

-- 오라클조인
SELECT EMPNO, ENAME, D.DEPTNO, DNAME, LOC --양쪽에 모두 존재하기 때문에 모호성이 생겨 D.를 명시해줘야한다.
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO AND E.DEPTNO = 10
ORDER BY D.DEPTNO;

SELECT EMPNO, ENAME, D.DEPTNO, SAL, DNAME, LOC --양쪽에 모두 존재하기 때문에 모호성이 생겨 D.를 명시해줘야한다.
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO AND SAL >= 3000
ORDER BY D.DEPTNO;

-- ANSI 조인. 직관적
SELECT EMPNO, ENAME, D.DEPTNO, DNAME, LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
WHERE E.DEPTNO = 10
ORDER BY D.DEPTNO;

/* 차이 
오라클조인 : WHERE 조건에 연속적 으로 나열
JOIN ON : 직관적으로 구분이 가능
*/

-- 문제 -- 
-- EMP 테이블 별칭을 E로, DEPT 테이블 별칭은 D로 하여 다음과 같이 등가 조인을 했을때
-- 급여가 2500 이하이고 사원번호가 9999 이하인 사원의 정보가 출력되도록 작성(ANSI, 오라클 조인)
-- 오라클조인
SELECT EMPNO, ENAME, SAL, E.DEPTNO, DNAME, LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO -- 동등 조인, 이너 조인 (두 테이블이 일치하는 데이터만 선택)
AND SAL <= 2500 
AND E.EMPNO <= 9999
ORDER BY EMPNO;

-- ANSI 조인
SELECT EMPNO, ENAME, SAL, E.DEPTNO, DNAME, LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE SAL <= 2500 AND E.EMPNO <= 9999
ORDER BY EMPNO;

-- 비등가 조인 : 동일 컬럼(열, 레코드)이 없이 다른 조건을 사용하여 조인할 때 사용(일반적인 경우는 아님)
SELECT * =FROM EMP;
SELECT * FROM SALGRADE;

SELECT E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S -- 두 개의 테이블을 연결
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL; -- 비등가 조인

-- ANSI 조인으로 번경
SELECT ENAME, SAL, GRADE
FROM EMP E JOIN SALGRADE S
ON SAL BETWEEN LOSAL AND HISAL; -- 테이블 이름은 생략가능

-- 자체 조인 : SELF 조인이라고도 함. 같은 테이블을 두 번 사용하여 자체 조인
-- EMP 테이블에서 직속상관의 사원번호는 MGR에 있음.
-- MGR을 이용해서 상관의 이름을 알아내기 위해서 사용할 수 있음.
SELECT E1.EMPNO, E1.ENAME, E1.MGR, --같은 이름이 여러개 나오기 때문에 명확히 지정
    E2.EMPNO AS 상관사원번호,
    E2.ENAME AS 상관이름
FROM EMP E1, EMP E2
WHERE E1.MGR = E2.EMPNO;

-- 외부 조인 : 동등 조인의 경우 한쪽의 컬럼이 없으면 해당 행으로 표시되지 않음
-- 외부 조인은 내부 조인과 다르게 다른 한쪽에 값이 없어도 출력됨
-- 외부 조인은 동등 조인 조건을 만족하지 못해 누락되는 행을 출력하기 위해 사용

INSERT INTO EMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
    VALUES(9000, '장원영', 'SALES', 7698, SYSDATE, 2000, 1000, NULL);

-- 왼쪽 외부 조인 사용하기
SELECT ENAME, E.DEPTNO, DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO(+) -- 왼족 기준으로 오른쪽을 채움. 오른쪽이 비어있기 때문에 (+)는 오른쪽
ORDER BY E.DEPTNO; 

SELECT * FROM DEPT;

-- 오른쪽 외부 조인 사용하기
SELECT E.ENAME, D.DEPTNO, D.DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO -- 오른쪽 기준으로 왼쪽을 채움
ORDER BY E.DEPTNO;

-- SQL-99 표준 문법으로 배우는 ANSI 조인
-- NATURAL JOIN : 등가조인 대신 사용, 자동으로 같은 열을 찾아서 조인해줌
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, DEPTNO
FROM EMP NATURAL JOIN DEPT;

-- JOIN ~ USING : 등가 조인을 대신해서 사용, USING 키워드에 조인 기준 열을 명시하여 사용
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, DEPTNO
FROM EMP E JOIN DEPT D USING(DEPTNO); -- 조인해줘야할 테이블

-- JOIN ~ ON : ANSI 등가 조인
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, E.DEPTNO
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

-- ANSI LEFT OUTER JOIN
SELECT ENAME, E.DEPTNO, DNAME
FROM EMP E LEFT OUTER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
ORDER BY E.DEPTNO; 

-- ANSI RIGHT OUTER JOIN
SELECT E.ENAME, D.DEPTNO, D.DNAME
FROM EMP E RIGHT OUTER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
ORDER BY E.DEPTNO; 


SELECT * FROM EMP, DEPT;
-- 문제 --
-- 1. 급여가 2000 초과인 사원들의 부서 정보, 사원 정보를 출력(오라클과 ANSI)
SELECT DEPTNO, DNAME, E.EMPNO, E.ENAME, E.SAL
FROM EMP E NATURAL JOIN DEPT D
WHERE E.SAL > 2000;

-- 2. 각 부서별 평균 급여, 최대 급여, 최소 급여, 사원수를 출력
SELECT DEPTNO,
    TRUNC(AVG(SAL)) AS "평균",
    MAX(SAL) AS "최대 급여",
    MIN(SAL) AS "최소 급여",
    COUNT(*) AS "사원수"
FROM EMP E JOIN DEPT D USING (DEPTNO)
GROUP BY DEPTNO;

-- 3. 모든 부서 정보와 사원 정보를 오른쪽과 같이 부서 번호, 사원 이름순으로 정렬하여 출력
SELECT D.DEPTNO, D.DNAME, E.EMPNO, E.ENAME, E.JOB, E.SAL
FROM EMP E RIGHT OUTER JOIN DEPT D 
ON E.DEPTNO = D.DEPTNO
ORDER BY D.DEPTNO, E.ENAME;

-- 서브쿼리 : 어떤 상황이나 조건에 따라 변할 수 있는 데이터 값을 비교하기 위해,
-- SQL문 안에 작성하는 작은 SELECT 문을 의미합니다.
-- 'KING'이라는 이름을 가진 사원의 부서 이름을 찾기 위한 쿼리
SELECT DNAME FROM DEPT
WHERE DEPTNO = (SELECT DEPTNO FROM EMP WHERE ENAME = 'KING');

-- 사원 'JONES'의 급여보다 높은 급여를 받는 사원 정보 출력하기
SELECT *
FROM EMP
WHERE SAL > (SELECT SAL FROM EMP 
            WHERE ENAME = 'JONES'); -- 이름명이 나올 수 있기때문에 모호성을 가질 수 있음

-- EMP 테이블의 사원 정보 중에서 사원이름이 'ALLEN'인 사원의 추가 수당보다 많은 추가 수당을 받는 사원 출력
SELECT *
FROM EMP
WHERE COMM > (SELECT COMM FROM EMP WHERE ENAME = 'ALLEN');

-- 'JAMES'보다 이전에 입사한 사원 출력
SELECT * FROM EMP
WHERE HIREDATE < (SELECT HIREDATE FROM EMP WHERE ENAME = 'JAMES');

-- 20번 부서에 속한 사원 중 전체 사원의 평균 급여보다 높은 급여를 받는 
-- 사원 정보와 소속 부서 정보를 조회하는 경우에 대한 쿼리를 작성
SELECT EMPNO, ENAME, JOB, SAL, D.DEPTNO, DNAME, LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.DEPTNO = 20
AND SAL > (SELECT AVG(SAL) FROM EMP);

-- 다중행 서브쿼리 : 서브쿼리의 실행 결과 행이 여러 개가 나오는 서브 쿼리
-- IN : 메인쿼리의 데이터가 서브쿼리의 결과 중 하나라도 일치하면 True
-- 각 부서별 최대 급여와 동일한 급여를 받는 사원 정보를 출력
SELECT *
FROM EMP
WHERE SAL IN (SELECT MAX(SAL) FROM EMP
            GROUP BY DEPTNO);

-- ANY : 메인 쿼리의 비교 조건이 서브 쿼리의 여러 검색 결과 중 하나 이상 만족되면 반환
SELECT EMPNO, ENAME, SAL 
FROM EMP
WHERE SAL > ANY (SELECT SAL 
                FROM EMP
                WHERE JOB = 'SALESMAN');

-- 30번 부서 사원들의 급여보다 적은 급여를 받는 사원 정보 출력
-- ALL : 모든 조건을 만족하는 경우에 성립
SELECT *
FROM EMP
WHERE SAL < ALL(SELECT SAL
                FROM EMP
                WHERE DEPTNO = 30);
                -- 950 보다 작은 사람 출력

SELECT EMPNO, ENAME, SAL
FROM EMP 
WHERE SAL > ALL(SELECT SAL
                FROM EMP
                WHERE JOB = 'MANAGER');

-- EXISTS 연산자 : 서브쿼리의 결과값이 하나 이상 존재하면 조건식이 모두 참, 존재하지 않으면 모두 거짓
SELECT *
FROM EMP
WHERE EXISTS (SELECT DNAME
                FROM DEPT 
                WHERE DEPTNO = 10);

-- 다중 열 서브 쿼리 : 서브 쿼리의 결과가 두 개 이상의 컬럼으로 반환되어 메인 쿼리에 전달하는 쿼리
SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, SAL 
                        FROM EMP 
                        WHERE DEPTNO = 30);

-- GROUP BY 절이 포함된 다중열 서브쿼리
SELECT *
FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL)
                        FROM EMP
                        GROUP BY DEPTNO);

