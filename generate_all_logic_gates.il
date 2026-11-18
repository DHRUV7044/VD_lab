;; ==============================================================================
;; CADENCE VIRTUOSO SCRIPT: GENERATE ALL STANDARD LOGIC GATES
;; Library: standard_logic_components
;; Gates: nand2, nand3, nand4, and2, and3, and4,
;;        nor2, nor3, nor4, or2, or3, or4, xor2
;; Each with two versions:
;;   1. normal (<name>): wn="400n", wp="400n"
;;   2. symmetric (<name>_sym): logical effort scaled with s="1"
;; Pin ordering: vin1 (top) down to vinN, vout, vdd, gnd
;; Direct base cell CDF registered into data.dm
;; ==============================================================================

let((libId ipinMaster opinMaster nmosMaster pmosMaster invMaster)
  libId = "standard_logic_components"
  ipinMaster = dbOpenCellViewByType("basic" "ipin" "symbol" "" "r")
  opinMaster = dbOpenCellViewByType("basic" "opin" "symbol" "" "r")
  nmosMaster = dbOpenCellViewByType("gpdk180" "nmos" "symbol" "" "r")
  pmosMaster = dbOpenCellViewByType("gpdk180" "pmos" "symbol" "" "r")

  ;; -------------------------------------------------------------
  ;; HELPER: Setup CDF for any cell
  ;; -------------------------------------------------------------
  procedure(setupCDF(cellName isSym termList)
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
        cdfId->simInfo->spectre = list(nil 'termOrder termList 'componentName "subcircuit")
        cdfId->simInfo->auLvs = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder termList 'netlistProcedure "ansLvsCompPrim")
        cdfId->simInfo->auCdl = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder termList 'netlistProcedure "ansCdlSubcktCall")
        cdfId->simInfo->hspiceD = list(nil 'namePrefix "X" 'componentName "subcircuit" 'termOrder termList)
        cdfSaveCDF(cdfId)
        printf("CDF registered for %s\n" cellName)
      )
    )
  )

  ;; ==============================================================
  ;; PART 1: NAND4 & NAND4_SYM
  ;; ==============================================================
  printf("\n==================== BUILDING NAND4 ====================\n")
  foreach(isSym list(nil t)
    let((cellName srcCv dstCv pm nm errList)
      cellName = if(isSym "nand4_sym" "nand4")
      printf("Building %s...\n" cellName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )

      srcCv = dbOpenCellViewByType("lab8_logical_effort" "symmetric_nand3" "schematic" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")

      ;; Copy all shapes from nand3 except GND line at Y=-1.4375 and VOUT line
      foreach(s srcCv~>shapes
        if(s~>objType == "line" then
          let((isGnd isOut)
            isGnd = (member(list(0.4375 -1.4375) s~>points) || member(list(-0.4375 -1.4375) s~>points))
            isOut = member(list(2.6875 0.375) s~>points)
            unless(isGnd || isOut
              dbCopyFig(s dstCv)
            )
          )
        else
          dbCopyFig(s dstCv)
        )
      )

      ;; Copy existing transistors with sizing
      foreach(inst srcCv~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          let((newInst wVal)
            newInst = dbCopyFig(inst dstCv)
            if(isSym then
              wVal = if(newInst~>cellName == "nmos" "pPar(\"s\")*1.6u" "pPar(\"s\")*800n")
            else
              wVal = if(newInst~>cellName == "nmos" "pPar(\"wn\")" "pPar(\"wp\")")
            )
            dbSetq(newInst wVal w)
          )
        )
      )

      ;; Add PM3 at (2.25 0.6875)
      let((pm3 nm3)
        pm3 = dbCreateInst(dstCv pmosMaster "PM3" list(2.25 0.6875) "R0")
        dbSetq(pm3 if(isSym "pPar(\"s\")*800n" "pPar(\"wp\")") w)

        ;; Add NM3 at (0.1875 -1.6875)
        nm3 = dbCreateInst(dstCv nmosMaster "NM3" list(0.1875 -1.6875) "R0")
        dbSetq(nm3 if(isSym "pPar(\"s\")*1.6u" "pPar(\"wn\")") w)

        ;; VDD rail extend to PM3:
        dbCreateLine(dstCv list("wire" "drawing") list(list(1.6875 1.0) list(2.5 1.0)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(2.5 1.0) list(2.5 0.875)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(2.5 0.875) list(2.875 0.875)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(2.875 0.6875) list(2.875 0.875)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(2.5 0.6875) list(2.875 0.6875)))

        ;; VOUT rail: connect (1.6875 0.375) to PM3 D (2.5 0.5) and to opin at (3.5 0.375)
        dbCreateLine(dstCv list("wire" "drawing") list(list(1.6875 0.375) list(2.5 0.375)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(2.5 0.375) list(2.5 0.5)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(2.5 0.375) list(3.5 0.375)))

        ;; NM0 S (0.4375 -1.3125) to NM3 D (0.4375 -1.5)
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.4375 -1.3125) list(0.4375 -1.5)))

        ;; NM3 S (0.4375 -1.875) and B (0.75 -1.6875) to GND at Y=-2.0
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.4375 -1.875) list(0.4375 -2.0)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.4375 -2.0) list(0.75 -2.0)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.75 -2.0) list(0.75 -1.6875)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.75 -1.125) list(0.75 -2.0)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(-0.4375 -2.0) list(0.4375 -2.0)))

        ;; Gate connections for vin1..vin4:
        ;; in lab8 nand3:
        ;; Top gate line (Y=0.0): connects PM2 Gate (1.4375 0.6875) and NM2 Gate (0.1875 0.0) -> vin1
        ;; Mid gate line (Y=-0.5625): connects PM1 Gate (0.625 0.6875) and NM1 Gate (0.1875 -0.5625) -> vin2
        ;; Bot gate line (Y=-1.125): connects PM0 Gate (-0.3125 0.6875) and NM0 Gate (0.1875 -1.125) -> vin3
        ;; Now vin4: connects PM3 Gate (2.25 0.6875) and NM3 Gate (0.1875 -1.6875)
        dbCreateLine(dstCv list("wire" "drawing") list(list(-0.75 -1.6875) list(0.1875 -1.6875)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(-0.5 -1.6875) list(-0.5 -1.875)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(-0.5 -1.875) list(-0.625 -1.875)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(-0.625 -1.875) list(-0.625 -2.125)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(-0.625 -2.125) list(2.1875 -2.125)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(2.1875 -2.125) list(2.1875 0.6875)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(2.1875 0.6875) list(2.25 0.6875)))

        ;; Pins: vin1 on top down to vin4 on bottom
        schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.75 0.0) "R0")
        schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.75 -0.5625) "R0")
        schCreatePin(dstCv ipinMaster "vin3" "input" nil list(-0.75 -1.125) "R0")
        schCreatePin(dstCv ipinMaster "vin4" "input" nil list(-0.75 -1.6875) "R0")

        schCreatePin(dstCv ipinMaster "vdd" "input" nil list(-0.375 1.0) "R0")
        schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.375 -2.0) "R0")
        schCreatePin(dstCv opinMaster "vout" "output" nil list(3.5 0.375) "R0")

        dbSave(dstCv)
        errList = schCheck(dstCv)
        printf("schCheck %s: %L\n" cellName errList)
        dbClose(dstCv)
        dbClose(srcCv)
      )

      ;; Symbol for nand4: expand nand3 symbol to 4 inputs
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )
      srcCv = dbOpenCellViewByType("lab8_logical_effort" "symmetric_nand3" "symbol" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(term dstCv~>terminals dbDeleteObject(term))

      ;; Delete old input pin rects and labels
      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing") && xCoord(car(s~>bBox)) < 0.8
          dbDeleteObject(s)
        )
        when(s~>objType == "label" && member(s~>theLabel '("in1" "in2" "in3" "vin1" "vin2" "vin3"))
          dbDeleteObject(s)
        )
      )

      ;; Re-create 4 input pins nicely spaced from top to bottom
      let((pinCoords)
        pinCoords = list(
          list("vin1" 0.0875)
          list("vin2" -0.0125)
          list("vin3" -0.1125)
          list("vin4" -0.2125)
        )
        foreach(entry pinCoords
          let((pName yP rect net term lbl)
            pName = car(entry)
            yP = cadr(entry)
            rect = dbCreateRect(dstCv list("pin" "drawing") list(list(0.6 yP-0.025) list(0.65 yP+0.025)))
            net = dbMakeNet(dstCv pName)
            term = dbCreateTerm(net pName "input")
            dbCreatePin(net rect pName)
            lbl = dbCreateLabel(dstCv list("pin" "label") list(0.6625 yP-0.0125) pName "lowerLeft" "R0" "roman" 0.05)
          )
        )
      )

      ;; Re-create VOUT, VDD, GND pins on symbol
      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing")
          cond(
            (xCoord(car(s~>bBox)) > 1.2
              let((net term)
                net = dbMakeNet(dstCv "vout") term = dbCreateTerm(net "vout" "output") dbCreatePin(net s "vout")
              ))
            (yCoord(car(s~>bBox)) > 0.05
              let((net term)
                net = dbMakeNet(dstCv "vdd") term = dbCreateTerm(net "vdd" "input") dbCreatePin(net s "vdd")
              ))
            (yCoord(car(s~>bBox)) < -0.25
              let((net term)
                net = dbMakeNet(dstCv "gnd") term = dbCreateTerm(net "gnd" "input") dbCreatePin(net s "gnd")
              ))
          )
        )
      )

      ;; Update symbol labels
      foreach(s dstCv~>shapes
        when(s~>objType == "label"
          cond(
            (s~>theLabel == "out" s~>theLabel = "vout")
            (s~>theLabel == "nand3" s~>theLabel = cellName)
            (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
          )
        )
      )

      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      ;; Setup CDF
      setupCDF(cellName isSym '("vin1" "vin2" "vin3" "vin4" "vout" "vdd" "gnd"))
    )
  )

  ;; ==============================================================
  ;; PART 2: AND GATES (and2, and3, and4)
  ;; ==============================================================
  printf("\n==================== BUILDING AND GATES ====================\n")

  ;; AND2 & AND2_SYM are already built and verified! We'll just ensure CDF is clean.
  foreach(isSym list(nil t)
    setupCDF(if(isSym "and2_sym" "and2") isSym '("vin1" "vin2" "vout" "vdd" "gnd"))
  )

  ;; AND3 & AND3_SYM (transistor level: nand3 + inverter)
  foreach(isSym list(nil t)
    let((cellName srcNand srcInv dstCv dx dy errList)
      cellName = if(isSym "and3_sym" "and3")
      printf("Building %s...\n" cellName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )

      dx = 3.6875
      dy = -1.125

      srcNand = dbOpenCellViewByType(libId if(isSym "nand3_sym" "nand3") "schematic" "" "r")
      srcInv  = dbOpenCellViewByType(libId if(isSym "inverter_sym" "inverter") "schematic" "" "r")
      dstCv   = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")

      foreach(s srcNand~>shapes dbCopyFig(s dstCv))
      foreach(inst srcNand~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          dbCopyFig(inst dstCv)
        )
      )

      foreach(s srcInv~>shapes
        if(s~>objType == "line" then
          let((p1 p2 isLead)
            p1 = car(s~>points)
            p2 = cadr(s~>points)
            isLead = (p1 == list(-1.0 2.125) || p1 == list(-1.0625 0.875) || p1 == list(-1.0625 1.5) || p2 == list(1.0625 1.5))
            unless(isLead
              dbCreateLine(dstCv s~>lpp list(
                list(car(p1)+dx cadr(p1)+dy)
                list(car(p2)+dx cadr(p2)+dy)
              ))
            )
          )
        )
      )

      foreach(inst srcInv~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          let((newInst newXy wVal)
            newXy = list(car(inst~>xy)+dx cadr(inst~>xy)+dy)
            newInst = dbCreateInst(dstCv inst~>master sprintf(nil "INV_%s" inst~>name) newXy inst~>orient)
            if(isSym then
              wVal = if(newInst~>cellName == "pmos" "pPar(\"s\")*800n" "pPar(\"s\")*400n")
            else
              wVal = if(newInst~>cellName == "pmos" "pPar(\"wp\")" "pPar(\"wn\")")
            )
            dbSetq(newInst wVal w)
          )
        )
      )

      dbCreateLine(dstCv list("wire" "drawing") list(list(2.6875 0.375) list(3.3125 0.375)))
      dbCreateLine(dstCv list("wire" "drawing") list(list(1.6875 1.0) list(3.6875 1.0)))
      dbCreateLine(dstCv list("wire" "drawing") list(list(0.75 -1.4375) list(3.6875 -1.4375)))
      dbCreateLine(dstCv list("wire" "drawing") list(list(3.6875 -1.4375) list(3.6875 -0.25)))
      dbCreateLine(dstCv list("wire" "drawing") list(list(3.6875 0.375) list(4.5 0.375)))

      schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.75 0.0) "R0")
      schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.75 -0.5625) "R0")
      schCreatePin(dstCv ipinMaster "vin3" "input" nil list(-0.75 -1.125) "R0")
      schCreatePin(dstCv ipinMaster "vdd" "input" nil list(-0.375 1.0) "R0")
      schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.375 -1.4375) "R0")
      schCreatePin(dstCv opinMaster "vout" "output" nil list(4.5 0.375) "R0")

      dbSave(dstCv)
      errList = schCheck(dstCv)
      printf("schCheck %s: %L\n" cellName errList)
      dbClose(dstCv)
      dbClose(srcNand)
      dbClose(srcInv)

      ;; Symbol for and3: Copy nand3 symbol, delete inversion bubble, connect output lead
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )
      srcCv = dbOpenCellViewByType(libId if(isSym "nand3_sym" "nand3") "symbol" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
      foreach(s srcCv~>shapes
        unless(s~>objType == "ellipse" && s~>bBox == list(list(1.125 -0.125) list(1.25 0.0))
          dbCopyFig(s dstCv)
        )
      )
      foreach(term dstCv~>terminals dbDeleteObject(term))

      ;; Fix terminals on and3 symbol
      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing")
          let((pinName dir net term yVal)
            yVal = yCoord(car(s~>bBox))
            cond(
              (xCoord(car(s~>bBox)) > 1.2
                pinName = "vout" dir = "output")
              (yVal > 0.05
                pinName = "vdd" dir = "input")
              (yVal < -0.25
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
      ;; Update labels
      foreach(s dstCv~>shapes
        when(s~>objType == "label"
          cond(
            (rexMatchp("nand" s~>theLabel) s~>theLabel = cellName)
            (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
          )
        )
      )
      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      setupCDF(cellName isSym '("vin1" "vin2" "vin3" "vout" "vdd" "gnd"))
    )
  )

  ;; AND4 & AND4_SYM (transistor level: nand4 + inverter)
  foreach(isSym list(nil t)
    let((cellName srcNand srcInv dstCv dx dy errList)
      cellName = if(isSym "and4_sym" "and4")
      printf("Building %s...\n" cellName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )

      dx = 4.5
      dy = -1.125

      srcNand = dbOpenCellViewByType(libId if(isSym "nand4_sym" "nand4") "schematic" "" "r")
      srcInv  = dbOpenCellViewByType(libId if(isSym "inverter_sym" "inverter") "schematic" "" "r")
      dstCv   = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")

      foreach(s srcNand~>shapes dbCopyFig(s dstCv))
      foreach(inst srcNand~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          dbCopyFig(inst dstCv)
        )
      )

      foreach(s srcInv~>shapes
        if(s~>objType == "line" then
          let((p1 p2 isLead)
            p1 = car(s~>points)
            p2 = cadr(s~>points)
            isLead = (p1 == list(-1.0 2.125) || p1 == list(-1.0625 0.875) || p1 == list(-1.0625 1.5) || p2 == list(1.0625 1.5))
            unless(isLead
              dbCreateLine(dstCv s~>lpp list(
                list(car(p1)+dx cadr(p1)+dy)
                list(car(p2)+dx cadr(p2)+dy)
              ))
            )
          )
        )
      )

      foreach(inst srcInv~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          let((newInst newXy wVal)
            newXy = list(car(inst~>xy)+dx cadr(inst~>xy)+dy)
            newInst = dbCreateInst(dstCv inst~>master sprintf(nil "INV_%s" inst~>name) newXy inst~>orient)
            if(isSym then
              wVal = if(newInst~>cellName == "pmos" "pPar(\"s\")*800n" "pPar(\"s\")*400n")
            else
              wVal = if(newInst~>cellName == "pmos" "pPar(\"wp\")" "pPar(\"wn\")")
            )
            dbSetq(newInst wVal w)
          )
        )
      )

      ;; Wire between nand4 out (3.5 0.375) and inverter in (-0.375+dx 1.5+dy) = (4.125 0.375)
      dbCreateLine(dstCv list("wire" "drawing") list(list(3.5 0.375) list(4.125 0.375)))
      ;; VDD line: PM3 vdd top at (2.5 1.0) connect to inverter vdd (0.0+dx 2.125+dy) = (4.5 1.0)
      dbCreateLine(dstCv list("wire" "drawing") list(list(2.5 1.0) list(4.5 1.0)))
      ;; GND line: from (0.75 -2.0) to (4.5 -2.0) and up to (4.5 -0.25)
      dbCreateLine(dstCv list("wire" "drawing") list(list(0.75 -2.0) list(4.5 -2.0)))
      dbCreateLine(dstCv list("wire" "drawing") list(list(4.5 -2.0) list(4.5 -0.25)))
      ;; Inverter VOUT lead: (0.0+dx 1.5+dy) = (4.5 0.375) to (5.3 0.375)
      dbCreateLine(dstCv list("wire" "drawing") list(list(4.5 0.375) list(5.3 0.375)))

      schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.75 0.0) "R0")
      schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.75 -0.5625) "R0")
      schCreatePin(dstCv ipinMaster "vin3" "input" nil list(-0.75 -1.125) "R0")
      schCreatePin(dstCv ipinMaster "vin4" "input" nil list(-0.75 -1.6875) "R0")
      schCreatePin(dstCv ipinMaster "vdd" "input" nil list(-0.375 1.0) "R0")
      schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.375 -2.0) "R0")
      schCreatePin(dstCv opinMaster "vout" "output" nil list(5.3 0.375) "R0")

      dbSave(dstCv)
      errList = schCheck(dstCv)
      printf("schCheck %s: %L\n" cellName errList)
      dbClose(dstCv)
      dbClose(srcNand)
      dbClose(srcInv)

      ;; Symbol for and4: Copy nand4 symbol, delete inversion bubble
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )
      srcCv = dbOpenCellViewByType(libId if(isSym "nand4_sym" "nand4") "symbol" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
      foreach(s srcCv~>shapes
        unless(s~>objType == "ellipse" && s~>bBox == list(list(1.125 -0.125) list(1.25 0.0))
          dbCopyFig(s dstCv)
        )
      )
      foreach(term dstCv~>terminals dbDeleteObject(term))

      ;; Terminals on and4 symbol
      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing")
          let((pinName dir net term yVal)
            yVal = yCoord(car(s~>bBox))
            cond(
              (xCoord(car(s~>bBox)) > 1.2
                pinName = "vout" dir = "output")
              (yVal > 0.05
                pinName = "vdd" dir = "input")
              (yVal < -0.25
                pinName = "gnd" dir = "input")
              (yVal > 0.05
                pinName = "vin1" dir = "input")
              (yVal > -0.05
                pinName = "vin2" dir = "input")
              (yVal > -0.15
                pinName = "vin3" dir = "input")
              (t
                pinName = "vin4" dir = "input")
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
            (rexMatchp("nand" s~>theLabel) s~>theLabel = cellName)
            (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
          )
        )
      )
      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      setupCDF(cellName isSym '("vin1" "vin2" "vin3" "vin4" "vout" "vdd" "gnd"))
    )
  )

  ;; ==============================================================
  ;; PART 3: NOR GATES (nor2, nor3, nor4)
  ;; ==============================================================
  printf("\n==================== BUILDING NOR GATES ====================\n")

  ;; NOR2 & NOR2_SYM (From lab10 static_nor2)
  foreach(isSym list(nil t)
    let((cellName srcCv dstCv errList)
      cellName = if(isSym "nor2_sym" "nor2")
      printf("Building %s...\n" cellName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )

      srcCv = dbOpenCellViewByType("lab10_decoder_static" "static_nor2" "schematic" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(inst srcCv~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          let((newInst wVal)
            newInst = dbCopyFig(inst dstCv)
            if(isSym then
              ;; 2 series PMOS: Wp = 2 * 800n * s = 1.6u * s. Parallel NMOS: Wn = 400n * s
              wVal = if(newInst~>cellName == "pmos" "pPar(\"s\")*1.6u" "pPar(\"s\")*400n")
            else
              wVal = if(newInst~>cellName == "pmos" "pPar(\"wp\")" "pPar(\"wn\")")
            )
            dbSetq(newInst wVal w)
          )
        )
      )

      ;; In static_nor2:
      ;; vin1 (top) is at (-0.75 0.625)
      ;; vin2 (bottom) is at (-0.75 0.0625)
      ;; vdd is at (0.0 1.0)
      ;; gnd is at (-0.25 -1.0)
      ;; vout is at (0.875 -0.25)
      schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.75 0.625) "R0")
      schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.75 0.0625) "R0")
      schCreatePin(dstCv ipinMaster "vdd" "input" nil list(0.0 1.0) "R0")
      schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.25 -1.0) "R0")
      schCreatePin(dstCv opinMaster "vout" "output" nil list(0.875 -0.25) "R0")

      dbSave(dstCv)
      errList = schCheck(dstCv)
      printf("schCheck %s: %L\n" cellName errList)
      dbClose(dstCv)
      dbClose(srcCv)

      ;; Symbol for nor2 (from static_nor2 symbol)
      srcCv = dbOpenCellViewByType("lab10_decoder_static" "static_nor2" "symbol" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(term dstCv~>terminals dbDeleteObject(term))

      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing")
          let((pinName dir net term yVal)
            yVal = yCoord(car(s~>bBox))
            cond(
              (xCoord(car(s~>bBox)) > 1.2
                pinName = "vout" dir = "output")
              (yVal > 0.05
                pinName = "vdd" dir = "input")
              (yVal < -0.3
                pinName = "gnd" dir = "input")
              (yVal > -0.1
                pinName = "vin1" dir = "input")
              (t
                pinName = "vin2" dir = "input")
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
            (rexMatchp("nor" s~>theLabel) s~>theLabel = cellName)
            (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
          )
        )
      )
      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      setupCDF(cellName isSym '("vin1" "vin2" "vout" "vdd" "gnd"))
    )
  )

  ;; NOR3 & NOR3_SYM (From lab10 static_nor3)
  foreach(isSym list(nil t)
    let((cellName srcCv dstCv errList)
      cellName = if(isSym "nor3_sym" "nor3")
      printf("Building %s...\n" cellName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )

      srcCv = dbOpenCellViewByType("lab10_decoder_static" "static_nor3" "schematic" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(inst srcCv~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          let((newInst wVal)
            newInst = dbCopyFig(inst dstCv)
            if(isSym then
              ;; 3 series PMOS: Wp = 3 * 800n * s = 2.4u * s. Parallel NMOS: Wn = 400n * s
              wVal = if(newInst~>cellName == "pmos" "pPar(\"s\")*2.4u" "pPar(\"s\")*400n")
            else
              wVal = if(newInst~>cellName == "pmos" "pPar(\"wp\")" "pPar(\"wn\")")
            )
            dbSetq(newInst wVal w)
          )
        )
      )

      ;; In static_nor3:
      ;; vin1 (top) is at (-0.6875 1.5)
      ;; vin2 (mid) is at (-0.6875 0.9375)
      ;; vin3 (bottom) is at (-0.75 0.375)
      ;; vdd is at (0.0625 1.875)
      ;; gnd is at (-0.1875 -1.0)
      ;; vout is at (2.4375 -0.25)
      schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.6875 1.5) "R0")
      schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.6875 0.9375) "R0")
      schCreatePin(dstCv ipinMaster "vin3" "input" nil list(-0.75 0.375) "R0")
      schCreatePin(dstCv ipinMaster "vdd" "input" nil list(0.0625 1.875) "R0")
      schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.1875 -1.0) "R0")
      schCreatePin(dstCv opinMaster "vout" "output" nil list(2.4375 -0.25) "R0")

      dbSave(dstCv)
      errList = schCheck(dstCv)
      printf("schCheck %s: %L\n" cellName errList)
      dbClose(dstCv)
      dbClose(srcCv)

      ;; Symbol for nor3 (from static_nor3 symbol)
      srcCv = dbOpenCellViewByType("lab10_decoder_static" "static_nor3" "symbol" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(term dstCv~>terminals dbDeleteObject(term))

      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing")
          let((pinName dir net term yVal)
            yVal = yCoord(car(s~>bBox))
            cond(
              (xCoord(car(s~>bBox)) > 1.2
                pinName = "vout" dir = "output")
              (yVal > 0.05
                pinName = "vdd" dir = "input")
              (yVal < -0.3
                pinName = "gnd" dir = "input")
              (yVal > -0.05
                pinName = "vin1" dir = "input")
              (yVal > -0.2
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
            (rexMatchp("nor" s~>theLabel) s~>theLabel = cellName)
            (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
          )
        )
      )
      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      setupCDF(cellName isSym '("vin1" "vin2" "vin3" "vout" "vdd" "gnd"))
    )
  )

  ;; NOR4 & NOR4_SYM (Extend static_nor3 with PM3 and NM3)
  foreach(isSym list(nil t)
    let((cellName srcCv dstCv errList)
      cellName = if(isSym "nor4_sym" "nor4")
      printf("Building %s...\n" cellName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )

      srcCv = dbOpenCellViewByType("lab10_decoder_static" "static_nor3" "schematic" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")

      ;; In static_nor3:
      ;; Delete VOUT wire that went to opin at (2.4375 -0.25)
      foreach(s srcCv~>shapes
        if(s~>objType == "line" && member(list(2.4375 -0.25) s~>points) then
          nil
        else
          dbCopyFig(s dstCv)
        )
      )

      foreach(inst srcCv~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          let((newInst wVal)
            newInst = dbCopyFig(inst dstCv)
            if(isSym then
              ;; 4 series PMOS: Wp = 4 * 800n * s = 3.2u * s. Parallel NMOS: Wn = 400n * s
              wVal = if(newInst~>cellName == "pmos" "pPar(\"s\")*3.2u" "pPar(\"s\")*400n")
            else
              wVal = if(newInst~>cellName == "pmos" "pPar(\"wp\")" "pPar(\"wn\")")
            )
            dbSetq(newInst wVal w)
          )
        )
      )

      ;; Add PM3 below PM2: PM2 is at (-0.0625 0.375). Place PM3 at (-0.0625 -0.1875)
      ;; Add NM3 to the right: NM2 is at (0.875 -0.625). Place NM3 at (1.5 -0.625)
      let((pm3 nm3)
        pm3 = dbCreateInst(dstCv pmosMaster "PM3" list(-0.0625 -0.1875) "R0")
        dbSetq(pm3 if(isSym "pPar(\"s\")*3.2u" "pPar(\"wp\")") w)

        nm3 = dbCreateInst(dstCv nmosMaster "NM3" list(1.5 -0.625) "R0")
        dbSetq(nm3 if(isSym "pPar(\"s\")*400n" "pPar(\"wn\")") w)

        ;; In static_nor3, PM2 Drain was at (0.1875 0.375) -> connected to vout wire at (0.1875 0.1875)
        ;; Now PM2 Drain connects to PM3 Source at (0.1875 0.0)
        ;; Delete wire segment between (0.1875 0.375) and (0.1875 0.1875)
        foreach(s dstCv~>shapes
          when(s~>objType == "line" && member(list(0.1875 0.375) s~>points) && member(list(0.1875 0.1875) s~>points)
            dbDeleteObject(s)
          )
        )
        ;; Connect PM2 D (0.1875 0.375) to PM3 S (0.1875 0.0)
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.1875 0.375) list(0.1875 0.0)))
        ;; PM3 B to VDD: PM3 B is at (0.5625 0.0) -> connect to VDD bus at (0.5625 1.8125)
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.5625 0.0) list(0.5625 0.9375)))

        ;; PM3 D (-0.0625 -0.375) connects to VOUT bus at Y=-0.25
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.1875 -0.375) list(0.1875 -0.25)))

        ;; NM3 D (1.75 -0.4375) to VOUT bus at Y=-0.25:
        ;; VOUT bus in static_nor3 runs from (-0.125 -0.25) to (1.125 -0.25)
        ;; Extend VOUT bus to (1.75 -0.25) and opin at (2.8 -0.25)
        dbCreateLine(dstCv list("wire" "drawing") list(list(1.125 -0.25) list(1.75 -0.25)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(1.75 -0.4375) list(1.75 -0.25)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(1.75 -0.25) list(2.8 -0.25)))

        ;; NM3 S (1.75 -0.8125) and B (2.0625 -0.625) to GND bus at Y=-0.9375:
        ;; GND bus in static_nor3 runs to (1.375 -0.9375)
        dbCreateLine(dstCv list("wire" "drawing") list(list(1.375 -0.9375) list(1.75 -0.9375)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(1.75 -0.9375) list(1.75 -0.8125)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(1.75 -0.9375) list(2.0625 -0.9375)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(2.0625 -0.9375) list(2.0625 -0.625)))

        ;; Gate connections for vin4:
        ;; PM3 Gate is at (-0.0625 -0.1875), NM3 Gate is at (1.5 -0.625)
        dbCreateLine(dstCv list("wire" "drawing") list(list(-0.75 -0.1875) list(-0.0625 -0.1875)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(-0.35 -0.1875) list(-0.35 -1.25)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(-0.35 -1.25) list(1.35 -1.25)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(1.35 -1.25) list(1.35 -0.625)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(1.35 -0.625) list(1.5 -0.625)))

        ;; Create Pins: top to bottom
        schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.6875 1.5) "R0")
        schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.6875 0.9375) "R0")
        schCreatePin(dstCv ipinMaster "vin3" "input" nil list(-0.75 0.375) "R0")
        schCreatePin(dstCv ipinMaster "vin4" "input" nil list(-0.75 -0.1875) "R0")

        schCreatePin(dstCv ipinMaster "vdd" "input" nil list(0.0625 1.875) "R0")
        schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.1875 -1.0) "R0")
        schCreatePin(dstCv opinMaster "vout" "output" nil list(2.8 -0.25) "R0")

        dbSave(dstCv)
        errList = schCheck(dstCv)
        printf("schCheck %s: %L\n" cellName errList)
        dbClose(dstCv)
        dbClose(srcCv)
      )

      ;; Symbol for nor4 (from static_nor3 symbol, expand to 4 inputs)
      srcCv = dbOpenCellViewByType("lab10_decoder_static" "static_nor3" "symbol" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(term dstCv~>terminals dbDeleteObject(term))

      ;; Delete old input pin rects and labels
      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing") && xCoord(car(s~>bBox)) < 0.8
          dbDeleteObject(s)
        )
        when(s~>objType == "label" && member(s~>theLabel '("in1" "in2" "in3" "vin1" "vin2" "vin3"))
          dbDeleteObject(s)
        )
      )

      ;; Re-create 4 input pins
      let((pinCoords)
        pinCoords = list(
          list("vin1" 0.025)
          list("vin2" -0.075)
          list("vin3" -0.175)
          list("vin4" -0.275)
        )
        foreach(entry pinCoords
          let((pName yP rect net term lbl)
            pName = car(entry)
            yP = cadr(entry)
            rect = dbCreateRect(dstCv list("pin" "drawing") list(list(0.475 yP-0.025) list(0.525 yP+0.025)))
            net = dbMakeNet(dstCv pName)
            term = dbCreateTerm(net pName "input")
            dbCreatePin(net rect pName)
            lbl = dbCreateLabel(dstCv list("pin" "label") list(0.5375 yP-0.0125) pName "lowerLeft" "R0" "roman" 0.05)
          )
        )
      )

      ;; Terminals for VOUT, VDD, GND
      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing")
          cond(
            (xCoord(car(s~>bBox)) > 1.2
              let((net term)
                net = dbMakeNet(dstCv "vout") term = dbCreateTerm(net "vout" "output") dbCreatePin(net s "vout")
              ))
            (yCoord(car(s~>bBox)) > 0.05
              let((net term)
                net = dbMakeNet(dstCv "vdd") term = dbCreateTerm(net "vdd" "input") dbCreatePin(net s "vdd")
              ))
            (yCoord(car(s~>bBox)) < -0.3
              let((net term)
                net = dbMakeNet(dstCv "gnd") term = dbCreateTerm(net "gnd" "input") dbCreatePin(net s "gnd")
              ))
          )
        )
      )

      foreach(s dstCv~>shapes
        when(s~>objType == "label"
          cond(
            (rexMatchp("nor" s~>theLabel) s~>theLabel = cellName)
            (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
          )
        )
      )
      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      setupCDF(cellName isSym '("vin1" "vin2" "vin3" "vin4" "vout" "vdd" "gnd"))
    )
  )

  ;; ==============================================================
  ;; PART 4: OR GATES (or2, or3, or4)
  ;; ==============================================================
  printf("\n==================== BUILDING OR GATES ====================\n")

  procedure(buildOrGate(nInputs isSym)
    let((cellName norName invName srcNor srcInv dstCv dx dy errList)
      cellName = sprintf(nil "or%d%s" nInputs if(isSym "_sym" ""))
      norName  = sprintf(nil "nor%d%s" nInputs if(isSym "_sym" ""))
      invName  = if(isSym "inverter_sym" "inverter")
      printf("Building %s from %s + %s...\n" cellName norName invName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )

      srcNor = dbOpenCellViewByType(libId norName "schematic" "" "r")
      srcInv = dbOpenCellViewByType(libId invName "schematic" "" "r")
      dstCv  = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")

      ;; 1. Copy NOR shapes and instances
      foreach(s srcNor~>shapes dbCopyFig(s dstCv))
      foreach(inst srcNor~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          dbCopyFig(inst dstCv)
        )
      )

      ;; 2. Determine NOR output position to shift inverter
      let((norOutX norOutY)
        cond(
          (nInputs == 2
            norOutX = 0.875 norOutY = -0.25)
          (nInputs == 3
            norOutX = 2.4375 norOutY = -0.25)
          (nInputs == 4
            norOutX = 2.8 norOutY = -0.25)
        )

        ;; Inverter input is at (-1.0 1.5). We want (-1.0+dx 1.5+dy) to connect to (norOutX norOutY)
        ;; dx = norOutX + 1.0 + 0.6 = norOutX + 1.6
        ;; dy = norOutY - 1.5 = -1.75
        dx = norOutX + 1.6
        dy = -1.75

        ;; Copy inverter shapes without outer pin leads
        foreach(s srcInv~>shapes
          if(s~>objType == "line" then
            let((p1 p2 isLead)
              p1 = car(s~>points)
              p2 = cadr(s~>points)
              isLead = (p1 == list(-1.0 2.125) || p1 == list(-1.0625 0.875) || p1 == list(-1.0625 1.5) || p2 == list(1.0625 1.5))
              unless(isLead
                dbCreateLine(dstCv s~>lpp list(
                  list(car(p1)+dx cadr(p1)+dy)
                  list(car(p2)+dx cadr(p2)+dy)
                ))
              )
            )
          )
        )

        ;; Copy inverter instances
        foreach(inst srcInv~>instances
          unless(member(inst~>cellName '("ipin" "opin"))
            let((newInst newXy wVal)
              newXy = list(car(inst~>xy)+dx cadr(inst~>xy)+dy)
              newInst = dbCreateInst(dstCv inst~>master sprintf(nil "INV_%s" inst~>name) newXy inst~>orient)
              if(isSym then
                wVal = if(newInst~>cellName == "pmos" "pPar(\"s\")*800n" "pPar(\"s\")*400n")
              else
                wVal = if(newInst~>cellName == "pmos" "pPar(\"wp\")" "pPar(\"wn\")")
              )
              dbSetq(newInst wVal w)
            )
          )
        )

        ;; Connect NOR out (norOutX norOutY) to inverter in (-0.375+dx 1.5+dy)
        dbCreateLine(dstCv list("wire" "drawing") list(list(norOutX norOutY) list(-0.375+dx 1.5+dy)))

        ;; Connect inverter VDD (0.0+dx 2.125+dy) to NOR VDD bus
        ;; NOR VDD top line is at Y=1.0 (for nor2) or Y=1.875 (for nor3, nor4)
        let((norVddY)
          norVddY = if(nInputs == 2 1.0 1.875)
          dbCreateLine(dstCv list("wire" "drawing") list(list(0.0+dx 2.125+dy) list(0.0+dx norVddY)))
          dbCreateLine(dstCv list("wire" "drawing") list(list(0.0 norVddY) list(0.0+dx norVddY)))
        )

        ;; Connect inverter GND (0.0+dx 0.875+dy) to NOR GND bus at Y=-1.0
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.0+dx 0.875+dy) list(0.0+dx -1.0)))
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.0 -1.0) list(0.0+dx -1.0)))

        ;; Inverter output lead to opin: (0.0+dx 1.5+dy) to (0.8+dx 1.5+dy)
        dbCreateLine(dstCv list("wire" "drawing") list(list(0.0+dx 1.5+dy) list(0.8+dx 1.5+dy)))

        ;; Create pins
        cond(
          (nInputs == 2
            schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.75 0.625) "R0")
            schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.75 0.0625) "R0")
            schCreatePin(dstCv ipinMaster "vdd" "input" nil list(0.0 1.0) "R0")
            schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.25 -1.0) "R0")
          )
          (nInputs == 3
            schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.6875 1.5) "R0")
            schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.6875 0.9375) "R0")
            schCreatePin(dstCv ipinMaster "vin3" "input" nil list(-0.75 0.375) "R0")
            schCreatePin(dstCv ipinMaster "vdd" "input" nil list(0.0625 1.875) "R0")
            schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.1875 -1.0) "R0")
          )
          (nInputs == 4
            schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-0.6875 1.5) "R0")
            schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-0.6875 0.9375) "R0")
            schCreatePin(dstCv ipinMaster "vin3" "input" nil list(-0.75 0.375) "R0")
            schCreatePin(dstCv ipinMaster "vin4" "input" nil list(-0.75 -0.1875) "R0")
            schCreatePin(dstCv ipinMaster "vdd" "input" nil list(0.0625 1.875) "R0")
            schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-0.1875 -1.0) "R0")
          )
        )
        schCreatePin(dstCv opinMaster "vout" "output" nil list(0.8+dx 1.5+dy) "R0")

        dbSave(dstCv)
        errList = schCheck(dstCv)
        printf("schCheck %s: %L\n" cellName errList)
        dbClose(dstCv)
        dbClose(srcNor)
        dbClose(srcInv)

        ;; Symbol: Copy NOR symbol, remove bubble
        srcCv = dbOpenCellViewByType(libId norName "symbol" "" "r")
        dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
        foreach(s srcCv~>shapes
          unless(s~>objType == "ellipse"
            dbCopyFig(s dstCv)
          )
        )
        foreach(term dstCv~>terminals dbDeleteObject(term))

        ;; Create symbol terminals
        foreach(s dstCv~>shapes
          when(s~>lpp == list("pin" "drawing")
            let((pinName dir net term yVal)
              yVal = yCoord(car(s~>bBox))
              cond(
                (xCoord(car(s~>bBox)) > 1.2
                  pinName = "vout" dir = "output")
                (yVal > 0.05
                  pinName = "vdd" dir = "input")
                (yVal < -0.3
                  pinName = "gnd" dir = "input")
                (nInputs == 2
                  pinName = if(yVal > -0.1 "vin1" "vin2") dir = "input")
                (nInputs == 3
                  pinName = if(yVal > -0.05 "vin1" if(yVal > -0.2 "vin2" "vin3")) dir = "input")
                (nInputs == 4
                  pinName = if(yVal > 0.0 "vin1" if(yVal > -0.1 "vin2" if(yVal > -0.2 "vin3" "vin4"))) dir = "input")
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
              (rexMatchp("nor" s~>theLabel) s~>theLabel = cellName)
              (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
            )
          )
        )
        dbSave(dstCv)
        dbClose(dstCv)
        dbClose(srcCv)

        ;; CDF
        let((termList)
          termList = cond(
            (nInputs == 2 '("vin1" "vin2" "vout" "vdd" "gnd"))
            (nInputs == 3 '("vin1" "vin2" "vin3" "vout" "vdd" "gnd"))
            (nInputs == 4 '("vin1" "vin2" "vin3" "vin4" "vout" "vdd" "gnd"))
          )
          setupCDF(cellName isSym termList)
        )
      )
    )
  )

  for(n 2 4
    foreach(isSym list(nil t)
      buildOrGate(n isSym)
    )
  )

  ;; ==============================================================
  ;; PART 5: XOR2 & XOR2_SYM (Complementary Static CMOS)
  ;; ==============================================================
  printf("\n==================== BUILDING XOR2 GATES ====================\n")

  foreach(isSym list(nil t)
    let((cellName srcCv dstCv errList)
      cellName = if(isSym "xor2_sym" "xor2")
      printf("Building %s...\n" cellName)

      when(ddGetObj(libId cellName "schematic")
        ddDeleteObj(ddGetObj(libId cellName "schematic"))
      )
      when(ddGetObj(libId cellName "symbol")
        ddDeleteObj(ddGetObj(libId cellName "symbol"))
      )

      srcCv = dbOpenCellViewByType("lab11_adders" "xor2" "schematic" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "schematic" "schematic" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(inst srcCv~>instances
        unless(member(inst~>cellName '("ipin" "opin"))
          let((newInst wVal)
            newInst = dbCopyFig(inst dstCv)
            if(isSym then
              wVal = if(newInst~>cellName == "pmos" "pPar(\"s\")*1.6u" "pPar(\"s\")*800n")
            else
              wVal = if(newInst~>cellName == "pmos" "pPar(\"wp\")" "pPar(\"wn\")")
            )
            dbSetq(newInst wVal w)
          )
        )
      )

      ;; Pins in lab11 xor2:
      ;; vin1 (top) is at (-3.0 -1.0)
      ;; vin2 (bottom) is at (-2.9375 -3.0)
      ;; vdd is at (-3.0 -0.25)
      ;; gnd is at (-2.875 -4.0)
      ;; vout is at (1.5 -2.25)
      schCreatePin(dstCv ipinMaster "vin1" "input" nil list(-3.0 -1.0) "R0")
      schCreatePin(dstCv ipinMaster "vin2" "input" nil list(-2.9375 -3.0) "R0")
      schCreatePin(dstCv ipinMaster "vdd" "input" nil list(-3.0 -0.25) "R0")
      schCreatePin(dstCv ipinMaster "gnd" "input" nil list(-2.875 -4.0) "R0")
      schCreatePin(dstCv opinMaster "vout" "output" nil list(1.5 -2.25) "R0")

      dbSave(dstCv)
      errList = schCheck(dstCv)
      printf("schCheck %s: %L\n" cellName errList)
      dbClose(dstCv)
      dbClose(srcCv)

      ;; Symbol for xor2 (from lab11 xor2 symbol)
      srcCv = dbOpenCellViewByType("lab11_adders" "xor2" "symbol" "" "r")
      dstCv = dbOpenCellViewByType(libId cellName "symbol" "schematicSymbol" "w")
      foreach(s srcCv~>shapes dbCopyFig(s dstCv))
      foreach(term dstCv~>terminals dbDeleteObject(term))

      foreach(s dstCv~>shapes
        when(s~>lpp == list("pin" "drawing")
          let((pinName dir net term yVal)
            yVal = yCoord(car(s~>bBox))
            cond(
              (xCoord(car(s~>bBox)) > 1.2
                pinName = "vout" dir = "output")
              (yVal > 0.05
                pinName = "vdd" dir = "input")
              (yVal < -0.3
                pinName = "gnd" dir = "input")
              (yVal > -0.1
                pinName = "vin1" dir = "input")
              (t
                pinName = "vin2" dir = "input")
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
            (rexMatchp("xor" s~>theLabel) s~>theLabel = cellName)
            (isSym && s~>theLabel == "cdsParam(2)" dbDeleteObject(s))
          )
        )
      )
      dbSave(dstCv)
      dbClose(dstCv)
      dbClose(srcCv)

      setupCDF(cellName isSym '("vin1" "vin2" "vout" "vdd" "gnd"))
    )
  )

  printf("\nALL LOGIC GATES BUILT SUCCESSFULLY!\n")
  exit()
)
