data work02.H1;
set work02.longdata;
if label0='인구(명)' and var2='계';
run;

proc sgplot data=work02.H1 (where=(var1='전국' or var1='서울특별시' or var1='경기도'));
series x=label y=value / group=var1;	
run;

data work02.h2_all;
set work02.h1;if var1='전국';keep var1 label value;rename value=value_all;
run;

data work02.h2_city;
set work02.h1;if var1='서울특별시' or var1='경기도';keep var1 label value;
run;

proc sql;
create table work02.h2 as
(select a.var1, a.label, a.value, b.value_all from work02.h2_city as a left join work02.h2_all as b on a.label=b.label);
run;

data work02.h3;
set work02.h2;
value_ratio=value/value_all;
run;

proc sgplot data=work02.H3;
series x=label y=value_ratio / group=var1;	
run;
