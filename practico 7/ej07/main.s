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
*/


.data
  N: .dword 3 
  A: .dword 1,7,2,44,3,21,1,2,3
  /* A = |1   7   2|
         |44  3  21|
         |1   2   3|
  */

.text
  ldr X0, =A            // X3 <= &A[0][0]
  ldr X9, N             // x0 <= N1 (N1=3;)
  add X1, XZR, XZR	    // s = 0
  add X2, XZR, XZR      // i = 0
  fstLoop:
    cmp X2, X9          // comparo N e i
    b.GE end            // si N <= i, termino con la ejecucion
    add X3, XZR, XZR    // j = 0
  sndLoop:
    cmp X3, X9          // comparo N i j
    b.GE nextRow        // si N <= j, salto a la proxima fila
    mul X12, X2, X9     // X12 = i * N
    add X12, X12, X3    // X12 = (i*N) + j
    lsl X12, X12, #3    // X12 = ((i*N) + j) * 8
    add X12, X0, X12    // X12 = &A[0][0] + ((i*N) + j) * 8 = A[i][j]
    ldur X11, [X12, #0] // X11 = A[i][j]
    add X1, X1, X11     // s += A[i][j]
    add X3, X3, #1      // j++
    b sndLoop           // salto incondicional a sndLoop
  nextRow:
    add X2, X2, #1      // i++ (siguiente fila)
    b fstLoop           // salto incondicional a fstLoop
  end:

infloop: B infloop
