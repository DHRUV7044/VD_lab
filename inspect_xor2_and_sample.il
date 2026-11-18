let((cvXor2 cvSample views)
  cvXor2 = dbOpenCellViewByType("standard_logic_components" "xor2" "schematic" "" "r")
  printf("--- standard_logic_components/xor2 Instances ---\n")
  foreach(i cvXor2~>instances
    printf("Inst %s master lib:%s cell:%s xy:%L w:%L\n" i~>name i~>libName i~>cellName i~>xy i~>w)
  )
  dbClose(cvXor2)

  views = ddGetObj("sample" "xor3")~>views~>name
  printf("--- sample/xor3 views: %L ---\n" views)
  if(member("schematic" views) then
    cvSample = dbOpenCellViewByType("sample" "xor3" "schematic" "" "r")
    printf("--- sample/xor3 Instances ---\n")
    foreach(i cvSample~>instances
      printf("Inst %s master lib:%s cell:%s xy:%L\n" i~>name i~>libName i~>cellName i~>xy)
    )
    dbClose(cvSample)
  )
  if(member("symbol" views) then
    let((symCv)
      symCv = dbOpenCellViewByType("sample" "xor3" "symbol" "" "r")
      printf("--- sample/xor3 Symbol Terms ---\n")
      foreach(term symCv~>terminals
        printf("Term %s pins %L\n" term~>name term~>pins~>fig~>bBox)
      )
      dbClose(symCv)
    )
  )
  exit()
)
