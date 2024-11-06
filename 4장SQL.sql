use market_db;

set @myVar1 = 5;
set @myVar2 = 4.25;

select @myVar1;
select @myVar1 + @myvar2;
-- 변수도 대소문자 구분을 하지 않는다

set @txt = '가수 이름 ==>';
set @height = 166;
select @txt, mem_name from member where height > @height ;

set @count = 3;
select mem_name, height from member order by height limit @count;
-- limit은 변수 사용이 불가하다.

prepare mySQL from 'select mem_name, height from member order by height limit ?';
execute mySQL using @count;
-- Java에서 활용했던 preparestatment와 유사한 방식
-- execute문을 사용해야 완전한 SQL문이 실행된다

select avg(price) as '평균 가격' from buy;

select cast(avg(price) as signed) as '평균 가격' from buy;
select convert(avg(price), signed) as '평균 가격' from buy;

select cast('2022$12$12' as DATE) as '날짜';
select cast('2022/12/13' as DATE) as '날짜';
select cast('2022%12%14' as DATE) as '날짜';
select cast('2022@12@15' as DATE) as '날짜';

-- CONCAT(cast(price as char), 'X', cast(amount as char), '=')
-- concat함수에 들어가면 자동으로 문자로 바꿔주기 때문에 컬럼명만 적어도 정상적으로 출력된다.
select num, CONCAT(price, 'X', amount, '=') as '가격X수량', price*amount as '구매액'
	from buy;
    
select '100' || '200' ;
select concat('100','200');
select concat(100,'200');
select 100 + '200';

select * from buy
	inner join member
    on buy.mem_id = member.mem_id
where buy.mem_id = 'GRL';

select * from member
	inner join buy
    on buy.mem_id = member.mem_id;
    
select * from buy;
select * from member;

-- mem_name, addr, phone은 member테이블의 컬럼이고 prod_name은 buy테이블의 컬럼이다.
-- from으로 buy테이블을 선택했지만 join절을 실행하는 순간 두 테이블이 나란히 존재하는 형태가 되기 때문에,
-- 컬럼명이 일치하든, 일치하지 않든 테이블명을 명시해야 옳다.
select member.mem_id, mem_name, prod_name, addr, concat(phone1, phone2) as '연락처'
	from member
	inner join buy
    on buy.mem_id = member.mem_id;
    
select member.mem_id, mem_name, prod_name, addr, concat(phone1, phone2) as '연락처'
	from buy
	inner join member
    on buy.mem_id = member.mem_id;
    
select
	buy.mem_id,
	member.mem_name,
    buy.prod_name,
    member.addr,
    concat(member.phone1, member.phone2) as '연락처'
    from buy
		inner join member
        on buy.mem_id = member.mem_id;
        

select B.mem_id, M.mem_name, B.prod_name, M.addr, concat(M.phone1,M.phone2) as '연락처'
	from buy as B
    inner join member M
    on b.mem_id = m.mem_id
    order by m.mem_id;
    
select distinct m.mem_id, m.mem_name, m.addr
	from buy as b
    inner join member as m
    on m.mem_id = b.mem_id
    order by m.mem_id;
    
select m.mem_id, m.mem_name, b.prod_name, m.addr
	from member as m
    left outer join buy b
    on m.mem_id = b.mem_id
    order by m.mem_id;
-- left = 왼쪽에 있는 테이블의 모든 목록이 표시되어야한다

select m.mem_id, m.mem_name, b.prod_name, m.addr
	from member as m
    right outer join buy b
    on m.mem_id = b.mem_id
    order by m.mem_id;
-- right = 오른쪽에 있는 테이블의 모든 목록이 표시되어야한다
    
select m.mem_id, m.mem_name, b.prod_name, m.addr
	from buy b 
    left outer join member as m
    on m.mem_id = b.mem_id
    order by m.mem_id;

create table emp_table(
	emp char(4),
    manager char(4),
    phone varchar(8)
);

