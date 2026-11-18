let((cv)
  cv = dbOpenCellViewByType("standard_logic_components" "xor2" "schematic" "" "r")
  printf("--- XOR2 Instances Details ---\n")
  foreach(inst cv~>instances
    printf("Inst %s master: %s lib: %s xy: %L orient: %s w: %L\n"
      inst~>name inst~>cellName inst~>libName inst~>xy inst~>orient inst~>w)
  )
  printf("--- XOR2 Wires Details ---\n")
  foreach(s cv~>shapes
    when(s~>objType == "line"
      printf("Wire: %L\n" s~>points)
    )
  )
  dbClose(cv)
  exit()
)
