// Ejecutar el siguiente codigo assembler que está en memoria para dar el valor final del
// registro X1. El contenido de la memoria se da como una lista de pares, direccion de
// memoria: contenido, suponiendo alineamiento de memoria del tipo big endian. Describa
// sinteticamente que hace el programa.

//   0x10010000: 0x8B010029
//   0x10010004: 0x8B010121


0x10010000: 0x8B010029 = 1000 1011 0000 0001 0000 0000 0010 1001 b

opcode = 100 0101 1000 b = 0x458 => ADD
Rm = 00001 = X1
shamt = 000000
Rn = 00001 = X1
Rd = 01001 = X9

La primera operacion es ADD X9, X1, X1


0x10010004: 0x8B010121 = 1000 1011 0000 0001 0000 0001 0010 0001 b

opcode = 100 0101 1000 b = 0x458 => ADD
Rm = 00001 = X1
shamt = 000000
Rn = 01001 = X9
Rd = 00001 = X1

La segunda operacion es ADD X1, X9, X1


Entonces, el bloque de codigo
    0x10010000: 0x8B010029      // ADD X9, X1, X1
    0x10010004: 0x8B010121      // ADD X1, X9, X1
realiza la operacion X1 = X1*3
