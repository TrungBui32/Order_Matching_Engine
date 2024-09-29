`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 04:38:52 PM
// Design Name: 
// Module Name: uart_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_rx (
    input wire clk,            
    input wire rst,             
    input wire rx,              
    output reg [32:0] data_out, 
    output reg data_ready       
);

    parameter CLK_FREQ = 100000000;  
    parameter BAUD_RATE = 9600;    
    localparam CLK_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg [15:0] clk_count = 0;
    reg [3:0] bit_count = 0;
    reg [32:0] rx_shift_reg = 0;
    reg receiving = 0;
    reg [1:0] state = 0;  // 0: idle, 1: receiving, 2: done

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_count <= 0;
            bit_count <= 0;
            state <= 0;
            receiving <= 0;
            data_ready <= 0;
            data_out <= 0;
        end else begin
            case (state)
                0: begin
                    // Idle state, waiting for start bit
                    if (rx == 0) begin  // Start bit detected
                        state <= 1;
                        clk_count <= 0;
                        bit_count <= 0;
                    end
                end

                1: begin
                    // Receiving state
                    clk_count <= clk_count + 1;
                    if (clk_count >= CLK_PER_BIT) begin
                        clk_count <= 0;
                        bit_count <= bit_count + 1;

                        if (bit_count > 0 && bit_count < 82) begin
                            // Read data bits
                            rx_shift_reg <= {rx, rx_shift_reg[32:1]};
                        end else if (bit_count == 34) begin
                            // Stop bit (ignored here, assuming valid)
                            data_out <= rx_shift_reg;
                            data_ready <= 1;
                            state <= 2;
                        end
                    end
                end

                2: begin
                    // Done state, waiting for data to be read
                    if (data_ready == 0) begin
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule