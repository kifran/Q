t:([]k:1 2 3 2 3;p:`xx`yy`zz`xx`yy;v:10 20 30 40 50);
/P:asc exec distinct p from t;
/pvt:exec P#(p!v) by k:k from t;

// -----------------
/unpivot1: {[line] (line?vals)!vals:(value line) where not null value line} each pvt

pivot:{[table]
 P:asc exec distinct p from t;
 exec P#(p!v) by k:k from t}
unpivot:{[table]
 delete from ( ungroup {`p`v!(key x;value x)} each table) where null v }

(`k`p xasc unpivot[pivot[t]]) ~ (`k`p xasc t)


/
q){[line] (line?vals)!vals:(value line) where not null value line} each pvt
k|           
-| ----------
1| (,`xx)!,10
2| `xx`yy!40 20
3| `yy`zz!50 30
q)exec p!v by k from t
1| (,`xx)!,10
2| `yy`xx!20 40
3| `zz`yy!30 50
q)exec p!v by k:k from t
k|           
-| ----------
1| (,`xx)!,10
2| `yy`xx!20 40
3| `zz`yy!30 50
\

//------------------

