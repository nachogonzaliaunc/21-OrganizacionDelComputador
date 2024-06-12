//---------------- Inicio Carga Parametros ------------------------------------

	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	// Incluimos el archivo donde estan todas las funciones
	.include "funciones.s"
	
	// Los inputs para este programa son:
	// W,A,S,D,SPACE

	.equ key_W, 0x2
	.equ key_A, 0x4
	.equ key_S, 0x8
	.equ key_D, 0x10
	.equ key_SPACE, 0x20

	.globl main

	main:
	// x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20

//---------------- Fin Carga Parametros ------------------------------------

reseteo:
//---------------- Inicio Dibujo ------------------------------------
 
	BL pintar_fondo

	BL pintar_bordes
	
	BL pintar_luna

	BL pintar_nave

//---------------- Fin Dibujo ------------------------------------

//---------------- Variables Globales ------------------------------------
	
	// Valores Hitbox: (este hitbox debe encerrar la nave)
	//	x1 -> Ancho.
	//	x2 -> Alto.
	// 	x3 -> Pixel X.
	// 	x4 -> Pixel Y.
	mov x1, 20
	mov x2, 11
	mov x3, 50
	mov x4, 44

	BL calcular_pixel			// Encuentro la esquina superior izq del Hitbox con x3 y x4

	mov x25 , x0				// Guardo la direccion del Hitbox en x25

	movz w7, 0x16, lsl 16		// x7 debe de ser del mismo color que los bordes que me detienen
	movk w7, 0x15, lsl 00		// En caso de modificar el color de los bordes, tambien se debe modificar x7

	movz w9, 0xE0, lsl 16		// x9 debe de ser del mismo color de la Luna (salta animacion final)
	movk w9, 0xE0E0, lsl 00		// En caso de modificar el color de la luna, tambien se debe modificar x9

	movz x8, 0x3F, lsl 16 		// x8 -> Tiempo de delay = Velocidad del Meteoro. 
	movk x8, 0xFFFF, lsl 00		// Este valor se puede modificar a gusto de cada jugador

//----------------------------------------------------
	
//---------------- Loop Inicial ------------------------------------

	// Realizo un loop inicial hasta que el jugador decide moverse
	quieto:		

		BL loop_pulsador			

		B quieto

//----------------------------------------------------

