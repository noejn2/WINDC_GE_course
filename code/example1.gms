* Setting working directory
$setglobal cd C:\Users\nnrno\OneDrive - University of Illinois - Urbana\Drive\sub-projects\WINDC_GE_course\

$title a transportation model
* Notice here that that elements of the declared set "{}" is as " / /"
* The words after the set names "i,j" are called text "canning plants, markets". These are optional
Sets
     i   canning plants   / seattle, san-diego /
     j   markets          / new-york, chicago, topeka / ;

* Above, we had to sets == i and j. So alternatively, we can:
*Set i canning plants / seattle, san-diego /;
*Set j markets        / new-york, chicago, topeka/;


* THIS IS DATA ENTRY BY LIST
Parameters

     a(i)  capacity of plant i in cases
       /    seattle     350
            san-diego   600  /

     b(j)  demand at market j in cases
       /    new-york    325
            chicago     300
            topeka      275  / ;
           
* Similarly to Sets, we can split parameters. Notice that
* instead of spaces we use "," to separate the pairs.
*Parameter a(i) capacity of plant i in cases
*        / seatle  350,        san-diego 600 /;

* THIS IS DATA ENTRY BY TABLE
Table d(i,j)  distance in thousands of miles
                  new-york       chicago      topeka
    seattle          2.5           1.7          1.8
    san-diego        2.5           1.8          1.4  ;

* A scalar can be regarded as a parameter that has no domain
Scalar f  freight in dollars per case per thousand miles  /90/ ;

* THIS IS DATA ENTRY BY DIRECT ASSIGNMENT
Parameter c(i,j)  transport cost in thousands of dollars per case ;

          c(i,j) = f * d(i,j) / 1000 ;
* If you wish to make a direct assignment to specific elements in the domain:
* c('Seattle', 'New-York') = 0.40;


* The z variable is declared without a domain because it is a scalar quantity.
* Every GAMS optimization model must contain one such variable to serve as the quantity to be minimized or maximized.
Variables
     x(i,j)  shipment quantities in cases
     z       total transportation costs in thousands of dollars ;

* The variable that serves as the quantity to be optimized must be a scalar and must be of the free type.
* In our transportation example, z is kept free by default, but x(i,j) is constrained to non-negativity by the following statement.
Positive Variable x ;

*In the case of equations, you must make the declaration and definition
* in separate GAMS statements. Nitce here the ";"
Equations
     cost        define objective function
     supply(i)   observe supply limit at plant i
     demand(j)   satisfy demand at market j ;

cost ..        z  =e=  sum((i,j), c(i,j)*x(i,j)) ;

supply(i) ..   sum(j, x(i,j))  =l=  a(i) ;

demand(j) ..   sum(i, x(i,j))  =g=  b(j) ;

Model transport /all/ ;

Solve transport using lp minimizing z ;

* Creating additional display values
parameter pctx(i,j)  perc of market j's demand filled by plant i;
        pctx(i,j) =  100.0*x.l(i,j)/b(j) ;

Display x.l, x.m, pctx ;

* Send to results directory
execute_unload "%cd%output/example1_out.gdx";