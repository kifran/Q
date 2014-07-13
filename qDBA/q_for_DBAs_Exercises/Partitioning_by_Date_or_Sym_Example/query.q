ds:hopen `:localhost:1000
dt:hopen `:localhost:2000
s:hopen `:localhost:3000

/Choose a 10-item symlist from one of the servers
symlist:ds({exec sym from select distinct sym from trade};())
asym:first symlist

datelist:ds({exec date from select distinct date from trade};())
adate:first datelist

st:09:00:00.000
et:10:00:00.000

show "CHOOSE WHERE DATE=D,SYM=S"
\t ds({[d;s]select from trade where date=d,sym=s};adate;asym)
\t dt({[d;s]select from trade where date=d,sym=s};adate;asym)
\t s({[d;s]select from trade where date=d,int=symdict[s]};adate;asym)

show "CHOOSE WHERE SYM=S,DATE=D"
\t ds({[d;s]select from trade where sym=s,date=d};adate;asym)
\t dt({[d;s]select from trade where sym=s,date=d};adate;asym)
\t s({[d;s]select from trade where int=symdict[s],date=d};adate;asym)

show "CHOOSE DATE,TIME,SYM"
\t ds({[d;s;st;et]select from trade where date=d,time within (st;et),sym=s};adate;asym;st;et)
\t dt({[d;s;st;et]select from trade where date=d,time within (st;et),sym=s};adate;asym;st;et)
\t s({[d;s;st;et]select from trade where date=d,time within (st;et),int=symdict[s]};adate;asym;st;et)

show "CHOOSE DATE,SYM,TIME"
\t ds({[d;s;st;et]select from trade where date=d,sym=s,time within (st;et)};adate;asym;st;et)
\t dt({[d;s;st;et]select from trade where date=d,sym=s,time within (st;et)};adate;asym;st;et)
\t s({[d;s;st;et]select from trade where date=d,int=symdict[s],time within (st;et)};adate;asym;st;et)

show "CHOOSE SYM,TIME,DATE"
\t ds({[d;s;st;et]select from trade where sym=s,time within (st;et),date=d};adate;asym;st;et)
\t dt({[d;s;st;et]select from trade where sym=s,time within (st;et),sym=s,date=d};adate;asym;st;et)
\t s({[d;s;st;et]select from trade where int=symdict[s],time within (st;et),date=d};adate;asym;st;et)

show "CHOOSE SYM,DATE,TIME"
\t ds({[d;s;st;et]select from trade where sym=s,date=d,time within (st;et)};adate;asym;st;et)
\t dt({[d;s;st;et]select from trade where sym=s,date=d,time within (st;et)};adate;asym;st;et)
\t s({[d;s;st;et]select from trade where int=symdict[s],date=d,time within (st;et)};adate;asym;st;et)

hclose ds
hclose dt
hclose s