//---------------- Inicio Movimiento ------------------------------------
	
	mov_hitbox_izq:

		loop_mov_hitbox_izq:
			
			// Primero debo detectar si puedo moverme

			mov x21, x25				// x21 -> Direccion Esquina Superior Izq
			sub x21, x21 , 8			// Reviso 2 pixeles a la izq si debo detenerme
			ldr w6, [x21]

			cmp w6, w7					// Si el color es el que me detiene, entonces freno
			b.eq quieto

			cmp w6, w9					// Si el color es el de la luna, entonces animacion final
			b.eq final

			movz x23, 0xA00, lsl 00		// x23 = 2560
			mul x22, x2, x23			// x22 -> alto * 2560 
			add x21, x21, x22			// x21 -> Direccion Esquina Inferior Izq 2 pixeles a la izq			
			ldr w6, [x21]

			cmp w6, w7					// Si el color es el que me detiene, entonces freno
			b.eq quieto

			cmp w6, w9					// Si el color es el de la luna, entonces animacion final
			b.eq final

			// Si llegue hasta aca entonces no debo detenerme
			
			BL funcion_delay

			// x1 -> Ancho del hitbox
			// x2 -> Alto del hitbox
			// x25 -> Ubicacion del hitbox
			BL funcion_mover_elem_izq

			sub x25 , x25 , 4			// Mi nueva esquina superior izq ahora esta un pixel a la izq que antes

			BL loop_pulsador			// Reviso si ingreso un nuevo input
			
		B loop_mov_hitbox_izq

	mov_hitbox_der:
			
		loop_mov_hitbox_der:

			// Primero debo detectar si puedo moverme

			mov x21, x25				// x21 -> Direccion Esquina Superior Izq

			add x22, x1, x1				// x22 -> ancho + ancho
			add x22, x22, x22			// x22 -> ancho + ancho + ancho + ancho = ancho * 4
			add x22, x22, 4
			add x21, x21 , x22			// Me muevo a la esquina superior derecha y 2 pixeles mas
			ldr w6, [x21]

			cmp w6, w7					// Si el color es el que me detiene, entonces freno
			b.eq quieto

			cmp w6, w9					// Si el color es el de la luna, entonces animacion final
			b.eq final

			movz x23, 0xA00, lsl 00		// x23 = 2560
			mul x22, x2, x23			// x22 -> alto * 2560 
			add x21, x21, x22			// x21 -> Direccion Esquina Inferior Der 2 pixeles a la der			
			ldr w6, [x21]

			cmp w6, w7					// Si el color es el que me detiene, entonces freno
			b.eq quieto

			cmp w6, w9					// Si el color es el de la luna, entonces animacion final
			b.eq final

			// Si llegue hasta aca entonces no debo detenerme
			
			BL funcion_delay

			// x1 -> Ancho del hitbox
			// x2 -> Alto del hitbox
			// x25 -> Ubicacion del hitbox
			BL funcion_mover_elem_der

			add x25, x25, 4				// Mi nueva esquina superior izq ahora esta un pixel a la der que antes

			BL loop_pulsador			// Reviso si ingreso un nuevo input
			
		B loop_mov_hitbox_der

	mov_hitbox_arr:
			
		loop_mov_hitbox_arr:

			// Primero debo detectar si puedo moverme

			mov x21, x25				// x21 -> Direccion Esquina Superior Izq
			movz x22 , 0x1400 , lsl 00	// x22 -> 2560 * 2			
			sub x21, x21 , x22 			// Me muevo 2 pixeles arriba
			ldr w6, [x21]

			cmp w6, w7					// Si el color es el que me detiene, entonces freno
			b.eq quieto

			cmp w6, w9					// Si el color es el de la luna, entonces animacion final
			b.eq final
			
			add x22, x1, x1				// x22 -> ancho + ancho
			add x22, x22, x22			// x22 -> ancho + ancho + ancho + ancho = ancho * 4
			add x21, x21 , x22			// x21 -> Direccion Esquina Superior Der 2 pixeles arriba
			ldr w6, [x21]

			cmp w6, w7					// Si el color es el que me detiene, entonces freno
			b.eq quieto

			cmp w6, w9					// Si el color es el de la luna, entonces animacion final
			b.eq final

			// Si llegue hasta aca entonces no debo detenerme
			
			BL funcion_delay

			// x1 -> Ancho del hitbox
			// x2 -> Alto del hitbox
			// x25 -> Ubicacion del hitbox
			BL funcion_mover_elem_arr

			sub x25, x25, 2560			// Mi nueva esquina superior izq ahora esta un pixel arriba que antes

			BL loop_pulsador			// Reviso si ingreso un nuevo input
			
		B loop_mov_hitbox_arr

	mov_hitbox_aba:
			
		loop_mov_hitbox_aba:

			// Primero debo detectar si puedo moverme

			mov x21, x25				// x21 -> Direccion Esquina Superior Izq

			movz x23, 0xA00, lsl 00		// x23 = 2560
			mul x22, x2, x23			// x22 -> alto * 2560
			add x22, x22, 2560 			
			add x21, x21, x22			// x21 -> Direccion Esquina Inferior Izq				
			ldr w6, [x21]

			cmp w6, w7					// Si el color es el que me detiene, entonces freno
			b.eq quieto

			cmp w6, w9					// Si el color es el de la luna, entonces animacion final
			b.eq final

			add x22, x1, x1				// x22 -> ancho + ancho
			add x22, x22, x22			// x22 -> ancho + ancho + ancho + ancho = ancho * 4
			add x21, x21 , x22			// x21 -> Direccion Esquina Inferior Der 2 pixeles arriba
			ldr w6, [x21]

			cmp w6, w7					// Si el color es el que me detiene, entonces freno
			b.eq quieto

			cmp w6, w9					// Si el color es el de la luna, entonces animacion final
			b.eq final

			// Si llegue hasta aca entonces no estoy en el borde y me muevo
			
			BL funcion_delay

			// x1 -> Ancho del hitbox
			// x2 -> Alto del hitbox
			// x25 -> Ubicacion del hitbox
			BL funcion_mover_elem_aba

			add x25, x25, 2560			// Mi nueva esquina superior izq ahora esta un pixel abajo que antes

			BL loop_pulsador			// Reviso si ingreso un nuevo input
			
		B loop_mov_hitbox_aba
	
	animacion_der:

		mov x3, 300					// 	x3 -> Pixel X limite
		mov x4, 44					// 	x4 -> Pixel Y limite

		BL calcular_pixel			// Encuentro la direccion donde quiero que se detenga

		mov x6, x0					// x6 -> Guardo la direccion del limite

		// Valores Hitbox: (este cuadrado debe encerrar la nave)
		mov x1, 20					//	x1 -> Ancho
		mov x2, 11					//	x2 -> Alto
		mov x3, 50					// 	x3 -> Pixel X
		mov x4, 44					// 	x4 -> Pixel Y
		
		BL calcular_pixel			// Encuentro la esquina superior izq del Hitbox con x3 y x4

		mov x25, x0					// x25 -> Direccion del hitbox

		loop_animacion_der:
			
			BL funcion_delay

			// x1 -> Ancho del hitbox
			// x2 -> Alto del hitbox
			// x25 -> Ubicacion del hitbox
			BL funcion_mover_elem_der

			add x25, x25, 4				// Mi nueva esquina superior izq ahora esta un pixel a la der que antes

			cmp x25, x6					// Si llego al limite entonces freno
			b.eq fin_animacion_der
			
		B loop_animacion_der

	animacion_aba:

		mov x3, 300					// 	x3 -> Pixel X limite
		mov x4, 140					// 	x4 -> Pixel Y limite

		BL calcular_pixel			// Encuentro la direccion donde quiero que se detenga

		mov x6, x0					// x6 -> Guardo la direccion del limite

		mov x3, 300					// 	x3 -> Pixel X apago propulsor
		mov x4, 110					// 	x4 -> Pixel Y apago propulsor

		BL calcular_pixel			// Encuentro la direccion donde quiero que se apague el propulsor

		mov x7, x0					// x7 -> Guardo la direccion de apagado del propulsor

		// Valores Hitbox: (este cuadrado debe encerrar la nave)
		mov x1, 20					//	x1 -> Ancho
		mov x2, 31					//	x2 -> Alto
		mov x3, 300					// 	x3 -> Pixel X
		mov x4, 44					// 	x4 -> Pixel Y
		
		BL calcular_pixel			// Encuentro la esquina superior izq del Hitbox con x3 y x4

		mov x25, x0					// x25 -> Direccion del hitbox
			
		loop_animacion_aba:
			
			BL funcion_delay

			// x1 -> Ancho del hitbox
			// x2 -> Alto del hitbox
			// x25 -> Ubicacion del hitbox
			BL funcion_mover_elem_aba

			add x25, x25, 2560			// Mi nueva esquina superior izq ahora esta un pixel abajo que antes

			cmp x25, x7					// Si todavia no llegue a donde tengo que apagar, no apago
			b.ne no_apago
										// Para apagarlo devuelvo el valor original del alto del hitbox
			mov x2, 11					//	x2 -> Alto hitbox

			no_apago:
			cmp x25, x6					// Si llego al limite entonces freno
			b.eq fin_animacion_aba
			
		B loop_animacion_aba

