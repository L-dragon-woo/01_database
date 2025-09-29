-- 9. subquery

-- ===================================
-- SUBQUERY
-- ===================================
-- 하나의 SQL문(main-query) 안에 포함되어 있는 또 다른 SQL문(sub-query)으로, 메인 쿼리가 서브 쿼리를 포함하는 종속적인 관계입니다.
-- 메인 쿼리 실행 중에 서브 쿼리를 먼저 실행해서 그 결과값을 다시 메인 쿼리에 전달하는 방식으로 동작합니다. 
-- '어떤 질문(메인쿼리)에 답하기 위해 먼저 해결해야 하는 또 다른 질문(서브쿼리)'을 처리할 때 매우 유용합니다.

# 서브쿼리(SUBQUERY) 유형
-- 1. 일반 서브쿼리
--  1-a. 단일행 일반 서브쿼리
--  1-b. 다중행 일반 서브쿼리
-- 2. 상관 서브쿼리
--  2-a. 스칼라 서브쿼리
-- 3. 인라인뷰(파생테이블)

# 규칙
-- 1.  서브쿼리는 반드시 소괄호 `()` 로 묶어야 합니다.
-- 2.  서브쿼리는 `WHERE` 절의 연산자 오른쪽에 주로 위치하지만, 
-- **`SELECT` 절이나 `FROM` 절에서도 테이블이나 컬럼처럼 사용**될 수 있습니다.
-- 3.  서브쿼리 내에서 `ORDER BY`는 일반적으로 사용할 수 없지만, 
-- **`FROM` 절에 사용되는 인라인뷰(Inline View)나 
-- `LIMIT`처럼 특정 순서의 데이터가 꼭 필요한 경우에는 예외적으로 사용**됩니다.

-- ================================
-- 일반 서브쿼리
-- ================================
-- 단일행 서브쿼리
-- 서브쿼리의 실행 결과가 오직 하나의 행만 나오는 경우를 말하며,
-- 단일행 연산자는 (=,<,<=,>,>=)와 함께 사용된다.

-- 열무김치라떼의 카테고리명은 뭘까?
-- 먼저 열무김치라떼의 category_code를 알아내고(서브쿼리), 그 코드를 이용해서 카테고리명을
-- 찾는다.(메인쿼리)

-- 1. tbl_menu에서 열무김치라떼의 카테고리 번호를 조회
SELECT 
	category_code
FROM tbl_menu
WHERE menu_name='열무김치라떼';

-- 2. tbl_category에서 해당 카테고리 번호의 카테고리명을 조회(메인쿼리)
SELECT 
category_name 
FROM tbl_category
WHERE category_code = (SELECT category_code
								FROM tbl_menu
							  WHERE menu_name='열무김치라떼'
							);

-- 민트미역국과 같은 카테고리의 메뉴조회(메뉴코드, 메뉴명, 주문가능여부)
SELECT
		 menu_code 
	  , menu_name 
	  , menu_price
	  , orderable_status 
	FROM tbl_menu
	WHERE 
		category_code = (SELECT category_code 
								FROM tbl_menu
								WHERE menu_name='민트미역국'
							);

-- 다중행 서브쿼리
-- 서브쿼리의 실행 결과가 여러개의 행으로 나오는 경우입니다.
-- 다중행 연산자는(IN, NOT IN, ANY, ALL) 와 함께 사용해야 합니다.

-- 모든 식사류 메뉴를 조회해주세요
-- '식사류'에 해당하는 카테고리 코드를 먼저 찾고 이를 서브쿼리로 먼저 조회한 후,
-- 해당 코드들에 포함(IN)되는 메뉴들을 찾기

-- 식사류 메뉴 모두 조회
SELECT category_code FROM tbl_category WHERE ref_category_code = 1;

-- 서브쿼리가 다중행을 반환하는 경우 = 연산자를 사용할 수 없다.
SELECT *
	FROM
		tbl_menu
	WHERE
		category_code IN (SELECT category_code
									FROM tbl_category c
									WHERE ref_category_code = 1
								);

-- all 연산자
-- 서브 쿼리의 결과 모두에 대해 연산결과가 참이면 참을 반환한다.
-- x > ALL(..)  : 모든 값보다 크면 참. 최대값보다 크면 참
-- x >= ALL(..) : 모든 값보다 크거나 같으면 참. 최대값보다 크거나 같으면 참.
-- x < ALL(..)  : 모든 값보다 작으면 참. 최소값보다 작으면 참
-- x <= ALL(..) : 모든 값보다 작거나 같으면 참. 최소값보다 작거나 같으면 참.
-- x = ALL(..)  : 모든 값과 같으면 참.
-- x != ALL(..) : 모든 값과 다르면 참. NOT IN과 동일
-- ANY 연산자
-- x > ANY(..): 서브쿼리의 값 중 어느 하나보다 크면 참입니다. 즉, 최소값보다 크면 참입니다.
-- x >= ANY(..): 서브쿼리의 값 중 어느 하나보다 크거나 같으면 참입니다. 즉, 최소값보다 크거나 같으면 참입니다.
-- x < ANY(..): 서브쿼리의 값 중 어느 하나보다 작으면 참입니다. 즉, 최대값보다 작으면 참입니다.
-- x <= ANY(..): 서브쿼리의 값 중 어느 하나보다 작거나 같으면 참입니다. 즉, 최대값보다 작거나 같으면 참입니다.
-- x = ANY(..): 서브쿼리의 값 중 어느 하나와 같으면 참입니다. 이는 IN 연산자와 동일합니다.
-- x != ANY(..): 서브쿼리의 값 중 어느 하나와 다르면 참입니다. 즉, 서브쿼리 결과에 x와 다른 값이 하나라도 존재하면 참이 됩니다.


