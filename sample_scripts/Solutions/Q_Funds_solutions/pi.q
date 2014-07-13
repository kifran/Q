
\P 0
pi_calc1:{[n]
	x:n?1f;
	y:n?1f;
	d:sqrt (x*x)+(y*y);
	num:sum d<1;
	/num:count d where d<1;
	pi:4*num%n;
	pi
 };

pi_calc2:{[n]
	x:n?1f;
	y:n?1f;
	points:,'[x;y];
	num: sum{[p]
	d:sqrt (p[0]*p[0])+(p[1]*p[1]);
	res:d<1;
	res
	}each points;
	pi:4*num%n;
	pi
 };
 
\t pi1:pi_calc1[10000000];
\t pi2:pi_calc2[10000000]; 