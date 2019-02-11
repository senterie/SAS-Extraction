%let dir=D:\OneDrive\Github\SAS-Extraction\지방재정365\sas7bdat\;
%let lib=json;
%let String01=ESJRV1000133420181212043443CMJUY;/*apiKey*/

libname &lib "&dir";

%macro json(String05, date_s, date_e);

	%do date_want=&date_s %to &date_e;
	data L001_&date_want;run;

		%let string02=1;
		%do %until (&check=200);

		%let url=&string05?key=&string01&type=json&pindex=&string02&psize=100&accnut_year=&date_want;

		filename out "&dir.SeriesDataOut.txt" recfm=v lrecl=999999999;
		proc http out=out url="&url" method="post" ct="application/json";
		run;

		data raw;
		infile "&dir.SeriesDataOut.txt" dsd lrecl=999999999 dlm='{}[]:,';
		input raw : $2000.@@;
		if _n_=5 then call symput('check', scan(raw,2));
		run;

		data temp;
		merge raw raw(firstobs=2 rename=(raw=_raw));
		if mod(_n_,2) eq 0;
		run;

		data temp;
		set temp;
		if raw='' then group+1;
		run;

		proc transpose data=temp out=data_one(drop=_:);
		by group;
		id raw;
		var _raw;
		run;

		data L001_&date_want;
		set L001_&date_want data_one;
		run;

		%let string02=%eval(&string02+1);

		%end;

	%end;

  data &lib..&table(drop=group RESULT CODE MESSAGE ARBGT list_total_count);
  set L001_&date_s-L001_&date_e;
  if accnut_year="" then delete;
  run;

%mend;

%json(String05=http://lofin.mois.go.kr/HUB/ARBGT, table=table001, date_s=2010, date_e=2020);
