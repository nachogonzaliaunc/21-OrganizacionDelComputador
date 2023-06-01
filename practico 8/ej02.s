// Tenemos las siguientes instrucciones en assembler LEGv8:
//  ADDI X9, X9, #0
//  STUR X10, [X11, #32]

// 2.1) Que formato (R, I, D, B, CB, IM) de instrucciones son?
// 2.2) Ensamblar a codigo de maquina LEGv8, mostrando sus representaciones en 
//      binario y luego en hexadecimal

ADDI  X9, X9, #0
como es tipo I, el ensamblado es el siguiente:
|  opcode  |ALU_inmediate| Rn  | Rd  |
|31      22|21         10|9   5|4   0|

En este caso:
opcode = 1001000100
ALU_inmediate = 000000000000
Rn(X9) = 01001
Rd(X9) = 01001

El codigo de maquina ensamblado es el siguiente:
1001 0001 0000 0000 0000 0001 0010 1001 b = 0x91000129



STUR X10, [X11, #32]
como es tipo D, el ensamblado es el siguiente:
|  opcode  |DT_adress| op  | Rn  | Rt  |
|31      21|20     12|11 10|9   5|4   0|

En este caso:
opcode = 11111000000
DT_adress(#32) = 000100000
op = 00
Rn(X11) = 01011
Rt(X10) = 01010

El codigo de maquina ensamblado es el siguiente:
1111 1000 0000 0010 0000 0001 0110 1010 b = 0xF802016A
