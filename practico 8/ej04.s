// Transformar de binario a hexadecimal. Que instrucciones LEGv8 representan en memoria?

// 4.1) 1000 1011 0000 0000 0000 0000 0000 0000

1000 1011 0000 0000 0000 0000 0000 0000 b = 0x8B000000

opcode = 100 0101 1000 = 0x458 => la instruccion es ADD (de tipo R)
sabiendo esto, desarrollamos el resto del desensamblado
Rm = 00000 = X0
shamt = 000000
Rn = 00000 = X0
Rd = 00000 = X0

Entonces, la instruccion LEGv8 que representa el numero binario es:
ADD X0, X0, X0


// 4.2) 1101 0010 1011 1111 1111 1111 1110 0010

1101 0010 1011 1111 1111 1111 1110 0010 = 0xD2BFFFE2

opcode = 110 1001 0101 b = 0x695 => la instruccion es MOVZ (de tipo IM)
sabiendo esto, desarrollamos el resto del desensamblado (teniendo en cuenta que el opcode
tiene solo 9 bits, descartamos los dos menos significativos)
LSL = 01 => #16
MOV_inmediate = 1111 1111 1111 1111 b = 0xFFFF
Rd = 0 0010 = X2

Entonces, la instruccion LEGv8 que representa el numero binario es:
MOVZ X2 0xFFFF, LSL #16
