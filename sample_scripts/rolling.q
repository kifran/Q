\l taq.q

/1st Solution
/x is the current element of the data vector (price)
/we build up the global vector called LIST with elements from price 
/Once we reach N elements, we remove the first element from the LIST on each iteration of inner1 
/the aggregation is calculated on LIST and returned

inner1:{[x;N;agg]
	LIST,:x;
	if[(count LIST)>N;LIST _:0];
	agg LIST
	};

outer1:{[n;data;agg]
	LIST::();
	r:inner1[;n;agg]each data;
	r
 };
/show .Q.w[]; 

show"1st Solution"; 
\ts trade:update rolling1:outer1[100;price;avg] by sym from trade; 
/show .Q.w[]; 
/
/2nd Solution
/input x is the previous output
/input y is the current element in data vector (price)
inner2:{[x;y;N]
	$[(count x)>=N; /If there are more than N elements in the previous output, drop the earliest element
	:(1_x),y;
	:x,y] /Otherwise return the current input appended to the previous output
	};

/n is number of previous rows to look back on
/use scan adverb on dyadic function inner3 to iterate of data vector (price) such that the current output is obtained 
/by passing as inputs to inner3 the previous output and the current input (in that order).
outer2:{[n;data;agg]
	y:inner2[;;n]\[data];
	/break;	
	r:agg each y;
	r
 };

show"2nd Solution";  
\ts trade:update rolling2:outer2[100;price;avg] by sym from trade; 
/show .Q.w[]; 

/there is one extra level of nesting with the output of the scan solution
/raze each resultant datapoint so we can compare results of both solutions
(trade[`rolling1])~raze each trade[`rolling2]


/3rd Solution - far less memory efficient
/return the last N elements from the input list x
inner3:{[x;N]
	(neg N)sublist x
	};


/Recursively build a list of lists containing the previous N elements at each point of data
outer3:{[N;data]
		r1:,\[data]; /recursively build list of lists
		r2:inner3[;N] each r1;	/grab the last N elements from each list
		r2
	};
show"3rd Solution";  

\ts trade:update rolling3:outer3[3;price] by sym from trade; 

(trade[`rolling1])~trade[`rolling3]
/
/4th solution work in progress
a:til 10
inner4:{[n;d]xprev[n;d]}

outer4:{[n;d]
			res:{x where not null x}each 
			reverse each 
			flip (enlist d),inner4[;d]each 1+til n
		};

res1:outer4[3;a]
\ts update rolling4:outer4[3;price]by sym from `trade

(trade[`rolling1])~trade[`rolling4]
	






