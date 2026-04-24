# Pipelined RISC CPU Implementation in Verilog

## Overview
This repository contains a structural Verilog implementation of the pipelined RISC processor described in the foundational textbook, "Logic and Computer Design Fundamentals" by M. Morris Mano and Charles R. Kime. The project includes the entire datapath and control unit, verified through comprehensive unit testing of each sub-block and a full-system simulation executing an assembly multiplication program.

## Design Scope & Key Features
This implementation accurately maps the multi-stage pipelined datapath architecture from the textbook. However, to simplify the hardware control logic, this specific iteration omits advanced hardware hazard mitigation features:
* No Data Forwarding (Bypassing)
* No Branch Prediction

Because the pipeline lacks hardware hazard detection, data dependencies and control hazards are managed entirely in software. Successful program execution requires the manual insertion of **NOP (No-Operation)** instructions to flush the pipeline and ensure correct register write-backs before dependent instructions are fetched and executed.

## File Structure & Module Organization
The project is organized structurally, mirroring the sub-sections of the CPU design. The top-level module is `risc_cpu.v`, which instantiates all the functional sub-modules, with `risc_cpu_tb.v` serving as the main system-level testbench.

* `mux_A_B.v` / `mux_C.v` / `mux_d.v` - Datapath multiplexers
* `instruction_decoder.v` - Control unit main decoder
* `instruction_mem.v` - Primary instruction memory (ROM)
* `data_memory.v` - Read/Write data memory (RAM)
* `function_unit.v` - The Arithmetic Logic Unit (ALU)
* `regfile.v` - The 32x32 register file
* `constant_unit.v` - Generation of immediate constants
* `risc_cpu.v` - The top-level integration of the CPU datapath and control
* `asm_param.inc` - Parameters and definitions for assembly opcodes

## Verification & System-Level Simulation
Verification was a critical phase of this project, conducted systematically from the ground up:
1. **Unit Testing:** Every major sub-module (ALU, Register File, Multiplexers, Memory) was verified with dedicated Verilog testbenches prior to top-level integration.
2. **System-Level Simulation:** The final validation of the CPU was achieved by running a custom assembly program in simulation to perform integer multiplication. 

By strategically inserting NOPs to handle the pipeline hazards, the CPU successfully fetched, decoded, and executed the multiplication program. The final waveforms trace the Program Counter (PC), instruction memory fetching, register updating, and final product calculation, confirming the structural integrity of the pipeline.

## Documentation
* [CPU Architecture Design & Simulation Waveforms](./docs/CPU_Design_and_Verification.pdf) 
*(Contains structural block diagrams, individual unit tests, and the full-system multiplication simulation waveforms).*

## Tools & Development Environment
* **Hardware Description Language:** Verilog
* **Simulation Compiler:** Icarus Verilog
* **Waveform Viewer:** WaveTrace (VSCode Extension)
* **Architecture Reference:** "Logic and Computer Design Fundamentals" (Mano & Kime)
