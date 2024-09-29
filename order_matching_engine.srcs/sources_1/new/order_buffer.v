`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 06:44:00 PM
// Design Name: 
// Module Name: order_buffer
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


module order_buffer (
    input wire clk,
    input wire rst,
    input wire [15:0] price,
    input wire [15:0] quantity,
    input wire order_type,       
    input wire submit_order,
    output reg [15:0] buy_order_price,
    output reg [15:0] buy_order_quantity,
    output reg [15:0] sell_order_price,
    output reg [15:0] sell_order_quantity
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            buy_order_price <= 0;
            buy_order_quantity <= 0;
            sell_order_price <= 0;
            sell_order_quantity <= 0;
        end else if (submit_order) begin
            if (order_type == 0) begin 
                buy_order_price <= price;
                buy_order_quantity <= quantity;
            end else begin 
                sell_order_price <= price;
                sell_order_quantity <= quantity;
            end
        end
    end

endmodule

