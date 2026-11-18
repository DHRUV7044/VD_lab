let((cv)
  cv = dbOpenCellViewByType("lab11_adders" "and2" "schematic" "" "r")
  when(cv
    printf("=== lab11 and2 instances ===\n")
    foreach(inst cv~>instances
      printf("inst %s cell=%s xy=%L\n" inst~>name inst~>cellName inst~>xy)
    )
    printf("=== lab11 and2 terms ===\n")
    foreach(term cv~>terminals
      printf("term %s dir=%s\n" term~>name term~>direction)
    )
    dbClose(cv)
  )
  cv = dbOpenCellViewByType("lab11_adders" "and2" "symbol" "" "r")
  when(cv
    printf("=== lab11 and2 symbol shapes ===\n")
    foreach(s cv~>shapes
      printf("shape type=%s lpp=%L points=%L bBox=%L\n" s~>objType s~>lpp s~>points s~>bBox)
    )
    dbClose(cv)
  )
  cv = dbOpenCellViewByType("lab11_adders" "xor2" "schematic" "" "r")
  when(cv
    printf("=== lab11 xor2 instances ===\n")
    foreach(inst cv~>instances
      printf("inst %s cell=%s xy=%L\n" inst~>name inst~>cellName inst~>xy)
    )
    printf("=== lab11 xor2 terms ===\n")
    foreach(term cv~>terminals
      printf("term %s dir=%s\n" term~>name term~>direction)
    )
    dbClose(cv)
  )
  cv = dbOpenCellViewByType("lab11_adders" "xor2" "symbol" "" "r")
  when(cv
    printf("=== lab11 xor2 symbol shapes ===\n")
    foreach(s cv~>shapes
      printf("shape type=%s lpp=%L points=%L bBox=%L\n" s~>objType s~>lpp s~>points s~>bBox)
    )
    dbClose(cv)
  )
  exit()
)
