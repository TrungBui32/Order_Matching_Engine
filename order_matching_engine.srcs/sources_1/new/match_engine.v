`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 06:44:00 PM
// Design Name: 
// Module Name: match_engine
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


module match_engine(
    input clk,
    input rst,
    input [32:0] buy_data_in,  			
    input [32:0] sell_data_in, 			
    input buy_fifo_empty,      			
    input sell_fifo_empty,     			
    output reg buy_fifo_rd_en, 			
    output reg sell_fifo_rd_en,			
    output reg [32:0] matched_data, 	
    output reg match_found      		
    );
    
    reg [31:24] buy_price, sell_price;  // Extracted price from the buy/sell orders
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            buy_fifo_rd_en <= 0;
            sell_fifo_rd_en <= 0;
            matched_data <= 0;
            match_found <= 0;
        end else if (!buy_fifo_empty && !sell_fifo_empty) begin
            // Extract prices from buy/sell orders
            buy_price <= buy_data_in[31:24];    
            sell_price <= sell_data_in[31:24];  
            
            if (buy_price >= sell_price) begin
                // A match is found
                match_found <= 1;
                matched_data <= buy_data_in; 
                
                // Enable reading from both FIFOs (remove matched orders)
                buy_fifo_rd_en <= 1;
                sell_fifo_rd_en <= 1;
            end else begin
                // No match, disable reads
                match_found <= 0;
                buy_fifo_rd_en <= 0;
                sell_fifo_rd_en <= 0;
            end
        end else begin
            // One or both FIFOs are empty, disable reads and no match
            buy_fifo_rd_en <= 0;
            sell_fifo_rd_en <= 0;
            match_found <= 0;
        end
    end
endmodule