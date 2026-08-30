# VLSI Design Laboratory - Cadence Virtuoso CAD Flow

Academic lab records for VLSI Design using Cadence custom IC design tools. This repository documents schematic capture, layout design, physical verification (DRC & LVS), and parasitic extraction.

## VLSI Cell Catalog
- **Lab 1: Inverter Simulation**: Basic schematic entry and DC/transient simulation of a CMOS inverter cell (`lab1_inverter_sim`).
- **Lab 2 & Lab 2.2: Static Inverter Layout**:
  - CMOS Inverter layout design matching DRC rules.
  - LVS verification mapping schematic ports against layout contacts.
  - Quantus QRC parasitic extraction comparing post-layout RC parasitics vs. ideal schematic waveforms.
- **Lab 3: CMOS Static NAND Gate**: Two-input static NAND gate schematic design, layout, and DRC/LVS physical verification.
- **Lab 4: Dynamic Inverter**: Design and transient timing analysis of a dynamic logic inverter.
- **Lab 4_v2: Dynamic NAND Gate**: Dynamic two-input NAND logic circuit implementation.
- **Lab 5: D Flip-Flop (D-FF)**: Schematic and layout design of a standard memory cell (D-type Flip-Flop).
- **Lab 20: Transistor Layout**: Detailed layout, DRC, and LVS validation of single NMOS/PMOS transistor layouts.

## Directory Structure
```text
VD_lab/
├── labX/                       # Academic Lab directories
│   ├── library/                # Cadence Virtuoso cell library folder
│   ├── workspace/              # Cadence run workspaces
│   ├── layout/                 # Assura / PVS DRC and LVS run databases
│   └── graph_and_screenshot/   # Waveforms and layout screenshots
├── Makefile                    # Utility to create lab template folders
└── cds.lib                     # Link to Cadence library definitions configuration
```

## CAD Tool Stack
- **Schematic & Layout Capture**: Cadence Virtuoso (IC617 or newer)
- **Physical Verification**: Assura LVS / PVS (Physical Verification System)
- **Parasitic Extraction**: Cadence Quantus QRC
- **Simulation engine**: Cadence Spectre (Analog Design Environment - ADE)\n