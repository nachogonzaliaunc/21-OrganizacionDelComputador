// Dar el tipo de instruccion, la instruccion en assembler y la representacion binaria de los
// siguientes campos de LEGv8:


// 3.1) op=0x658, Rm=13, Rn=15, Rd=17, shamt=0

como op=0x658, sabemos que se trata de la operacion SUB

entonces la instruccion en assembler es:
SUB X17, X15, X13

y la representacion binaria es: 1100 1011 0000 1101 0000 0001 1111 0001
opcode = 11001011000
Rm(X13) = 01101
shamt = 000000
Rn(X15) = 01111
Rd(X17) = 10001



// 3.2) op=0x7c2, Rn=12, Rt=3, const=0x4

como op=0x7c2, sabmos que se trata de la operacion LDUR

entonces la instruccion en assembler es:
LDUR X3, [X12, #4]

y la representacion binaria es: 1111 0110 0100 0000 0100 0000 0110 1100
opcode = 11110110010
DT_adress(#4) = 000000100
op = 00
Rn(X12) = 01100
Rt(X3) = 00011
