// Que valor devuelve en X0 este programa?

// .org 0x0000
// MOVZ X0, 0x0400, LSL #0
// MOVK X0, 0x9100, LSL #16
// STURW X0, [XZR, #12]
// STURW X0, [XZR, #12]

00: MOVZ X0, 0x0400, LSL #0     // X0 = 0x0000 0000 0000 0400
04: MOVK X0, 0x9100, LSL #16    // X0 = 0x0000 0000 9100 0400
08: STURW X0, [XZR, #12]        // en la posicion de memoria 12, guardo X0
//12: STURW X0, [XZR, #12]      se sobreescribe ésta intruccion por 0x9100 0400

0x91000400 = 10010001000000000000010000000000b
Veamos de que instruccion se trata:
opcode: 1001000100 (entonces es ADDI)
ALU_inmediate: 000000000001 = 1
Rn: 00000 = 0
Rd: 00000 = 0

se trata de ADDI X0, X0, #1

Entonces, en la posicion 12 reemplazamos STURW X0, [XZR, #12] por ADDI X0, X0, #1

y el bloque de codigo seria:
00: MOVZ X0, 0x0400, LSL #0     // X0 = 0x0000 0000 0000 0400
04: MOVK X0, 0x9100, LSL #16    // X0 = 0x0000 0000 9100 0400
08: STURW X0, [XZR, #12]        // en la posicion de memoria 12, guardo X0
12: ADDI X0, X0, #1             // X0 = 0x0000 0000 9100 0401

Finalmente, X0 = 0x0000000091000401
