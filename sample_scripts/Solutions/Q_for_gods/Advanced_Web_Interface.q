
\l ../taq2.q

/1)
.z.pho:.z.ph
.z.ph:{0N!(.z.Z;"i"$0x0 vs .z.a;.z.u;.z.w;first x); .z.pho x}

/
/2)
\d .h
.z.ph:{x:uh$[@x;x;*x];$[~#x;hy[`htm]fram[$.z.f;x]("?";"?",*x:$."\\v");x~,"?";hp@{hb["?",x]x}'$."\\v";
	"?["~2#x;hp jx["J"$2_x]R  "?"=*x; @[{hp@alg'jx[0j]R::. 1_x};x;he];"?"in x;
	@[{hy[t]@`/:tx[t:`$-3#n#x]@.(1+n:x?"?")_x};x;he]
  #r:@[1::;`$":",p:HOME,"/",x;""];hy[`$(1+x?".")_x]"c"$r;hn["404 Not Found";`txt]p,": not found"]}
\
alg:{.q.ssr[.q.ssr[.q.ssr[x;"&";"&amp;"];">";"&gt;"];"<";"&lt;"]}

/3)
\d .h
html:{htc[`html]htc[`head;"<meta http-equiv=\"refresh\" content=\"10\">",htc[`style]sa,sb],htc[`body]x};

hp:hy[`htm]html pre@;

/4)
\d .h
jx:{[j;x]N:(*."\\C")-4;$[$[.Q.qt[x];N<n:#x;0];(" "/:ha'["?[",/:$(0;0|j-N),|&\(n-N;j+N); $`home`up`down`end],,($n),"[",($j),"]";"");()],$[.Q.qt[x];,htbl .q.sublist[j,N]x;.Q.S[."\\C";j]x]}

htbl:{g:{(#*y)#'(,,"<",x),y,,,"</",x:($x),">"};,/htac[`table;(,`class)!,"standard"](htc[`thead]htc[`tr]@,/htc[`th]'$!x),htc[`tbody]@,/,/'+g[`tr]@,/`td g',:'$. x:+0!x}

html:{htc[`html]htc[`head;.h.htac[`script;`type`src!("text/javascript";"plaid.js")]""],htc[`style;sa,sb],htc[`body]x}

hp:hy[`htm]html pre@;


