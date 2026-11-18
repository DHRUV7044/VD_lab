cat << 'EOF' > generate_nand234.il
let((ipinMaster opinMaster libId)
  ipinMaster = dbOpenCellViewByType("basic" "ipin" "symbol" "" "r")
  opinMaster = dbOpenCellViewByType("basic" "opin" "symbol" "" "r")
  libId = "standard_logic_components"

  ;; ==============================================================
  ;; 1. BUILD nand2 & nand2_sym (vin1 on top, vin2 on bottom)
  ;; ==============================================================
  printf("\n=== BUILDING nand2 & nand2_sym ===\n")

  foreach(isSym list(nil t)
    let((cellName srcCv dstCv)
      cellName = if(isSym "nand2_sym" "nand2")
      printf("Building %s...\n" cellName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )

      srcCv = dbOpenCellViewByType("lab8_logical_effort" "symmetric_nand2" "schematic" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(inst srcCv~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          newInst = dbCopyFig(inst dstCv)
          if(isSym then
            when(newInst~>cellName == "nmos" dbCreateProp(newInst "w" "string" "pPar(\"s\")*800n"))
            when(newInst~>cellName == "pmos" dbCreateProp(newInst "w" "string" "pPar(\"s\")*800n"))
          else
            when(newInst~>cellName == "nmos" dbCreateProp(newInst "w" "string" "pPar(\"wn\")"))
            when(newInst~>cellName == "pmos" dbCreateProp(newInst "w" "string" "pPar(\"wp\")"))
          )
        )
      )

      ;; Connect wires properly to top/bottom pins
      ;; in2 was at (-0.75 0.0) -> now TOP input = vin1
      schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.75 0.0) "R0")
      ;; in1 was at (-0.75 -0.625) -> now BOTTOM input = vin2
      schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.75 -0.625) "R0")
      ;; VDD & GND
      schCreatePin(dstCv ipinMaster "vdd" "input" nil list(-0.375 1.0) "R0")
      schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.375 -0.9375) "R0")
      ;; VOUT
      schCreatePin(dstCv opinMaster "vout" "output" nil list(1.0625 0.375) "R0")

      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      ;; Symbol: Copy from reference, update labels & terminals
      srcCv = dbOpenCellViewByType("lab8_logical_effort" "symmetric_nand2" "symbol" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(term dstCv~>terminals dbDeleteObject(term))

      ;; In reference symbol: pin at (0.6 0.0375) is TOP -> vin1, pin at (0.6 -0.2125) is BOTTOM -> vin2
      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing")
          let((pinName dir net term)
            cond(
              (xCoord(car(s~>bBox)) < 0.8 && yCoord(car(s~>bBox)) > 0.0
                pinName = "vin1" dir = "input")
              (xCoord(car(s~>bBox)) < 0.8 && yCoord(car(s~>bBox)) < 0.0
                pinName = "vin2" dir = "input")
              (xCoord(car(s~>bBox)) > 1.2
                pinName = "vout" dir = "output")
              (yCoord(car(s~>bBox)) > 0.0
                pinName = "vdd" dir = "input")
              (t
                pinName = "gnd" dir = "input")
            )
            net = dbMakeNet(dstCv pinName)
            term = dbCreateTerm(net pinName dir)
            dbCreatePin(net s pinName)
          )
        )
      )
      foreach(s dstCv~>shapes
        when(s~>objType == "label"
          cond(
            (s~>theLabel == "in1" s~>theLabel = "vin1")
            (s~>theLabel == "in2" s~>theLabel = "vin2")
            (s~>theLabel == "out" s~>theLabel = "vout")
            (s~>theLabel == "nand2" s~>theLabel = cellName)
            (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
          )
        )
      )
      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      ;; Apply Base CDF
      let((cObj cdfId)
        cObj = ddGetObj(libId cellName)
        when(cObj
          when(cdfId = cdfGetBaseCellCDF(cObj) cdfDeleteCDF(cdfId))
          cdfId = cdfCreateBaseCellCDF(cObj)
          if(isSym then
            cdfCreateParam(cdfId ?name "s" ?prompt "s" ?defValue "1" ?type "string" ?storeDefault "yes" ?parseAsNumber "yes" ?parseAsCEL "yes")
            cdfId->paramLabelSet = "s"
          else
            cdfCreateParam(cdfId ?name "wp" ?prompt "wp" ?defValue "400n" ?type "string" ?storeDefault "yes" ?parseAsNumber "yes" ?parseAsCEL "yes")
            cdfCreateParam(cdfId ?name "wn" ?prompt "wn" ?defValue "400n" ?type "string" ?storeDefault "yes" ?parseAsNumber "yes" ?parseAsCEL "yes")
            cdfId->paramLabelSet = "wp wn"
          )
          cdfId->simInfo = list(nil)
          cdfId->simInfo->spectre = list(nil 'termOrder '("vin1" "vin2" "vout" "vdd" "gnd") 'componentName "subcircuit")
          cdfId->simInfo->auLvs = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder '("vin1" "vin2" "vout" "vdd" "gnd") 'netlistProcedure "ansLvsCompPrim")
          cdfId->simInfo->auCdl = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder '("vin1" "vin2" "vout" "vdd" "gnd") 'netlistProcedure "ansCdlSubcktCall")
          cdfId->simInfo->hspiceD = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder '("vin1" "vin2" "vout" "vdd" "gnd"))
          cdfSaveCDF(cdfId)
        )
      )
      printf("Cell %s complete.\n" cellName)
    )
  )

  ;; ==============================================================
  ;; 2. BUILD nand3 & nand3_sym (vin1 top, vin2 mid, vin3 bottom)
  ;; ==============================================================
  printf("\n=== BUILDING nand3 & nand3_sym ===\n")

  foreach(isSym list(nil t)
    let((cellName srcCv dstCv)
      cellName = if(isSym "nand3_sym" "nand3")
      printf("Building %s...\n" cellName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )

      srcCv = dbOpenCellViewByType("lab8_logical_effort" "symmetric_nand3" "schematic" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(inst srcCv~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          newInst = dbCopyFig(inst dstCv)
          if(isSym then
            ;; 3 series NMOS: Wn = 3 * 400n * s = 1.2u * s. PMOS in parallel: Wp = 800n * s
            when(newInst~>cellName == "nmos" dbCreateProp(newInst "w" "string" "pPar(\"s\")*1.2u"))
            when(newInst~>cellName == "pmos" dbCreateProp(newInst "w" "string" "pPar(\"s\")*800n"))
          else
            when(newInst~>cellName == "nmos" dbCreateProp(newInst "w" "string" "pPar(\"wn\")"))
            when(newInst~>cellName == "pmos" dbCreateProp(newInst "w" "string" "pPar(\"wp\")"))
          )
        )
      )

      ;; Input pin placement in lab8 symmetric_nand3:
      ;; Top input: (-0.75 0.0) -> vin1
      schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.75 0.0) "R0")
      ;; Middle input: (-0.75 -0.5625) -> vin2
      schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.75 -0.5625) "R0")
      ;; Bottom input: (-0.75 -1.125) -> vin3
      schCreatePin(dstCv ipinMaster "vin3" "input" nil list(-0.75 -1.125) "R0")
      ;; VDD & GND
      schCreatePin(dstCv ipinMaster "vdd" "input" nil list(-0.375 1.0) "R0")
      schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.375 -1.4375) "R0")
      ;; VOUT
      schCreatePin(dstCv opinMaster "vout" "output" nil list(2.6875 0.375) "R0")

      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      ;; Symbol
      srcCv = dbOpenCellViewByType("lab8_logical_effort" "symmetric_nand3" "symbol" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(term dstCv~>terminals dbDeleteObject(term))

      ;; Assign symbol terminals by Y coordinate: top->vin1, mid->vin2, bot->vin3
      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing")
          let((pinName dir net term yVal)
            yVal = yCoord(car(s~>bBox))
            cond(
              (xCoord(car(s~>bBox)) > 1.2
                pinName = "vout" dir = "output")
              (yVal > 0.15
                pinName = "vdd" dir = "input")
              (yVal < -0.3
                pinName = "gnd" dir = "input")
              (yVal > 0.0
                pinName = "vin1" dir = "input")
              (yVal > -0.15
                pinName = "vin2" dir = "input")
              (t
                pinName = "vin3" dir = "input")
            )
            net = dbMakeNet(dstCv pinName)
            term = dbCreateTerm(net pinName dir)
            dbCreatePin(net s pinName)
          )
        )
      )
      foreach(s dstCv~>shapes
        when(s~>objType == "label"
          cond(
            (s~>theLabel == "in1" s~>theLabel = "vin1")
            (s~>theLabel == "in2" s~>theLabel = "vin2")
            (s~>theLabel == "in3" s~>theLabel = "vin3")
            (s~>theLabel == "out" s~>theLabel = "vout")
            (s~>theLabel == "nand3" s~>theLabel = cellName)
            (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
          )
        )
      )
      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      ;; CDF
      let((cObj cdfId)
        cObj = ddGetObj(libId cellName)
        when(cObj
          when(cdfId = cdfGetBaseCellCDF(cObj) cdfDeleteCDF(cdfId))
          cdfId = cdfCreateBaseCellCDF(cObj)
          if(isSym then
            cdfCreateParam(cdfId ?name "s" ?prompt "s" ?defValue "1" ?type "string" ?storeDefault "yes" ?parseAsNumber "yes" ?parseAsCEL "yes")
            cdfId->paramLabelSet = "s"
          else
            cdfCreateParam(cdfId ?name "wp" ?prompt "wp" ?defValue "400n" ?type "string" ?storeDefault "yes" ?parseAsNumber "yes" ?parseAsCEL "yes")
            cdfCreateParam(cdfId ?name "wn" ?prompt "wn" ?defValue "400n" ?type "string" ?storeDefault "yes" ?parseAsNumber "yes" ?parseAsCEL "yes")
            cdfId->paramLabelSet = "wp wn"
          )
          cdfId->simInfo = list(nil)
          cdfId->simInfo->spectre = list(nil 'termOrder '("vin1" "vin2" "vin3" "vout" "vdd" "gnd") 'componentName "subcircuit")
          cdfId->simInfo->auLvs = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder '("vin1" "vin2" "vin3" "vout" "vdd" "gnd") 'netlistProcedure "ansLvsCompPrim")
          cdfId->simInfo->auCdl = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder '("vin1" "vin2" "vin3" "vout" "vdd" "gnd") 'netlistProcedure "ansCdlSubcktCall")
          cdfId->simInfo->hspiceD = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder '("vin1" "vin2" "vin3" "vout" "vdd" "gnd"))
          cdfSaveCDF(cdfId)
        )
      )
      printf("Cell %s complete.\n" cellName)
    )
  )

  ;; ==============================================================
  ;; 3. BUILD nand4 & nand4_sym (4 inputs: vin1, vin2, vin3, vin4)
  ;; ==============================================================
  printf("\n=== BUILDING nand4 & nand4_sym ===\n")

  foreach(isSym list(nil t)
    let((cellName srcCv dstCv)
      cellName = if(isSym "nand4_sym" "nand4")
      printf("Building %s...\n" cellName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )

      srcCv = dbOpenCellViewByType("lab6_same_size_nand" "nand4" "schematic" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(inst srcCv~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          newInst = dbCopyFig(inst dstCv)
          if(isSym then
            ;; 4 series NMOS: Wn = 4 * 400n * s = 1.6u * s. PMOS in parallel: Wp = 800n * s
            when(newInst~>cellName == "nmos" dbCreateProp(newInst "w" "string" "pPar(\"s\")*1.6u"))
            when(newInst~>cellName == "pmos" dbCreateProp(newInst "w" "string" "pPar(\"s\")*800n"))
          else
            when(newInst~>cellName == "nmos" dbCreateProp(newInst "w" "string" "pPar(\"wn\")"))
            when(newInst~>cellName == "pmos" dbCreateProp(newInst "w" "string" "pPar(\"wp\")"))
          )
        )
      )

      ;; Find and copy pin positions from lab6 nand4 with vin1..vin4 top to bottom
      let((inPins)
        inPins = nil
        foreach(inst srcCv~>instances
          when(inst~>cellName == "ipin" && !member(inst~>name '("PIN_VDD" "PIN_GND" "PIN_vdd" "PIN_gnd"))
            inPins = cons(inst inPins)
          )
        )
        ;; Sort input pins descending by Y coordinate (highest Y = top = vin1)
        inPins = sort(inPins (lambda (a b) yCoord(a~>xy) > yCoord(b~>xy)))
        schCreatePin(dstCv ipinMaster "vin1" "input" nil car(inPins)~>xy "R0")
        schCreatePin(dstCv ipinMaster "vin2" "input" nil cadr(inPins)~>xy "R0")
        schCreatePin(dstCv ipinMaster "vin3" "input" nil caddr(inPins)~>xy "R0")
        schCreatePin(dstCv ipinMaster "vin4" "input" nil cadddr(inPins)~>xy "R0")

        ;; Find VDD, GND, VOUT
        foreach(inst srcCv~>instances
          when(inst~>cellName == "opin"
            schCreatePin(dstCv opinMaster "vout" "output" nil inst~>xy "R0")
          )
          when(inst~>cellName == "ipin"
            when(rexMatchp("vdd" inst~>name) || rexMatchp("VDD" inst~>name) || yCoord(inst~>xy) > 1.2
              schCreatePin(dstCv ipinMaster "vdd" "input" nil inst~>xy "R0")
            )
            when(rexMatchp("gnd" inst~>name) || rexMatchp("GND" inst~>name) || yCoord(inst~>xy) < -1.8
              schCreatePin(dstCv ipinMaster "gnd" "input" nil inst~>xy "R0")
            )
          )
        )
      )

      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      ;; Symbol for nand4: Expand nand3 symbol body to 4 inputs
      srcCv = dbOpenCellViewByType("lab8_logical_effort" "symmetric_nand3" "symbol" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(term dstCv~>terminals dbDeleteObject(term))

      ;; Re-create 4 input pins spaced from Y=0.15 down to Y=-0.30
      let((net term rect pin)
        ;; Delete old input pin rects
        foreach(s dstCv~>shapes
          when(s~>lpp == list("pin" "drawing") && xCoord(car(s~>bBox)) < 0.8
            dbDeleteObject(s)
          )
        )
        ;; vin1 at (0.6 0.15)
        rect = dbCreateRect(dstCv list("pin" "drawing") list(list(0.6 0.125) list(0.65 0.175)))
        net = dbMakeNet(dstCv "vin1") term = dbCreateTerm(net "vin1" "input") dbCreatePin(net rect "vin1")
        ;; vin2 at (0.6 0.0)
        rect = dbCreateRect(dstCv list("pin" "drawing") list(list(0.6 -0.025) list(0.65 0.025)))
        net = dbMakeNet(dstCv "vin2") term = dbCreateTerm(net "vin2" "input") dbCreatePin(net rect "vin2")
        ;; vin3 at (0.6 -0.15)
        rect = dbCreateRect(dstCv list("pin" "drawing") list(list(0.6 -0.175) list(0.65 -0.125)))
        net = dbMakeNet(dstCv "vin3") term = dbCreateTerm(net "vin3" "input") dbCreatePin(net rect "vin3")
        ;; vin4 at (0.6 -0.30)
        rect = dbCreateRect(dstCv list("pin" "drawing") list(list(0.6 -0.325) list(0.65 -0.275)))
        net = dbMakeNet(dstCv "vin4") term = dbCreateTerm(net "vin4" "input") dbCreatePin(net rect "vin4")

        ;; Existing VOUT, VDD, GND pins
        foreach(s dstCv~>shapes
          when(s~>lpp == list("pin" "drawing")
            cond(
              (xCoord(car(s~>bBox)) > 1.2
                net = dbMakeNet(dstCv "vout") term = dbCreateTerm(net "vout" "output") dbCreatePin(net s "vout"))
              (yCoord(car(s~>bBox)) > 0.15
                net = dbMakeNet(dstCv "vdd") term = dbCreateTerm(net "vdd" "input") dbCreatePin(net s "vdd"))
              (yCoord(car(s~>bBox)) < -0.35
                net = dbMakeNet(dstCv "gnd") term = dbCreateTerm(net "gnd" "input") dbCreatePin(net s "gnd"))
            )
          )
        )
      )

      foreach(s dstCv~>shapes
        when(s~>objType == "label"
          cond(
            (s~>theLabel == "in1" s~>theLabel = "vin1")
            (s~>theLabel == "in2" s~>theLabel = "vin2")
            (s~>theLabel == "in3" s~>theLabel = "vin3")
            (s~>theLabel == "out" s~>theLabel = "vout")
            (s~>theLabel == "nand3" s~>theLabel = cellName)
            (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
          )
        )
      )
      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      ;; CDF
      let((cObj cdfId)
        cObj = ddGetObj(libId cellName)
        when(cObj
          when(cdfId = cdfGetBaseCellCDF(cObj) cdfDeleteCDF(cdfId))
          cdfId = cdfCreateBaseCellCDF(cObj)
          if(isSym then
            cdfCreateParam(cdfId ?name "s" ?prompt "s" ?defValue "1" ?type "string" ?storeDefault "yes" ?parseAsNumber "yes" ?parseAsCEL "yes")
            cdfId->paramLabelSet = "s"
          else
            cdfCreateParam(cdfId ?name "wp" ?prompt "wp" ?defValue "400n" ?type "string" ?storeDefault "yes" ?parseAsNumber "yes" ?parseAsCEL "yes")
            cdfCreateParam(cdfId ?name "wn" ?prompt "wn" ?defValue "400n" ?type "string" ?storeDefault "yes" ?parseAsNumber "yes" ?parseAsCEL "yes")
            cdfId->paramLabelSet = "wp wn"
          )
          cdfId->simInfo = list(nil)
          cdfId->simInfo->spectre = list(nil 'termOrder '("vin1" "vin2" "vin3" "vin4" "vout" "vdd" "gnd") 'componentName "subcircuit")
          cdfId->simInfo->auLvs = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder '("vin1" "vin2" "vin3" "vin4" "vout" "vdd" "gnd") 'netlistProcedure "ansLvsCompPrim")
          cdfId->simInfo->auCdl = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder '("vin1" "vin2" "vin3" "vin4" "vout" "vdd" "gnd") 'netlistProcedure "ansCdlSubcktCall")
          cdfId->simInfo->hspiceD = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder '("vin1" "vin2" "vin3" "vin4" "vout" "vdd" "gnd"))
          cdfSaveCDF(cdfId)
        )
      )
      printf("Cell %s complete.\n" cellName)
    )
  )

  ;; Delete old unversioned nand and nand_sym cells
  when(ddGetObj(libId "nand") ddDeleteObj(ddGetObj(libId "nand")))
  when(ddGetObj(libId "nand_sym") ddDeleteObj(ddGetObj(libId "nand_sym")))

  ;; Run schCheck verification
  foreach(c '("nand2" "nand2_sym" "nand3" "nand3_sym" "nand4" "nand4_sym")
    let((cv)
      cv = dbOpenCellViewByType(libId c "schematic" "schematic" "a")
      when(cv
        printf("Running schCheck on %s...\n" c)
        schCheck(cv)
        dbSave(cv)
        dbClose(cv)
      )
    )
  )

  printf("\n=== BATCH 1 (NAND 2, 3, 4) FINISHED SUCCESSFULLY ===\n")
  exit()
)
EOF

virtuoso -nograph -restore generate_nand234.il </dev/null
rm -f generate_nand234.il

