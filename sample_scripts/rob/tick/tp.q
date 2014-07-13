\l schema.q

\p 5010

selectsyms:{[upddata;symlist] 
	$[`~symlist;upddata;
	[indices:where upddata[1] in symlist;upddata[;indices]]
	]};

pub:{[table;data]
	{[table;data;tdict] 
		data:selectsyms[data;tdict[1]];
	if[count data;neg[first tdict](`upd;table;data)]}[table;data]each d table
	};

sub:{d[x[0]],: enlist (.z.w;x[1])}

upd:{[x;y] x insert y;pub[x;y]}

tablelist:`trade`quote

d:tablelist!(count tablelist)#()
