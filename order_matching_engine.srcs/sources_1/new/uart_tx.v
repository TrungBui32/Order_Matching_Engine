`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 04:38:52 PM
// Design Name: 
// Module Name: uart_tx
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


module uart_tx (
    input wire clk,            
    input wire rst,            
    input wire [32:0] data_in,  
    input wire send,         
    output reg tx,           
    output reg ready           
);

    parameter CLK_FREQ = 100000000;  
    parameter BAUD_RATE = 9600;     
    localparam CLK_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg [15:0] clk_count = 0;
    reg [3:0] bit_count = 0;
    reg [34:0] tx_shift_reg = 0;  // Start bit, data bits, stop bit

    reg sending = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_count <= 0;
            bit_count <= 0;
            tx <= 1;  // Idle state for UART is high
            ready <= 1;
            sending <= 0;
        end else begin
            if (send && ready) begin
                // Start transmitting: build shift register (start + data + stop)
                tx_shift_reg <= {1'b1, data_in, 1'b0};  // Stop bit = 1, start bit = 0
                sending <= 1;
                ready <= 0;
            end

            if (sending) begin
                clk_count <= clk_count + 1;
                if (clk_count >= CLK_PER_BIT) begin
                    clk_count <= 0;
                    bit_count <= bit_count + 1;

                    if (bit_count < 35) begin
                        tx <= tx_shift_reg[bit_count];  // Transmit bits in order
                    end else begin
                        // Transmission complete
                        sending <= 0;
                        ready <= 1;
                        bit_count <= 0;
                        tx <= 1;  // Idle state
                    end
                end
            end
        end
    end
endmodule



