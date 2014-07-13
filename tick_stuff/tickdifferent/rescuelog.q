/ rescue tickerplant logfile after crash 
/ for kdb+ 2.4 or later 
"kdb+rescuelog 0.4 2008.09.22"

lreplay:{-11!(-1;x)} /replay entire log file. Same as -11!x

/
-11!(-2;x)
given a valid logfile, return the number of chunks.
given an invalid logfile, return the number of valid chunks and length (in bytes) of the valid part.
\
lgoodtil:{-11!(-2;x)}

lgooditems:{first lgoodtil x}
lgoodcount:{last lgoodtil x}
lcount:hcount 
lvalid:{(lcount x)=lgoodcount x}
lreplaygood:{-11!(lgooditems x;x)}
dummyupd:{[x;y]}
/ upd:dummyupd


/
.z.ps:{[x]show".z.ps";value x}; /If .z.ps is defined, it will execute if you replay the TP log file
upd:{[t;x]show"upd"}; /the messages within the log file are invocations of the dyadic function upd
