\l taq.q

g1:("proc1";`IBM)
b1:("proc1";99)
g2:("proc2";`IBM;`N)
b2:("proc2";88;`N)

f1:{[x]
	res:x+x; /comment 1
	res
	};

protected_eval:{[x](1b;value x)}
catch:{[try;error]show "error ",error," at: ",-3!try;(0b;try)};

/monadic form

protected:{[x]
	res:@[protected_eval;x;catch[x;]];
	res
	};

/$[first res;show "success";show"failure"];

/multi valent form
res1:.[proc2;(`IBM;`N);{show "error was ",x;0b}];
res2:.[proc2;(`IBM;56);{show "error was ",x;0b}];
