// Decidir cuales de las siguientes instrucciones en assembler se pieden codificar en codigo
// de maquina LEGv8. Explicar que falla en las que no pueden ser ensambladas.


// 1. LSL XZR, XZR, 0
Si puede codificarse, y el codigo de maquina seria: 11010011011000000000001111111111
opcode: 11010011011
Rm: 00000
shamt: 000000
Rn(XZR): 11111
Rd(XZR): 11111


// 2. ADDI X1, X2, #-1
No puede ensamblarse ya que el inmediato a adicionar debe ser sin signo


// 3. ADDI X1, X2, #4096
No puede ensamblarse ya que el inmediato a adicionar debe poder representarse en 12 bits
y 4096 necesita 13 bits


// 4. EOR X32, X31, X30
No puede ensamblarse ya que no existe un registro X32


// 5. ORRI X24, X24, 0x1FFF
No puede ensamblarse porque el inmediato debe ser capaz de representarse en 12 bits,
0x1FFF necesita 13 bits


// 6. STUR X9, [XZR, #-129]
Si puede codificarse, ya que la direccion de memoria que se pide es representable en 9 bits,
y recordemos que STUR permite que la direccion sea signada, entonces podemos ir de -255 a 255
El codigo de maquina seria: 11111000000101111111001111101001
opcode: 11111000000
DT_adress: 101111111
op: 00
Rn: 11111
Rt: 01001

129 = 010000001
en complemento a 2: 101111110 + 1 = 101111111


// 7. LDURB XZR, [XZR, #-1]
Al igual que el apartado, tenemos direcciones de memoria signadas, entonces si se puede codificar
El codigo de maquina seria: 00111000010111111111001111111111
opcode: 00111000010
DT_adress: 111111111
op: 00
Rn: 11111
Rt: 11111

1 = 000000001
en complemento a 2: 111111110 + 1 = 111111111


// 8. LSR X16, X17, #68
No puede ensamblarse porque el shamt debe ser capaz de representarse en 6 bits y 68 requiere 7 bits


// 9. MOVZ X0, 0x1010, LSL #12
No puede ensamblarse, ya que el inmediato de LSL debe ser 0, 16, 24 o 48


// 10. MOVZ XZR, 0xFFFF, LSL #48
Si puede ensamblarse, el codigo de maquina seria: 1101001011111111111111111111
opcode: 110100101
LSL: 11
MOV_inmediate: 111111111111
Rd: 11111
