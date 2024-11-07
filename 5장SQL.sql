create database naver_db;
use naver_db;

create table member(
	id varchar(4) primary key,
	name varchar(4),
    no int,
    addr varchar(2),
    tel1 varchar(3),
    tel2 varchar(10),
    height int,
    debut date
);
drop table member;
select * from member;

create table buy(
	num int primary key auto_increment,
    id varchar(4),
    product varchar(8),
    category varchar(5),
	price int,
	amount int
    -- foreign key (id) references member(id)
    -- foreign key는 마지막에...
);
drop table buy;
select * from buy;

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

-- alter를 이용해 foreign key추가하기
alter table buy add constraint foreign key (id) references member(id);
-- alter를 이용해 컬럼이 가진 데이터 타입 변경하기
alter table member modify column tel2 varchar(8);
alter table member modify column addr char(2);
-- alter를 이용해 컬럼명을 수정하기
alter table buy change column amount count int;
alter table buy change column count amount int;

select m.id, m.name, b.product
	from buy b
    inner join member m
	on b.id = m.id;
    
alter table buy
	add constraint foreign key (id) references member(id)
	on update cascade on delete cascade;
-- on update cascade on delete cascade는 외래키 지정할 시 세트로 적용되어야한다.
-- 이미 외래키를 지정한 상태라면 drop을 통해 외래키를 삭제하고 다시 지정해야한다.

update member set id='PINK' where id='BLK';
delete from member where id='PINK';

create table member(
	mem_id char(8) primary key,
	mem_name varchar(10) not null,
    height int null,
    email char(30) null unique
);

drop table member;

insert into member values('BLK','블랙핑크',163,'pink@gmail.com');
insert into member values('TWC','트와이스',167, NULL);
insert into member values('APN','에이핑크',164,'pink@gmail.com');
-- UNIQUE를 사용했기 때문에 같은 이메일은 들어가지 않음


create table member(
	mem_id char(8) primary key,
	mem_name varchar(10) not null,
    height int null CHECK(HEIGHT >= 100),
    PHONE1 CHAR(3) NULL
);

INSERT INTO member VALUES('BLK','블랙핑크',163, NULL);
INSERT INTO member VALUES('BLK','블랙핑크',99, NULL);
-- CHECK함수에서 FALSE를 받으면 데이터베이스에 입력이 되지 않는다

ALTER TABLE member ADD constraint
	CHECK(PHONE1 IN ('02','031','032','054','055','061'));

INSERT INTO member VALUES('TWC','트와이스',167, '02');
INSERT INTO member VALUES('OMY','오마이걸',167, '010');
-- CHECK 제약조건을 추가하여 010은 입력되지 않음


create table member(
	mem_id char(8) primary key,
	mem_name varchar(10) not null,
    height int null default 160,
    PHONE1 CHAR(3) NULL
);

ALTER TABLE member
	ALTER column PHONE1 SET default '02';
-- 컬럼에 속성을 추가할 때는 ALTER COLUMN문을 사용한다

INSERT INTO member VALUES('RED','레드벨벳',161, '054');
INSERT INTO member VALUES('SPC','우주소녀',NULL, DEFAULT);

-- MARKET_DB SQL 파일사용
USE market_db;
CREATE VIEW v_member AS
	SELECT mem_id, mem_name, addr FROM member;
-- 테이블의 직접접근을 막음
    
SELECT * FROM v_member;
SELECT * FROM member;

INSERT INTO v_member(mem_id, mem_name, addr) values('BTS','방탄소년단','경기');
-- 안됨

CREATE VIEW v_height167 AS
	SELECT * FROM member WHERE height >= 167;

SELECT * FROM v_height167;

DELETE FROM v_height167 WHERE height < 167;

INSERT INTO v_height167 VALUES('TRA','티아라',6,'서울',NULL,NULL,159,'2005-01-01');

ALTER VIEW v_height167 AS
	SELECT * FROM member WHERE height >= 167
    WITH CHECK OPTION;
    
INSERT INTO v_height167 VALUES('TOB','텔레토비',4,'영국',NULL,NULL,140,'1995-01-01');


UPDATE v_member SET addr = '부산' WHERE mem_id='BLK';

select mem_name, addr FROM v_member WHERE addr IN('서울','경기');

CREATE VIEW v_memberbuy AS
	SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, CONCAT(M.phone1, M.phone2) AS '연락처'
	FROM buy B INNER JOIN member M
    ON B.mem_id = M.mem_id;
    
SELECT * FROM v_memberbuy;
SELECT * FROM v_memberbuy WHERE mem_name = '블랙핑크';

DROP VIEW v_memberbuy;

CREATE VIEW v_viewtest1 AS
	SELECT
		B.mem_id AS 'Member ID',
		M.mem_name AS 'Member Name',
        B.prod_name AS 'Product Name',
        CONCAT(M.phone1, M.phone2) AS 'Office Phone'
	FROM buy B
    INNER JOIN member M
    ON B.mem_id = M.mem_id;

SELECT DISTINCT `Member ID`, `Member Name` FROM v_viewtest1;

-- VIEW수정은 ALTER VIEW를 사용한다.

ALTER VIEW v_viewtest1 AS
	SELECT
		B.mem_id AS '회원 아이디',
		M.mem_name AS '회원 이름',
        B.prod_name AS '제품 이름',
        CONCAT(M.phone1, M.phone2) AS '연락처'
	FROM buy B
    INNER JOIN member M
    ON B.mem_id = M.mem_id;

SELECT DISTINCT `회원 아이디`, `회원 이름` FROM v_viewtest1;


