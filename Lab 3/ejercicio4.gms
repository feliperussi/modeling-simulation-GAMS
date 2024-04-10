*************************************************************************
***      Lab 3                                                        ***
***      Ejercicio 4                                                  ***
***      Felipe Arias Russi - 201914996                               ***
***      Mario Ruiz - 201920695                                       ***
*************************************************************************

Sets
   b / Baldosa1*Baldosa20 /
   t / Tubo1*Tubo7 /;

* Esta tabla muestra que tubo pasa por cual baldosa

Table conexion(b,t) 
             Tubo1  Tubo2  Tubo3  Tubo4  Tubo5  Tubo6  Tubo7
   Baldosa1    1      0      0      0      0      0      0
   Baldosa2    0      1      0      0      0      0      0
   Baldosa3    0      1      0      0      0      0      0
   Baldosa4    0      0      0      0      0      0      0
   Baldosa5    1      0      1      0      0      0      0
   Baldosa6    0      1      0      0      0      0      0
   Baldosa7    0      1      0      0      0      0      0
   Baldosa8    0      0      0      0      0      0      1
   Baldosa9    0      0      1      1      0      0      0
   Baldosa10   0      0      0      1      1      0      0
   Baldosa11   0      0      0      0      1      0      0
   Baldosa12   0      0      0      0      0      0      1
   Baldosa13   0      0      0      1      0      1      0
   Baldosa14   0      0      0      1      1      0      0
   Baldosa15   0      0      0      0      1      0      0
   Baldosa16   0      0      0      0      0      0      1
   Baldosa17   0      0      0      0      0      1      0
   Baldosa18   0      0      0      0      0      0      0
   Baldosa19   0      0      0      0      0      0      1
   Baldosa20   0      0      0      0      0      0      1
;

Parameters cover(t) ;
Variables
    z
   x(b) ;

Binary Variables x;

Equations
   objective ,
   coverConstraint(t) ;

objective.. sum(b, x(b)) =e= z;

* Esto minimiza el numero de baldosas que se deben revisar para encontrar todos los tubos

coverConstraint(t).. sum(b$(conexion(b,t) = 1), x(b)) =g= 1;

Model setCovering /all/;
Set bCovered;

solve setCovering using mip minimizing z;

bCovered(b) = x.l(b);
Display bCovered;
