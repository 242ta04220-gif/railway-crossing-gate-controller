`timescale 1ns/1ps

module railway_crossing (
    input  wire clk,
    input  wire reset,

    // Train detection sensors
    input  wire train_approaching,
    input  wire train_present,

    // Outputs
    output reg gate_open,
    output reg gate_closed,
    output reg warning_light,
    output reg warning_buzzer
);

    // FSM states
    localparam IDLE       = 3'b000;
    localparam WARNING    = 3'b001;
    localparam CLOSE_GATE = 3'b010;
    localparam TRAIN_PASS = 3'b011;
    localparam OPEN_GATE  = 3'b100;

    reg [2:0] state;

    // Warning timer
    reg [3:0] warning_count;

    // ------------------------------------------------
    // Main FSM
    // ------------------------------------------------

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            state         <= IDLE;
            warning_count <= 4'd0;

            gate_open     <= 1'b1;
            gate_closed   <= 1'b0;
            warning_light <= 1'b0;
            warning_buzzer<= 1'b0;

        end

        else begin

            case (state)

                // ------------------------------------
                // IDLE
                // ------------------------------------
                IDLE: begin

                    gate_open      <= 1'b1;
                    gate_closed    <= 1'b0;
                    warning_light  <= 1'b0;
                    warning_buzzer <= 1'b0;
                    warning_count  <= 4'd0;

                    if (train_approaching) begin
                        state <= WARNING;
                    end

                end

                // ------------------------------------
                // WARNING
                // ------------------------------------
                WARNING: begin

                    gate_open      <= 1'b1;
                    gate_closed    <= 1'b0;
                    warning_light  <= 1'b1;
                    warning_buzzer <= 1'b1;

                    if (warning_count < 4'd5) begin
                        warning_count <= warning_count + 1'b1;
                    end

                    else begin
                        warning_count <= 4'd0;
                        state <= CLOSE_GATE;
                    end

                end

                // ------------------------------------
                // CLOSE GATE
                // ------------------------------------
                CLOSE_GATE: begin

                    gate_open      <= 1'b0;
                    gate_closed    <= 1'b1;
                    warning_light  <= 1'b1;
                    warning_buzzer <= 1'b1;

                    state <= TRAIN_PASS;

                end

                // ------------------------------------
                // TRAIN PASSING
                // ------------------------------------
                TRAIN_PASS: begin

                    gate_open      <= 1'b0;
                    gate_closed    <= 1'b1;
                    warning_light  <= 1'b1;
                    warning_buzzer <= 1'b1;

                    // Keep gate closed while train
                    // is detected
                    if (!train_present) begin
                        state <= OPEN_GATE;
                    end

                end

                // ------------------------------------
                // OPEN GATE
                // ------------------------------------
                OPEN_GATE: begin

                    gate_open      <= 1'b1;
                    gate_closed    <= 1'b0;
                    warning_light  <= 1'b0;
                    warning_buzzer <= 1'b0;

                    state <= IDLE;

                end

                // ------------------------------------
                // DEFAULT
                // ------------------------------------
                default: begin

                    state <= IDLE;

                    gate_open      <= 1'b1;
                    gate_closed    <= 1'b0;
                    warning_light  <= 1'b0;
                    warning_buzzer <= 1'b0;

                end

            endcase

        end

    end

endmodule
