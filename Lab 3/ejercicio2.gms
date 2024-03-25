*************************************************************************
***      Lab 3                                                        ***
***      Ejercicio 2                                                  ***
***      Felipe Arias Russi - 201914996                               ***
***      Mario Ruiz - 201920695                                       ***
*************************************************************************
Sets
    pueblo /Pueblo1*Pueblo6/;

Alias (pueblo, pFrom, pTo);

Table distance(pFrom,pTo) 'Tiempo entre pueblos (min)'
              Pueblo1    Pueblo2    Pueblo3    Pueblo4    Pueblo5    Pueblo6
  Pueblo1     0          10         20         30         30         20
  Pueblo2     10         0          25         35         20         10
  Pueblo3     20         25         0          15         30         20
  Pueblo4     30         35         15         0          15         25
  Pueblo5     30         20         30         15         0          14
  Pueblo6     20         10         20         25         14         0;

Variables
 z
 b(pueblo);
 
Binary Variables
    b(pueblo)  "Indica si hay una estación en el pueblo";

Equations
    objectiveFunction       "Función objetivo"
    atLeastOneStation
    stationWithin15min(pueblo) "Garantiza una estación a no más de 15 minutos";

* Función objetivo: minimizar el número de estaciones
objectiveFunction.. z =e= sum(pueblo, b(pueblo));
atLeastOneStation .. sum(pueblo, b(pueblo)) =g= 1;
* Restricción: cada pueblo debe tener al menos una estación a 15 minutos o menos
stationWithin15min(pFrom).. 
    sum(pTo$(distance(pFrom,pTo) <= 15), b(pTo)) + b(pFrom) =g= 1;

Model transport / all /;

* Configurar CPLEX como solver de MIP
option mip=CPLEX;

* Resolver el modelo para minimizar la cantidad de estaciones
Solve transport using mip minimizing z;

* Mostrar los resultados
Display b.l;