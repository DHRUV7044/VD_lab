let((cv)
  cv = dbOpenCellViewByType("lab11_adders" "inv" "schematic" "" "r")
  printf("--- lab11_adders/inv Instances ---\n")
  foreach(i cv~>instances
    printf("Inst %s master: %s lib: %s xy: %L orient: %s w: %L\n"
      i~>name i~>cellName i~>libName i~>xy i~>orient i~>w)
  )
  printf("--- lab11_adders/inv Terminals ---\n")
  foreach(t cv~>terminals
    printf("Term %s dir: %s\n" t~>name t~>direction)
  )
  dbClose(cv)
  exit()
)
