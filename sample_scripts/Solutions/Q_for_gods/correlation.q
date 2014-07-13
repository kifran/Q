/1)
l1:(1,2,3,4);
l2:(6,7,8,9);
cor[l1;l2]

/2)
l1:(1,2,3,4);
l2:reverse l1;
cor[l1;l2]

/3)
l1:10000?10.0;
l2:10000?10.0;
cor[l1;l2]

/4)
n:1000
a:n?1.0
v:{[l;n] cor[l;rotate[n;l]]}[a]each neg[floor(n%2)]+til n
where v=max v;
t:([]til count v;v); 


/5)
PI:3.14
t:([] til 100; a:(sin[(PI%4)*1+til 100])+0.5-100?1.0);    / sin wave with random noise
t1:([] x:-10+0.1*til 201);
update y:sin[x*PI%4]+(0.5-201?1.0) from `t1;
b:t1`y;
v:{[b;n] cor[b;rotate[n;b]]}[b]each neg[(floor (count t1)%2)]+til count t1;    / auto corr
update v:v from `t1;

 
/6)
t1:exec price from select avg price by date from trade where date in -50#date, sym=`CVX,time within (09:30;16:00);

t2:exec price from select avg price by date from trade where date in -50#date, sym=`XOM,time within (09:30;16:00);

xomcvxCor:cor[t1;t2];

/7)
secs:`IYE`IYW`IYM`IYH`IYF`IYC`IDU`IYJ`IYT`IEO 
//Energy,Tech,Basic Materials,Healthcare, Financial,Consumer Serv,Utilities,Industrial,Transport,Oil/Gas

ssecs:raze secs,/:\:secs;

v:{[e1;e2];
    t1:(exec price from select price:avg price by date from trade where date in -50#date,sym=e1,time within (09:30;16:15));
    t2:(exec price from select price:avg price by date from trade where date in -50#date,sym=e2,time within (09:30;16:15));
    if[any(t1~();t2~());:0];
    :.[cor;(t1;t2);0]; //protected eval for length
    }'[ssecs[;0];ssecs[;1]]
show (count secs;0N)#v


 
