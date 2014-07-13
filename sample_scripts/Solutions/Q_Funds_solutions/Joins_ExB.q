
\c 10 150
medals:([]year:`int$();color:`symbol$();country:`symbol$());

n:20;
years:1988+4*til n;
countries:`CHN`GER`KOR`SWE;
colors:`gold`silver`bronze;

x:flip cross[years;colors];

y:(x[0];x[1];(count x[0])?countries);

x,:enlist(count x[0])?countries
`medals insert x;

country1:([id:`ALG`CHN`GER`KOR`SWE];
	name:`Algeria`China`Germany`Korea`Sweden);

t1:delete country from lj[medals;xcol[`country;country1]];

show select C:count i from t1 where name=`Korea,color=`gold;

x:`gold`silver`bronze!reverse 1+til 3;

show t2:`s xdesc select sum s by name from update s:x[color] from t1;











/