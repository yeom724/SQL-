create database myTest;
USE MYTEST;

create table test1(
	COL1 CHAR(5),
    COL2 INT,
    COL3 VARCHAR(10)
);

create TABLE TEST2(
	COL1 CHAR(5),
	COL2 INT,
    COL3 VARCHAR(10)
);

ALTER TABLE TEST1
	ADD constraint primary key (COL1);

ALTER TABLE TEST2
	ADD constraint foreign key (COL1) references TEST1(COL1);
    

USE MARKET_DB;

CREATE TABLE TABLE1(
	COL1 INT primary KEY,
    COL2 INT,
    COL3 INT
);

SHOW index FROM TABLE1;

DROP TABLE if exists BUY, MEMBER;
CREATE TABLE MEMBER(
	MEM_ID CHAR(8),
    MEM_NAME VARCHAR(10),
    MEM_NUMBER INT,
    ADDR CHAR(2)
);

INSERT INTO MEMBER VALUES('TWC', '트와이스', 9, '서울');
INSERT INTO member VALUES('BLK', '블랙핑크', 4, '경남');
INSERT INTO member VALUES('WMN', '여자친구', 6, '경기');
INSERT INTO member VALUES('OMY', '오마이걸', 7, '서울');

SELECT * FROM MEMBER;

ALTER TABLE MEMBER
	MODIFY column MEM_id CHAR(8) primary KEY;
    
-- 혹은

ALTER TABLE MEMBER
	ADD constraint primary key (MEM_ID);
    
SHOW INDEX FROM MEMBER;
SHOW TABLE STATUS LIKE 'member';

CREATE INDEX idx_member_addr ON member(addr);
-- 보조인덱스 생성 (UNIQUE 없음)

analyze TABLE member;
-- 생성된 인덱스를 사용


create unique INDEX idx_member_mem_number ON member(mem_number);
-- 중복이 있어서 인덱스 생성 안됨

CREATE UNIQUE INDEX idx_member_name ON member(mem_name);
INSERT INTO member values('MOO','마마무',2,'태국','001','12341234',155,'2020.10.10');
-- 보조인덱스로 NAME을 UNIQUE로 지정했기 때문에 이후 INSERT에 제약을 받는다.

SELECT mem_id, mem_name, addr FROM member
	WHERE mem_name = '에이핑크';

CREATE INDEX idx_mem_num ON member(mem_number);

SELECT mem_name, mem_number FROM member
	WHERE mem_number >= 7;
    
select distinct mem_id FROM BUY;

SELECT mem_id, SUM(amount) FROM BUY GROUP BY mem_id;

ALTER TABLE BUY
	ADD TEST1 CHAR(2);
    
    DESC BUY;
    
ALTER TABLE BUY DROP TEST1;

