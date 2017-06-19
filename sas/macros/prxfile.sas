%Macro PRXFILE(Source);
	%********************************************************************************;
	%*                                                                              *;
	%*  MACRO: PRXFILE                                                              *;
	%*                                                                              *;
	%*  USAGE: 1) %prxfile(argument)                                                *;
	%*                                                                              *;
	%*  DESCRIPTION:                                                                *;
	%*    This macro returns the file name when a full path is                      *;
	%*     passed to it.                                                            *;
	%*  E.g.:          %let macvar=%prxfile('E:\SAS\RSA\progname.sas')              *;
	%*  The variable macvar gets the value "progname"                               *;
	%*                                                                              *;
	%*  NOTES:                                                                      *;
	%*    You can use &_SASPROGRAMFILE or &_CLIENTPROJECTPATH as the                *;
	%*    input values. The path must have a three letter extension.                *;
	%*    To send the macro generated code to a log file in your home directory use *;
	%*    filename mprint '&home\logs\mprint_%prxfile(&_SASPROGRAMFILE).log'        *;
    %*    options mfile mprint                                                      *;
	%********************************************************************************;
	%local RegexID folder_name full_path_name file_name;
	%let full_path_name=%sysfunc(dequote(&source));
	%let RegexID=%sysfunc(PRXPARSE(S/(.*[\\|\/])[^\\|\/]+$/$1/));
	%if RegexID > 0 %then
		%do;
			%let folder_name=%sysfunc(PRXCHANGE(&RegexID,2, &full_path_name));

			%syscall PRXFREE(RegexID);
		%end;
	%else
		%do;
			%put Errors found in the pattern: &Regex;
		%end;
	%let file_name_ext=%SUBSTR(%str(&full_path_name),%LENGTH(%str(&folder_name))+1);
	%let file_name =%SUBSTR(%str(&file_name_ext),1,%LENGTH(%str(&file_name_ext))-4);

	%nrbquote(&file_name)
%Mend;
