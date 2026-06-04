# 04. 1011 Sequence Detector

## Overview

This project implements a serial sequence detector for the bit pattern `1011`.

The detector receives one input bit per clock cycle and asserts an output when the target sequence is detected.


## Design Goal

The goal of this project is to practice finite state machine design in Verilog.

The FSM tracks the progress of the received bit stream and detects when the sequence `1011` appears.


## Files

04_1011_detector/

├── rtl/
│   └── synchronizer.v
│   └── sequence_detector.v
│   └── top.v

├── tb/
│   └── tb_top.v

└── README.md



