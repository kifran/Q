/ 2005.05.12  x@&"6"=x[;3] /updates (image is 340)
/ q tick/ssl.q {sym|taq|fx|dj30|sp500} [host]:port[:usr:pwd]
/ modify this file for your feeds and schemas
/ 100,000 triarch/ssl records per second

\c 200 200

\l q/utils.q
\l q/timer.q
\t 1000

rld:.z.d;
.timer.inserttimercfg[`reload;`time$2*1000]
reload:{[x]if[.z.z>rld+06:00:00.000;rld+:1;.log.out[.z.a;"Starting Re Sub Mechanism.";()];subscribe[]];}

tp:`:localhost:5010
symfile:`$"tick/sym.txt"
sym:()
o:.Q.opt .z.x;
show o;
if[ `tp in key o;tp:hsym `$ first o[`tp]];
if[ `symfile in key o;symfile:hsym `$ first o[`symfile]];


x:.z.x,count[.z.x]_("sym";":5010")
if[not h:neg @[hopen;tp;0];trade:3#();quote:5#();.u.upd:{@[x;::;,;y]}]
sub:`ssl 2:(`sub;1)
ssub:`ssl 2:(`ssub;2)
init:`ssl 2:(`init;1)
subscribe:{[].log.out[.z.a;"Starting to Subscribe.";()];oldsym::sym;.log.out[.z.a;"Subscribing to symbol list";()];init[`$QSSLUSER];@[ssub[`IDN_RDF] each;sym::`$read0 symfile;()];if[ count oldsym;report[]];
            }
report:{[].log.out[.z.a;"Count of subscribed syms in new list: ",string count sym;()];
           .log.out[.z.a;"Count of old subscribed syms in new list: ", string count oldsym;()];
           .log.out[.z.a;"New syms and old syms are listed.";a:`new`removed!(sym except oldsym;oldsym except sym)];
            .utils.sendmail[(first o[`insname]),"SSL Resubscribe.";"";raze (" Resubscription Process Complete.";"Server is: ",(string .z.h);" There were ",(string count a[`new])," new syms ";" There were ",(string count a[`removed])," removed syms")]; 	     
            }

/"There were ",(string count a[`removed])," removed syms"
/"There were ",(string count a[`new])," new syms";
/.utils.sendmail[(first o[`insname]),"SSL Resubscribe.";"";raze (" Resubscribe Process Complete.";"Server is: ",(string .z.h);"Added Syms are:")]; 	     
/.utils.sendmail[(first o[`insname])," KDB+ TEST ";`g;-3!("Successfull TEST";"Server: ",(string .z.h);"Instance is: ",first o[`insname];"Port is: ",string system "p";"Date is: ",string .z.d;"Time is:",(string .z.t)," GMT";"Process ID is: ",string .z.i;"Script is: ssl.q")]
          
QSSLUSER:getenv[`QSSLUSER]

if[QSSLUSER~"";.log.out[.z.a;"QSSLUSER not defined. Resetting to current username.";()];QSSLUSER:string .z.u];
.log.out[.z.a;"QSSLUSER is:", QSSLUSER;()];

s:@[init; `$QSSLUSER;1]
if[s~1;.log.err[.z.a;"Error Connecting To SSL Server. Exiting.";o];exit 0];

/init[`$QSSLUSER]
subscribe[]

//@[init; `$QSSLUSER;{[x] .log.err[.z.a;"Error connecting to SSL Server. Exiting.";()];exit 0}[x]]

/ callbacks
close:0#`;stt:{[r;e;s]if[s in 7 8;close,:r];};

ipcr:string first `$(read0 `:ipcroute);
ip_ssl_server:ipcr[(1+last ipcr ss ":") + til ((-1+count ipcr)-(last ipcr ss ":"))];

dis:{.log.out[.z.a;"Disconnect from Reuters.";()];
      .utils.sendmail["REUTERS SSL FEED HANDLER HAS DISCONNECTED ";`g;-3!("REUTERS SSL FEED HANDLER HAS DISCONNECTED";"Tick Server: ",(string .z.h);"SSL Server's IP: ",ip_ssl_server;"Instance is: ",first o[`insname];"Port is: ",string system "p";"Date is: ",string .z.d;"Time is:",(string .z.t)," GMT";"Process ID is: ",string .z.i;"Script is: ssl.q")]
      };
      
rec:{.log.out[.z.a;"Reconnected to Reuters.";()];
	.utils.sendmail["REUTERS SSL FEED HANDLER HAS CONNECTED SUCCESSFULLY";`g;-3!("REUTERS SSL FEED HANDLER HAS CONNECTED SUCCESSFULLY";"Server: ",(string .z.h);"SSL Server's IP: ",ip_ssl_server;"Instance is: ",first o[`insname];"Port is: ",string system "p";"Date is: ",string .z.d;"Time is:",(string .z.t)," GMT";"Process ID is: ",string .z.i;"Script is: ssl.q")]
      };

