\d .qml

{@[x;y;z]}./:{({x[3]set x[0]2:(`$x 4;x 2)};x,y;
    {'`$"loading ",x[4],"() from ",x[1],": ",y}[x,y])}[
        {x[;(-1+count x 1)^first where{count inv`$":",x}each -1_x 1]}
            {(`$x;x,\:$[.z.o like"w*";".dll";".so"])}
                ("./";"./",string[.z.o],"/";""),\:"qml"]each
        {(x 0;x 1;"qml_",string x 1)}each raze flip each flip(1 2 3 4;(
            `sin`cos`tan`asin`acos`atan`sinh`cosh`tanh`asinh`acosh`atanh,
                `exp`expm1`log`log10`logb`log1p`sqrt`cbrt`floor`ceil`fabs,
                `erf`erfc`lgamma`gamma`j0`j1`y0`y1`ncdf`nicdf`kcdf`kicdf,
                `mdet`minv`mevu`mchol`mqr`mqrp`mlup`msvd`poly`const;
            `atan2`pow`hypot`fmod`beta`pgammar`pgammarc`ipgammarc,
                `c2cdf`c2icdf`stcdf`sticdf`pscdf`psicdf`smcdf`smicdf,
                `solve`min`root;
            `pbetar`ipbetar`fcdf`ficdf`gcdf`gicdf`bncdf`bnicdf,
                `solvex`minx`rootx`conmin`line;
            `conminx`linex));

version:const 0;pi:const 1;e:const 2;eps:const 3;
pgamma:{gamma[x]*pgammar[x;y]};
pgammac:{gamma[x]*pgammarc[x;y]};
pbeta:{beta[x;y]*pbetar[x;y;z]};
diag:{{@[x#abs[type y]$0;z;:;y]}[count x]'[x;til count x]};
mdiag:{(n#x)@'til n:count[x]&count x 0};
mrank:{sum not(d<eps*d[0]*count[x]|count x 0)|0=d:mdiag msvd[x]1};
mpinv:{flip x[0]mmu{?[(y<x)|y=0;y;1%y]}[eps*x[1;0;0]*count[x 0]|count x 2]'[x 1]
    mmu flip(x:msvd x)2};
mev:{x@\:idesc{$[0>type x;x*x;sum x*x]}'[(x:mevu x)0]};

\d .
