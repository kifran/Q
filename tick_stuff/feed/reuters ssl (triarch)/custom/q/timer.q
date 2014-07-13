"loading timer.q"

\d .timer
timercfg:([]time:`time$();function:`symbol$();freq:`time$())

inserttimercfg:{[x;freq] .log.out[.z.h;"Adding Function ", (string x), " timercfg for frequency ", string freq;()]; `.timer.timercfg insert (`time$0;x;freq);}

checktimer:{[x] f:value each exec function from .timer.timercfg where .z.t > time + freq;	update time:.z.t from `.timer.timercfg where .z.t > time + freq;	(f)@\:(x);	}


\d .

/All functions must be of the form f[x]  where x is the call time. 
.z.ts:{.timer.checktimer[x]}


//.timer.inserttimercfg[`sendping;`time$"v"$10]




/Time Functions.



sendping:{[x] .u.pub[`ping;enlist a:`time`sym`action`args`argtypes!(`time$x;`HUB;`ping;enlist "";enlist "")];
             .log.debug[.z.h;"Sending Ping to all components.";a];} 


\t 1000