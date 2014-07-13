/faster disk sort function
/
3 inputs
1st input: t - file descriptor to splayed table which needs to be sorted 
2nd input: c - column to sort on
3rd input: a - attribute to apply to on disk column

Example Usage: disksort[`:db5/trade/;`sym;`p#]
\
disksort:{[t;c;a] 
	if[not`s~attr(t:hsym t)c; /check to see if the splayed table is already sorted on c. If so, don't waste time sorting again
		if[count t;
			ii:iasc iasc flip c!t c,:();
			if[not$[(0,-1+count ii)~(first;last)@\:ii;@[{`s#x;1b};ii;0b];0b];
				{[x;y]
					v:get y;
					if[not
						$[all(fv:first v)~/:256#v;
							all fv~/:v;
							0b];
						v[x]:v;y set v];
					}[ii]each` sv't,'get` sv t,`.d]];
						@[t;first c;a]];t
			};
		
\c 10 150

n:1000000
trade:([]time:asc 9t+n?8t;sym:n?`IBM.N`MSFT.O`GOOG.L`UBS.L`BA.N;price:n?100f;size:n?1000);
/build on disk splayed table
set[`:db5/trade/;.Q.en[`:db5;trade]];

/sort method 2
show"optimised sort";
\ts disksort[`:db5/trade/;`sym;`p#]		
/		
n:1000000
trade:([]time:asc 9t+n?8t;sym:n?`IBM.N`MSFT.O`GOOG.L`UBS.L`BA.N;price:n?100f;size:n?1000);
/build on disk splayed table
set[`:db5/trade/;.Q.en[`:db5;trade]];

/sort method 1
show"standard sort";
\ts @[`sym xasc `:db5/trade/;`sym;`p#]


\l db5

		
