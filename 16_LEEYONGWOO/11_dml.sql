-- 11. DML(Data Manupulation Language)
-- 데이터 조작 언어, 테이블에 값을 삽입하거나 수정하거나 삭제한다.

-- (1) insert : 새로운 행을 추가
INSERT
	INTO tbl_menu 
VALUES
(
	NULL
,	'바나나해장국'
,  8500
,  4
,	'Y'
);

SELECT * FROM tbl_menu;

-- insert시 null 허용 가능 컬럼 or auto_increment 등
-- 기본 값이 존재하는 칼럼은 제외하고 컬럼을 지정해서 삽입 가능

INSERT 
	INTO tbl_menu
	(
	menu_name
	,menu_price
	,category_code
	,orderable_status
	)
	values(
	'초콜릿죽',6500,7,'Y'
	);

-- 컬럼을 명시적으로 작성했을 경우 순서 변경이 가능하다.
INSERT
	INTO tbl_menu 
(
	menu_price, menu_name
	,orderable_status,category_code
)
VALUES 
(
	70000,'파인애플탕','Y',4
);

-- multi insert
INSERT 
	INTO tbl_menu 
VALUES
(NULL,'참치맛아이스크림',16998,12,'Y'),
(NULL,'멸치맛아이스크림',15000,12,'Y'),
(NULL,'고등어맛아이스크림',19000,12,'Y');

-- (2) update: 테이블에 기록된 컬럼의 값을 수정
-- 0~n개의 행이 업데이트 되며 테이블 전체 행의 수는 변화 없다.
UPDATE tbl_menu 
	SET category_code = 7
		,menu_name='딸기맛붕어빵'
WHERE menu_code=24;

SELECT * FROM tbl_menu;

-- subquery를 update절에 활용할 수 있다.
UPDATE tbl_menu
	SET category_code = 6
WHERE menu_code = (SELECT menu_code
							FROM tbl_menu
							WHERE menu_name='딸기맛붕어빵'
							);

-- (3) delete: 테이블의 행을 삭제하는 구문
-- where 절을 이용한 삭제
DELETE 
	FROM tbl_menu 
	WHERE menu_code=22;

-- limit을 활용한 삭제(offset지정은 불가)
DELETE
	FROM tbl_menu 
	ORDER BY menu_price
	LIMIT 2;

DELETE
	FROM tbl_menu 
	WHERE 1=1;
ROLLBACK;

-- (4) replace: 중복된 데이터를 덮어 쓸 수 있다.
REPLACE
	INTO tbl_menu
VALUES
(
	17
,	'참기름맛소주'
,	50000
,  10
,	'Y'
);

REPLACE tbl_menu
	SET menu_code=2
		, menu_price=1000
		, menu_name='우럭쥬스'
		, category_code=9
		, orderable_status = 'N';


SELECT * FROM tbl_menu;
ROLLBACK;
