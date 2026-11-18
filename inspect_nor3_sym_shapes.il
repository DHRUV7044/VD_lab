let((cv)
  cv = dbOpenCellViewByType("standard_logic_components" "nor3" "symbol" "" "r")
  printf("--- NOR3 Symbol Shapes ---\n")
  foreach(s cv~>shapes
    printf("Shape: %s lpp: %L bBox: %L\n" s~>objType s~>lpp s~>bBox)
  )
  dbClose(cv)
  exit()
)
