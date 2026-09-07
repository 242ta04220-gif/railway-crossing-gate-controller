`timescale 1ns/1ps

module railway_crossing_tb;

    reg clk;
    reg reset;

    reg train_approaching;
    reg train_present;

    wire gate_open;
    wire gate_closed;
    wire warning_light;
    wire warning_buzzer;

    // ------------------------------------------------
    // Device Under Test
    // ------------------------------------------------

    railway_crossing dut (

        .clk(clk),
        .reset(reset),

        .train_approaching(train_approaching),
        .train_present(train_present),

        .gate_open(gate_open),
        .gate_closed(gate_closed),
        .warning_light(warning_light),
        .warning_buzzer(warning_buzzer)
    );

    // ------------------------------------------------
    // Clock generation
    // ------------------------------------------------

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    // ------------------------------------------------
    // Test sequence
    // ------------------------------------------------

    initial begin

        // Initial conditions
        reset            = 1'b1;
        train_approaching = 1'b0;
        train_present     = 1'b0;

        #20;

        reset = 1'b0;

        // ============================================
        // TEST 1: Normal condition
        // ============================================

        $display("----------------------------------------");
        $display("TEST 1: NORMAL CONDITION");
        $display("----------------------------------------");

        #20;

        $display("Gate Open   = %b", gate_open);
        $display("Gate Closed = %b", gate_closed);

        // ============================================
        // TEST 2: Train approaching
        // ============================================

        $display("----------------------------------------");
        $display("TEST 2: TRAIN APPROACHING");
        $display("----------------------------------------");

        train_approaching = 1'b1;

        #70;

        $display("Warning Light = %b", warning_light);
        $display("Warning Buzzer = %b", warning_buzzer);
        $display("Gate Open = %b", gate_open);
        $display("Gate Closed = %b", gate_closed);

        // ============================================
        // TEST 3: Train passing
        // ============================================

        $display("----------------------------------------");
        $display("TEST 3: TRAIN PASSING");
        $display("----------------------------------------");

        train_approaching = 1'b0;
        train_present     = 1'b1;

        #40;

        $display("Gate Open = %b", gate_open);
        $display("Gate Closed = %b", gate_closed);
        $display("Warning Light = %b", warning_light);

        // ============================================
        // TEST 4: Train cleared
        // ============================================

        $display("----------------------------------------");
        $display("TEST 4: TRAIN CLEARED");
        $display("----------------------------------------");

        train_present = 1'b0;

        #20;

        $display("Gate Open = %b", gate_open);
        $display("Gate Closed = %b", gate_closed);
        $display("Warning Light = %b", warning_light);
        $display("Warning Buzzer = %b", warning_buzzer);

        // ============================================
        // End simulation
        // ============================================

        $display("----------------------------------------");
        $display("SIMULATION COMPLETED");
        $display("----------------------------------------");

        #20;

        $finish;

    end

    // ------------------------------------------------
    // Monitor
    // ------------------------------------------------

    initial begin

        $monitor(
            "Time=%0t | Approach=%b | Train=%b | GateOpen=%b | GateClosed=%b | Light=%b | Buzzer=%b",
            $time,
            train_approaching,
            train_present,
            gate_open,
            gate_closed,
            warning_light,
            warning_buzzer
        );

    end

endmodule
