.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

//------------------ Inicio Funciones Basicas ------------------ 

	calcular_pixel:
		// 	Parametros:
		// 	x3 -> Pixel X
		// 	x4 -> Pixel Y
		// 	Return x0 -> Posición (x,y) en la imagen

		mov x0, SCREEN_WIDTH				// x0 = 640
		mul x0, x0, x4						// x0 = 640 * y	
		add x0, x0, x3						// x0 = (640 * y) + x
		lsl x0, x0, 2						// x0 = ((640 * y) + x) * 4
		add x0, x0, x20						// x0 = ((640 * y) + x) * 4 + A[0]
	ret										

	pintar_pixel:
		// 	Parametros:
		// 	x1 -> Pixel X
		// 	x2 -> Pixel Y
		//  x10 -> Color

		// Guardamos los valores previos en el stack
		SUB SP, SP, 24 										
		STUR x30, [SP, 16]
		STUR x3, [SP, 8]
		STUR x4, [SP, 0]

		// Chequeamos que las coordenadas esten dentro de la pantalla, si no lo estan, no pintamos
		cmp x1, SCREEN_WIDTH
		b.ge no_paint					 	// x1 >= 640 	

		cmp x2, SCREEN_HEIGH
		b.ge no_paint						// x2 >= 480 

		mov x3, x1                          // x3 -> Pixel X
		mov x4, x2                          // x4 -> Pixel Y

		BL calcular_pixel 					// Calculamos la direccion del pixel a pintar

		stur w10, [x0]                      // Pintamos el Pixel

		no_paint:    
		// Devolvemos los valores previos del stack
		LDR x4, [SP, 0]					 			
		LDR x3, [SP, 8]
		LDR x30, [SP, 16]
		ADD SP, SP, 24	

	ret

	si_pixel_en_circulo_pintar:
		// Verificamos si el pixel en la coordenada (x1 , x2) pertenece al circulo. Si pertenece, lo pintamos
		// Parametros:
		// (x1 , x2) -> Pixel que estamos analizando
		// (x4 , x5) -> Pixel centro del circulo
		// x3 -> Radio del Circulo
		// x10 -> Color

		// Si (x1 - x4)² + (x2 - x5)² ≤ x3² => (x1 , x2) esta dentro del circulo

		// Guardamos los valores previos en el stack
		SUB SP, SP, 32 										
		STUR x30, [SP, 24]
		STUR x15, [SP, 16]
		STUR x14, [SP, 8]
		STUR x13, [SP, 0]

		mul x15,x3,x3           // x15 -> r * r

		sub x13, x1, x4         // x13 -> (x1 - x4) 
		mul x13, x13, x13       // x13 -> (x1 - x4) * (x1 - x4)

		sub x14, x2, x5         // x14 -> (x2 - x5)
		mul x14, x14, x14       // x14 -> (x2 - x5) * (x2 - x5)
		
		add x13, x13, x14       // x13 -> (x1 - x4)² + (x2 - x5)²

		cmp x13, x15
		b.gt outside            // Si no esta dentro, no pinto
		
		bl pintar_pixel         // Si estoy dentro, pinto el pixel (x1 , x2)

		outside:
		// Devolvemos los valores previos del stack
		LDR x13, [SP, 0]					 			
		LDR x14, [SP, 8]
		LDR x15, [SP, 16]
		LDR x30, [SP, 24]
		ADD SP, SP, 32
	ret

	dibujar_circulo:
		// Circulo de radio r centrado en (x0 , y0)
		// Parametros:
		// x3 -> r
		// (x4 , x5) -> (x0 , y0)
		// x10 -> Color

		// Guardamos los valores previos en el stack
		SUB SP, SP, 56 										
		STUR x30, [SP, 48]
		STUR x9, [SP, 40]
		STUR x8, [SP, 32]
		STUR x7, [SP, 24]
		STUR x6, [SP, 16]
		STUR x2, [SP, 8]
		STUR x1, [SP, 0]

		// Calculamos el tamaño del lado del minimo cuadrado que contiene el circulo    
		add x6, x3, x3                              // x6 -> r + r
		
		subs x1, x4, x3                             // x1 -> x0 - r
		b.lt set_x1_to_0                            // Si da negativo entonces x1 tiene que ser 0
		b skip_x1
		
		set_x1_to_0: 
			add x1, xzr, xzr                        // x1 -> 0
		skip_x1:
			subs x2, x5, x3                         // x2 -> y0 - r
			b.lt set_x2_to_0                        // Si da negativo entonces x2 tiene que ser 0
			b skip_x2
		set_x2_to_0: 
			add x2, xzr, xzr                        // x2 -> 0
		skip_x2:

		mov x7, x1                                  // x7 -> x1
		mov x9, x6                                  // x9 -> x6

		// Ahora recorro todo el cuadrado que contiene el circulo y solo pinto los pixeles que pertenecen a el.
		loop_1:                                    
			cbz x9, endloop_1
			cmp x2, SCREEN_HEIGH
			b.ge endloop_1
			mov x1, x7
			mov x8, x6
			loop_0:
				cbz x8, endloop_0
				cmp x1, SCREEN_WIDTH
				b.ge endloop_0
				bl si_pixel_en_circulo_pintar
				add x1, x1, 1
				sub x8, x8, 1
				b loop_0

		endloop_0:
			add x2, x2, 1
			sub x9, x9, 1
			b loop_1
		
		endloop_1:
		// Devolvemos los valores previos del stack
		LDR x1, [SP, 0]					 			
		LDR x2, [SP, 8]					 			
		LDR x6, [SP, 16]					 			
		LDR x7, [SP, 24]					 			
		LDR x8, [SP, 32]					 			
		LDR x9, [SP, 40]
		LDR x30, [SP, 48]
		ADD SP, SP, 56
	ret

	dibujar_cuadrado:
		// 	Parametros:
		// 	w10 -> Color
		//	x1 -> Ancho
		//	x2 -> Alto
		// 	x3 -> Pixel X
		// 	x4 -> Pixel Y

		// Guardamos los valores previos en el stack
		SUB SP, SP, 40 										
		STUR x30, [SP, 32]
		STUR x13, [SP, 24]
		STUR x12, [SP, 16]
		STUR x11, [SP, 8]
		STUR x9,  [SP, 0]

		BL calcular_pixel 					// Calculamos la direccion del pixel a dibujar
		
		mov x9, x2							// x9 = x2 --> A x9 le guardamos el alto del cuadrado
		mov x13, x0							// x13 = x0 --> A x13 le guardamos la direccion calculada
		pintar_cuadrado:
			mov x11, x1						// x11 = x1 --> A x11 le asignamos el ancho del cuadrado
			mov x12, x13					// x12 = x13 --> A x12 le guardamos x13, el pixel inicial de la fila
			color_cuadrado:
				stur w10, [x13]				// Memory[x13] = w10 -> A x13 le asignamos en memoria el color que respresenta w10
				add x13, x13, 4				// w13 = w13 + 4 -> x13 se mueve un pixel hacia la derecha
				sub x11, x11, 1				// w11 = w11 - 1 -> x11 le restamos un pixel de ancho
				cbnz x11, color_cuadrado	// Si x11 no es 0, entonces la fila no se termino de pintar. Seguimos pintandola
				mov x13, x12				// Terminamos de pintar la fila. x13 = x12. Volvemos al pixel de origen de la fila (el mas a la izq)
				add x13, x13, 2560			// x13 = x13 + 2560. Al sumarle 2560 damos un salto de linea (640 * 4)
				sub x9, x9, 1				// x9 = x9 - 1 -> Le restamos 1 al alto de la fila
				cbnz x9, pintar_cuadrado	// Si el alto no es 0, es porque aún no se termino de pintar

		// Devolvemos los valores previos del stack
		LDR x9, [SP, 0]					 			
		LDR x11, [SP, 8]					 			
		LDR x12, [SP, 16]					 			
		LDR x13, [SP, 24]					 			
		LDR x30, [SP, 32]					 			
		ADD SP, SP, 40
	ret


	dibujar_triangulo:
		// 	Parametros:
		// 	w10 -> Color
		//	x1 -> Ancho
		//  x2 -> Cantidad de filas a pintar antes de disminuir en 1 su valor (Altura = x1 * x2)
		// 	x3 -> Pixel X
		// 	x4 -> Pixel Y

		// Guardamos los valores previos en el stack
		SUB SP, SP, 48 										
		STUR x30, [SP, 40]
		STUR x15, [SP, 32]
		STUR x14, [SP, 24]
		STUR x13, [SP, 16]
		STUR x12, [SP, 8]
		STUR x11,  [SP, 0]

		BL calcular_pixel 						// Calculamos la direccion del pixel a dibujar
		
		mov x13, x0								// x13 = x0 -> A x13 le guardamos la direccion calculada
		mov x14, x1								// x14 = x1 -> A x14 le asignamos el ancho de la fila
		
		pintar_triangulo:
			mov x15, x2							// x15 = x2  -> A x15 le asignamos la cantidad de filas a pintar antes de disminuir el ancho de la fila actual
			pintar_fila:
				mov x11, x14					// x11 = x14 -> A x11 le asignamos el ancho de la fila
				mov x12, x13					// x12 = x13 -> A x12 le guardamos x13 (En esta parte de la ejecucción a x12 se le guarda el pixel inicial de la fila)
				
				color_triangulo:
					stur w10, [x13]				// Memory[x13] = w10 -> A x13 le asignamos en memoria el color que respresenta w10
					add x13, x13, 4				// w13 = w13 + 4 -> x13 se mueve un pixel hacia la derecha
					sub x11, x11, 1				// w11 = w11 - 1 -> x11 le restamos un pixel de ancho
					cbnz x11, color_triangulo	// Si x11 <= 0 (la fila no se termino de pintar), seguimos pintandola
					
				mov x13, x12					// En esta parte, ya se termino de pintar la fila. x13 = x12. Volvemos al pixel de origen de la fila
				add x13, x13, 2560				// Pasamos a la siguiente fila
				sub x15, x15, 1					// x15 = x15 - 1. Le restamos 1 a x15 para pintar al siguiente fila del mismo ancho que la anterior
				cbnz x15, pintar_fila
				
				mov x13, x12					// En esta parte, ya se termino de pintar la fila. x13 = x12. Volvemos al pixel de origen de la fila
				add x13, x13, 2564				// x13 = x13 + 2562. La constante 2560 es el total de pixeles de una fila, el numero 4 que se suma a 2560 sirve para movernos 
												//	1 pixel (4 posiciones) hacia la derecha. entonces si lo sumamos es como dar un salto de linea movido 1 pixeles a la derecha
				sub x14, x14, 2					// x14 = x14 - 2. A x14 le restamos 2 para disminuir el ancho de la siguiente fila en 1 pixel
				cbnz x14, pintar_triangulo

		// Devolvemos los valores previos del stack
		LDR x11, [SP, 0]					 			
		LDR x12, [SP, 8]					 			
		LDR x13, [SP, 16]					 			
		LDR x14, [SP, 24]					 			
		LDR x15, [SP, 32]					 			
		LDR x30, [SP, 40]					 			
		ADD SP, SP, 48
	ret

	funcion_delay:
		// 	Parametros:
		// 	x8 -> Duración DELAY.

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 										
		STUR x9,  [SP, 0]

		mov x9, x8  							// Inicializo x9 con x8.
		delay:
			sub x9, x9, 1
			cbnz x9, delay

		// Devolvemos los valores previos del stack
		LDR x9, [SP, 0]					 			
		ADD SP, SP, 8
	ret


