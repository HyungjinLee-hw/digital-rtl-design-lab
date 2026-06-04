\# 03. LED Toggle with Button Input



\## Overview



This project implements a button-controlled LED toggle design for an FPGA board.



Unlike a simple LED output, this design handles a real external button input. Since a physical button is asynchronous to the FPGA clock and can bounce, the input must be conditioned before it is used by digital logic.





\## Design Goal



The goal is to toggle an LED whenever a valid button press is detected.



The input path is structured as:



button input

→ synchronizer

→ debounce logic

→ edge/event detection

→ LED toggle register





\## Files

03\_led\_toggle/



├── rtl/

│   ├── synchronize.v

│   ├── debounce.v

│   ├── edge\_detector.v

│   └── led\_controller.v

│   └── top.v



├── tb/

│   └── tb\_top.v



└── README.md



