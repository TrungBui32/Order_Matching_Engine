`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 05:22:42 PM
// Design Name: 
// Module Name: fifo
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


module fifo (
    input wire clk,                	
    input wire rst,                	
    input wire wr_en,              
    input wire rd_en,              
    input wire [32:0] data_in,      
    output reg [32:0] data_out,     
    output reg full,               	
    output reg empty               
);

    parameter FIFO_DEPTH = 16;     			
    reg [32:0] fifo_mem [FIFO_DEPTH-1:0];  	
    reg [3:0] write_ptr = 0;       			
    reg [3:0] read_ptr = 0;       			
    reg [4:0] fifo_count = 0;      			
	
	// check full or empty 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            full <= 0;
            empty <= 1;
        end else begin
            full <= (fifo_count == FIFO_DEPTH);
            empty <= (fifo_count == 0);
        end
    end
	
	// write data in
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
        end
    end
	
	// read data out
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            read_ptr <= 0;
            data_out <= 32'd0;
        end else if (rd_en && !empty) begin
            data_out <= fifo_mem[read_ptr];
            read_ptr <= read_ptr + 1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fifo_count <= 0;
        end else begin
			// increase fifo_count if not full yet and not read simultaneously unless it empty
            if (wr_en && !full && !(rd_en && !empty)) begin
                fifo_count <= fifo_count + 1;  
			// decrease fifo_count if it not empty and not write simultaneously unless it full
            end else if (rd_en && !empty && !(wr_en && !full)) begin
                fifo_count <= fifo_count - 1;  
            end
        end
    end

endmodule