//------------------ Fin Funciones Basicas ------------------ 

//------------------ Inicio Funciones Dibujo ------------------ 

	pintar_luna:

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 						
		STUR X30, [SP, 0]

		// Luna
		movz w10, 0xE0, lsl 16              // 	w10 -> Color Luna 
		movk w10, 0xE0E0, lsl 00
		mov x3, 90                         	// 	x3 -> Radio
		mov x4, 535                       	// 	x4 -> x0
		mov x5, 355                         // 	x5 -> y0
		BL dibujar_circulo

		// Craters
		movz w10, 0x95, lsl 16				// w10 -> Color Craters
		movk w10, 0x9595, lsl 0
		mov x3, 15                         	// 	x3 -> Radio
		mov x4, 560                       	// 	x4 -> x0
		mov x5, 320                        	// 	x5 -> y0
		BL dibujar_circulo
		
		mov x3, 25                         	// 	x3 -> Radio
		mov x4, 500                       	// 	x4 -> x0
		mov x5, 340                         // 	x5 -> y0
		BL dibujar_circulo

		mov x3, 22                         	// 	x3 -> Radio
		mov x4, 550                       	// 	x4 -> x0
		mov x5, 380                         // 	x5 -> y0
		BL dibujar_circulo

		// Devolvemos los valores previos del stack
		LDR X30, [SP, 0]					
		ADD SP, SP, 8	
	ret

	pintar_luna_centrada:

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 						
		STUR X30, [SP, 0]

		// Luna
		movz w10, 0xE0, lsl 16              // 	w10 -> Color Luna 
		movk w10, 0xE0E0, lsl 00
		mov x3, 90                         	// 	x3 -> Radio
		mov x4, 320                   		// 	x4 -> x0
		mov x5, 240                         // 	x4 -> y0
		BL dibujar_circulo

		// Craters
		movz w10, 0x95, lsl 16				// w10 -> Color Craters
		movk w10, 0x9595, lsl 0
		mov x3, 15                         	// 	x3 -> Radio
		mov x4, 355                       	// 	x4 -> x0
		mov x5, 205                        	// 	x5 -> y0
		BL dibujar_circulo
		
		mov x3, 25                         	// 	x3 -> Radio
		mov x4, 285                       	// 	x4 -> x0
		mov x5, 225                         // 	x5 -> y0
		BL dibujar_circulo

		mov x3, 22                         	// 	x3 -> Radio
		mov x4, 335                       	// 	x4 -> x0
		mov x5, 265                         // 	x5 -> y0
		BL dibujar_circulo

		// Devolvemos los valores previos del stack
		LDR X30, [SP, 0]					
		ADD SP, SP, 8	
	ret

	pintar_fondo:

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 						
		STUR X30, [SP, 0]

		movz w10, 0x16, lsl 16				// w10 -> Color Fondo
		movk w10, 0x16, lsl 00
		mov x1, SCREEN_WIDTH				// x1 -> Ancho
		mov x2, SCREEN_HEIGH				// x2 -> Alto
		mov x3, 0							// x3 -> Pixel X
		mov x4, 0							// x4 -> Pixel Y
		BL dibujar_cuadrado

		// Devolvemos los valores previos del stack
		LDR X30, [SP, 0]					
		ADD SP, SP, 8		
	ret

	pintar_pantalla_carga:

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 						
		STUR X30, [SP, 0]

		movz w10, 0x00, lsl 16				// w10 -> Color Fondo
		movk w10, 0x0000, lsl 00
		mov x1, SCREEN_WIDTH				// x1 -> Ancho
		mov x2, SCREEN_HEIGH				// x2 -> Alto
		mov x3, 0							// x3 -> Pixel X
		mov x4, 0							// x4 -> Pixel Y
		BL dibujar_cuadrado

		// Devolvemos los valores previos del stack
		LDR X30, [SP, 0]					
		ADD SP, SP, 8		
	ret

	pintar_bordes:

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 						
		STUR X30, [SP, 0]

		movz w10, 0x16, lsl 16				// w10 -> Color Bordes
		movk w10, 0x15, lsl 00
		mov x1, SCREEN_WIDTH
		mov x2, 1
		mov x3, 0
		mov x4, 0
		BL dibujar_cuadrado
		
		mov x1, 1
		mov x2, SCREEN_HEIGH
		mov x3, 0
		mov x4, 0
		BL dibujar_cuadrado
		
		mov x1, 1
		mov x2, SCREEN_HEIGH
		mov x3, 639
		mov x4, 0
		BL dibujar_cuadrado
		
		mov x1, SCREEN_WIDTH
		mov x2, 1
		mov x3, 0
		mov x4, 479
		BL dibujar_cuadrado

		// Devolvemos los valores previos del stack
		LDR X30, [SP, 0]					
		ADD SP, SP, 8	
	ret

	pintar_nave:

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 						
		STUR X30, [SP, 0]

		// Base
		movz w10, 0xFF, lsl 16				// w10 -> Color Base
		movk w10, 0x9933, lsl 00
		mov x1, 20							// x1 -> Ancho
		mov x2, 5							// x2 -> Alto
		mov x3, 50							// x3 -> Pixel X
		mov x4, 50							// x4 -> Pixel Y
		BL dibujar_cuadrado

		// Capsula
		movz w10, 0x00, lsl 16				// w10 -> Color Capsula
		movk w10, 0xCCCC, lsl 00
		mov x1, 6							// x1 -> Ancho
		mov x2, 6							// x2 -> Alto
		mov x3, 57							// x3 -> Pixel X
		mov x4, 44							// x4 -> Pixel Y
		BL dibujar_cuadrado

		// Devolvemos los valores previos del stack
		LDR X30, [SP, 0]					
		ADD SP, SP, 8		
	ret

	pintar_propulsor:

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 						
		STUR X30, [SP, 0]

		// Propulsor
		movz w10, 0xEA, lsl 16				// w10 -> Color Fuego externo
		movk w10, 0xE000, lsl 00
		mov x1, 10							// x1 -> Ancho
		mov x2, 2							// x2 -> Altura = x1 * x2
		mov x3, 305							// x3 -> Pixel X
		mov x4, 55							// x4 -> Pixel Y
		BL dibujar_triangulo

		movz w10, 0xFC, lsl 16				// w10 -> Color Fuego interno
		movk w10, 0x0000, lsl 00
		mov x1, 6							// x1 -> Ancho
		mov x2, 2							// x2 -> Altura = x1 * x2
		mov x3, 307							// x3 -> Pixel X
		mov x4, 55							// x4 -> Pixel Y
		BL dibujar_triangulo

		// Devolvemos los valores previos del stack
		LDR X30, [SP, 0]					
		ADD SP, SP, 8		
	ret

	pintar_tren_aterrizaje:

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 						
		STUR X30, [SP, 0]

		movz w10, 0x00, lsl 16				// w10 -> Color Patitas
		movk w10, 0x0000, lsl 00

		// Pata Izq
		mov x1, 2							//	x1 -> Ancho
		mov x2, 5							//	x2 -> Alto
		mov x3, 305							// 	x3 -> Pixel X
		mov x4, 151							// 	x4 -> Pixel Y
		BL dibujar_cuadrado
		
		mov x1, 3
		mov x2, 2
		mov x3, 303
		mov x4, 156
		BL dibujar_cuadrado

		// Pata der
		mov x1, 2							//	x1 -> Ancho
		mov x2, 5							//	x2 -> Alto
		mov x3, 313							// 	x3 -> Pixel X
		mov x4, 151							// 	x4 -> Pixel Y
		BL dibujar_cuadrado
		
		mov x1, 3
		mov x2, 2
		mov x3, 314
		mov x4, 156
		BL dibujar_cuadrado

		// Devolvemos los valores previos del stack
		LDR X30, [SP, 0]					
		ADD SP, SP, 8	
	ret

	pintar_bandera:

		// Guardamos los valores previos en el stack
		SUB SP, SP, 8 						
		STUR X30, [SP, 0]

		// Mastil
		movz w10, 0x66, lsl 16				// w10 -> Color Mastil
		movk w10, 0x3300, lsl 00
		mov x1, 2							// x1 -> Ancho
		mov x2, 50							// x2 -> Alto
		mov x3, 350							// x3 -> Pixel X
		mov x4, 120							// x4 -> Pixel Y
		BL dibujar_cuadrado

		// Franjas Azules
		movz w10, 0x6C, lsl 16				// w10 -> Color Azul
		movk w10, 0xACE4, lsl 00		
		mov x1, 50							// x1 -> Ancho
		mov x2, 30							// x2 -> Alto
		mov x3, 350							// x3 -> Pixel X
		mov x4, 120							// x4 -> Pixel Y
		BL dibujar_cuadrado

		// Franja Blanca
		movz w10, 0xFF, lsl 16				// w10 -> Color Blanco
		movk w10, 0xFFFF, lsl 00
		mov x1, 50							// x1 -> Ancho
		mov x2, 10							// x2 -> Alto
		mov x3, 350							// x3 -> Pixel X
		mov x4, 130							// x4 -> Pixel Y
		BL dibujar_cuadrado

		// Sol
		movz w10, 0xFF, lsl 16              // 	w10 -> Color Sol 
		movk w10, 0xFF00, lsl 00
		mov x3, 5                         	// 	x3 -> Radio
		mov x4, 375                       	// 	x4 -> x0
		mov x5, 135                       	// 	x5 -> y0
		BL dibujar_circulo

		// Devolvemos los valores previos del stack
		LDR X30, [SP, 0]					
		ADD SP, SP, 8		
	ret

