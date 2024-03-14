/*
	Traducir el siguiente programa en C a ensamblador LEGv8 dada la asignacion de varialbles
	a los registros X0=str, X1=found, X2=i, X9=N. El numero 48 se corresponde con el caracter
	'0' en ASCII, por lo tanto el programa cuenta la cantidad de '0's que aparecen en una
	cadena de caracteres de longitud N


	#define N (1<<N)
	char *str;
	long found, i;
	for (found=0, i=0; i!=N; ++i)
		found += (str[i] == 48);
*/


.data
	str: .dword 0x754d30616c6f4830, 0x00000000306f646e
	N: .dword 15
	offset: .dword 0x40080000


.text
	LDR X0, =str
	LDR X10, offset
	LDR X9, N		// N = 15
	add X0, X0, X10      		// X0 = &str[0]
	add X1, XZR, XZR        // found = 0
	add X2, XZR, XZR        // i = 0
	loop:
		cmp X2, X9            // comparo N e i
		b.EQ end            	// si N=i,termina la ejecucion
		add X11, X0, X2       // X11 = &str[0] + i = &str[i]
		ldurb W12, [X11, #0]  // X12 = str[i] 
		cmp W12, #48        	// comparo X12 y 48 (caracter 0)
		b.NE skip            	// si son distintos no lo cuento
		add X1, X1, #1        // si X12=0, found++
	skip:
		add X2, X2, #1        // i++
		B loop								// salto incondicional a loop
	end:

infloop: B infloop