//---------------- Fin Movimiento ------------------------------------

//---------------- Inicio Lectura Inputs ------------------------------------

	loop_pulsador:

		// Guardo el valor de x9 debido a guarda el color de la luna
		SUB SP, SP, 8 										
		STUR x9,  [SP, 0]

		// Seteamos el GPIO para poder realizar la lectura de los inputs
		mov x9, GPIO_BASE

		// Atención: se utilizan registros w porque la documentación de broadcom
		// indica que los registros que estamos leyendo y escribiendo son de 32 bits

		// Setea gpios 0 - 9 como lectura
		str wzr, [x9, GPIO_GPFSEL0]

		// Lee el estado de los GPIO 0 - 31
		ldr w10, [x9, GPIO_GPLEV0]

		// Devolvemos el valor de x9
		LDR x9, [SP, 0]					 			
		ADD SP, SP, 8

		// And bit a bit mantiene el resultado del bit 2 en w10 (notar 0b... es binario)
		// al inmediato se lo refiere como "máscara" en este caso:
		// - Al hacer AND revela el estado del bit 2
		// - Al hacer OR "setea" el bit 2 en 1
		// - Al hacer AND con el complemento "limpia" el bit 2 (setea el bit 2 en 0)
		
		and w11, w10, 0b00000010
		and w12, w10, 0b00000100
		and w13, w10, 0b00001000
		and w14, w10, 0b00010000
		and w15, w10, 0b00100000

		// si w11 es 0 entonces el GPIO 1 estaba liberado
		// de lo contrario será distinto de 0, (en este caso particular 2)
		// significando que el GPIO 1 fue presionado

		cmp w11 , key_W			// Al presionar la W el hitbox se mueve para arriba
		beq mov_hitbox_arr

		cmp w12 , key_A			// Al presionar la A el hitbox se mueve para la izquierda
		beq mov_hitbox_izq

		cmp w13 , key_S			// Al presionar la S el hitbox se mueve para abajo
		beq mov_hitbox_aba

		cmp w14 , key_D			// Al presionar la D el hitbox se mueve para la derecha
		beq mov_hitbox_der

		cmp w15 , key_SPACE		// Al presionar SPACE el juego se reinicia
		beq reseteo
		
	ret

