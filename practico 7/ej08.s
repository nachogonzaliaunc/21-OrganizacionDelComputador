/* 
  Mostrar como se implementarian las siguienes pseudoinstrucciones con la minima
  cantidad de instrucciones LEGv8. 

  Nemónico |               Operación              | Semantica
  ---------------------------------------------------------------------
    cmp    |              comparación             | FLAGS = R[Rn]-R[Rm]
    cmpi   |  comparacion con operando inmediato  | FLAGS = R[Rn]-ALUImm
    mov    |   copia de valores entre registros   | R[Rd] = R[n]
    nop    | no-operacion, el skip de LEGv8
    not    | operador logicode negacion bit a bit | R[Rd] = ~R[rn]
*/


cmp a, b ≡ subs XZR, a, b

cmpi a, #n ≡ subis XZR, a, #n

mov a, b ≡ add a, XZR, b

nop ≡ mov XZR, XZR

not a ≡ sub a, XZR, a
        subi a, a, #1