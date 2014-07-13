show"q1";
f:{x+y};
f[10;11];

show"q2";
f1:{neg (y*xexp[x+1;2])%(-1+2*x+1)};
res1:f1[10;3]

f0:{neg y*xexp[x+1;2]%-1+2*x+1};
/\t do[100000;res1:f0[10;3]]

show"q3";
f2:f1[10;];
show res2:f2[3];
show res1~res2;

show"q4";
res1:f2 til 10;
res2:f2 each til 10;
show res1~res2;

show"length 10";
\t do[10000;f2 til 10];
\t do[10000;f2 each til 10];
show"length 100";
\t do[10000;f2 til 100];
\t do[10000;f2 each til 100];
show"length 1000";
\t do[10000;f2 til 1000];
\t do[10000;f2 each til 1000];

show"q5";
show"a";
j:{[a]{a+1}[a]};

/j[2];
j:{[a]{x+1}[a]};
j[2];
j:{[a]{[a]a+1}[a]};
j[2];
show"b";
/j[`a];
show"c";
@[j;`a;{0}];
show"d";
@[j;`a;{show x;0}];
show"e";
@[j;`a;{err+:1;2 x}];







show"q5";











/