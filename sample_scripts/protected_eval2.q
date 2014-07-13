d:
	("type";"rank";"foo")!
	({[x]show"type error";"error 1"};{[x]"error 2"};{[x]"error 3"});
	
catch:{d[x;`HH]};

f1:{x-10};

res1:@[f1;100;catch];
res2:@[f1;`IBM;catch];	