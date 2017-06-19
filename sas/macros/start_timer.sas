%macro start_timer();
  data _null_;
	  call symput('start_time',datetime());
  run;
%mend start_timer;
