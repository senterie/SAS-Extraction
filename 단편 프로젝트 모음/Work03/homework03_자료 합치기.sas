data w1_raw;
set json.data_city;
if length(div_num)<3 then delete;
run;

data compare_all;run;
%macro homework03;
%do year=1993 %to 2017;

proc sql;
create table w1 as
select *
from w1_raw where year=&year;
quit;
run;

proc sql;
create table w2 as
select *
from json.data_state where year=&year;
quit;
run;

proc sql;
create table w1_01 as
select *, substr(div_num, 1, 2) as div_state, sum(num) as sum
from w1 where substr(div_num, 5,1)="0"
group by div_state, old;
quit;
run;

proc sort data = w1_01 out=w1_02 nodupkey;
by div_state old;
run;

proc sql;
create table compare as
select a.year, a.old, a.num, a.div_state, a.sum, b.year as year_original, b.old as old_original, b.div as div_original, b.div_num as div_num_original, b.num as sum_original
from w1_02 as a left join w2 as b
on a.div_state=b.div_num and a.old=b.old and a.year=b.year;
quit;
run;

proc sql;
create table adjust_01 as
select *,
sum(case when (select count(*) from compare where old="100세 이상")^=0 then 1 else 0 end) as up100,
sum(case when (select count(*) from compare where old="85세 이상")^=0 then 1 else 0 end) as up85
from compare;
quit;

data adjust_02;
set adjust_01;
if up85>0 and old="80세 이상" then delete;
if up100>0 and old="80세 이상" then delete;
if up100>0 and old="85세 이상" then delete;
run;

data compare_all;
set compare_all adjust_02;
run;

%end;
%mend homework03;
%homework03
data compare_all;set compare_all;if _n_<7 then delete;run;

data compare_all;
set compare_all;
if sum=sum_original then compare=0; else compare=1;
run;

data semi_final;
set compare_all;
if old^='계' then old_num=put(input(scan(old, 1, '세'),best.),Z3.);
run;
proc sort data=semi_final;
by year div_state old_num;
run;

data final;
set semi_final;
drop up100 up85 old_num;
run;

proc means data=final;
var compare;
run;
