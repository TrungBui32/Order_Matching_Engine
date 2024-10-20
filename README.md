# Order Matching Engine

## Overview

The Order Matching Engine is a Python and Verilog-based project designed to handle order processing for financial transactions efficiently. It provides a graphical user interface (GUI) using PyQt5 to allow users to submit buy and sell orders, while utilizing an FPGA for order matching via UART communication. The system aims to provide low-latency order matching capabilities suitable for high-frequency trading applications.

## Features

- **User Interface**: 
  - Simple and intuitive GUI for submitting buy/sell orders.
  - Real-time display of active buy, sell, and matched orders.

- **Order Submission**:
  - Select order type (Buy/Sell), enter price, and quantity.
  - Orders are timestamped and sent to the FPGA for processing.
  - Buy orders and Sell orders are stored in different FIFOs to reduce the time to access memory.

- **Order Matching**:
  - FPGA processes incoming orders, matches buy and sell orders, and sends matched orders back to the GUI.

- **Communication**:
  - Utilizes UART for serial communication between the GUI and FPGA.
  - Supports two types of orders: buy and sell, with proper data encoding.

## Architecture

### GUI (Python - PyQt5)
- Handles user input and displays the order tables.
- Communicates with the FPGA via UART.

### FPGA (Verilog)
- Receives orders, processes them, and sends matched orders back to the GUI.
- Implements FIFO buffers for storing buy and sell orders.
- Uses UART for data transmission.

## Code Structure

- **Python Files**:
  - `main.py`: Contains the main GUI code and logic for order submission.

- **Verilog Files**:
  - `top_module.v`: Top-level module coordinating UART communication and order matching.
  - `uart_tx.v`: UART transmission module.
  - `uart_rx.v`: UART reception module.
  - `fifo.v`: FIFO implementation for order storage.
  - `match_engine.v`: Logic for matching buy and sell orders.
