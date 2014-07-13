\d .version


\c 200 200

.version.version:"1.0.0.10"
.version.builddate:"2008.11.13"
.version.starttimestamp:.z.z
.version.getversion:{[].version.version}
.version.getbuilddate:{[].version.getbuilddate}


\d . 

\d .log

debugflag:0b;

/Log Message function
logmsg:{[lvl;nm;msg;opts]neg[1] raze "<->","###" sv (string .z.Z;string nm;string lvl;msg;$[opts~();()," ";-3!opts])}

out:{[nm;msg;opts]logmsg[`normal;nm;msg;opts];}
err:{[nm;msg;opts]logmsg[`err;nm;msg;opts];}
warn:{[nm;msg;opts]logmsg[`warn;nm;msg;opts];}
debug:{[nm;msg;opts]if[.log.debugflag;logmsg[`debug;nm;msg;opts]];}

\d .

\d .utils
i:0

loadfile:{[dir;nm].log.out[.z.h;"Loading  the file ",( f:"/" sv  string dir,nm);()];
                 if[dir~`;f:1_ raze string f];
                 a:@[value;raze "\\l ",f;-1];
                 if[a~-1;.log.err[.z.h;"File could not be loaded.";()];:()];
                  .log.out[.z.h;"File sucesfully loaded";()];}
                
mkconstr:{[h;p] hsym `$ ":" sv string (h;p)}

opencon:{[x] .log.out[.z.h;"Opening connection to ", string x;()];
             h:@[hopen;x;-1];if[h~-1;.log.err[.z.h;"Could not open connection";()];:-1];
             .log.out[.z.h;"Sucesfully opened connection";()];h}

loadfuncp:{[x;y;z;w].log.out[.z.h;"Loading shared object ",(string x)," from ", string y;()]; 
                @[`.;z;:; y 2: (x;w)];
               .log.out[.z.h;"Finished loading shared object ",(string x)," from ", string y;()]; }

loadfunc:{[x;y;z;w].[loadfuncp;(x;y;z;w);{[x;y] .log.err[.z.h;"Exiting.Error loading Shared Object", string x;()];exit 0}[x]]}

getuid:{[] .utils.i+::1;.utils.i}

sendmail:{[s;g;txt] e:"\\bin/mail.sh " ,(-3!s), " ",(-3!txt)," ",("mailnames.txt"), " &" ;value e;}

sendmail1:{[s;g;txt] e:"\\bin/mail1.sh " ,(-3!s), " ",(-3!txt)," ",("mailnames.txt"), " &" ;value e;}


.utils.sd:{[x](-8!)x}
.utils.ds:{[x](-9!)x}

\d .params

baseport:4000^"I"$getenv[`QPORT]
configdir:(`$raze string (`$getenv[`HOME]),`$"/config/")^"S"$getenv[`QCONFIG]
logdir:getenv[`QLOGS]

\d .
