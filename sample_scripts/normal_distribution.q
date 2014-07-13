
gen:{[n] sqrt[-2*log n?1.0]*cos[2*3.14159265358979*n?1.0]}

t:([]x:gen 1000000);

y:select n:count i by 0.1 xbar x from t;

save `:y.csv

