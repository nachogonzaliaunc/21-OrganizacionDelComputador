/*
  Dadas las siguientes sentencias en "C":
    a) Escribir la secuencia minima de codigo assembler LEGv8 asumiendo que f, g, h, i y j 
    se asignan en los registros X0, X1, X2, X3 y X4 respectivamente.
    b) Dar el valor de cada variable en cada instruccion assembler si f, g, h, i y j se inicializan
    con valores de 1, 2, 3, 4, 5, en base 10, respectivamente.
*/

I) f = g + h + i + j;

ADD X0, X1, X2    // f = 2 + 5 = 5
ADD X0, X0, X3    // f = 5 + 4 = 9
ADD X0, X0, X4    // f = 9 + 5 = 14



II) f = g + (h + 5);

ADDI X0, X2, #5   // f = 3 + 5 = 8 
ADD X0, X1, X0    // f = 2 + 8 = 10



III) f = (g + h) + (g + h);

ADD X0, X1, X2    // j = 2 + 3 = 5
ADD X0, X0, X0    // f = 5 + 5 = 10
