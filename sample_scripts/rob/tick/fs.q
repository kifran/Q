h: hopen 5010;

randompub:{n:first 1+1?3;
    syms:`AUDUSD`EURUSD`AUDJPY`AUDCAD;
    $[`trade~t:first 1?`trade`quote;
          data:(n#.z.T;n?syms;10+n?10.;1000+n?9000);
          data:(n#.z.T;n?syms;10+n?10.;1000+n?9000;12+n?10.;1000+n?9000)];
    neg[h](`upd;t;data);show(t;count data)};

.z.ts:{randompub[]};
\t 1000 
