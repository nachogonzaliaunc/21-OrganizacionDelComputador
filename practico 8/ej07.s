// Ensamblar estos delay loops

//     MOVZ X0, 0x1, LSL #48
// L1: SUBI X0, X0, #1
//     CNBZ X0, L1

MOVZ X0, 0x1, LSL #48: 11010010111000000000000000100000b = 0xD2E00020
opcode: 110100101
LSL: 11
MOV_inmediate: 0000000000000001
Rd: 00000

SUBI X0, X0, #1: 1101001000000000000010000000000b = 0xD1000400
opcode: 1001000100
ALU_inmediate: 000000000001
Rn: 00000
Rd: 00000

CNBZ X0, L1: 10110101111111111111111111100000b = 0xB5FFFFE0
opcode: 10110101
COND_BR_adress: 1111111111111111111 = -1 (porque vuelvo una operacion para atras)
Rt: 00000

Entonces el bloque de codigo ensamblado seria:
0xD2E00020
0xD1000400
0xB5FFFFE0



//     MOVZ X0, 0xFFFF, LSL #32
// L1: SUBIS X0, X0, #1
//     B.NE L1

MOVZ X0, 0xFFFF, LSL #32: 11010010110111111111111111100000b = 0xD2DFFFE0
opcode: 110100101
LSL: 10
MOV_inmediate: 1111111111111111
Rd: 00000

SUBIS X0, X0, #1: 11110001000000000000010000000000b = 0xF1000400
opcode: 1111000100
ALU_inmediate: 000000000001
Rn: 00000
Rd: 00000

B.NE L1: 01010100111111111111111111100001b = 0x54FFFFE1
opcode: 01010100
COND_BR_adress: 1111111111111111111  = -1 (porque vuelvo una operacion para atras)
Rt: 00001

Entonces el bloque de codigo ensamblado seria:
0xD2DFFFE0
0xF1000400
0x54FFFFE1



//     MOVZ X0, 0x2, LSL #16
// LI: SUBIS XZR, X0, #0
//     B.EQ EXIT
//     SUBI X0, X0, #1
//     B L1
// EXIT:

MOVZ X0, 0x2, LSL #16: 11010010101000000000000001000000b = 0xD2A00040
opcode: 110100101
LSL: 01
MOV_inmediate: 0000000000000010
Rd: 00000

SUBIS XZR, X0, #0: 11110001000000000000000000011111b = 0xF100001F
opcode: 1111000100
ALU_inmediate: 0000000000000000
Rn: 00000
Rd: 11111

B.EQ EXIT: 01010100000000000000000001100000b = 0x54000060
opcode: 01010100
COND_BR_adress: 0000000000000000011 = 3 (porque me salto 3 operaciones)
Rt: 00000

SUBI X0, X0, #1: 11010001000000000000010000000000b = 0xD1000400
opcode: 1101000100
ALU_inmediate: 000000000001
Rn: 00000
Rd: 00000

B L1: 00010111111111111111111111111101b = 0x17FFFFFD
opcode: 000101
BR_adress: 11111111111111111111111101  = -2 (porque vuelvo dos operaciones para atras)

Entonces el bloque de codigo ensamblado seria:
0xD2A00040
0xF100001F
0x54000060
0xD1000400
0x17FFFFFD