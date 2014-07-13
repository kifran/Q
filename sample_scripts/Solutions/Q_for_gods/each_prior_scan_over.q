show"Each Prior";
show "question 1";
/modify the dyadic addition function with the each prior adverb and then apply to a list 
show +':[1+til 10];
/or 
f:+':;
show f 1+til 10;

show "question 2";
l:10?999
show where <':[l]; /check if the current element is less than the prior element by modifying the dyadic '<' operator with each prior

show "question 3";
tbl:([]size:10?200 500 800 1000);
/
Run through the size column and divide each size by the previous size, therby giving a fractional change
over the previous value. The resultant column is labelled fraction. 
Then we can filter so that we only pick the rows where the size has doubled or more over the previous size
\
show select from(update fraction:%':[size]from tbl)where fraction>=2; 
/or 
show select from(update fraction:ratios size from tbl)where 2<=fraction;

show"Scan";

show"question 1";
show ,\["a";"bcdef"];
/or
show "a",\"bcdef";
/or
show 1_({ x,y}\)["abcdef"];

show "question 2";
/
this solution is a work around for the fact that we cannot use the '^' known as the fill operator on strings.
counting the strings and testing for a count of zero will identify empty strings.
If the current string is not empty, return the current input
If the current string is empty, return the previous output
\
str:15?("";"abc";"mn";"wxyz");

f:{$[count y;y;x]}\ 
f str 
/N.B. This was discussed on k4 listbox and {x maxs(til count x)*0<count each x}str performs better on longer lists.

show"Over";

show "question 1";
(*/)2 4 8 16 32 64

show "question 2";

show"i";
/
fib is taking an anonymous monadic function and modifying it with the over adverb.
We set the number of iterations at 10
See following link for explanation of scan and over behaviour:
https://code.kx.com/trac/wiki/Reference/Slash
\
fib:{{x,sum -2#x}/[x;1 1]}  
fib 10

show"ii";
g:{1,{[x;y]x,sum -2#x}/[1+til x]}
g 10


