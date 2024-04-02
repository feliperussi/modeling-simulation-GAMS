*************************************************************************
***      Lab 3                                                        ***
***      Ejercicio 3                                                  ***
***      Felipe Arias Russi - 201914996                               ***
***      Mario Ruiz - 201920695                                       ***
*************************************************************************

Sets
  c canciones / 1*8 /  
* Conjunto de canciones.
  l lados / A, B /    
* Conjunto de lados del cassette.
  g géneros / Blues, RockAndRoll /;
* Conjunto de géneros musicales.

* Duración de cada canción.
Parameters duracion(c) /
  1 4, 2 5, 3 3, 4 2, 5 4, 6 3, 7 5, 8 4
/;

* Género de cada canción.
Table genero(c, g)
        Blues RockAndRoll 
  1      1       0        
  2      0       1         
  3      1       0         
  4      0       1        
  5      1       0        
  6      0       1       
  7      0       0        
  8      1       1 ;      

Variables
  z
* Variable para la función objetivo (podría ser cualquier cosa, aquí simplemente garantiza la factibilidad).
  asignacion(c,l) binary;
* Variables binarias para la asignación de canciones a lados.

Binary Variables asignacion(c,l);



* Restricciones
Equations
  objectiveFunction
  menorDuracionPorLado(l)
  mayorDuracionPorLado(l)
  exactamenteDosBluesPorLado(l)
  minimoTresRockAndRollEnA
  restriccionCancion1y5
  restriccionCanciones2y4Con1
  restriccionLados(c);

* Función objetivo trivial, solo para cumplir con la estructura del modelo.
objectiveFunction.. z =e= sum((c,l), asignacion(c,l));
* Cada lado debe tener una duración total entre 14 y 16 minutos.
menorDuracionPorLado(l)..  sum(c, duracion(c)*asignacion(c,l)) =g= 14;
mayorDuracionPorLado(l)..  sum(c, duracion(c)*asignacion(c,l)) =l= 16;

* Exactamente 2 canciones de Blues en cada lado.
exactamenteDosBluesPorLado(l)..  sum(c, genero(c,"Blues")*asignacion(c,l)) =e= 2;

* El lado A debe tener al menos 3 canciones tipo Rock and Roll.
minimoTresRockAndRollEnA..  sum(c, genero(c,"RockAndRoll")*asignacion(c,"A")) =g= 3;

* Si la canción 1 está en el lado A, la canción 5 no debe estar en el lado A.
restriccionCancion1y5..  asignacion("1","A") + asignacion("5","A") =l= 1;

* Si la canción 2 y 4 están en el lado A, entonces la canción 1 debe estar en el lado B.
restriccionCanciones2y4Con1..  asignacion("2","A") + asignacion("4","A")  =l= 1+asignacion("1","B");

restriccionLados(c)..  asignacion(c,"A")+asignacion(c,"B")=e=1

Model organizacionCassette /all/;
Solve organizacionCassette using mip minimizing z;

Display asignacion.l;