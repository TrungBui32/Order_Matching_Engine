`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 06:43:12 PM
// Design Name: 
// Module Name: order_matching_engine
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


module order_matching_engine (
    input wire clk,
    input wire rst,
    input wire  type, 
    input wire [15:0] price,      
    input wire [15:0] quantity,   
    input wire order_type,        // 0 for Buy, 1 for Sell
    input wire submit_order,      
    output wire [31:0] matched_price, 
    output wire [31:0] matched_quantity 
);

    wire [31:0] buy_order_price;
    wire [15:0] buy_order_quantity;
    wire [31:0] sell_order_price;
    wire [15:0] sell_order_quantity;

    order_buffer ob (
        .clk(clk),
        .rst(rst),
        .price(price),
        .quantity(quantity),
        .order_type(order_type),
        .submit_order(submit_order),
        .buy_order_price(buy_order_price),
        .buy_order_quantity(buy_order_quantity),
        .sell_order_price(sell_order_price),
        .sell_order_quantity(sell_order_quantity)
    );

//    match_engine me (
//        .clk(clk),
//        .rst(rst),
//        .buy_order_price(buy_order_price),
//        .buy_order_quantity(buy_order_quantity),
//        .sell_order_price(sell_order_price),
//        .sell_order_quantity(sell_order_quantity),
//        .matched_price(matched_price),
//        .matched_quantity(matched_quantity)
//    );

endmodule

