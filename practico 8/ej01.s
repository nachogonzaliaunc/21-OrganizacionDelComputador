// Extender los siguientes numeros de 26 bits en complemento a dos a 64 bits. Si el numero
// es negativo verificar que la extension a 64 bits codifica el mismo numero original de 26 bits.


// 1.1) 00 0000 0000 0000 0000 0000 0001

Completo el numero:
0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0001

Como es positivo, no debo calcular su complemento a 2



// 1.2) 10 0000 0000 0000 0000 0000 0000

Completo el numero:
1111 1111 1111 1111 1111 1111 1111 1111 1111 1110 0000 0000 0000 0000 0000 0000
Niego bit a bit:
0000 0000 0000 0000 0000 0000 0000 0000 0000 0001 1111 1111 1111 1111 1111 1111
Sumo 1:
0000 0000 0000 0000 0000 0000 0000 0000 0000 0010 0000 0000 0000 0000 0000 0000

Este ultimo numero codifica el mismo numero original de 26 bits