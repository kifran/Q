
show x:1056 14 145 7261 5496 1201 -9643;
show"q1";
show 60+til 20;
show"q2";
show avg x;
show mavg[2;x];
/2 mavg x
show med x;

show"q3";
w:38 47 10 55 60 81 20;
show wavg[w;x];

show"q4";
show dev x;
dev2:{[x]sqrt (avg x*x)-(xexp[avg x;2])};
show dev[x]=dev2[x];

show"q5";
show deltas[x];
show "x";
show x
/
show "next x";
show next x;
show "prev x";
show prev x;
show x-prev x;
show x^x-prev x;
show 999^x-prev x;

show"q6";
show max x;
show min x;

show"q7";
show abs x;
show max abs x;
show min abs x;

show"q8";
show signum x;
show x>=0;

show"q9";
show prd 1+til 10;
show f:{[x]prd 1+til x};
show f[10];

show"q10";
show sum x;

show"q11";
show sums x;
show prds x;

show"q12";
show y:mod[x;12];
show z:div[x;12];
show x=y+12*z;

show"q13";
show floor x%z;

show"q14";
show a:0N 14 66 4 22 66 0N 72 26 0N;
show (ceiling avg[a where not a=0N])^a;
show fills a;

show"q15";
show a where not null a;
show a where not a=0N;

show"q16";
show distinct `a`b`a`b`c`a`b`a`b`c`b`c`a;

show"q17";
cut[4;lower .Q.A];









/