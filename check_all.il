let((cells cv errList)
  cells = list("inverter" "inverter_sym" "nand2" "nand2_sym" "nand3" "nand3_sym" "nand4" "nand4_sym")
  foreach(cellName cells
    printf("\n>>> Checking %s schematic <<<\n", cellName)
    cv = dbOpenCellViewByType("standard_logic_components" cellName "schematic" "" "r")
    if(cv then
      errList = schCheck(cv)
      printf("schCheck %s: %L\n", cellName, errList)
      printf("Terminals: ")
      foreach(term cv~>terminals
        printf("%s(%s) ", term~>name, term~>direction)
      )
      printf("\n")
      dbClose(cv)
    else
      printf("Could not open %s schematic\n", cellName)
    )
  )
  exit()
)
