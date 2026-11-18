procedure(createNandGate(cellName isSymmetric)
  let((cv symCv nmosMaster pmosMaster ipinMaster opinMaster
       pm0 pm1 nm0 nm1
       pinVdd pinGnd pinVin1 pinVin2 pinVout
       netVdd netGnd netVin1 netVin2 netVout netMid
       wpVal wnVal cdfFile)

    printf("\n>>> Building %s (isSymmetric=%L) from scratch <<<\n" cellName isSymmetric)

    if(isSymmetric then
      wpVal = "pPar(\"s\")*800n"
      wnVal = "pPar(\"s\")*800n"
    else
      wpVal = "pPar(\"wp\")"
      wnVal = "pPar(\"wn\")"
    )

    ;; 1. Open new schematic view
    cv = dbOpenCellViewByType("standard_logic_components" cellName "schematic" "schematic" "w")
    unless(cv error("Failed to open schematic view for %s" cellName))

    ;; Masters
    nmosMaster = dbOpenCellViewByType("gpdk180" "nmos" "symbol" "" "r")
    pmosMaster = dbOpenCellViewByType("gpdk180" "pmos" "symbol" "" "r")
    ipinMaster = dbOpenCellViewByType("basic" "ipin" "symbol" "" "r")
    opinMaster = dbOpenCellViewByType("basic" "opin" "symbol" "" "r")

    ;; Place PMOS transistors (PM0, PM1 in parallel at top)
    pm0 = dbCreateInst(cv pmosMaster "PM0" list(-0.8 1.8125) "R0")
    dbSetq(pm0 wpVal w)
    pm1 = dbCreateInst(cv pmosMaster "PM1" list(0.3 1.8125) "R0")
    dbSetq(pm1 wpVal w)

    ;; Place NMOS transistors (NM0 top, NM1 bottom in series)
    nm0 = dbCreateInst(cv nmosMaster "NM0" list(-0.25 1.1875) "R0")
    dbSetq(nm0 wnVal w)
    nm1 = dbCreateInst(cv nmosMaster "NM1" list(-0.25 0.3875) "R0")
    dbSetq(nm1 wnVal w)

    ;; Place Pin instances
    pinVdd  = dbCreateInst(cv ipinMaster "PIN_VDD"  list(-0.25 2.5)  "R0")
    pinGnd  = dbCreateInst(cv ipinMaster "PIN_GND"  list(-0.25 -0.2) "R0")
    pinVin1 = dbCreateInst(cv ipinMaster "PIN_VIN1" list(-1.8 1.8125) "R0")
    pinVin2 = dbCreateInst(cv ipinMaster "PIN_VIN2" list(-1.8 0.3875) "R0")
    pinVout = dbCreateInst(cv opinMaster "PIN_VOUT" list(1.4 1.4)    "R0")

    ;; Create Nets
    netVdd  = dbMakeNet(cv "vdd")
    netGnd  = dbMakeNet(cv "gnd")
    netVin1 = dbMakeNet(cv "vin1")
    netVin2 = dbMakeNet(cv "vin2")
    netVout = dbMakeNet(cv "vout")
    netMid  = dbMakeNet(cv "net_mid")

    ;; Create Cell Terminals & Pins
    dbCreatePin(netVdd  dbCreateRect(cv list("pin" "drawing") list(-0.275 2.475 -0.225 2.525)) "vdd")
    dbCreatePin(netGnd  dbCreateRect(cv list("pin" "drawing") list(-0.275 -0.225 -0.225 -0.175)) "gnd")
    dbCreatePin(netVin1 dbCreateRect(cv list("pin" "drawing") list(-1.825 1.7875 -1.775 1.8375)) "vin1")
    dbCreatePin(netVin2 dbCreateRect(cv list("pin" "drawing") list(-1.825 0.3625 -1.775 0.4125)) "vin2")
    dbCreatePin(netVout dbCreateRect(cv list("pin" "drawing") list(1.375 1.375 1.425 1.425)) "vout")

    cv~>terminals~>direction = list("input" "input" "input" "input" "output")

    ;; Connect InstTerms (Logical netlisting connections)
    ;; PM0: S=vdd, D=vout, G=vin1, B=vdd
    dbCreateConnByName(netVdd  pm0 "S")
    dbCreateConnByName(netVout pm0 "D")
    dbCreateConnByName(netVin1 pm0 "G")
    dbCreateConnByName(netVdd  pm0 "B")

    ;; PM1: S=vdd, D=vout, G=vin2, B=vdd
    dbCreateConnByName(netVdd  pm1 "S")
    dbCreateConnByName(netVout pm1 "D")
    dbCreateConnByName(netVin2 pm1 "G")
    dbCreateConnByName(netVdd  pm1 "B")

    ;; NM0 (top NMOS): D=vout, S=netMid, G=vin1, B=gnd
    dbCreateConnByName(netVout nm0 "D")
    dbCreateConnByName(netMid  nm0 "S")
    dbCreateConnByName(netVin1 nm0 "G")
    dbCreateConnByName(netGnd  nm0 "B")

    ;; NM1 (bottom NMOS): D=netMid, S=gnd, G=vin2, B=gnd
    dbCreateConnByName(netMid  nm1 "D")
    dbCreateConnByName(netGnd  nm1 "S")
    dbCreateConnByName(netVin2 nm1 "G")
    dbCreateConnByName(netGnd  nm1 "B")

    ;; Draw Schematic Wires
    ;; VDD rail to PMOS Sources
    dbCreateLine(cv list("wire" "drawing") list(list(-0.25 2.5) list(-0.25 2.2)))
    dbCreateLine(cv list("wire" "drawing") list(list(-0.55 2.2) list(0.55 2.2)))
    dbCreateLine(cv list("wire" "drawing") list(list(-0.55 2.2) list(-0.55 2.0)))
    dbCreateLine(cv list("wire" "drawing") list(list(0.55 2.2) list(0.55 2.0)))

    ;; PMOS Drains to NM0 Drain & VOUT
    dbCreateLine(cv list("wire" "drawing") list(list(-0.55 1.6) list(-0.55 1.4)))
    dbCreateLine(cv list("wire" "drawing") list(list(0.55 1.6) list(0.55 1.4)))
    dbCreateLine(cv list("wire" "drawing") list(list(-0.55 1.4) list(1.4 1.4)))
    dbCreateLine(cv list("wire" "drawing") list(list(0.0 1.4) list(0.0 1.375)))

    ;; NM0 Source to NM1 Drain
    dbCreateLine(cv list("wire" "drawing") list(list(0.0 1.0) list(0.0 0.575)))

    ;; NM1 Source to GND
    dbCreateLine(cv list("wire" "drawing") list(list(0.0 0.2) list(0.0 0.0)))
    dbCreateLine(cv list("wire" "drawing") list(list(0.0 0.0) list(-0.25 0.0)))
    dbCreateLine(cv list("wire" "drawing") list(list(-0.25 0.0) list(-0.25 -0.2)))

    ;; VIN1 to PM0 Gate and NM0 Gate
    dbCreateLine(cv list("wire" "drawing") list(list(-1.8 1.8125) list(-1.2 1.8125)))
    dbCreateLine(cv list("wire" "drawing") list(list(-1.2 1.8125) list(-0.8 1.8125)))
    dbCreateLine(cv list("wire" "drawing") list(list(-1.2 1.8125) list(-1.2 1.1875)))
    dbCreateLine(cv list("wire" "drawing") list(list(-1.2 1.1875) list(-0.25 1.1875)))

    ;; VIN2 to PM1 Gate and NM1 Gate
    dbCreateLine(cv list("wire" "drawing") list(list(-1.8 0.3875) list(-1.4 0.3875)))
    dbCreateLine(cv list("wire" "drawing") list(list(-1.4 0.3875) list(-0.25 0.3875)))
    dbCreateLine(cv list("wire" "drawing") list(list(-1.4 0.3875) list(-1.4 2.3)))
    dbCreateLine(cv list("wire" "drawing") list(list(-1.4 2.3) list(0.1 2.3)))
    dbCreateLine(cv list("wire" "drawing") list(list(0.1 2.3) list(0.1 1.8125)))
    dbCreateLine(cv list("wire" "drawing") list(list(0.1 1.8125) list(0.3 1.8125)))

    ;; Connection dots
    dbCreateEllipse(cv list("wire" "drawing") list(list(-0.27 2.18) list(-0.23 2.22)))
    dbCreateEllipse(cv list("wire" "drawing") list(list(-0.02 1.38) list(0.02 1.42)))
    dbCreateEllipse(cv list("wire" "drawing") list(list(-1.22 1.7925) list(-1.18 1.8325)))
    dbCreateEllipse(cv list("wire" "drawing") list(list(-1.42 0.3675) list(-1.38 0.4075)))

    dbSave(cv)
    dbClose(cv)
    printf("Schematic saved.\n")

    ;; 2. Create Symbol from Scratch (Standard IEEE NAND Gate shape with bubble & supply pins)
    symCv = dbOpenCellViewByType("standard_logic_components" cellName "symbol" "schematicSymbol" "w")
    unless(symCv error("Failed to open symbol view for %s" cellName))

    ;; Draw NAND Gate Body: Flat back at x=-0.3, curved front reaching x=0.3
    dbCreateLine(symCv list("device" "drawing") list(list(-0.3 -0.4) list(-0.3 0.4)))
    dbCreateLine(symCv list("device" "drawing") list(list(-0.3 0.4) list(0.0 0.4)))
    dbCreateLine(symCv list("device" "drawing") list(list(-0.3 -0.4) list(0.0 -0.4)))
    dbCreateArc(symCv list("device" "drawing") list(list(0.0 -0.4) list(0.3 0.4)) list(0.0 -0.4) list(0.0 0.4))

    ;; Draw Inversion Bubble at output
    dbCreateEllipse(symCv list("device" "drawing") list(list(0.3 -0.05) list(0.4 0.05)))

    ;; Input lead lines
    dbCreateLine(symCv list("device" "drawing") list(list(-0.5 0.2) list(-0.3 0.2)))
    dbCreateLine(symCv list("device" "drawing") list(list(-0.5 -0.2) list(-0.3 -0.2)))
    ;; Output lead line
    dbCreateLine(symCv list("device" "drawing") list(list(0.4 0.0) list(0.6 0.0)))
    ;; Supply lead lines (VDD top, GND bottom)
    dbCreateLine(symCv list("device" "drawing") list(list(0.0 0.4) list(0.0 0.6)))
    dbCreateLine(symCv list("device" "drawing") list(list(0.0 -0.4) list(0.0 -0.6)))

    ;; Selection Box
    dbCreateRect(symCv list("instance" "drawing") list(list(-0.5 -0.6) list(0.6 0.6)))

    ;; Labels: [@instanceName], [@partName]
    dbCreateLabel(symCv list("instance" "label") list(-0.3 0.65) "[@instanceName]" "lowerLeft" "R0" "roman" 0.0625)
    dbCreateLabel(symCv list("device" "label")   list(-0.2 -0.05) cellName "centerLeft" "R0" "roman" 0.0625)

    ;; Symbol Pins & Terminals
    let((net pin rect)
      ;; vin1 pin at (-0.5 0.2)
      net = dbMakeNet(symCv "vin1")
      rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.525 0.175) list(-0.475 0.225)))
      pin = dbCreatePin(net rect "vin1")
      pin~>term~>direction = "input"
      dbCreateLabel(symCv list("pin" "label") list(-0.45 0.22) "vin1" "lowerLeft" "R0" "roman" 0.05)

      ;; vin2 pin at (-0.5 -0.2)
      net = dbMakeNet(symCv "vin2")
      rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.525 -0.225) list(-0.475 -0.175)))
      pin = dbCreatePin(net rect "vin2")
      pin~>term~>direction = "input"
      dbCreateLabel(symCv list("pin" "label") list(-0.45 -0.18) "vin2" "lowerLeft" "R0" "roman" 0.05)

      ;; vout pin at (0.6 0.0)
      net = dbMakeNet(symCv "vout")
      rect = dbCreateRect(symCv list("pin" "drawing") list(list(0.575 -0.025) list(0.625 0.025)))
      pin = dbCreatePin(net rect "vout")
      pin~>term~>direction = "output"
      dbCreateLabel(symCv list("pin" "label") list(0.48 0.03) "vout" "lowerLeft" "R0" "roman" 0.05)

      ;; vdd pin at (0.0 0.6)
      net = dbMakeNet(symCv "vdd")
      rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.025 0.575) list(0.025 0.625)))
      pin = dbCreatePin(net rect "vdd")
      pin~>term~>direction = "input"

      ;; gnd pin at (0.0 -0.6)
      net = dbMakeNet(symCv "gnd")
      rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.025 -0.625) list(0.025 -0.575)))
      pin = dbCreatePin(net rect "gnd")
      pin~>term~>direction = "input"
    )

    dbSave(symCv)
    dbClose(symCv)
    printf("Symbol saved.\n")

    ;; 3. Write CDF Parameter & Simulation View
    if(isSymmetric then
      cdfFile = outfile(sprintf(nil "basic_circuits/library/standard_logic_components/%s/cdf_parameter_file" cellName) "w")
      fprintf(cdfFile "((nil description nil callback nil choices nil defValue \"1\" display nil dontSave nil editable nil name \"s\" paramType \"string\" parseAsCEL t parseAsNumber t prompt \"s\" storeDefault t units nil use nil))\n")
      fprintf(cdfFile "(nil ams (nil isPrimitive \"\" extraTerminals \"\" propMapping \"\" termMapping \"\" termOrder \"\" componentName \"\" excludeParameters \"\" arrayParameters \"\" stringParameters \"\" referenceParameters \"\" enumParameters \"\" instParameters \"\" otherParameters \"\" netlistProcedure \"\") auLvs (nil namePrefix \"X\" permuteRule \"\" propMapping \"\" deviceTerminals \"\" termOrder \"\\\"vin1\\\" \\\"vin2\\\" \\\"vout\\\" \\\"vdd\\\" \\\"gnd\\\"\" componentName \"subcircuit\" instParameters \"\" otherParameters \"\" netlistProcedure \"ansLvsCompPrim\") auCdl (nil dollarEqualParams \"\" dollarParams \"\" modelName \"\" namePrefix \"X\" propMapping \"\" termOrder \"\\\"vin1\\\" \\\"vin2\\\" \\\"vout\\\" \\\"vdd\\\" \\\"gnd\\\"\" componentName \"subcircuit\" instParameters \"\" otherParameters \"\" netlistProcedure \"ansCdlSubcktCall\") spectre (nil modelParamExprList \"\" optParamExprList \"\" opParamExprList \"\" stringParameters \"\" propMapping \"\" termMapping \"\" termOrder \"\\\"vin1\\\" \\\"vin2\\\" \\\"vout\\\" \\\"vdd\\\" \\\"gnd\\\"\" componentName \"subcircuit\" instParameters \"\" otherParameters \"\" netlistProcedure \"\") hspiceD (nil opParamExprList \"\" optParamExprList \"\" propMapping \"\" termMapping \"\" termOrder \"\\\"vin1\\\" \\\"vin2\\\" \\\"vout\\\" \\\"vdd\\\" \\\"gnd\\\"\" namePrefix \"X\" componentName \"subcircuit\" instParameters \"\" otherParameters \"\" netlistProcedure \"\"))\n")
      fprintf(cdfFile "(nil paramLabelSet \"s\" opPointLabelSet nil modelLabelSet nil paramDisplayMode \"parameter\" paramEvaluate \"t nil nil nil nil\" paramSimType \"DC\" termDisplayMode \"none\" termSimType \"DC\" netNameType \"schematic\" instDisplayMode \"instName\" instNameType \"schematic\")\n")
      fprintf(cdfFile "(nil doneProc \"\" formInitProc \"\" promptWidth 175 fieldWidth 350 buttonFieldWidth 340 fieldHeight 35)\n\n")
      close(cdfFile)
    else
      cdfFile = outfile(sprintf(nil "basic_circuits/library/standard_logic_components/%s/inv_cdf_file" cellName) "w")
      fprintf(cdfFile "((nil description nil callback nil choices nil defValue \"800n\" display nil dontSave nil editable nil name \"wn\" paramType \"string\" parseAsCEL t parseAsNumber t prompt \"wn\" storeDefault t units nil use nil) (nil description nil dontSave nil use nil callback nil display nil paramType \"string\" prompt \"wp\" name \"wp\" parseAsCEL t storeDefault t editable nil units nil parseAsNumber t choices nil defValue \"800n\"))\n")
      fprintf(cdfFile "(nil ams (nil isPrimitive \"\" extraTerminals \"\" propMapping \"\" termMapping \"\" termOrder \"\" componentName \"\" excludeParameters \"\" arrayParameters \"\" stringParameters \"\" referenceParameters \"\" enumParameters \"\" instParameters \"\" otherParameters \"\" netlistProcedure \"\") auLvs (nil namePrefix \"X\" permuteRule \"\" propMapping \"\" deviceTerminals \"\" termOrder \"\\\"vin1\\\" \\\"vin2\\\" \\\"vout\\\" \\\"vdd\\\" \\\"gnd\\\"\" componentName \"subcircuit\" instParameters \"\" otherParameters \"\" netlistProcedure \"ansLvsCompPrim\") auCdl (nil dollarEqualParams \"\" dollarParams \"\" modelName \"\" namePrefix \"X\" propMapping \"\" termOrder \"\\\"vin1\\\" \\\"vin2\\\" \\\"vout\\\" \\\"vdd\\\" \\\"gnd\\\"\" componentName \"subcircuit\" instParameters \"\" otherParameters \"\" netlistProcedure \"ansCdlSubcktCall\") spectre (nil modelParamExprList \"\" optParamExprList \"\" opParamExprList \"\" stringParameters \"\" propMapping \"\" termMapping \"\" termOrder \"\\\"vin1\\\" \\\"vin2\\\" \\\"vout\\\" \\\"vdd\\\" \\\"gnd\\\"\" componentName \"subcircuit\" instParameters \"\" otherParameters \"\" netlistProcedure \"\") hspiceD (nil opParamExprList \"\" optParamExprList \"\" propMapping \"\" termMapping \"\" termOrder \"\\\"vin1\\\" \\\"vin2\\\" \\\"vout\\\" \\\"vdd\\\" \\\"gnd\\\"\" namePrefix \"X\" componentName \"subcircuit\" instParameters \"\" otherParameters \"\" netlistProcedure \"\"))\n")
      fprintf(cdfFile "(nil paramLabelSet \"wp wn\" opPointLabelSet nil modelLabelSet nil paramDisplayMode \"parameter\" paramEvaluate \"t nil nil nil nil\" paramSimType \"DC\" termDisplayMode \"none\" termSimType \"DC\" netNameType \"schematic\" instDisplayMode \"instName\" instNameType \"schematic\")\n")
      fprintf(cdfFile "(nil doneProc \"\" formInitProc \"\" promptWidth 175 fieldWidth 350 buttonFieldWidth 340 fieldHeight 35)\n\n")
      close(cdfFile)
    )
    printf("CDF saved.\n")
  )
)

;; Build both from scratch
createNandGate("nand" nil)
createNandGate("nand_sym" t)
exit()
