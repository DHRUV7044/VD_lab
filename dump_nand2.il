let((cv symCv)
  cv = dbOpenCellViewByType("standard_logic_components" "nand2" "schematic" "" "r")
  when(cv
    printf("=== nand2 instances ===\n")
    foreach(inst cv~>instances
      printf("inst %s cell=%s xy=%L w=%L\n" inst~>name inst~>cellName inst~>xy inst~>w)
    )
    printf("=== nand2 pins ===\n")
    foreach(term cv~>terminals
      foreach(p term~>pins
        printf("term %s dir=%s figType=%s bBox=%L xy=%L\n" term~>name term~>direction p~>fig~>objType p~>fig~>bBox p~>fig~>xy)
      )
    )
    dbClose(cv)
  )
  symCv = dbOpenCellViewByType("standard_logic_components" "nand2" "symbol" "" "r")
  when(symCv
    printf("=== nand2 symbol shapes ===\n")
    foreach(s symCv~>shapes
      printf("shape type=%s lpp=%L points=%L bBox=%L\n" s~>objType s~>lpp s~>points s~>bBox)
    )
    foreach(term symCv~>terminals
      foreach(p term~>pins
        printf("sym term %s bBox=%L xy=%L\n" term~>name p~>fig~>bBox p~>fig~>xy)
      )
    )
    dbClose(symCv)
  )
  exit()
)
