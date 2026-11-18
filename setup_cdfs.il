let(()
  ;; 1. Function to apply CDF to a cell in standard_logic_components
  procedure(applyCellCdf(cellName isSymmetric termOrderList)
    let((cellId cdfId cdfFile)
      printf("Applying CDF directly to %s...\n" cellName)
      cellId = ddGetObj("standard_logic_components" cellName)
      when(cellId
        ;; Get or create base CDF
        cdfId = cdfGetBaseCellCDF(cellId)
        unless(cdfId
          cdfId = cdfCreateBaseCellCDF(cellId)
        )
        when(cdfId
          ;; Delete existing parameters if any
          foreach(param cdfId~>parameters
            cdfDeleteParam(param)
          )

          ;; Set parameters
          if(isSymmetric then
            cdfCreateParam(cdfId
              ?name "s"
              ?prompt "s"
              ?defValue "1"
              ?type "string"
              ?display "artParameterInToolDisplay('s)"
              ?parseAsCEL t
              ?parseAsNumber t
            )
            cdfId~>paramLabelSet = "s"
          else
            cdfCreateParam(cdfId
              ?name "wn"
              ?prompt "wn"
              ?defValue "400n"
              ?type "string"
              ?display "artParameterInToolDisplay('wn)"
              ?parseAsCEL t
              ?parseAsNumber t
            )
            cdfCreateParam(cdfId
              ?name "wp"
              ?prompt "wp"
              ?defValue "400n"
              ?type "string"
              ?display "artParameterInToolDisplay('wp)"
              ?parseAsCEL t
              ?parseAsNumber t
            )
            cdfId~>paramLabelSet = "wp wn"
          )

          ;; Save simulation & LVS views
          cdfSaveCDF(cdfId)
          printf("Direct CDF applied successfully to %s\n" cellName)
        )
      )
    )
  )

  ;; Apply to inverter, inverter_sym, nand, nand_sym
  applyCellCdf("inverter" nil list("vin" "vout" "vdd" "gnd"))
  applyCellCdf("inverter_sym" t list("vin" "vout" "vdd" "gnd"))
  applyCellCdf("nand" nil list("vin1" "vin2" "vout" "vdd" "gnd"))
  applyCellCdf("nand_sym" t list("vin1" "vin2" "vout" "vdd" "gnd"))

  exit()
)
