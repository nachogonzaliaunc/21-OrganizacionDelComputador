/*
  Traducir el siguiente programa "C" a LEGv8.
  La asignacion de variables a registros X0=A, X1=s, X2=i, X3=j, X9=N
  Notar que en "C" los arreglos bidimensionales se representan en memoria usando un orden por filas
  es decir &A[i][j] = A + 8*(i*N+j)


  #define N (1<<10)
  long A[N][N], s, i, j;
  s=0;
  for (i=0; i<N; ++i)
    for (j=0; j<N; ++j)
      s += A[i][j];

  
  7.2) Se puede hacer lo mismo sin usar ninguna variable indice i, j

  
  nuevo codigo en C:  
  #define N (1<<10)
  long A[N][N], s, i, j;
  s=0;
  finalAddress = &A[0][0] + (N * N)
  for (i=0; i!=finalAddress; ++i)
    s += A[i];
*/


.data
  N: .dword 3 
  A: .dword 1,7,2,44,3,21,1,2,3
  // A = |1   7   2|
  //     |44  3  21|
  //     |1   2   3|

.text
  ldr X0, =A            // X3 <= &A[0][0]
  ldr X9, N             // x0 <= N1 (N1=3;)
  add X1, XZR, XZR	    // s = 0
  mul X9, X9, X9        // finalAddress = N*N
  lsl X9, X9, #3        // finalAddress = (N*N)*8
  add X9, X0, X9        // finalAddress = &A[0][0] + (N*N)+8
  loop:
    cmp X0, X9          // comparo i y finalAddress
    b.EQ end            // si i = finalAddress, finalizo la ejecucion
    ldur X11, [X0, #0]  // X11 = A[i]
    add X1, X1, X11     // s += A[i]
    add X0, X0, #8      // i++
    b loop              // salto incondicional a loop
  end:

infloop: B infloop
