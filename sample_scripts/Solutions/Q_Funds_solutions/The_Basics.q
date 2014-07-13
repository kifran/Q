show 2+3;
show 2*10+3;
x:56;
y:x%28;

.ns1.f1:{x-10};

t1:([]
	c1:`int$();
	c2:`symbol$();
	c3:`float$()
);

fxy:
 {[x;y] /comment1
				r1:(x*x)%(y*y); /comment2
		r2:.ns1.f1[y];
 r3:{[i;j]i-j}[x;y];
	r1
 };

s:(10;20;
	30;40);					
					
a:4.56;
b:9;
c:-21;
fabc:{[x;y;z]sum[(x;y;z)]%3};
/fabc:{[x;y;z]avg[(x;y;z)]};

r1:fabc[a;b;c];
show"functions";
show system"f";
/\f
/exit 0;
/\\
show"Advanced questions";

show"Q1";
100-2*(4+(10+1%2))
100-2*4+10+1%2

show"Q2";
(((100-2)*(4+10))+1)%2
(1+(100-2)*4+10)%2
%[1+(100-2)*4+10;2]
