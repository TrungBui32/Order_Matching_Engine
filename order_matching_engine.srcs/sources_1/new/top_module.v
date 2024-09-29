`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2024 05:46:57 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input wire clk,           
    input wire rst,           
    input wire send,          
    input wire rx,            
    output wire tx,           
    output wire [32:0] matched_data,
    output wire match_found
);
	// Data format: {type, price, quantity, time} with 33 bits in total
	
    wire [32:0] rx_data_out;
    wire data_ready;
    
    wire buy_fifo_empty, sell_fifo_empty;
    wire [32:0] buy_fifo_data_out, sell_fifo_data_out;
    
    wire buy_fifo_rd_en, sell_fifo_rd_en;
    
    wire ready;
    wire wr_en_buy, wr_en_sell;
    
    // UART TX
    uart_tx uart_tx_inst (
        .clk(clk),
        .rst(rst),
        .data_in(matched_data),
        .send(match_found),
        .tx(tx),
        .ready(ready)
    );
    
    // UART RX
    uart_rx uart_rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(rx_data_out),
        .data_ready(data_ready)
    );
    
    // FIFO for buy orders
    fifo buy_fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en_buy),
        .rd_en(buy_fifo_rd_en),
        .data_in(rx_data_out),  
        .data_out(buy_fifo_data_out),
        .full(),
        .empty(buy_fifo_empty)
    );

    // FIFO for sell orders
    fifo sell_fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en_sell),
        .rd_en(sell_fifo_rd_en),
        .data_in(rx_data_out),  
        .data_out(sell_fifo_data_out),
        .full(),
        .empty(sell_fifo_empty)
    );
    
    // Control the FIFO write enable based on received data
    assign wr_en_buy = data_ready && (rx_data_out[32:31] == 2'b01); 	// buy order
    assign wr_en_sell = data_ready && (rx_data_out[32:31] == 2'b10); 	// sell order

    // Match Engine
    match_engine match_engine_inst (
        .clk(clk),
        .rst(rst),
        .buy_data_in(buy_fifo_data_out),
        .sell_data_in(sell_fifo_data_out),
        .buy_fifo_empty(buy_fifo_empty),
        .sell_fifo_empty(sell_fifo_empty),
        .buy_fifo_rd_en(buy_fifo_rd_en),
        .sell_fifo_rd_en(sell_fifo_rd_en),
        .matched_data(matched_data),
        .match_found(match_found)
    );

endmodule