create database SQLDtest;
use SQLDtest;

create table TBL1(
	COL1 char(2),
    COL2 char(2)
);

create table TBL2(
	COL1 char(2),
	COL2 char(2)
);

create table TBL1(
	COL1 char(2),
	COL2 int
);

drop table TBL1;

insert into TBL1 values('AA', 'A1');
insert into TBL1 values('AB', 'A2');

insert into TBL2 values('AA', 'A1');
insert into TBL2 values('AB', 'A2');
insert into TBL2 values('AC', 'A3');
insert into TBL2 values('AD', 'A4');

insert into TBL1 values('AA', 10);
insert into TBL1 values('AA', 5);
insert into TBL1 values('AB', 20);
insert into TBL1 values('AB', 40);

select col1, col2, COUNT(*) as CNT
	from (select col1, col2 from TBL1
			union ALL
            select col1, col2 from TBL2
            UNION
            select col1, col2 from TBL1) as test
		GROUP BY COL1, COL2;


select col1, sum(col2) from TBL1
	group by col1
    union all
    select null, sum(col2) from TBL1
    order by 1 asc;
    
select col1, sum(col2) from TBL1
	group by grouping (col1)
    order by 1 asc;
    
select col1, sum(col2) from TBL1
	group by col1 with rollup
    order by 1 asc;
    
