-- DDL : 데이터베이스 생성하기  (Create)
-- 데이터베이스 오브젝트(DB, Table 등... 객체) CRUD
create database shop_DB;
use shop_DB;

-- DDL : 데이터베이스 조회하기 (Read)
show databases;

-- DDL : 데이터베이스 수정하기 (Update)
-- alter database shop_DB rename to DB_shop;
-- Alter schema에서 지정한 속성
ALTER SCHEMA shop_db  DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_unicode_ci ;

-- DDL : 데이터베이스 삭제하기 (Delete)
drop database shop_DB;

-- DDL : 테이블 생성 (Create)
create table member_table(
	member_id char(8) not null primary key,
    member_name char(5) not null,
    member_addr char(20)
) default charset=utf8;
-- 한글아 깨지지 마~

create table product(
	product_name char(4) not null primary key,
	cost int not null,
    make_date date,
    company char(5),
    amount int not null
) default charset=utf8;

-- 테이블 삭제하기 (Delete)
drop table member_table;
drop table product;

-- 테이블 읽어오기 (컬럼의 구조를 보여줌)
desc member_table;

-- 테이블 수정하기

-- ------------------------------------------------------- --
-- DML (테이블의 데이터를 CRUD)

insert into member_table values('tess','나훈아','경기 부천시 중동');
insert into member_table values('hero','임영웅','서울 은평구 증산동');
insert into member_table values('iyou','아이유','인천 남구 주안동');
insert into member_table values('jyp','박진영','경기 고양시 장항동');
select * from member_table;

select member_name, member_addr from member_table;
-- 특정 컬럼만 추출하여 모든 행을 출력
select * from member_table where member_id='tess';
-- 하나 또는 복수의 행을 검색할 수 있음 (선택된 행만 출력)

insert into product values('바나나',1500,'2021-07-01','델몬트',17);
insert into product values('카스',2500,'2022-03-01','OB',3);
insert into product values('삼각김밥',800,'2023-09-01','CJ',22);
select * from product;