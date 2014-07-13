maskTable:{[t1;t2;mask]
  kt1: keys t1;      
  columns: (cols t1) except kt1;
  t1:0!t1;  
  /t2:0!t2;
  /mask:0!mask;
  /t1[columns]: {[t1;t2;mask;col] maskColumn[t1[col]; t2[col]; mask[col]]}[t1;t2;mask] each columns;  
  t1[columns]: {maskColumn[x[0];x[1];x[2]]} each flip (t1;0!t2;0!mask) @\: columns;     
  kt1 xkey t1}

maskColumn:{[c1;c2;mask]
 c1[where mask]:c2[where mask];
 c1}

t1:([c1:`a`b`c`d] c2: 10 20 30 40; c3: 100 200 300 400);
t2:([c1:`c`a] c2: 31 100);
show "Before";
show t1;
show t2;

t2:t1 lj t2;
mask: (.5<t1%t2)&(5>t1%t2);
t1:maskTable[t1;t2;mask];
show "After: corrections ignored (?)"
ignored: 0N & t1;
ignored: maskTable[ignored;t2;not mask]
show ignored;

show "After: updated"
show t1;