-- 가장 비싼 메뉴 조회
-- 서브쿼리가 반환하는 모든값에 대해 비교 조건이 참이어야 최종적으로 참을 반환한다.

-- Max 함수로 최대값만 조회
SELECT
	MAX(menu_price)
	FROM tbl_menu;

SELECT
	menu_name 
	FROM tbl_menu
	WHERE 
		menu_price >= ALL(SELECT menu_price FROM tbl_menu);

-- 한식보다 비싼 중식/일식이 존재하는지 궁금하다.
SELECT 
		*
	FROM tbl_menu
	WHERE category_code  IN (5,6)
	AND menu_price > all(SELECT menu_price
								FROM tbl_menu
								WHERE category_code = 4
								);

-- exists : 조회 결과가 있을 때 true, 없을 때 false
-- 메뉴 테이블에 존재하는 카테고리만 조회
SELECT
	category_name
	FROM tbl_category a
	WHERE EXISTS (SELECT 1
						FROM tbl_menu b
						WHERE b.category_code =a.category_code 
						);

SELECT DISTINCT category_code FROM tbl_menu;
-- =============================
-- 상관 서브쿼리
-- =============================
-- 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음
-- 그 결과를 다시 메인쿼리로 반환하는 방식으로 수행되는 서브쿼리

-- 서브쿼리의 WHERE 절 수행을 위해서는 메인쿼리가 먼저 수행되는 구조
-- 메인쿼리 테이블의 레코드(행)에 따라 서브쿼리의 결과값도 바뀜
-- 메인 쿼리에서 처리되는 각 행의 컬럼값에 따라 응답이 달라져야 하는 경우에 유용

-- 각 카테고리별로 가장 비싼 메뉴를 모두 찾아주세요
SELECT category_code,max(menu_price)
FROM tbl_menu
GROUP BY category_code;  

SELECT
	menu_code
 , menu_name
 , menu_price
 , category_code
 , orderable_status
FROM 
	tbl_menu a
WHERE
	menu_price = (SELECT MAX(b.menu_price)
							FROM tbl_menu b
							WHERE b.category_code =a.category_code
					);
-- 해당 카테고리 메뉴의 평균가보다 높은 가격을 가진 메뉴만 조회

SELECT
	menu_code
 , menu_name
 , menu_price
 , category_code
 , orderable_status
FROM 
	tbl_menu a
WHERE
	menu_price > (SELECT AVG(b.menu_price)
							FROM tbl_menu b
							WHERE b.category_code =a.category_code
					);

-- ===============================================
-- 스칼라 서브쿼리
-- ===============================================

-- 결과값이 단일값(1개의 행, 1개의 열)인 상관 서브쿼리의 한 종류입니다.

-- 메뉴명과 함께 카테고리명을 조회

-- 메뉴명, 카테고리명을 조회
SELECT
	a.menu_name
	, b.category_name
 FROM tbl_menu a
 LEFT JOIN tbl_category b ON a.category_code = b.category_code ;

SELECT
	a.menu_name
  ,(SELECT category_name
  		FROM tbl_category b
  		WHERE b.category_code = a.category_code
  		) category_name
 FROM tbl_menu a;

-- ===========================
-- 인라인뷰(INLINE-VIEW)
-- ===========================
-- FROM절에 서브쿼리를 사용한 것을 인라인뷰(INLINE-VIEW)라고한다.

# VIEW란
-- 실제테이블을 주어진 뷰('보다'라는 의미를 가짐)를 통해 제한적으로 사용가능함.
-- 실제테이블에 근거한 논리적인 가상테이블(사용자에게 하나의 테이블처럼 사용가능)이다.
-- view 를 사용하면 복잡한 쿼리문을 간단하게 만듦으로써 가독성이 좋으므로 편리하게 쿼리문을 만들수 있다.

-- view에는 stored view와 inline view가 있다.
-- 1. inline view : from절에 사용하는 서브쿼리, 1회용
-- 2. stored view : 영구적으로 사용가능. 재활용가능한 가상테이블

SELECT -- 인라인뷰에 존재하는 컬럼만 참조할 수 있다.
	v.menu_name
  ,v.category_name 
  ,v.menu_price 
FROM (SELECT a.menu_name
					,(SELECT category_name
					FROM tbl_category b
					WHERE b.category_code=a.category_code
					) category_name
					, a.menu_price
					FROM tbl_menu a
					) v

SELECT count(*) 'count'
	FROM tbl_menu
	GROUP BY category_code;

SELECT
		Max(count)
	FROM (SELECT Count(*) 'count'
				FROM tbl_menu
				GROUP BY category_code) AS countmenu;


-- CTE(common table Expression)
-- 인라인뷰로 사용되는 서브쿼리를 미리 정의해서 사용하는 문법

WITH menucate as(
		SELECT menu_name
			, category_name
		FROM tbl_menu a
		JOIN tbl_category b ON a.category_code = b.category_code
)
SELECT 
	*
	FROM menucate;



