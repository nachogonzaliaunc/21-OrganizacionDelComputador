/*
  Suponiendo que el microprocesador LEGv8 está configurado en modo LE little-endian, decir
  que valores toman los registros X0 a X7 al terminar este programa:
*/


MOVZ X9, 0xCDEF, LSL 0    // X9 = 0x0000 0000 0000 CDEF
MOVK X9, 0x89AB, LSL 16   // X9 = 0x0000 0000 89AB CDEF
MOVK X9, 0x4567, LSL 32   // X9 = 0x0000 4567 89AB CDEF
MOVK X9, 0x0123, LSL 48   // X9 = 0x0123 4567 89AB CDEF
STUR X9, [XZR, #0]
LDURB X0, [XZR, #0]
  :
LDURB X7, [XZR, #7]



Al terminar el programa, los registros toman los siguientes valores:
X0 = 0xEF
X1 = 0xCD
X2 = 0xAB
X3 = 0x89
X4 = 0x67
X5 = 0x45
X6 = 0x23
X7 = 0x01



/*
  Que valores toman los registros X0 a X7 si el microprocesador LEGv8 está
  configurado en modo BE big-endian?
*/
X0 = 0x01
X1 = 0x23
X2 = 0x45
X3 = 0x67
X4 = 0x89
X5 = 0xAB
X6 = 0xCD
X7 = 0xEF