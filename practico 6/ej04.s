/*
  Dadas las siguientes sentencias en assembler LEGv8:
    a) Escribir la secuencia mínima de código “C” asumiendo que los registros X0, X1, y X2
    contienen las variables f, g, y h respectivamente.
    b) Dar el valor de cada variable en cada instrucción assembler si f, g, y h se inicializan
    con valores de 1, 2 y 3, en base 10 respectivamente.
*/


I) SUB  X1, XZR, X1
   ADD  X0, X1, X2

g = -g        // g = -2
f = g + h     // f = -2 +3 = 1



II) ADDI X2, X0, #1
    SUB  X0, X1, X2

h = f + 1     // h = 1 + 1 = 2 
f = g - h     // f = 2 - 2 = 0
