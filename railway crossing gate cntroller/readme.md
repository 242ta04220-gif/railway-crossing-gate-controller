 Railway Crossing Gate Controller using Verilog

A railway level-crossing gate controller designed using Verilog HDL.

Overview

The controller detects an approaching train and automatically controls
the railway crossing gate.

When a train approaches:

1. Warning light turns ON.
2. Warning buzzer turns ON.
3. Gate closes.
4. Gate remains closed while the train is passing.
5. After the train clears the crossing, the gate opens.
6. The system returns to the normal state.

> This is an educational RTL simulation project. Real railway crossing
> systems are safety-critical and require certified fail-safe hardware,
> redundant sensors, and extensive verification.

 Features

- FSM-based design
- Train approach detection
- Train presence detection
- Automatic gate control
- Warning light
- Warning buzzer
- Verilog testbench

 FSM States

```text
             Train Approaching
                    |
                    v
                  WARNING
                    |
                    v
               CLOSE_GATE
                    |
                    v
                TRAIN_PASS
                    |
              Train Cleared
                    |
                    v
                OPEN_GATE
                    |
                    v
                   IDLE
