delimiter $$
	create procedure user_proc()
		begin
			select * from member;
		end $$
delimiter ;

call user_proc();
drop procedure user_proc;
drop procedure user_proc3;

delimiter $$
	create procedure user_proc1(in userName varchar(10))
		begin
		
			select * from member where mem_name = userName;
		
		end $$
	
    create procedure user_proc3(in txtValue char(10), out outValue int)
		begin
			insert into noTable values(null, txtValue);
            select max(id) into outValue from noTable;
            -- noTable테이블의 id값 중 제일 큰 값을 outValue변수에 넣어라
        end $$
        
	create procedure ifelse_proc(in memName varchar(10))
		begin
			declare debutYear int;
            -- 지역변수생성
            
            select year(debut_date) into debutYear from member
				where mem_name = memName;
			-- member테이블에서 멤버네임과 파라미터이름이 같은 로우의
            -- debut_date를 가져와 년도만 추출하여 debutYear 변수에 담아라
			
            if(debutYear >=2015) then
				select '신인 가수, 화이팅~' as msg;
			else
				select '고참 가수, 수고요~' as msg;
			end if;
        end $$
        
	create procedure dynamic_proc(in tableName varchar(20))
		begin
            set @sqlQurey = concat('select * from ', tableName);
            -- 사용자 변수생성
            prepare myQuery from @sqlQurey;
            execute myQuery;
            deallocate prepare myQuery;
        end $$
delimiter ;

drop procedure dynamic_proc;
call user_proc1('블랙핑크');

create table noTable(
	id int auto_increment primary key,
	txt char(10)
);

call user_proc3('test1', @myValue);
call user_proc3('test2', @myValue);
call user_proc3('test3', @myValue);
select concat('입력된 id 값 ==>',@myValue) as meg;

drop table noTable;

call ifelse_proc('오마이걸');
call dynamic_proc('member');

set global log_bin_trust_function_creators = 1;
use market_db;

-- 이 안에서 스토어드 프로시저나 함수 작성 가능
delimiter $$
	create function sumFunc(number1 int, number2 int) returns int
		begin
			return number1 + number2;
		end $$
		
	create function calcYearFunc(dYear int) returns int
		begin
			declare runYear int; -- 변수생성
            set runYear = year(curdate()) - dYear;
            return runYear;
        end $$
        
	create procedure cursor_proc()
		begin
			declare memNumber int;
            declare cnt int default 0; -- 변수선언과 초기화
            declare total int default 0;
            declare endOfRow boolean default false;
            
            declare memberCursor cursor for
				select mem_number from member;
                
			declare continue handler for
				not found set endOfRow = true;
                
			open memberCursor;
            
            cursor_loop: Loop
				fetch memberCursor into memNumber;
                
                if endOfRow then
					leave cursor_loop; -- break
				end if;
                
                set cnt = cnt + 1;
                set total = total + memNumber;
			END loop cursor_loop;
            
            select (total/cnt) as '회원의 평균 인원 수';
            
            close memberCursor;
        end $$
delimiter ;

select sumFunc(100, 200) as '합계';
select calcYearFunc(2010) as '활동 햇수';

select calcYearFunc(2007) into @debut2007;
select calcYearFunc(2013) into @debut2013;
select @debut2007-@debut2013 as '2007과 2013차이';

-- 함수 체이닝
select mem_id, mem_name, calcYearFunc(year(debut_date)) as '활동 햇수' from member;

drop function calcYearFunc;

call cursor_proc();
select mem_id, mem_number from member;
