res:1 1
f:{[]
	res,:res[i-1]+res[i-2];
	i+:1}
i:2
while[i<100;f[]]

i:2
n:10000000
res:1 1
\t while[i<n;f[]]


/Scan/Over solutions
/
From code.kx - 
If f is a monadic function, f\ calls f on its argument repeatedly until a value matching the argument 
or the last seen is produced. The result is the argument followed by all the results except the last.

When f\ is called with two arguments, the first argument can be either 
an integer number of iterations or a "while" condition that can be applied to the result of f
\
/fib is monadic
/keep appending the sum of the last 2 elements in the previous output list
fib:{[x]{x,sum -2#x}/[x;1 1]}; /over adverb is used.
\t res0:fib[n]

/f1 is monadic
f1:{reverse sums x}
\t res1:first each f1\[10000000;1 0]