//---------------- Fin Lectura Inputs ------------------------------------

//---------------- Inicio Animacion Final ------------------------------------
	final:

	BL pintar_pantalla_carga

	movz x8, 0x1FFF, lsl 16			// Damos un tiempo de delay para cambiar de escena.
	movk x8, 0xFFFF, lsl 00			// Modificable a gusto del jugador

	BL funcion_delay
	
	BL pintar_fondo

	BL pintar_luna_centrada

	BL pintar_nave

	movz x8, 0x3F, lsl 16 			// x8 -> Tiempo de delay = Velocidad de la animacion
	movk x8, 0xFFFF, lsl 00			// Modificable a gusto del jugador

	B animacion_der

	fin_animacion_der:

	movz x8, 0xFFF, lsl 16			// Damos un tiempo de delay para que active los propulsores
	movk x8, 0xFFFF, lsl 00			// Modificable a gusto del jugador	

	BL funcion_delay

	BL pintar_propulsor

	movz x8, 0xAF, lsl 16 			// Volvemos a setear x8 -> Tiempo de delay = Velocidad descenso nave
	movk x8, 0xFFFF, lsl 00			// Modificable a gusto del jugador

	B animacion_aba

	fin_animacion_aba:

	BL pintar_tren_aterrizaje

	movz x8, 0xFFF, lsl 16			// Damos un tiempo de delay para poner la bandera
	movk x8, 0xFFFF, lsl 00			// Modificable a gusto del jugador

	BL funcion_delay

	BL pintar_bandera

	B quieto

//---------------- Fin Animacion Final ------------------------------------

//---------------- Infinite Loop ------------------------------------
InfLoop:
	b InfLoop
	