import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget, QLabel, QPushButton, QLineEdit, \
    QTableWidget, QTableWidgetItem, QComboBox, QHBoxLayout
import serial
import time

# Connect to the FPGA (assuming serial communication via UART)
ser = serial.Serial('COM8', 9600, timeout=1)  # Adjust the COM port as needed


class OrderMatchingGUI(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Low Latency Order Matching Engine")
        self.setGeometry(100, 100, 800, 600)

        # Main layout
        self.layout = QVBoxLayout()

        # Order Type: Buy or Sell
        self.order_type_label = QLabel("Order Type:")
        self.layout.addWidget(self.order_type_label)
        self.order_type_combo = QComboBox()
        self.order_type_combo.addItems(["Buy", "Sell"])
        self.layout.addWidget(self.order_type_combo)

        # Price input
        self.price_label = QLabel("Price:")
        self.layout.addWidget(self.price_label)
        self.price_input = QLineEdit()
        self.layout.addWidget(self.price_input)

        # Quantity input
        self.quantity_label = QLabel("Quantity:")
        self.layout.addWidget(self.quantity_label)
        self.quantity_input = QLineEdit()
        self.layout.addWidget(self.quantity_input)

        # Button to submit the order
        self.submit_button = QPushButton("Submit Order")
        self.submit_button.clicked.connect(self.submit_order)
        self.layout.addWidget(self.submit_button)

        # Tables for displaying buy and sell orders
        self.tables_layout = QHBoxLayout()

        # Buy orders table
        self.buy_table = QTableWidget()
        self.buy_table.setColumnCount(3)
        self.buy_table.setHorizontalHeaderLabels(["Timestamp", "Price", "Quantity"])
        self.tables_layout.addWidget(QLabel("Buy Orders"))
        self.tables_layout.addWidget(self.buy_table)

        # Sell orders table
        self.sell_table = QTableWidget()
        self.sell_table.setColumnCount(3)
        self.sell_table.setHorizontalHeaderLabels(["Timestamp", "Price", "Quantity"])
        self.tables_layout.addWidget(QLabel("Sell Orders"))
        self.tables_layout.addWidget(self.sell_table)

        self.layout.addLayout(self.tables_layout)

        # Matched orders table
        self.matched_table = QTableWidget()
        self.matched_table.setColumnCount(3)
        self.matched_table.setHorizontalHeaderLabels(["Timestamp", "Price", "Quantity"])
        self.layout.addWidget(QLabel("Matched Orders"))
        self.layout.addWidget(self.matched_table)

        # Set the layout
        container = QWidget()
        container.setLayout(self.layout)
        self.setCentralWidget(container)

    def submit_order(self):
        # Gather order details
        order_type = self.order_type_combo.currentText()
        price = self.price_input.text()
        quantity = self.quantity_input.text()
        timestamp = time.strftime('%d/%m/%Y %H:%M:%S', time.localtime())  # Readable timestamp

        # Send the order to FPGA (encode it in the format expected by FPGA)
        type_bit = '01' if order_type == 'Buy' else '10'  # Buy: '01', Sell: '10'
        order_str = f"{type_bit},{price},{quantity},{timestamp}\n"
        ser.write(order_str.encode())  # Send via UART

        # Clear input fields
        self.price_input.clear()
        self.quantity_input.clear()

        # Add the order to the respective buy/sell table
        if order_type == "Buy":
            self.add_order_to_table(self.buy_table, timestamp, price, quantity)
        else:
            self.add_order_to_table(self.sell_table, timestamp, price, quantity)

        # Check for matched orders
        self.check_for_matches()

    def add_order_to_table(self, table, timestamp, price, quantity):
        # Insert a new row at the top of the table (FIFO behavior)
        table.insertRow(0)
        table.setItem(0, 0, QTableWidgetItem(timestamp))main
        table.setItem(0, 1, QTableWidgetItem(price))
        table.setItem(0, 2, QTableWidgetItem(quantity))

    def check_for_matches(self):
        # Read from FPGA and display matched orders
        try:
            if ser.in_waiting > 0:
                matched_order = ser.readline().decode().strip()  # Read from UART
                if matched_order:
                    # Assuming FPGA sends matched data in the format: "matched_timestamp,matched_price,matched_quantity"
                    order_data = matched_order.split(',')
                    if len(order_data) == 3:  # Ensure the format is correct
                        timestamp, price, quantity = order_data
                        self.add_order_to_table(self.matched_table, timestamp, price, quantity)
        except Exception as e:
            print(f"Error receiving match data: {e}")

    def closeEvent(self, event):
        ser.close()  # Close the serial port when the GUI is closed
        event.accept()


# Run the application
if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = OrderMatchingGUI()
    window.show()
    sys.exit(app.exec_())
