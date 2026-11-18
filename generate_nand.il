let((cv symCv nmosMaster pmosMaster ipinMaster opinMaster
     pm0 pm1 nm0 nm1
     pinVdd pinGnd pinVin1 pinVin2 pinVout
     netVdd netGnd netVin1 netVin2 netVout netMid
     net pin rect cdfFile)

  ;; ==========================================
  ;; 1. BUILD CELL: nand (wn, wp parameters)
  ;; ==========================================
  printf(">>> Building cell: nand from scratch\n")
  cv = dbOpenCellViewByType("standard_logic_components" "nand" "schematic" "schematic" "w")
  nmosMaster = dbOpenCellViewByType("gpdk180" "nmos" "symbol" "" "r")
  pmosMaster = dbOpenCellViewByType("gpdk180" "pmos" "symbol" "" "r")
  ipinMaster = dbOpenCellViewByType("basic" "ipin" "symbol" "" "r")
  opinMaster = dbOpenCellViewByType("basic" "opin" "symbol" "" "r")

  ;; Transistors
  pm0 = dbCreateInst(cv pmosMaster "PM0" list(-0.8 1.8125) "R0")
  dbCreateProp(pm0 "w" "string" "pPar(\"wp\")")
  pm1 = dbCreateInst(cv pmosMaster "PM1" list(0.3 1.8125) "R0")
  dbCreateProp(pm1 "w" "string" "pPar(\"wp\")")

  nm0 = dbCreateInst(cv nmosMaster "NM0" list(-0.25 1.1875) "R0")
  dbCreateProp(nm0 "w" "string" "pPar(\"wn\")")
  nm1 = dbCreateInst(cv nmosMaster "NM1" list(-0.25 0.3875) "R0")
  dbCreateProp(nm1 "w" "string" "pPar(\"wn\")")

  ;; Pins
  pinVdd  = dbCreateInst(cv ipinMaster "PIN_VDD"  list(-0.25 2.5)  "R0")
  pinGnd  = dbCreateInst(cv ipinMaster "PIN_GND"  list(-0.25 -0.2) "R0")
  pinVin1 = dbCreateInst(cv ipinMaster "PIN_VIN1" list(-1.8 1.8125) "R0")
  pinVin2 = dbCreateInst(cv ipinMaster "PIN_VIN2" list(-1.8 0.3875) "R0")
  pinVout = dbCreateInst(cv opinMaster "PIN_VOUT" list(1.4 1.4)    "R0")

  ;; Nets
  netVdd  = dbMakeNet(cv "vdd")
  netGnd  = dbMakeNet(cv "gnd")
  netVin1 = dbMakeNet(cv "vin1")
  netVin2 = dbMakeNet(cv "vin2")
  netVout = dbMakeNet(cv "vout")
  netMid  = dbMakeNet(cv "net_mid")

  ;; Terminals
  dbCreatePin(netVdd  dbCreateRect(cv list("pin" "drawing") list(-0.275 2.475 -0.225 2.525)) "vdd")
  dbCreatePin(netGnd  dbCreateRect(cv list("pin" "drawing") list(-0.275 -0.225 -0.225 -0.175)) "gnd")
  dbCreatePin(netVin1 dbCreateRect(cv list("pin" "drawing") list(-1.825 1.7875 -1.775 1.8375)) "vin1")
  dbCreatePin(netVin2 dbCreateRect(cv list("pin" "drawing") list(-1.825 0.3625 -1.775 0.4125)) "vin2")
  dbCreatePin(netVout dbCreateRect(cv list("pin" "drawing") list(1.375 1.375 1.425 1.425)) "vout")

  ;; Connections
  dbCreateConnByName(netVdd  pm0 "S")
  dbCreateConnByName(netVout pm0 "D")
  dbCreateConnByName(netVin1 pm0 "G")
  dbCreateConnByName(netVdd  pm0 "B")

  dbCreateConnByName(netVdd  pm1 "S")
  dbCreateConnByName(netVout pm1 "D")
  dbCreateConnByName(netVin2 pm1 "G")
  dbCreateConnByName(netVdd  pm1 "B")

  dbCreateConnByName(netVout nm0 "D")
  dbCreateConnByName(netMid  nm0 "S")
  dbCreateConnByName(netVin1 nm0 "G")
  dbCreateConnByName(netGnd  nm0 "B")

  dbCreateConnByName(netMid  nm1 "D")
  dbCreateConnByName(netGnd  nm1 "S")
  dbCreateConnByName(netVin2 nm1 "G")
  dbCreateConnByName(netGnd  nm1 "B")

  ;; Wires
  dbCreateLine(cv list("wire" "drawing") list(list(-0.25 2.5) list(-0.25 2.2)))
  dbCreateLine(cv list("wire" "drawing") list(list(-0.55 2.2) list(0.55 2.2)))
  dbCreateLine(cv list("wire" "drawing") list(list(-0.55 2.2) list(-0.55 2.0)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.55 2.2) list(0.55 2.0)))

  dbCreateLine(cv list("wire" "drawing") list(list(-0.55 1.6) list(-0.55 1.4)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.55 1.6) list(0.55 1.4)))
  dbCreateLine(cv list("wire" "drawing") list(list(-0.55 1.4) list(1.4 1.4)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.0 1.4) list(0.0 1.375)))

  dbCreateLine(cv list("wire" "drawing") list(list(0.0 1.0) list(0.0 0.575)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.0 0.2) list(0.0 0.0)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.0 0.0) list(-0.25 0.0)))
  dbCreateLine(cv list("wire" "drawing") list(list(-0.25 0.0) list(-0.25 -0.2)))

  dbCreateLine(cv list("wire" "drawing") list(list(-1.8 1.8125) list(-0.8 1.8125)))
  dbCreateLine(cv list("wire" "drawing") list(list(-1.2 1.8125) list(-1.2 1.1875)))
  dbCreateLine(cv list("wire" "drawing") list(list(-1.2 1.1875) list(-0.25 1.1875)))

  dbCreateLine(cv list("wire" "drawing") list(list(-1.8 0.3875) list(-0.25 0.3875)))
  dbCreateLine(cv list("wire" "drawing") list(list(-1.4 0.3875) list(-1.4 2.3)))
  dbCreateLine(cv list("wire" "drawing") list(list(-1.4 2.3) list(0.1 2.3)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.1 2.3) list(0.1 1.8125)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.1 1.8125) list(0.3 1.8125)))

  dbCreateEllipse(cv list("wire" "drawing") list(list(-0.27 2.18) list(-0.23 2.22)))
  dbCreateEllipse(cv list("wire" "drawing") list(list(-0.02 1.38) list(0.02 1.42)))
  dbCreateEllipse(cv list("wire" "drawing") list(list(-1.22 1.7925) list(-1.18 1.8325)))
  dbCreateEllipse(cv list("wire" "drawing") list(list(-1.42 0.3675) list(-1.38 0.4075)))

  dbSave(cv)
  dbClose(cv)

  ;; Symbol for nand
  symCv = dbOpenCellViewByType("standard_logic_components" "nand" "symbol" "schematicSymbol" "w")
  dbCreateLine(symCv list("device" "drawing") list(list(-0.3 -0.4) list(-0.3 0.4)))
  dbCreateLine(symCv list("device" "drawing") list(list(-0.3 0.4) list(0.0 0.4)))
  dbCreateLine(symCv list("device" "drawing") list(list(-0.3 -0.4) list(0.0 -0.4)))
  dbCreateArc(symCv list("device" "drawing") list(list(0.0 -0.4) list(0.3 0.4)) list(0.0 -0.4) list(0.0 0.4))
  dbCreateEllipse(symCv list("device" "drawing") list(list(0.3 -0.05) list(0.4 0.05)))
  dbCreateLine(symCv list("device" "drawing") list(list(-0.5 0.2) list(-0.3 0.2)))
  dbCreateLine(symCv list("device" "drawing") list(list(-0.5 -0.2) list(-0.3 -0.2)))
  dbCreateLine(symCv list("device" "drawing") list(list(0.4 0.0) list(0.6 0.0)))
  dbCreateLine(symCv list("device" "drawing") list(list(0.0 0.4) list(0.0 0.6)))
  dbCreateLine(symCv list("device" "drawing") list(list(0.0 -0.4) list(0.0 -0.6)))
  dbCreateRect(symCv list("instance" "drawing") list(list(-0.5 -0.6) list(0.6 0.6)))
  dbCreateLabel(symCv list("instance" "label") list(-0.3 0.65) "[@instanceName]" "lowerLeft" "R0" "roman" 0.0625)
  dbCreateLabel(symCv list("device" "label")   list(-0.2 -0.05) "nand" "centerLeft" "R0" "roman" 0.0625)

  net = dbMakeNet(symCv "vin1")
  rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.525 0.175) list(-0.475 0.225)))
  pin = dbCreatePin(net rect "vin1")
  pin~>term~>direction = "input"
  dbCreateLabel(symCv list("pin" "label") list(-0.45 0.22) "vin1" "lowerLeft" "R0" "roman" 0.05)

  net = dbMakeNet(symCv "vin2")
  rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.525 -0.225) list(-0.475 -0.175)))
  pin = dbCreatePin(net rect "vin2")
  pin~>term~>direction = "input"
  dbCreateLabel(symCv list("pin" "label") list(-0.45 -0.18) "vin2" "lowerLeft" "R0" "roman" 0.05)

  net = dbMakeNet(symCv "vout")
  rect = dbCreateRect(symCv list("pin" "drawing") list(list(0.575 -0.025) list(0.625 0.025)))
  pin = dbCreatePin(net rect "vout")
  pin~>term~>direction = "output"
  dbCreateLabel(symCv list("pin" "label") list(0.48 0.03) "vout" "lowerLeft" "R0" "roman" 0.05)

  net = dbMakeNet(symCv "vdd")
  rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.025 0.575) list(0.025 0.625)))
  pin = dbCreatePin(net rect "vdd")
  pin~>term~>direction = "input"

  net = dbMakeNet(symCv "gnd")
  rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.025 -0.625) list(0.025 -0.575)))
  pin = dbCreatePin(net rect "gnd")
  pin~>term~>direction = "input"

  dbSave(symCv)
  dbClose(symCv)
  printf("nand schematic and symbol created.\n")

  ;; ==========================================
  ;; 2. BUILD CELL: nand_sym (scaling factor s)
  ;; ==========================================
  printf(">>> Building cell: nand_sym from scratch\n")
  cv = dbOpenCellViewByType("standard_logic_components" "nand_sym" "schematic" "schematic" "w")

  pm0 = dbCreateInst(cv pmosMaster "PM0" list(-0.8 1.8125) "R0")
  dbCreateProp(pm0 "w" "string" "pPar(\"s\")*800n")
  pm1 = dbCreateInst(cv pmosMaster "PM1" list(0.3 1.8125) "R0")
  dbCreateProp(pm1 "w" "string" "pPar(\"s\")*800n")

  nm0 = dbCreateInst(cv nmosMaster "NM0" list(-0.25 1.1875) "R0")
  dbCreateProp(nm0 "w" "string" "pPar(\"s\")*800n")
  nm1 = dbCreateInst(cv nmosMaster "NM1" list(-0.25 0.3875) "R0")
  dbCreateProp(nm1 "w" "string" "pPar(\"s\")*800n")

  pinVdd  = dbCreateInst(cv ipinMaster "PIN_VDD"  list(-0.25 2.5)  "R0")
  pinGnd  = dbCreateInst(cv ipinMaster "PIN_GND"  list(-0.25 -0.2) "R0")
  pinVin1 = dbCreateInst(cv ipinMaster "PIN_VIN1" list(-1.8 1.8125) "R0")
  pinVin2 = dbCreateInst(cv ipinMaster "PIN_VIN2" list(-1.8 0.3875) "R0")
  pinVout = dbCreateInst(cv opinMaster "PIN_VOUT" list(1.4 1.4)    "R0")

  netVdd  = dbMakeNet(cv "vdd")
  netGnd  = dbMakeNet(cv "gnd")
  netVin1 = dbMakeNet(cv "vin1")
  netVin2 = dbMakeNet(cv "vin2")
  netVout = dbMakeNet(cv "vout")
  netMid  = dbMakeNet(cv "net_mid")

  dbCreatePin(netVdd  dbCreateRect(cv list("pin" "drawing") list(-0.275 2.475 -0.225 2.525)) "vdd")
  dbCreatePin(netGnd  dbCreateRect(cv list("pin" "drawing") list(-0.275 -0.225 -0.225 -0.175)) "gnd")
  dbCreatePin(netVin1 dbCreateRect(cv list("pin" "drawing") list(-1.825 1.7875 -1.775 1.8375)) "vin1")
  dbCreatePin(netVin2 dbCreateRect(cv list("pin" "drawing") list(-1.825 0.3625 -1.775 0.4125)) "vin2")
  dbCreatePin(netVout dbCreateRect(cv list("pin" "drawing") list(1.375 1.375 1.425 1.425)) "vout")

  dbCreateConnByName(netVdd  pm0 "S")
  dbCreateConnByName(netVout pm0 "D")
  dbCreateConnByName(netVin1 pm0 "G")
  dbCreateConnByName(netVdd  pm0 "B")

  dbCreateConnByName(netVdd  pm1 "S")
  dbCreateConnByName(netVout pm1 "D")
  dbCreateConnByName(netVin2 pm1 "G")
  dbCreateConnByName(netVdd  pm1 "B")

  dbCreateConnByName(netVout nm0 "D")
  dbCreateConnByName(netMid  nm0 "S")
  dbCreateConnByName(netVin1 nm0 "G")
  dbCreateConnByName(netGnd  nm0 "B")

  dbCreateConnByName(netMid  nm1 "D")
  dbCreateConnByName(netGnd  nm1 "S")
  dbCreateConnByName(netVin2 nm1 "G")
  dbCreateConnByName(netGnd  nm1 "B")

  dbCreateLine(cv list("wire" "drawing") list(list(-0.25 2.5) list(-0.25 2.2)))
  dbCreateLine(cv list("wire" "drawing") list(list(-0.55 2.2) list(0.55 2.2)))
  dbCreateLine(cv list("wire" "drawing") list(list(-0.55 2.2) list(-0.55 2.0)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.55 2.2) list(0.55 2.0)))

  dbCreateLine(cv list("wire" "drawing") list(list(-0.55 1.6) list(-0.55 1.4)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.55 1.6) list(0.55 1.4)))
  dbCreateLine(cv list("wire" "drawing") list(list(-0.55 1.4) list(1.4 1.4)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.0 1.4) list(0.0 1.375)))

  dbCreateLine(cv list("wire" "drawing") list(list(0.0 1.0) list(0.0 0.575)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.0 0.2) list(0.0 0.0)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.0 0.0) list(-0.25 0.0)))
  dbCreateLine(cv list("wire" "drawing") list(list(-0.25 0.0) list(-0.25 -0.2)))

  dbCreateLine(cv list("wire" "drawing") list(list(-1.8 1.8125) list(-0.8 1.8125)))
  dbCreateLine(cv list("wire" "drawing") list(list(-1.2 1.8125) list(-1.2 1.1875)))
  dbCreateLine(cv list("wire" "drawing") list(list(-1.2 1.1875) list(-0.25 1.1875)))

  dbCreateLine(cv list("wire" "drawing") list(list(-1.8 0.3875) list(-0.25 0.3875)))
  dbCreateLine(cv list("wire" "drawing") list(list(-1.4 0.3875) list(-1.4 2.3)))
  dbCreateLine(cv list("wire" "drawing") list(list(-1.4 2.3) list(0.1 2.3)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.1 2.3) list(0.1 1.8125)))
  dbCreateLine(cv list("wire" "drawing") list(list(0.1 1.8125) list(0.3 1.8125)))

  dbCreateEllipse(cv list("wire" "drawing") list(list(-0.27 2.18) list(-0.23 2.22)))
  dbCreateEllipse(cv list("wire" "drawing") list(list(-0.02 1.38) list(0.02 1.42)))
  dbCreateEllipse(cv list("wire" "drawing") list(list(-1.22 1.7925) list(-1.18 1.8325)))
  dbCreateEllipse(cv list("wire" "drawing") list(list(-1.42 0.3675) list(-1.38 0.4075)))

  dbSave(cv)
  dbClose(cv)

  ;; Symbol for nand_sym
  symCv = dbOpenCellViewByType("standard_logic_components" "nand_sym" "symbol" "schematicSymbol" "w")
  dbCreateLine(symCv list("device" "drawing") list(list(-0.3 -0.4) list(-0.3 0.4)))
  dbCreateLine(symCv list("device" "drawing") list(list(-0.3 0.4) list(0.0 0.4)))
  dbCreateLine(symCv list("device" "drawing") list(list(-0.3 -0.4) list(0.0 -0.4)))
  dbCreateArc(symCv list("device" "drawing") list(list(0.0 -0.4) list(0.3 0.4)) list(0.0 -0.4) list(0.0 0.4))
  dbCreateEllipse(symCv list("device" "drawing") list(list(0.3 -0.05) list(0.4 0.05)))
  dbCreateLine(symCv list("device" "drawing") list(list(-0.5 0.2) list(-0.3 0.2)))
  dbCreateLine(symCv list("device" "drawing") list(list(-0.5 -0.2) list(-0.3 -0.2)))
  dbCreateLine(symCv list("device" "drawing") list(list(0.4 0.0) list(0.6 0.0)))
  dbCreateLine(symCv list("device" "drawing") list(list(0.0 0.4) list(0.0 0.6)))
  dbCreateLine(symCv list("device" "drawing") list(list(0.0 -0.4) list(0.0 -0.6)))
  dbCreateRect(symCv list("instance" "drawing") list(list(-0.5 -0.6) list(0.6 0.6)))
  dbCreateLabel(symCv list("instance" "label") list(-0.3 0.65) "[@instanceName]" "lowerLeft" "R0" "roman" 0.0625)
  dbCreateLabel(symCv list("device" "label")   list(-0.2 -0.05) "nand_sym" "centerLeft" "R0" "roman" 0.0625)

  net = dbMakeNet(symCv "vin1")
  rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.525 0.175) list(-0.475 0.225)))
  pin = dbCreatePin(net rect "vin1")
  pin~>term~>direction = "input"
  dbCreateLabel(symCv list("pin" "label") list(-0.45 0.22) "vin1" "lowerLeft" "R0" "roman" 0.05)

  net = dbMakeNet(symCv "vin2")
  rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.525 -0.225) list(-0.475 -0.175)))
  pin = dbCreatePin(net rect "vin2")
  pin~>term~>direction = "input"
  dbCreateLabel(symCv list("pin" "label") list(-0.45 -0.18) "vin2" "lowerLeft" "R0" "roman" 0.05)

  net = dbMakeNet(symCv "vout")
  rect = dbCreateRect(symCv list("pin" "drawing") list(list(0.575 -0.025) list(0.625 0.025)))
  pin = dbCreatePin(net rect "vout")
  pin~>term~>direction = "output"
  dbCreateLabel(symCv list("pin" "label") list(0.48 0.03) "vout" "lowerLeft" "R0" "roman" 0.05)

  net = dbMakeNet(symCv "vdd")
  rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.025 0.575) list(0.025 0.625)))
  pin = dbCreatePin(net rect "vdd")
  pin~>term~>direction = "input"

  net = dbMakeNet(symCv "gnd")
  rect = dbCreateRect(symCv list("pin" "drawing") list(list(-0.025 -0.625) list(0.025 -0.575)))
  pin = dbCreatePin(net rect "gnd")
  pin~>term~>direction = "input"

  dbSave(symCv)
  dbClose(symCv)
  printf("nand_sym schematic and symbol created.\n")

  exit()
)
