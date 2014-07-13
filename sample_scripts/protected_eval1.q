f1:{[x]x+10};

catch1:{[e]show"error was: ",e;0b};
f2:{[x;y]x+y};

res1:@[f1;9;catch1];
res2:@[f1;`IBM;catch1];
res1:.[f2;(9;2);catch1];
res2:.[f2;(`IBM;2);catch1];
res1:.[f1;enlist 99;catch1];
res2:.[f1;enlist `IBM;catch1];

try:{[x]res:value x};

try2:{[x]res:(1b;value x)};
catch2:{[e]show"error was: ",e;(0b;e)};

res1:@[try;"f1[99]";catch1];
res2:@[try;"f1[`IBM]";catch1];
res3:@[try;("f1";99);catch1];
res4:@[try;("f2";99;100);catch1];
res5:@[try;("f2";99;`IBM);catch1];

res6:@[try2;("f2";99;100);catch2];
res7:@[try2;("f2";99;`IBM);catch2];


catch3:{[t;e]show"error was: ",e," while executing ",-3!t;(0b;(e;t))};
res8:@[try2;("f2";99;100);catch3[("f2";99;100);]];
res9:@[try2;("f2";99;`IBM);catch3[("f2";99;`IBM);]];


/