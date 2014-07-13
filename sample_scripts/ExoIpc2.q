/ Maintain a tables of currently logged stuff

requests:([]
        time:           `time$();
        user:           `$();  
        handle:         `int$();
        requests:        `$();
        duration:       `time$();
        success:        `boolean$();
        sync:           `boolean$()
 );

/sync (get)
.z.pg:{[x]
        // Capture exec time
        start:.z.T;     
        // Protectec eval
        res:@[value;x;{`fail}];
        // Capture end time
        end:.z.T;
        execTime: end-start;
        // Establish success/failure
        success:1b;  
        if[res~`fail;success:0b];
        // Add to requests table
        requests,:(start; .z.u; .z.w; `$x; execTime; success; 1b);
        //Return result
        :res ;
 };
 
/.z.pg:.z.ps:{value x} 
 
/async
.z.ps:{[x]
        start:.z.T;     
        success:1b;  
        res:@[value;x;{`fail}];
        end:.z.T;
        execTime: end-start;
        if[res~`fail;success:0b];
        requests,:(start; .z.u; .z.w; `$x; execTime; success; 0b);
        :res ;
 }; 

 

 