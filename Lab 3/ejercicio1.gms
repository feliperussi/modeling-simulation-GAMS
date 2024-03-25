*************************************************************************
***      Lab 3                                                        ***
***      Ejercicio 1                                                  ***
***      Felipe Arias Russi - 201914996                               ***
***      Mario Ruiz - 201920695                                       ***
*************************************************************************

* Define el conjunto de filas de jugadores
Sets
  i filas / Jugador1*Jugador7 /
  
* Define el conjunto de capacidades
  j columnas / Control, Disparo, Rebotes, Defensa/ 
  
* Define el conjunto de roles
  k roles / Ataque, Centro, Defensa/;
  
* Define la función objetivo y la variable binaria para seleccionar los jugadores
Variables

* Función objetivo para maximizar la defensa
  z    
* Variable binaria
  b(i);
  
* Asegura que la variable sea binaria
Binary Variables b(i);

* Define el puntaje de la capacidad de cada jugador
Table t(i, j)
                Control  Disparo  Rebotes  Defensa
    Jugador1    3        3        1        3
    Jugador2    2        1        3        2
    Jugador3    2        3        2        2
    Jugador4    1        3        3        1
    Jugador5    3        3        3        3
    Jugador6    3        1        2        3
    Jugador7    3        2        2        1;

Table r(i, k)
                Ataque  Centro  Defensa
    Jugador1    1       0       0        
    Jugador2    0       1       0        
    Jugador3    1       0       1        
    Jugador4    0       1       1        
    Jugador5    1       0       1        
    Jugador6    0       1       1        
    Jugador7    1       0       1;
    
Parameters roles(k)
    / Ataque     2 
      Centro     1
      Defensa    4 /;
      
* Define las ecuaciones del modelo.
Equations
  objectiveFunction        * Función objetivo.
  restriction_jugadores    * Restricción número de jugadores.
  restriction_roles        * Restricción de roles.
  restriction_capacidades  * Restricción de capacidades.
  restriction_jugador23   * Restricción exclusión de jugadores.;

* Especifica la función objetivo.
objectiveFunction        ..  z =e= sum((i), t(i,"Defensa")*b(i));

* Establece las restricciones de cada fila
restriction_jugadores    ..  sum((i), b(i)) =e= 5;

restriction_roles(k)     ..  sum((i), r(i,k)*b(i)) =g= roles(k);

restriction_capacidades(j).. sum((i), t(i,j)*b(i)) =g= 2*sum((i),b(i));

restriction_jugador23    ..  b("Jugador2") + b("Jugador3") =e= 1;

* Define y resuelve el modelo.
Model modell /all/;

* Utiliza CPLEX como solver.
option lp=CPLEX;

* Minimiza el costo de la dieta.
Solve modell using mip maximizing z;

* Muestra los resultados de las variables de decisión.
Display b.l;
