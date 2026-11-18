let((cv)
  cv = dbOpenCellViewByType("lab8_logical_effort" "symmetric_nor2" "schematic" "" "r")
  when(cv
    printf("=== lab8 symmetric_nor2 instances ===\n")
    foreach(inst cv~>instances
      printf("inst %s cell=%s xy=%L w=%L\n" inst~>name inst~>cellName inst~>xy inst~>w)
    )
    printf("=== lab8 symmetric_nor2 terms ===\n")
    foreach(term cv~>terminals
      printf("term %s dir=%s\n" term~>name term~>direction)
    )
    dbClose(cv)
  )
  cv = dbOpenCellViewByType("lab8_logical_effort" "symmetric_nor2" "symbol" "" "r")
  when(cv
    printf("=== lab8 symmetric_nor2 symbol shapes ===\n")
    foreach(s cv~>shapes
      printf("shape type=%s lpp=%L points=%L bBox=%L\n" s~>objType s~>lpp s~>points s~>bBox)
    )
    dbClose(cv)
  )
  exit()
)