//------------------ Fin Funciones Dibujo ------------------ 

//------------------ Iinicio Funciones Animacion ------------------ 

	funcion_mover_elem_der:
		// Parametros
		// x1 -> Ancho del elemento.
		// x2 -> Alto del elemento.
		// x25 -> Esquina Superior Izquierda del elemento.

		// Guardamos los valores previos en el stack
		SUB SP, SP, 24 										
		STUR x30, [SP, 16]
		STUR x25, [SP, 8]
		STUR x1, [SP, 0]

		
		// Hacemos cuentas nesesarias.
		add x22, x1, x1								// x22 -> ancho + ancho
		add x22, x22, x22							// x22 -> ancho + ancho + ancho + ancho = ancho * 4
		add x25, x25, x22							// x25 = x25 + x1 * 4
		sub x25, x25, 4								// x25 = x25 - 4
		add x1, x1, 1 								// x1 = x1 + 1
		BL calcular_pixel
		
			mov x16, x25 							// x16 = x0 -> Inicializo x16 con x0 (Pixel Derecho Superior).
			mov x17, x2								// x17 = x2 -> x17 alto del elemento
			mover_elemento_der:
				mov x18, x1 						// x18 = x1 -> Contador de Ancho
				mov x19, x16 						// x19 = x16 -> Actual Pixel
				mover_pixel_der:
					mov x21, x19 					// x21 = x19 -> guardo en x21 el pixel actual
					add x21, x21, 4 				// x21 = x21 + 4 -> Me situo en el pixel de la derecha de x21
					ldr w5, [x19] 					// w5 = [x19] -> cargo en w5 el color de x19
					str w5, [x21] 					// pinto el pixel de x21, con el color guardado en w5
					sub x18, x18, 1 				// Resto 1 al contador de ancho
					sub x19, x19, 4 				// voy al pixel de la izq de x19
					cbnz x18, mover_pixel_der 		
					sub x17, x17, 1
					add x16, x16, 2560
					cbnz x17, mover_elemento_der

		// Devolvemos los valores previos del stack
		LDR x1, [SP, 0]
		LDR x25, [SP, 8]					 			
		LDR x30, [SP, 16]
		ADD SP, SP, 24
	ret


	funcion_mover_elem_izq:
		// Parametros
		// x1 -> Ancho del elemento.
		// x2 -> Alto del elemento.
		// x25 -> Esquina Superior Izquierda del elemento.

		// Guardamos los valores previos en el stack
		SUB SP, SP, 24 										
		STUR x30, [SP, 16]
		STUR x25, [SP, 8]
		STUR x1, [SP, 0]
		
		// Hacemos cuentas nesesarias.
		add x1, x1, 1 								// x1 = x1 + 1
					
			mov x16, x25 							// x16 = x0 -> Inicializo x16 con x0 (Pixel Superior Izquierdo).
			mov x17, x2								// x17 = x2 -> x17 alto del elemento
			mover_elemento_izq:	
				mov x18, x1 						// x18 = x1 -> Contador de Ancho
				mov x19, x16 						// x19 = x16 -> Actual Pixel
				mover_pixel_izq:	
					mov x21, x19 					// x21 = x19 -> guardo en x21 el pixel actual 
					sub x21, x21, 4 				// x21 = x21 - 4 -> Me situo en el pixel de la izquierda de x21
					ldr w5, [x19] 					// w5 = [x19] -> cargo en w5 el color de x19
					str w5, [x21] 					// pinto el pixel de x21, con el color guardado en w5
					sub x18, x18, 1 				// Resto 1 al contador de ancho
					add x19, x19, 4 				// voy al pixel de la der de x19
					cbnz x18, mover_pixel_izq
					sub x17, x17, 1
					add x16, x16, 2560
					cbnz x17, mover_elemento_izq
			
		// Devolvemos los valores previos del stack
		LDR x1, [SP, 0]
		LDR x25, [SP, 8]					 			
		LDR x30, [SP, 16]
		ADD SP, SP, 24
	ret


	funcion_mover_elem_arr:
		// Parametros
		// x1 -> Ancho del elemento.
		// x2 -> Alto del elemento.
		// x25 -> Esquina Superior Izquierda del elemento.

		// Guardamos los valores previos en el stack
		SUB SP, SP, 24 										
		STUR x30, [SP, 16]
		STUR x25, [SP, 8]
		STUR x2, [SP, 0]
		
		// Hacemos cuentas nesesarias.
		add x2, x2, 1 								// x2 = x2 + 1
					
			mov x16, x25 							// x16 = x0 -> Inicializo x16 con x0 (Pixel Superior Izquierdo).
			mov x17, x2								// x17 = x2 -> x17 alto del elemento
			mover_elemento_arr:
				mov x18, x1 						// x18 = x1 -> Contador de Ancho
				mov x19, x16 						// x19 = x16 -> Actual Pixel
				mover_pixel_arr:
					mov x21, x19 					// x21 = x19 -> guardo en x21 el pixel actual 
					sub x21, x21, 2560 				// x21 = x21 - 2560 -> Me situo en el pixel de arriba de x21
					ldr w5, [x19] 					// w5 = [x19] -> cargo en w5 el color de x19
					str w5, [x21] 					// pinto el pixel de x21, con el color guardado en w5
					sub x18, x18, 1 				// Resto 1 al contador de ancho
					add x19, x19, 4 				// voy al pixel de la der de x19
					cbnz x18, mover_pixel_arr
					sub x17, x17, 1
					add x16, x16, 2560
					cbnz x17, mover_elemento_arr
			
		// Devolvemos los valores previos del stack
		LDR x2, [SP, 0]
		LDR x25, [SP, 8]					 			
		LDR x30, [SP, 16]
		ADD SP, SP, 24
	ret

	funcion_mover_elem_aba:
		// Parametros
		// x1 -> Ancho del elemento.
		// x2 -> Alto del elemento.
		// x25 -> Esquina Superior Izquierda del elemento.

		// Guardamos los valores previos en el stack
		SUB SP, SP, 24 										
		STUR x30, [SP, 16]
		STUR x25, [SP, 8]
		STUR x2, [SP, 0]

		// Hacemos cuentas nesesarias.
		add x22, x1, x1								// x22 -> ancho + ancho
		add x22, x22, x22							// x22 -> ancho + ancho + ancho + ancho = ancho * 4
		add x25, x25, x22							// x25 = x25 + x1 * 4
		sub x25, x25, 4								// x25 = x25 - 4

		movz x23, 0xA00, lsl 00						// x23 = 2560
		mul x24, x2, x23							// x22 -> alto * 2560
		add x25, x25, x24							// x25 = x25 + x24
		sub x25, x25, 2560							// x25 = x25 - 2560
		
		add x2, x2, 1 								// x2 = x2 + 1
		
			mov x16, x25 							// x16 = x0 -> Inicializo x16 con x0 (Pixel Derecho Inferior).
			mov x17, x2								// x17 = x2 -> x17 alto del elemento
			mover_elemento_aba:
				mov x18, x1 						// x18 = x1 -> Contador de Ancho
				mov x19, x16 						// x3 = x0 -> Actual Pixel
				mover_pixel_aba:
					mov x21, x19 					// x21 = x19 -> guardo en x21 el pixel actual
					add x21, x21, 2560 				// x21 = x21 + 2560 -> Me situo en el pixel de abajo de x21
					ldr w5, [x19] 					// w5 = [x19] -> cargo en w5 el color de x19
					str w5, [x21] 					// pinto el pixel de x21, con el color guardado en w5
					sub x18, x18, 1 				// Resto 1 al contador de ancho
					sub x19, x19, 4 				// voy al pixel de la izq de x19
					cbnz x18, mover_pixel_aba 		
					sub x17, x17, 1
					sub x16, x16, 2560
					cbnz x17, mover_elemento_aba

		// Devolvemos los valores previos del stack
		LDR x2, [SP, 0]
		LDR x25, [SP, 8]					 			
		LDR x30, [SP, 16]
		ADD SP, SP, 24
	ret


//------------------ Fin Funciones Animacion ------------------ 
