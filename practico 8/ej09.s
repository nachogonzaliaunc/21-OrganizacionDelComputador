// Suponiendo que el PC está en la primera palabra de memoria 0x00000000 y se desea
// saltar a la ultima instruccion de los primeros 4 GiB o sea a 0xFFFFFFFC, cuantas
// instrucciones B son necesarias? (no se puede usar BR)


Recordemos, por lo visto en el ejercicio anterior, la maxima cantidad de lugares
que puedo saltar con un branch es 0x07FFFFFC, entonces dividamos 0xFFFFFFFC/0x07FFFFFC

0xFFFFFFFC = 4294967292
0x07FFFFFC =  134217724

0xFFFFFFFC / 0x07FFFFFC = 32.00000092387202 (resuelto con calculadora)

Entonces se necesitan 33 instrucciones B
