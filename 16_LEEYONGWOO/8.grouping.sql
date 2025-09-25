-- 8. grouping 

-- group by: 결과 집합을 특정 열의 값에 따라 그룹화
-- having : group by절과 함께 사용하며 그룹의 조건을 적용
-- 6 select 조회컬럼...
-- 1   from 조회할 대상 테이블(베이스테이블)
-- 2   join 조회 대상 테이블 ...
-- 3  where 테이블 행을 조건으로 필터링
-- 4  group by 대상 컬럼으로 결과 집합 그룹핑
-- 5 having 그룹핑 결과를 조건으로 필터링 
-- 7  order by 정렬 기준

-- 그룹함수: count, sum, avg, min, max
-- 여러 개의 값중에 한개를 반환

SELECT
	category_code
	, COUNT(*)
	FROM tbl_menu
	GROUP BY category_code;

-- count 함수의 특성
SELECT 
	count(*) -- '*' 모든 행
	,count(category_code) -- 컬럼명 기재 시 값이 있는 행만 카운트
	,count(ref_category_code ) -- null값은 카운트 하지 않는다
	FROM tbl_category;

-- sum: 숫자 합계를 계산
SELECT 
	category_code, 
count(menu_price)
	FROM tbl_menu
	GROUP BY category_code;

-- min, max는 모든 데이터 타입을 대상으로 사용 가능
SELECT 
	min(emp_name)
	,	max(emp_name)
	,  min(hire_date)
	,  max(hire_date)
	FROM employee;

-- group by에서 2개 이사으이 그룹 생성
SELECT 
	menu_price
	, category_code
	, count(*)
	FROM tbl_menu
	GROUP BY menu_price, category_code;

-- 카테고리별로 메뉴 가격 평균이 10000원 이상인 카테고리
-- 카테고리 코드, 카테고리명, 평균 메뉴 가격 조회
SELECT
tm.category_code
,tc.category_name
,avg(tm.menu_price)
FROM tbl_menu tm
JOIN tbl_category tc ON tm.category_code=tc.category_code 
GROUP BY tm.category_code ,tc.category_name
HAVING avg(tm.menu_price )>=10000;


-- rollup: 중간 집계 함수로 group by 와 함께 사용
-- group by 절의 첫 번째 기준 컬럼에 대한 중간 집계 + 총 집게 값이
-- result set에 포함된다.



-- 문제 33: 한쪽 테이블의 모든 데이터 보여주기
-- 주제: RIGHT JOIN
-- 문제: 모든 비디오의 제목을 보여주고, 해당 비디오에 '좋아요'를 누른 사용자가 있다면 그 username도 함께 보여주세요. '좋아요'가 없는 비디오도 목록에 포함되어야 합니다.
SELECT
v.title,
u.username 
FROM videos v
LEFT JOIN video_likes vl ON v.video_id =vl.video_id 
LEFT JOIN users u ON vl.user_id =u.user_id;


-- 문제 34: 특정 카테고리 중 활동이 없는 데이터 찾기
-- 주제: LEFT JOIN + WHERE IN
-- 문제: 'IT/테크' 또는 '교육' 카테고리 비디오 중에서, '좋아요'를 받지 못한 비디오의 제목과 카테고리를 조회하세요.
SELECT
v.title,
v.category 
FROM videos v
LEFT JOIN video_likes vl ON v.video_id =vl.video_id 
WHERE v.category IN ('IT/테크','교육') AND vl.like_id  IS NULL;


-- 문제 35: JOIN 종합 문제
-- 주제: 4개 테이블 JOIN + WHERE + ORDER BY

-- 문제: '대한민국' 국적의 사용자가 '좋아요'를 누른 비디오의 제목과, 그 비디오를 만든 크리에이터의 채널명을 조회하세요. 결과를 채널명 가나다순으로 정렬하세요.
SELECT
v.title,
c.channel_name 
FROM users u
JOIN video_likes vl ON u.user_id =vl.user_id 
JOIN videos v ON vl.video_id = v.video_id 
JOIN creators c ON v.creator_id =c.creator_id 
WHERE u.country LIKE '대한민국' AND vl.like_id IS NOT NULL
ORDER BY c.channel_name;

-- 문제 36: 데이터 그룹으로 묶고 개수 세기
-- 주제: GROUP BY, COUNT()
-- 문제: 각 비디오 카테고리별로 비디오가 총 몇 개씩 있는지 개수를 세어보세요.
SELECT 
	v.category
	,count(v.category)
FROM videos v
GROUP BY v.category; 


-- 문제 37: 그룹별 합계와 평균 계산하기 (JOIN과 함께)
-- 주제: GROUP BY, SUM(), AVG() with JOIN

-- 문제: 각 크리에이터 채널별로, 올린 비디오의 총 조회수 합계와 평균 조회수를 계산하세요. 결과를 총 조회수 합계가 높은 순으로 정렬하세요.
SELECT
v.creator_id,
sum(v.view_count ),
avg(v.view_count )
FROM videos v
GROUP BY v.creator_id 
ORDER BY sum(v.view_count ) DESC;



-- 문제 38: 그룹화된 결과에 조건 적용하기
-- 주제: GROUP BY, HAVING

-- 문제: 비디오를 3개 이상 올린 크리에이터에 대해서만, 각 크리에이터별 creator_id와 올린 비디오의 총 개수를 조회하세요.
SELECT
v.creator_id,
count(v.video_id) -- COUNT(*)
FROM videos v
GROUP BY v.creator_id
HAVING count(v.video_id)>=3;


-- 문제 39: JOIN과 GROUP BY, HAVING 
-- 주제: JOIN, GROUP BY, HAVING

-- 문제: '대한민국' 국적을 가진 크리에이터 중에서, 올린 비디오의 평균 조회수가 500,000 이상인 크리에이터의 채널명과 평균 조회수를 조회하세요.
SELECT
c.channel_name,
avg(v.view_count )
FROM users u
JOIN creators c ON u.user_id = c.user_id 
JOIN videos v ON c.creator_id = v.creator_id
WHERE u.country LIKE '대한민국'
GROUP BY v.creator_id 
HAVING avg(v.view_count )>=500000;



