datatypes:`date`time`sym`price`size`ex`f1!
	("D"$;"T"$;"S"$;"F"$;"I"$;"S"$;"S"$);

data:"date=2010-11-30;time=09:30;sym=IBM;price=100.3;size=1000;ex=N;f1=dummy1;c2=dummy2";

a:10 20 30
{[i]show i} each a

res:()!()

parse_func2:{[i]r2:vs["=";i];
	/break;
	res,:(enlist `$r2@0)!(enlist r2@1)}; 

parse_func1:{[x]
	r1:vs[";";x];
	/break;
	r3:parse_func2 each r1;
 };
 
parse_func1[data];

fields:(key res)where (key res)in (key datatypes) /fields we want to include
res:fields!(res[fields])
/(`c2`dd) _ res
res1:@'[datatypes[key res];res];





/ 