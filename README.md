# VLSI Design Lab Synchronizer

This repository is used for syncing Cadence Virtuoso designs and project databases from the VLSI Design (VD) laboratory workstation to a local laptop. It contains academic practical files, layout runs, and verification logs.

## Academic Contents
- **lab1**: Schematic entry and DC/transient simulation of a CMOS inverter cell.
- **lab2 & lab2.2**: Static inverter layouts with Assura/PVS DRC & LVS runs, and Quantus QRC parasitic extraction logs.
- **lab3**: 2-input CMOS static NAND gate schematic and layout physical verification.
- **lab4 & lab4_v2**: Dynamic inverter and dynamic NAND gate schematics.
- **lab5**: D Flip-Flop schematic and layout.
- **lab20**: Transistor layouts (NMOS/PMOS) with DRC/LVS checkouts.

## Setup Reference
- `cds.lib`: Links Cadence library paths.
- `Makefile`: Script utility used on lab workstations to instantiate standardized cell views and directory structures.