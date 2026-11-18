let((cv)
  cv = dbOpenCellViewByType("standard_logic_components" "xor2" "schematic" "" "r")
  printf("--- XOR2 Nets ---\n")
  foreach(net cv~>nets
    printf("Net %s terms: %L instTerms: %L\n"
      net~>name net~>terms~>name
      mapcar(lambda((it) sprintf(nil "%s.%s" it~>inst~>name it~>name)) net~>instTerms)
    )
  )
  dbClose(cv)
  exit()
)
