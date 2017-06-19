/*-------------------------------------------------------------------*
 *    Name: VARVALS.sas                                              *
 *   Title: Create a table of variable characteristics               *            
 *-------------------------------------------------------------------*
 * Author:   David J                                                 *
 * Created:  28 Nov 2016                                             *
 * Version:  1                                                       *
 *-------------------------------------------------------------------*/
/*------------------------------------------------------------------*
| VARVALS macro - create a variable values summary                 |
|         dataset to view a summary of the values for all columns  |
|         This macro samples without replacement from the dataset  |
|         in order to quickly build a summary of randomly sampled  |
|         values                                                   |
*------------------------------------------------------------------*/
%macro varvals(
			lib=WORK,             /* Input library                     */
			ds=_LAST_ ,           /* Input dataset                     */
			n=20);                 /* Number of observations to sample  */
	%let lib=%upcase(&lib);
	%let ds=%upcase(&ds);
	%put &ds;
	proc sql inobs=&n;
		create table x as
			select * from &lib..&ds;
		%let sqlobsn=&sqlobs;
	quit;
	%put &sqlobsn;
	proc sql;
		drop table x;
	quit;
	%if %sysevalf(&sqlobsN < &n) %then
		%do;
			%put ERROR: Random sample size is larger than the number of observations in the dataset;
			%goto done;
		%end;
	proc sql;
		create table VARVALS as 
			select varnum, name, length, type, format
				from sashelp.vcolumn
					where upcase(libname)="&lib" and upcase(memname)="&ds";
		%let sqlobsv=&sqlobs;
	quit;

	proc sql noprint;
		select name into: vnames separated by ' ' 
			from VARVALS;
	quit;
	%put &vnames;
	data work.rsubset_vars( drop = obsleft sampsize);
		sampsize = &n;
		obsleft = totobs;
		do while( sampsize > 0);
			pickit + 1;
			if ranuni( 0) < sampsize/ obsleft then
				do;
					set &lib..&ds point = pickit nobs = totobs;
					output;
					sampsize = sampsize-1;
				end;
			obsleft = obsleft-1;
		end;
		stop;
	run;
	PROC SQL noprint;
		SELECT t1.name INTO: VNAMES_DT SEPARATED BY ' '
			FROM WORK.VARVALS t1
				WHERE UPCASE(TYPE)='NUM' and t1.format IN ('DATE9.','YYMMDDN8.','YYMMDD10.','$YMMDDN8.','DDMMYYD10.');
		%let sqlobsd=&sqlobs;
	QUIT;
	proc sql;
		create table WORK.VRANGE_DT( bufsize=102400 )
			(
			name char(31) format=$CHAR31. informat=$CHAR31.,
			VARRANGE char(1024) format=$CHAR1024. informat=$CHAR1024.
			);
	quit;
	%let l=1;
	%do %until (&sqlobsd<&l);
		%let tempvarname&l=%scan("&vnames_dt",&l," ");
		proc sql;
			create table range_of_var as
				select  
					put((min(t1.&&tempvarname&l)),date9.) as min_of_var,
					put((mean(t1.&&tempvarname&l)),date9.) as mean_of_var,
					put((max(t1.&&tempvarname&l)),date9.) as max_of_var
				from work.rsubset_vars t1;
		quit;
		proc sql noprint;
			select t1.min_of_var,t1.mean_of_var,t1.max_of_var into: min_var&l,:mean_var&l,:max_var&l
				from range_of_var t1;
		quit;
		proc sql;
			insert into WORK.VRANGE_DT
				values("&&tempvarname&l","min=&&min_var&l,mean=&&mean_var&l,max=&&max_var&l");
		quit;
		proc sql;
			drop table range_of_var;
		quit;
		%let l=%eval(&l+1);
	%end;
	PROC SQL noprint;
		SELECT t1.name INTO: VNAMES_NUM SEPARATED BY ' '
			FROM WORK.VARVALS t1
				WHERE UPCASE(TYPE)='NUM' and t1.format NOT IN ('DATE9.','YYMMDDN8.','YYMMDD10.','$YMMDDN8.','DDMMYYD10.');
		%let sqlobsn=&sqlobs;
	QUIT;
	proc sql;
		create table WORK.VRANGE( bufsize=102400 )
			(
			name char(31) format=$CHAR31. informat=$CHAR31.,
			VARRANGE char(1024) format=$CHAR1024. informat=$CHAR1024.
			);
	quit;
	%let k=1;
	%do %until (&sqlobsn<&k);
		%let tempvarname&k=%scan("&vnames_num",&k," ");
		proc sql;
			create table range_of_var as
				select  
					(min(t1.&&tempvarname&k)) as min_of_var,
					(mean(t1.&&tempvarname&k)) as mean_of_var,
					(max(t1.&&tempvarname&k)) as max_of_var
				from work.rsubset_vars t1;
		quit;
		proc sql noprint;
			select t1.min_of_var,t1.mean_of_var,t1.max_of_var into: min_var&k,:mean_var&k,:max_var&k
				from range_of_var t1;
		quit;
		proc sql;
			insert into WORK.VRANGE
				values("&&tempvarname&k","min=&&min_var&k,mean=&&mean_var&k,max=&&max_var&k");
		quit;
		proc sql;
			drop table range_of_var;
		quit;
		%let k=%eval(&k+1);
	%end;
	PROC SQL noprint;
		SELECT t1.name INTO: VNAMES_CHAR SEPARATED BY ' '
			FROM WORK.VARVALS t1
				WHERE UPCASE(TYPE)='CHAR';
		%let sqlobsc=&sqlobs;
	QUIT;
	proc sql;
		create table WORK.VMODEC( bufsize=102400 )
			(
			name char(31) format=$CHAR31. informat=$CHAR31.,
			VARMODE char(1024) format=$CHAR1024. informat=$CHAR1024.
			);
	quit;
	%let j=1;
	%do %until (&sqlobsc<&j);
		%let tempvarname&j=%scan("&vnames_char",&j," ");
		proc sql outobs=5;
			create table count_of_varc as
				select t1.&&tempvarname&j, 
					(count(t1.&&tempvarname&j)) as count_of_var
				from work.rsubset_vars t1
					group by t1.&&tempvarname&j
						order by count_of_var desc;
		quit;
		proc sql noprint;
			select t1.&&tempvarname&j into: most_freq_vars&j separated by ','
				from work.count_of_varc t1;
		quit;
		proc sql;
			insert into WORK.VMODEC
				values("&&tempvarname&j","&&most_freq_vars&j");
		quit;
		proc sql;
			drop table count_of_varc;
		quit;
		%let j=%eval(&j+1);
	%end;
	proc sql;
		create table WORK.VUNIQUE( bufsize=102400 )
			(
			name char(31) format=$CHAR31. informat=$CHAR31.,
			num_unique char(31) format=$CHAR31. informat=$CHAR31.,
			percent_missing char(31) format=$CHAR31. informat=$CHAR31.
			);
	quit;
	%let i=1;
	%do %until (&sqlobsv<&i);
		%let tempvarname&i=%scan("&vnames",&i," ");
		proc sql noprint;
			select count(unique(&&tempvarname&i)),put(nmiss(&&tempvarname&i)/&n,percentn8.2) as percent_missing into: num_unique_vars&i,:perc_miss&i
				from work.rsubset_vars;
		quit;
		proc sql;
			insert into WORK.VUNIQUE
				values("&&tempvarname&i","&&num_unique_vars&i of &n sampled","&&perc_miss&i");
		quit;
		%let i=%eval(&i+1);
	%end;
	proc sql;
		drop table work.VARVALS;
	quit;
	proc sql;
		create table work.varval1 as 
			select t1.name, 
				strip(t1.num_unique) as num_unique, 
				strip(t1.percent_missing) as percent_mising
			from work.vunique t1;
	quit;
	proc sql;
		create table work.varval2 as 
			select name, substr(compress(varmode),1,100) as varvals
				from work.vmodec
					outer union corr 
						select name, substr(compress(varrange),1,100) as varvals
							from work.vrange_dt
								outer union corr 
									select  name, substr(compress(varrange),1,100) as varvals
										from work.vrange;
	quit;
	proc sort data=varval1;
		by name;
	run;
	proc sort data=varval2;
		by	name;;
	run;
	data varval;
		merge varval1 varval2;
	run;
	proc datasets nolist;
		delete rsubset_vars vmodec vrange vrange_dt vunique varval1 varval2;
	run;
%done:
	%*-- Restore global options;
	options notes;
%mend varvals;
