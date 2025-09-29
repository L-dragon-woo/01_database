-- 13 data types
-- (1) 명시적 형변환
SELECT floor(avg(menu_price)) FROM tbl_menu;

-- ANSI표준 : CAST (실수를 정수로)
SELECT CAST(avg(menu_price) AS signed INTEGER) '평균 메뉴 가격'
		, avg(menu_price)
FROM tbl_menu; 

-- mysql, mariadb : convert 제공 (실수를 정수로)
SELECT convert(avg(menu_price), signed INTEGER) '평균 메뉴 가격'
		, avg(menu_price)
FROM tbl_menu;

-- 20250929
SELECT cast('2025$9$29' AS date);
-- SELECT str_to_date('2025%9%29', '%y%m%d') '오늘 날짜';

SELECT cast(menu_price AS char(5)) FROM tbl_menu;
SELECT concat(CAST(menu_price AS char(5)), '원') FROM tbl_menu;

-- 카테고리별 메뉴 가격 합계 
SELECT category_code, concat(CAST(sum(menu_price) AS char(10)),'원') '합계'
FROM tbl_menu
GROUP BY category_code;

SELECT '1'+'2'; -- 각 문자가 정수로 변환됨
SELECT concat(menu_price,'원') FROM tbl_menu; -- menu_price가 문자로 변환됨
SELECT 3>'MAY'; -- 문자는 0으로 변환된다. (비교할때)

SELECT 7>'8may'; -- 문자에서 첫번째로 나온 숫자는 정수로 전환된다.
SELECT 5>'M6AY'; -- 숫자가 뒤에 나오면 문자로 인식되오 0으로 변환
SELECT hire_date ,hire_date >'2000-5-30' FROM employee; 
-- 날짜 형으로 바뀔 수 있는 문자는 date형으로 변환된다.

SELECT * FROM
INSERT INTO VALUES
UPDATE SET WHERE 
DELETE FROM WHERE 


