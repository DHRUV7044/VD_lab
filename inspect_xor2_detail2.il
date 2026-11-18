let((cv)
  cv = dbOpenCellViewByType("standard_logic_components" "xor2" "schematic" "" "r")
  printf("--- XOR2 InstTerms ---\n")
  foreach(inst cv~>instances
    printf("Inst: %s (%s)\n" inst~>name inst~>cellName)
    foreach(it inst~>instTerms
      printf("  %s -> net: %L\n" it~>name (if it~>net it~>net~>name "nil"))
    )
  )
  printf("--- XOR2 Wires ---\n")
  foreach(s cv~>shapes
    when(s~>objType == "line"
      printf("Wire: %L net: %L\n" s~>points (if s~>net s~>net~>name "nil"))
    )
  )
  dbClose(cv)
  exit()
)
