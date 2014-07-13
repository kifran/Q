if[1>count .z.x;show"Supply directory of historical database";exit 0];

hdb:.z.x 0

/Load the Historical Database
@[{system"l ",x};hdb;{show "Error message - ",x;exit 0}]