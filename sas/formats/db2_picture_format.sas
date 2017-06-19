*******************************************************************************
*Dates for the DB2 pass-through - m needs to be lowercase in the picture definition;
***********************************************************************************;
PROC FORMAT;
PICTURE DB2DATE (MIN=11 MAX=11 DEFAULT=11)
	OTHER='%Y-%0m-%0D' (DATATYPE=DATE);
PICTURE DB2DATEQ (MIN=13 MAX=13 DEFAULT=13)
	OTHER=%NRSTR("'%Y-%0m-%0D'")(DATATYPE=DATE);
RUN;