`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2024 06:53:25 PM
// Design Name: 
// Module Name: order_matching_engine_tb
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


`timescale 1ns / 1ps

module order_matching_engine_tb;

    reg clk;
    reg rst;
    reg [3:0] stock_type;
    reg [15:0] price;
    reg [15:0] quantity;
    reg order_type;
    reg submit_order;
    wire [15:0] matched_price;
    wire [15:0] matched_quantity;

    // Instantiate the order matching engine
    order_matching_engine ome (
        .clk(clk),
        .rst(rst),
        .stock_type(stock_type),
        .price(price),
        .quantity(quantity),
        .order_type(order_type),
        .submit_order(submit_order),
        .matched_price(matched_price),
        .matched_quantity(matched_quantity)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 100 MHz clock
    end

    initial begin
        clk = 0;
        rst = 1;
        submit_order = 0;

        // Reset
        #10 rst = 0;

        // Test case: Submit buy order
        stock_type = 4'b0000; // FPT
        price = 16'h0010;     // Price = 16
        quantity = 16'h000A;  // Quantity = 10
        order_type = 0;       // Buy
        submit_order = 1;     // Submit order
        #10 submit_order = 0;

        // Test case: Submit sell order
        stock_type = 4'b0001; // VIC
        price = 16'h0008;     // Price = 8
        quantity = 16'h0005;  // Quantity = 5
        order_type = 1;       // Sell
        submit_order = 1;     // Submit order
        #10 submit_order = 0;

        // Further test cases can be added here

        #100 $finish; // End simulation
    end

endmodule