g:(!).("I*";0x1f)0:  / (fids!values) from string   note: ask 0(means 0w)
/ fid funcs: price bid ask size bsize asize ttime qtime price buysell
fi:6 22 25 178 30 31 379 1025 1067 393 270 131 1021 32 211 372 373 375!("F"$;"F"$;"F"$;"I"$;"I"$;"I"$;"V"$;"T"$;"T"$;"F"$;31="I"$;"I"$;"I"$;"I"$;"I"$;"F"$;"I"$;"T"$)
/ default trade and quote fields (and sym function)
ti:1067 6 178 131 32 1021;qi:1025 22 25 30 31 211;  sf:{3_first x}
qj:22 25

irj:374;		/unique FID identifying message as of type irregular trade
iri:379 372 373 1021;         /full FIDS for irregular trade message
irf:fi iri	/function to be ran on the irregular trade FIDS

tcj:372; 		/unique FID identifying message as of type correction trade
tci:375 372 373 1021;   /full FIDS for correction trade message
tcf:fi tci		/function to be ran on the correction trade FIDS


cond:"BCDJKL STWZ"16 3 4 23 24 1 -1 138 61 171 139?"I"$;  /40 (.O uses 131)
mode:" AB  FHILNO R  XZY"15 14 62 27 17 16 36 61 35 63 28 60 57 58 188 29 96?"I"$;

/ update callback

t:q:ir:tc:();


f:{
    ktc each x where"7"=x[;3]; 
    ki each x where"0"=x[;3]; 
    k each x where"6"=x[;3]; 
  if[count t;h(".u.upd";`rtrade;flip t)];
  if[count q;h(".u.upd";`rquote;flip q)];
  if[count ir;h(".u.upd";`rtradeirreg;flip ir)];
  if[count tc;h(".u.upd";`rtradecorr;flip tc)];
  t::q::ir::tc::()}

ktc:{s:`$sf x:g x;e:last ` vs s;if[tcj in key x;tcdata:tcf@'x tci;tc,:enlist (s,tcdata[0 1 2],(0N;0N),tcdata[3],e)]}
 
/ default parse
k:{s:`$sf x:g x;e:last ` vs s; 
 if[    tj in key x;t,:enlist (s,tf@'x ti),e];
 if[any qj in key x;$[(count x[118]);bc:ac:`$x[118];(count x[131]);bc:ac:`$x[131];(count x[3264]);bc:ac:`$x[3264];bc:ac:`];qdata:qf@'x qi;qdata:qdata[0+til 5],(bc;ac),qdata[5];q,:enlist s,qdata,e,`$(x[293 296])];
 if[irj in key x;irdata:irf@'x iri;ir,:enlist (s,irdata[0 1 2],(0N;0N),irdata[3],e)]}
  
tj:6;tf:fi ti;qf:fi qi

ki:{;s:`$sf x:g x;e:last ` vs s;
    //.log.out[.z.a; "Processing Image for sym ", string s;x];
  }


/
/ sample overrides
if[d~"fx";ti:393 270;qi:22 25]

if[d~"taq";
 cond:"BCDJKL STWZ"16 3 4 23 24 1 -1 138 61 171 139?"I"$;  /40 (.O uses 131)
 mode:" AB  FHILNO R  XZY"15 14 62 27 17 16 36 61 35 63 28 60 57 58 188 29 96?"I"$;
 k:{if[o:"O"=e:last s:sf x:g x;e:"T"];s:`$-2_s;
  if[    tj in key x;t,:enlist s,(tf@'x ti),(0b;cond x 40 131 o;e)];
  if[any qj in key x;q,:enlist s,(qf@'x qi),(mode x 118;e)];}]

if[d~"lvl2";
 f:{i each x where not u:"6"=x[;3];k each x where u;if[count q;h(".u.upd";`quote;flip q)];q::()};
 k:{if[any qj in key x:g x;q,:enlist(`$-4_s;`$-4#s:-2_sf x),qf@'x qi]};
 i:{m,:sub each`$u where 9<count each u:(x:g x)800+til 14;if[count u:x 815;sub`$u]}]


/
/ maintain previous bid/ask state and fill if necessary
bid:ask:()!`float$()
as:{[s;x]$[null x;ask s;ask[s]:x]}
bs:{[s;x]$[null x;bid s;bid[s]:x]}
k:{s:`$sf x:g x;
 if[    tj in key x;t,:enlist s,tf@'x ti];
 if[any qj in key x;q,:enlist s,(as[s];bs[s];::;::)@'qf@'x qi];}

\

MSFT.O GE.N
VOD.L RTR.L
CAD=D2 EUR=EBS

London - (cond1)1068,(cond2)1069
euro:`AS`AT`BR`CO`DE`HE`I`IN`J`L`LN`MC`MI`OL`PA`ST`VI`VX
sym!:(count sym)#`;stt:{[r;s]if[not s=9;sym[r]:`ok`stale`close 10 11?s]}
