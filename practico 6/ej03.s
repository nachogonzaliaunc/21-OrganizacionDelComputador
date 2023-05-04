/*
  Dadas las siguientes sentencias en “C”:
    a) Escribir la secuencia mínima de código assembler LEGv8 asumiendo que f y g se
    asignan en los registros X0 y X1 respectivamente.
    b) Dar el valor de cada variable en cada instrucción assembler si f y g se inicializan con
    valores de 4 y 5, en base 10, respectivamente.
*/

I) f = -g - f;

SUB X0, XZR, X0   // f = 0 - 4 = -4
SUB X0, X0, X1    // f = -4 - 5 = -9



II) f = g + (-f - 5);

SUB X0, XZR, X0   // f = 0 - 4 = -4
SUBI X0, X0, #5   // f = -4 - 5 = -9
ADD X0, X1, X0    // f = 5 + (-9) = -4
