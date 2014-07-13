/sample matrix
m:3 3#2 4 8 3 5 6 0 7 1f

/get diagonal values
get_diagonal:{[x]
	i:til count x;
	.[x]each ,'[i;i];
	/.[x]each #[2]each til count x
	};

d:get_diagonal[m];

/replace value y in each row of matrix with value z
f1:{[x;y;z]x[where x=y]:z;x};

r:f1[;0f;100f] each m;

/get inverse
/inv computes the inverse of a non-singular floating point matrix.
i:inv m
/check speed performance
\t inv .5 xexp abs i-/:i:til 100

i:til 100
i1:-/:[i;i]


/mmu computes the matrix multiplication of floating point matrices. The arguments must be 
/floating point and must conform in the usual way, i.e. the columns of x must equal the rows of y.
show 1f=m mmu (inv m);

/get transpose
t:flip m

/get inverse and solve linear algebra equations
/
m mmu X = A
X=(inv m) mmu A
\
A:3?10f;
X:(inv m) mmu A;


op:1 2 3*/:1 2 3     /outer product
/result is (1 2 3;2 4 6;3 6 9)

identity:{x=/:x}[til 3] /build the identity matrix









/lsq
/
lsq verb is a matrix divide. x and y must be floating point matrices with the same number of columns. 
The number of rows of y must be less than or equal to the number of columns, 
and the rows of y must be linearly independent.

w:x lsq y
where w is the least squares solution of x = w mmu y, i.e. if:

d:x - (x lsq y) mmu y
then the sum d*d is minimized. If y is a square matrix, d is the zero matrix, up to rounding errors.
\
/Example
x:1f+3 4#til 12
y:4 4#2 7 -2 5 5 3 6 1 -2 5 2 7 5 0 3 4f
x ~ (x lsq y) mmu y


/Polynomial Fitting
lsfit:{(enlist y) lsq x xexp/: til 1+z} / fit y to poly in x with degree z
poly:{[c;x]sum c*x xexp til count c}    / polynomial with coefficients c

x:til 6
y:poly[1 5 -3 2] each x   / cubic
lsfit[x;y] each 1 2 3     / linear,quadratic,cubic(=exact) fits










/



	
	
	
	