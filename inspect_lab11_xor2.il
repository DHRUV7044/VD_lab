let((cv)
  cv = dbOpenCellViewByType("lab11_adders" "xor2" "schematic" "" "r")
  printf("--- lab11_adders/xor2 Pins ---\n")
  foreach(p cv~>pins
    printf("Pin: %s dir: %s xy: %L\n" p~>name p~>net~>name p~>fig~>xy)
  )
  foreach(i cv~>instances
    when(member(i~>cellName '("ipin" "opin"))
      printf("Pin inst: %s name: %s xy: %L\n" i~>cellName i~>name i~>xy)
    )
  )
  dbClose(cv)
  exit()
)
