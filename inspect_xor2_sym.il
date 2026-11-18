let((cv)
  cv = dbOpenCellViewByType("standard_logic_components" "xor2" "symbol" "" "r")
  printf("--- XOR2 Symbol Shapes ---\n")
  foreach(s cv~>shapes
    printf("Shape: %s lpp: %L bBox: %L\n" s~>objType s~>lpp s~>bBox)
  )
  printf("--- XOR2 Symbol Terms ---\n")
  foreach(term cv~>terminals
    printf("Term: %s pins: %L\n" term~>name term~>pins~>fig~>bBox)
  )
  dbClose(cv)
  exit()
)
