/*-------------------------------------------------------------------*
 *    Name: compare_libs.sas                                         *
 *   Title: Compare like datasets in cloned dataset libraries        *            
 *-------------------------------------------------------------------*
 * Author:   David Januszewski   <david.januszewski@rsagroup.ca>     *
 * Created:  19 Jun 2017                                             *
 * Version:  1                                                       *
 *-------------------------------------------------------------------*/
/*------------------------------------------------------------------*
| VARVALS macro - compare two similar libraries with same-named    |
|         datasets to compare variable attributes and table        |
|         row counts.                                              |
*------------------------------------------------------------------*/
%macro compare_libs(og_lib=,new_lib=);
	%*comparing the number of rows and columns;
	proc sql;
		create table og_dictionary_tables as
			select * from dictionary.tables
				where libname="&og_lib";
	quit;

	proc sql;
		create table new_dictionary_tables as
			select * from dictionary.tables
				where libname="&new_lib";
	quit;

	proc sql;
		create table dictionary_tables_compare as 
			select coalesce(t1.memname, t2.memname) as table_name,
				t2.nobs as nobs_og, t1.nobs as nobs_new, 		  
			case 
				when t1.nobs ne . and t2.nobs ne . 
				then t1.nobs - t2.nobs
			else .
			end 
		as nobs_diff,
			t2.nvar as nvar_og, t1.nvar as nvar_new, 
		case 
			when t1.nvar ne . and t2.nvar ne . 
			then t1.nvar - t2.nvar
		else .
		end 
	as nvar_diff
		from new_dictionary_tables t1
			full join og_dictionary_tables t2 on (t1.memname = t2.memname);
	quit;

	%*comparing the columns in the tables;
	proc sql;
		create table og_dictionary_columns as
			select * from dictionary.columns
				where libname="&og_lib";
	quit;

	proc sql;
		create table new_dictionary_columns as
			select * from dictionary.columns
				where libname="&new_lib";
	quit;

	proc sql;
		create table dictionary_columns_compare as 
			select coalesce(t1.memname,t2.memname) as table_name,
				coalesce(t1.name,t2.name) as column_name,
				t1.varnum as varnum_old, 
				t2.varnum as varnum_new, 
				t1.length as length_old, 
				t2.length as length_new, 
				t1.format as format_old, 
				t2.format as format_new
			from og_dictionary_columns t1
				full join new_dictionary_columns t2 on (t1.memname = t2.memname) and (t1.name = t2.name);
	quit;
	
	proc sql;
		drop table og_dictionary_tables;
		drop table new_dictionary_tables;
		drop table og_dictionary_columns;
		drop table new_dictionary_columns;
	quit;

%mend compare_libs;
