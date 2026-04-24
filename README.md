# RISC CPU Implementation in Verilog (Mano & Kime)

## Overview
This repository contains a structural Verilog implementation of the single-cycle RISC processor described in the foundational textbook, "Logic and Computer Design Fundamentals" (4th Edition or similar) by M. Morris Mano and Charles R. Kime. The project includes the entire datapath and control unit, verified through comprehensive unit testing of each sub-block and a full-system simulation executing a sample program.

## Design Scope & Key Features
This implementation is based on the **non-pipelined** version of the RISC CPU. While it accurately maps the textbook's architecture, it does not include features such as:
* Data forwarding
* Branch prediction

Consequently, consistent with the textbook's performance model, successful program execution on this processor requires the explicit insertion of a **NOP (No-Operation)** instruction following every operational instruction to ensure proper data dependency and control flow management.

## File Structure & Module Organization
The project is organized structurally, mirroring the sub-sections of the textbook. The top-level module is `risc_cpu.v`, which instantiates all the functional sub-modules, with `risc_cpu_tb.v` serving as the main system-level testbench for running programs.

* `mux_A_B.v` - Datapath multiplexers
* `mux_C.v`
* `mux_d.v`
* `instruction_decoder.v` - Control unit main decoder
* `instruction_mem.v` - Primary instruction memory (ROM)
* `data_memory.v` - Read/Write data memory (RAM)
* `function_unit.v` - The Arithmetic Logic Unit (ALU)
* `regfile.v` - The register file (e.g., 32x32)
* `constant_unit.v` - Generation of immediate constants
* `risc_cpu.v` - The top-level integration of the CPU datapath and control
* `asm_param.inc` - Parameters and definitions for assembly opcodes

### Verification Plan
Verification was a critical phase of this project, conducted in two stages: unit-level and system-level.

#### Unit Testing
Every major sub-module was verified with a dedicated testbench before integration. Detailed unit test waveform results for individual blocks (e.g., ALU operations, register file reads/writes, memory access) are available, demonstrating the isolated functionality of each component.

#### System-Level Simulation (Multiplication Program)
The final validation of the CPU was achieved by running a small assembly program in simulation. The chosen program demonstrates the processor's capability by performing integer multiplication.

The final waveform results, included in the documentation, show the full CPU executing this program. The waveforms trace key internal signals, such as the Program Counter (PC), instruction fetching, register contents updating, and memory operations, culminating in the correct final product of the multiplication being stored, thus confirming the successful full-system integration and instruction-set correctness.

*(You can now add links to your presentations and waveforms here if they are in PDF or other viewable formats in your repo)*

## Tools & Development Environment
* **Hardware Description Language:** Verilog
* **Simulation/Verification:** (e.g., ModelSim, Icarus Verilog, or Xilinx Vivado - state what you used)
* **Architecture Reference:** "Logic and Computer Design Fundamentals" (Mano & Kime)
