/ Maintain a tables of currently logged stuff

currentConns:([]
        time:           `time$();
        handle:         `int$();
        host:           `$();
        ip:             `int$();
        user:           `$();  
        numMessages:    `int$()
 );


/open
.z.po:{
        currentConns,:(.z.t; .z.w; .Q.host[.z.a]; .z.a; .z.u; 0);
 };
 
/close 
.z.pc:{
        delete from `currentConns where handle=x;
 }; 
 
/sync (get)
.z.pg:{[x]
        update numMessages:numMessages+1 from `currentConns where handle=.z.w;
        res: value x;
        :res ;
 };
 
/.z.pg:.z.ps:{value x} 
 
/async
.z.ps:{[x]
        update numMessages:numMessages+1 from `currentConns where handle=.z.w;
 }; 

 

 