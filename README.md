# CNN Digital Accelerator

## Overview
This repository contains the implementation of a **Convolutional Neural Network (CNN) digital accelerator** designed in **SystemVerilog** to perform image convolution on a **512x512 image** with a throughput of **5.7 GOPS**. The accelerator is optimized for **high-speed operation**, **area efficiency**, and **power efficiency**, achieving superior performance compared to a **C-based CPU implementation**.

## Features
- **Designed in SystemVerilog** for FPGA-based acceleration of image convolution.
- **Achieves a throughput of 5.7 GOPS** with optimized pipeline design.
- **Maximum operating frequency of 273.149 MHz**, verified through Quartus II timing analysis.
- **Synthesizable for Arria 10 GX FPGA**.
- **Comprehensive verification** using ModelSim with a testbench that compares every pixel to the expected output.

## Repository Structure
```
📂 FPGA-ImageConvolution
│── 📂 lab2_Theeban_Kumaresan.qar      # Quartus archive file for synthesis & implementation
│── 📄 lab2.sv    # Main SystemVerilog source file
│── 📄 README.md             # Project documentation (this file)
```

## Getting Started
### Prerequisites
- **Quartus II** (for synthesis and analysis)
- **ModelSim** (for simulation and verification)
- **Arria 10 GX FPGA Development Kit** (for hardware deployment)

### Running the Simulation
1. Open **ModelSim** and compile `lab2.sv` along with the testbench.
2. Run the simulation and check the output against expected pixel values.

### Synthesizing with Quartus II
1. Open **Quartus II** and load the provided Quartus project archive.
2. Perform **Analysis & Synthesis**.
3. Run **Fitter (Place & Route)**.
4. Perform **Timing Analysis** to verify the maximum frequency.
5. Generate the programming file and deploy it to the **Arria 10 GX FPGA**.

## Performance Metrics
- **Throughput:** 5.7 GOPS
- **Max Frequency:** 273.149 MHz
- **Comparison vs CPU:** Higher speed, better area, and power efficiency

## Verification
The accelerator is **verified in ModelSim** with a testbench that:
- Inputs a 512x512 image.
- Compares every output pixel to the expected result.
- Flags discrepancies for debugging.

## License
This project is open-source under the **MIT License**.

## Contact
For any questions or contributions, feel free to reach out via GitHub or email.