insert into emp_table values('대표',NULL,'0000');
insert into emp_table values('영업이사','대표','1111');
insert into emp_table values('관리이사','대표','2222');
insert into emp_table values('정보이사','대표','3333');
insert into emp_table values('영업과장','영업이사','1111-1');
insert into emp_table values('경리부장','관리이사','2222-1');
insert into emp_table values('인사부장','관리이사','2222-2');
insert into emp_table values('개발팀장','정보이사','3333-1');
insert into emp_table values('개발주임','정보이사','3333-1-1');

select A.emp as '직원', B.emp as '직속상관', B.phone as '직속상관 연락처'
	from emp_table as A
    inner join emp_table as B
    on A.manager = B.emp;

drop procedure if exists ifProc3;
-- 함수 삭제


delimiter $$
create procedure ifProc3()
begin
	declare debutDate DATE;
    declare curDate DATE;
    declare days INT;
    
    select debut_date into debutDate
		from market_db.member
        where mem_id = 'APN';
	
    set curDate = current_date();
    set days = datediff(curDate,debutDate);
    
    if (days/5) >= 5 then
		select concat('데뷔한 지',days,'일이나 지났습니다. 핑순이들 축하합니다!') as '축하문구';
	else
		select concat('데뷔한 지',days,'일밖에 안되었네요. 핑순이들 화이팅~') as '위로문구';
        
	end if;
end $$
delimiter ;

call ifProc3();

select * from buy;
select * from member;

select mem_id, sum(price*amount) as '총 구매금액', '최우수'  as 'test'
	from buy
	group by mem_id;

select mem_id, sum(price*amount) as '총 구매금액'
	from buy
	group by mem_id;
    
select mem_id, sum(price*amount) as '총 구매금액'
	from buy
	group by mem_id
    order by sum(price*amount) desc;
    
select B.mem_id, M.mem_name, sum(B.price*B.amount) as '총 구매금액'
	from buy B
    inner join member M
    on B.mem_id = M.mem_id
    group by B.mem_id
    order by sum(price*amount) desc;

select M.mem_id, M.mem_name, sum(B.price*B.amount) as '총 구매금액'
	from buy B
    right outer join member M
    on B.mem_id = M.mem_id
    group by M.mem_id
    order by sum(price*amount) desc;

select M.mem_id, M.mem_name, sum(B.price*B.amount) as '총 구매금액',
	case
		when(sum(B.price*B.amount) >= 1500) then '최우수 고객'
        when(sum(B.price*B.amount) >= 1000) then '우수 고객'
        when(sum(B.price*B.amount) >= 1) then '일반 고객'
        else '유령회원'
	end as '회원등급'
	from buy B
    right outer join member M
    on B.mem_id = M.mem_id
    group by M.mem_id
    order by sum(price*amount) desc;
    
delimiter $$
create procedure whileProc()
	begin

		declare i int;
		declare hap int;
		set i = 1;
		set hap = 0;
		
		while(i<=100) do
			set hap = hap + i;
			set i = i + 1;
		end while;
		
		select '1부터 100까지의 합 ==>', hap;
	end $$
delimiter ;

call whileProc();

drop procedure whileProc2;

delimiter $$
create procedure whileProc2()
	begin
		declare i int;
        declare hap int;
        set i = 1;
        set hap = 0;
        
        mywhile:
        while(i<=100) do
			if (i%4=0) then
				set i = i + 1;
                iterate mywhile;
			end if;
            
            set hap = hap+i;
            
            if (hap>1000) then
				leave mywhile;
			end if;
            
            set i = i + 1;
            
		end while;
        
        select '1부터 100까지의 합 (4의 배수 제외), 1000 넘으면 종료 ==>' as '조건', hap as '결과';
	end $$
delimiter ;

call whileProc2();

create table gate_table (
	id int auto_increment primary key,
    entry_time datetime
);

set @curDate = current_timestamp();

prepare mysql from 'insert into gate_table values(null,?)';
execute mysql using @curDate;
deallocate prepare mysql;

select * from gate_table;
    