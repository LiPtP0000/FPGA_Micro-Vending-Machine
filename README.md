# Micro-Vending-Machine

A verilog-based vending machine designed for the course "Digital System Course Design" of Southeast University.

---

_This project is originated from two miserable juniors who are attending the summer school of Southeast University. The project is committed to making every student of Southeast University speed through Southeast University._

## Developing Environment

- Board: NEXYS 4 DDR
- Language: Verilog
- Platform: Vivado 2017.4

## Main Features

- Supports the selection of 16 kinds of goods. Users select goods by specifying the product number, and the seven-segment decoder on the board will display the unit price of the goods. Additionally, the vending machine supports the purchase of two items at a time and displays the total price. Pressing the "Confirm" button will jump to the virtual checkout counter.
- Supports virtual money input by users. Users can choose to insert 1-yuan coin, 5-yuan, 10-yuan, 20-yuan or 50-yuan notes by pressing the specified buttons on FPGA. The total value paid by user is then calculated and displayed on the board.
- Supports change. If user pays more than the total price of the bought goods, the vending machine will display the amount of change.

- Users can press the "Quit" button anytime through the trading process to exit.

## Flowchart

Can be seen in [flowchart.pdf].
