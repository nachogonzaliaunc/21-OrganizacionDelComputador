/*
  Luego, dadas las siguientes sentencias en assembler LEGv8:
    a) Escribir la secuencia minima de codigo “C” asumiendo que los registros X0, X1 y X2
    contienen las variables f, g y h respectivamente.
    b) Dar el valor de cada variable en cada instruccion assembler si f, g y h se inicializan
    con valores de 1, 2, 3, en base 10, respectivamente
*/

I) ADD X0, X1, X2

f = g + h;    // f = 2 + 3 = 5



II) ADDI X0, X0, #1
    ADD X0, X1, X2

f = f + 1;    // f = 1 + 1 = 2
f = g + h;    // f = 2 + 3 = 5
