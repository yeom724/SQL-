create database market_DB;
use market_DB;
-- use명령어를 사용하면 테이블 이름만 명시해도 사용할 수 있다.

-- use명령어를 사용하지 않았을 경우 : market_DB.member_table 이라고 명시
-- create table market_DB.member_table();

CREATE TABLE member -- 회원 테이블
( mem_id  		CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  mem_name    	VARCHAR(10) NOT NULL, -- 이름
  mem_number    INT NOT NULL,  -- 인원수
  addr	  		CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  phone1		CHAR(3), -- 연락처의 국번(02, 031, 055 등)
  phone2		CHAR(8), -- 연락처의 나머지 전화번호(하이픈제외)
  height    	SMALLINT,  -- 평균 키
  debut_date	DATE  -- 데뷔 일자
) default charset=utf8 ;

CREATE TABLE buy -- 구매 테이블
(  num 		INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   mem_id  	CHAR(8) NOT NULL, -- 아이디(FK)
   prod_name 	CHAR(6) NOT NULL, --  제품이름
   group_name 	CHAR(4)  , -- 분류
   price     	INT  NOT NULL, -- 가격
   amount    	SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (mem_id) REFERENCES member(mem_id) -- 여권
) default charset=utf8 ;

drop database market_DB;
drop table member;
drop table buy;

INSERT INTO member VALUES('TWC', '트와이스', 9, '서울', '02', '11111111', 167, '2015.10.19');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남', '055', '22222222', 163, '2016.08.08');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기', '031', '33333333', 166, '2015.01.15');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울', NULL, NULL, 160, '2015.04.21');
INSERT INTO member VALUES('GRL', '소녀시대', 8, '서울', '02', '44444444', 168, '2007.08.02');
INSERT INTO member VALUES('ITZ', '잇지', 5, '경남', NULL, NULL, 167, '2019.02.12');
INSERT INTO member VALUES('RED', '레드벨벳', 4, '경북', '054', '55555555', 161, '2014.08.01');
INSERT INTO member VALUES('APN', '에이핑크', 6, '경기', '031', '77777777', 164, '2011.02.10');
INSERT INTO member VALUES('SPC', '우주소녀', 13, '서울', '02', '88888888', 162, '2016.02.25');
INSERT INTO member VALUES('MMU', '마마무', 4, '전남', '061', '99999999', 165, '2014.06.19');

INSERT INTO buy VALUES(NULL, 'BLK', '지갑', NULL, 30, 2);
INSERT INTO buy VALUES(NULL, 'BLK', '맥북프로', '디지털', 1000, 1);
INSERT INTO buy VALUES(NULL, 'APN', '아이폰', '디지털', 200, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '아이폰', '디지털', 200, 5);
INSERT INTO buy VALUES(NULL, 'BLK', '청바지', '패션', 50, 3);
INSERT INTO buy VALUES(NULL, 'MMU', '에어팟', '디지털', 80, 10);
INSERT INTO buy VALUES(NULL, 'GRL', '혼공SQL', '서적', 15, 5);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 2);
INSERT INTO buy VALUES(NULL, 'APN', '청바지', '패션', 50, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 1);
INSERT INTO buy VALUES(NULL, 'APN', '혼공SQL', '서적', 15, 1);
INSERT INTO buy VALUES(NULL, 'MMU', '지갑', NULL, 30, 4);

select mem_name as 멤버이름 from member;
-- mem_name 이름을 멤버이름이라고 임의로 별칭을 붙임
select mem_name '멤버이름' from member;
-- as를 생략하고 사용 가능 (따옴표 제외해도 됨)

select addr, debut_date, mem_name from member;
select addr as '주소', debut_date as '데뷔 일자', mem_name from member;

select * from member where mem_name = '블랙핑크';
-- 멤버이름이 블랙핑크인 행을 조회
select * from member where mem_number = 4;
-- 멤버숫자가 4인 행을 조회
select mem_id, mem_name from member where height <=162;
-- 키가 162이하인 행의 멤버아이디와 멤버이름을 조회

select mem_name, mem_number from member
where height >=165 AND mem_number >6;
-- 키가 165이상 이면서 멤버숫자가 6보다 큰 행의 멤버이름과 멤버숫자를 조회

select mem_name, mem_number from member
where height >=165 OR mem_number >6;
-- 키가 165이상 이거나 멤버숫자가 6보다 큰 행의 멤버이름과 멤버숫자를 조회

select mem_name, height from member
where height >=163 AND height <=165;

select mem_name, height from member
where height between 163 AND 165;
-- AND 논리연산자로 만든 범위지정을 between 명령어를 사용하면 간편하다

select mem_name, addr from member
where addr='경기' OR addr='전남' OR addr='경남';

select mem_name, addr from member
where addr IN('경기','전남','경남');
-- OR 논리연산자로 만든 범위지정을 IN() 명령어를 사용하면 간편하다

select * from member
where mem_name LIKE '__핑크';
-- 언더바(_)는 글자 수 제한을 두고 %는 글자수 제한이 없다
select * from member
where addr LIKE '경%';

select mem_id, mem_name, debut_date from member
order by debut_date; -- 오름차순

select mem_id, mem_name, debut_date from member
order by debut_date desc; -- 내림차순

select mem_id, mem_name, debut_date, height from member
	where height >= 164
	order by height desc;
-- order문 다음에는 where절을 사용할 수 없다, 문법 순서에 주의할 것

select mem_id, mem_name, debut_date, height from member
	where height >= 164
	order by height desc, debut_date asc;
-- 키를 기준으로 내림차순이지만 만약 같을 경우 날짜를 비교하여 오름차순 정렬

select * from member limit 3;

select mem_name, debut_date from member
	order by debut_date
	limit 3;