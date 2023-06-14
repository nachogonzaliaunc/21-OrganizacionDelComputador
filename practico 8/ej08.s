// Dadas las siguientes direcciones de memoria:
//      0x00014000
//      0x00114524
//      0x0F000200

// 8.1) Si el valor del PC es 0x00000000, es posible llegar con una sola instruccion
//      conditional branch a las direcciones de memoria arriba listadas?

Campo de inmediato de conditional branch: 19 bits
Maxima cantidad de instrucciones hacia adelante: (2 elevado a 18)-1
2 elevado a 18 = 1000000000000000000b = 0x40000
(2 elevado a 18)-1 = 0111111111111111111b = 0x3FFFF

Maxima cantidad de posiciones de memoria hacia adelante: (Instrucciones * 4)
11111111111111111100b = 0xFFFFC

Partiendo de PC=0x00000000 se alcanza la direccion:
0x00000000 + 0x000FFFFC = 0x000FFFFC

Entonces:
- 0x00014000 es posible llegar con una sola instruccion
- 0x00114524 no es posible llegar con una sola instruccion
- 0x0F000200 no es posible llegar con una sola instruccion




// 8.2) Si el valor del PC es 0x00000600, es posible llegar con una sola instruccion
//      branch a las direcciones de memoria arriba listadas?

Campo de inmediato de branch: 26 bits
Maxima cantidad de instrucciones hacia adelante: (2 elevado a 25)-1
2 elevado a 25 = 10000000000000000000000000b = 0x2000000
(2 elevado a 25)-1 = 01111111111111111111111111b = 0x1FFFFFF

Maxima cantidad de posiciones de memoria hacia adelante: (Instrucciones * 4)
111111111111111111111111100b = 0x7FFFFFC

Partiendo de PC=0x00000600 se alcanza la direccion:
0x00000600 + 0x07FFFFFC = 0x080005FC

Entonces:
- 0x00014000 es posible llegar con una sola instruccion
- 0x00114524 es posible llegar con una sola instruccion
- 0x0F000200 no es posible llegar con una sola instruccion




// 8.3) Si el valor del PC es 0x00000000 y quiero saltar al primer GiB de memoria
//      0x40000000. Escribir exactamente 2 instrucciones contiguas que posibilitan el
//      salto lejano (far jump)

MOVZ X0, 0x4000, LSL 16  // precacargo la direccion en el registro X0
BR X0                    // salto a la direccion que contiene el registro

*si el PC es distinto de 0x0, la respuesta es la misma
