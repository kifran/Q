
\c 20 120

qpd:5*2*4*"i"$16:00-09:30
date:raze(100*qpd)#'2009.01.05+til 5
sym:(raze/)5#enlist qpd#'100?`4
sym:(neg count sym)?sym
time:"t"$raze 500#enlist 09:30:00+15*til qpd
time+:(count time)?1000
side:raze 500#enlist raze(qpd div 2)#enlist"BA"
level:raze 500#enlist raze(qpd div 5)#enlist 0 1 2 3 4
level:(neg count level)?level
price:(500*qpd)?100f
size:(500*qpd)?100
quote:([]date;sym;time;side;level;price;size)

/ pivot t, keyed by k, on p, exposing v
/ f, a function of v and pivot values, names the columns
/ g, a function of k, pivot values, and the return of f, orders the columns
/ either can be defaulted with (::)
/ conceptually, this is
/ exec f[v;P]!raze((flip(p0;p1;.))!/:(v0;v1;..))[;P]by k0,k1,.. from t
/ where P~exec distinct flip(p0;p1;..)from t
/ followed by reordering the columns and rekeying

piv:{[t;k;p;v;f;g]
	v:(),v;
	G:group flip k!(t:.Q.v t)k;
	F:group flip p!t p;
	count[k]!g[k;P;C]xcols 0!key[G]!flip(C:f[v]P:flip value flip key F)!raze
	{[i;j;k;x;y]
		a:count[x]#x 0N;
		a[y]:x y;
		b:count[x]#0b;
		b[y]:1b;
		c:a i;
		c[k]:first'[a[j]@'where'[b j]];
   c}[I[;0];I J;J:where 1<>count'[I:value G]]/:\:[t v;value F]
   };
   
f:{[v;P]
	`$raze each string raze P[;0],'/:v,/:\:P[;1]
	};
g:{[k;P;c]k,(raze/)flip flip each 5 cut'10 cut raze reverse 10 cut asc c}
      / `Bpricei`Bsizei`Apricei`Asizei for levels i
	  
q:select from quote where sym=first sym

book:piv[`q;`date`sym`time;`side`level;`price`size;f;g]
![`book;();`date`sym!`date`sym;{x!fills,'x}cols get book];

show book


	  
   


 
