let((cv)
  cv = dbOpenCellViewByType("lab11_adders" "xor2" "schematic" "" "r")
  printf("--- lab11_adders/xor2 Labels ---\n")
  foreach(s cv~>shapes
    when(s~>objType == "label"
      printf("Label: %s xy: %L\n" s~>theLabel s~>xy)
    )
  )
  printf("--- lab11_adders/xor2 Terminals ---\n")
  foreach(term cv~>terminals
    printf("Term: %s dir: %s pins: %L\n" term~>name term~>direction term~>pins~>fig~>xy)
  )
  dbClose(cv)
  exit()
)
