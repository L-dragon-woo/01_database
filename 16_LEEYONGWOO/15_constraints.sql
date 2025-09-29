-- 15.constraints(제약조건)

-- (1) not null : null 값을 허용하지 않음.

CREATE TABLE IF NOT EXISTS user_notnull (
  user_no INT NOT NULL PRIMARY KEY,           -- 컬럼 레벨의 제약조건 
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255)
);

INSERT 
	INTO user_notnull
VALUES
(1, 'user01','pass01','홍길동','남','010-1234-5678','qhtm008@naver.com');

DESC user_notnull

SELECT * FROM user_notnull;

-- (2) unique : 중복값 허가하지 않음
CREATE TABLE IF NOT EXISTS user_unique (
  user_no INT NOT NULL UNIQUE,           -- 컬럼 레벨의 제약조건 
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255)
);

DESC user_unique;

INSERT 
	INTO user_unique
VALUES
(1,'user01','pass01','홍길동','남','010-1234-5678','hong@gmail.com');


SELECT * FROM user_unique;

CREATE TABLE IF NOT EXISTS user_unique2 (
  user_no INT NOT NULL,         
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  unique(user_no) -- 테이블 레벨 
);



INSERT 
	INTO user_unique2
VALUES
(1,'user01','pass01','홍길동','남','010-1234-5678','hong@gmail.com');


-- (3) primary key: 테이블의 식별자 역할(한 행을 구분)
-- not null + unique
-- 한 테이블 당 하나만 설정 가능 


CREATE TABLE IF NOT EXISTS user_primary (
  user_no INT NOT NULL,         
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  PRIMARY KEY(user_no) -- 테이블 레벨에 제약 조건
);


INSERT 
	INTO user_primary
VALUES
(null,'user01','pass01','홍길동','남','010-1234-5678','hong@gmail.com');

-- (4) foreign key: 참조 제약 조건 (참조 무결성 위배하지 않도록)
CREATE TABLE IF NOT EXISTS user_grade (
  grade_code INT UNIQUE,
  grade_name VARCHAR(255) NOT NULL
);

INSERT INTO user_grade VALUES 
(10, '일반회원'),
(20, '우수회원'),
(30, '특별회원');

SELECT * FROM user_grade;


-- 삭제롤 변경
CREATE TABLE IF NOT EXISTS user_foreignkey3 (
  user_no INT NOT NULL,         
  user_id VARCHAR(255) NOT NULL,
  user_pwd VARCHAR(255) NOT NULL,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3),
  phone VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  grade_code INT,
  PRIMARY KEY(user_no), -- 테이블 레벨에 제약 조건
  FOREIGN KEY(grade_code) REFERENCES user_grade(grade_code)
  -- ON UPDATE SET NULL ON DELETE SET NULL
  -- 수정 및 삭제 시 NULL값으로 변경
  ON UPDATE CASCADE ON DELETE CASCADE
  -- 수정 및 삭제 시 함께 삭제 
  );


desc user_foreignkey2;

SELECT * FROM user_foreignkey2 uf ;

DELETE FROM user_grade 
WHERE grade_code=10;


INSERT
	INTO user_foreignkey3
VALUES
(1,'user01','pass01','홍길동','남','010-1234-5678','hong@gmail.com',10);


DELETE  
	FROM user_grade 
WHERE grade_code=10;


-- (5) check 제약 조건
CREATE TABLE IF NOT EXISTS user_check (
  user_no INT AUTO_INCREMENT PRIMARY KEY,
  user_name VARCHAR(255) NOT NULL,
  gender VARCHAR(3) CHECK (gender IN ('남', '여')),
  age INT CHECK(age >= 19)
);

INSERT INTO user_check VALUES (NULL,'홍길동','남',20);

INSERT INTO user_check VALUES (NULL,'홍길동','남',20);-- age check 제약조건 위배


INSERT INTO user_check VALUES (NULL,'홍길동','남자',20); -- gender check 제약조건 위배

SELECT * FROM user_check;

-- (6) default : 칼럼에 null 값 대신 기본값 적용가능
CREATE TABLE IF NOT EXISTS tbl_country (
  country_code INT AUTO_INCREMENT PRIMARY KEY,
  country_name VARCHAR(255) DEFAULT '한국',
  population VARCHAR(255) DEFAULT '0명',
  add_day DATE DEFAULT (CURRENT_DATE),
  add_time DATETIME DEFAULT (CURRENT_TIME)
);

INSERT INTO tbl_country VALUES(NULL,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

SELECT * FROM tbl_country;
COMMIT;