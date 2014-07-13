h1:hopen 2000 // note server1 started with port set – p 2000
h2:hopen 3000 // note server2 started with port set – p 3000
hlist: (h1;h2)
Monitor: flip `time_of_ping`handle`port`ping_duration!(`timestamp$();`int$();`int$();`timespan$())

/
.z.ts: {{[h]a:.z.p;(neg h)((a;h))} each hlist}
\t 1000






/
