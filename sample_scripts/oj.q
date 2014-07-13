oj:{[source;lookup]
	lookup1:xkey[();lookup];
	fill_cols:cols[lookup] except cols[source];
	u:uj[lookup;source];
	u:value"update ",sv[",";"fills ",/:string fill_cols]," by ",(raze string keys lookup)," from u";


 };