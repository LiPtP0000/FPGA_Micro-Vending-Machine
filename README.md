# Micro-Vending-Machine

A Verilog-based FPGA Project of a Micro Vending Machine Designed for the Course "Digital System Course Design" of Southeast University.

---

_This project is originated from two miserable juniors who are attending the summer school of Southeast University. The project is committed to making every student of Southeast University speed through Southeast University._

## Developing Environment

- Board: NEXYS 4 DDR
- Language: Verilog
- Platform: Vivado 2017.4

## Main Features

### Vending Machine

- **Goods Selection Status**: Users select goods by specifying the product number, and the seven-segment decoder on the board will display the unit price of the goods. Additionally, the vending machine supports the purchase of two items at a time and displays the total price. Pressing the `Confirm` button (`BTNR`) will jump to the payment status.
- **Payment Status**: When entering the payment status, the vending machine will display the total price of the bought goods on the 7-segment displays. User can choose to insert 1-yuan coin, 5-yuan, 10-yuan, 20-yuan or 50-yuan notes by switching on the left 5 switches on FPGA. The total value paid by user is then calculated and displayed on the 7-segment displays. User can quit the payment status by pressing the `Cancel` button (`BTNC`). The vending machine will switch into a temp status to wait for the users' decision of whether to reselect the goods or just refund and quit.
- **Change Status**: If user pays more than the total price of the bought goods, the vending machine will display the amount of change. While changing, users can press the `Change` button (`BTND`) to return the maximum face value of change in the current status.

- **Reset Status**: If user wants to start over, just press the `Quit` button (`BTNU`) anytime through the trading process to exit.

### Lights

- A RGB LED display ( `LD26`) to indicate the status of the vending machine. The LEDs will display different colors according to the status of the vending machine.


| Color | Status |
|:-------:|:--------:|
| OFF | Idle |
| Red | Selecting the First Item|
| Green | Selecting the Second Item|
| Blue | Purchase Status|
| White | Exit confirmation (Exit to Change or Item selection)|
| Mint | Change Status|


- 16 LEDs ( `LD0-LD15`) to indicate the switch status(on/off, during the Good Selection Status). Note that the LEDs will be all turned ON during the Payment Status and Change Status.

## Configuration in Vivado

1. Set the board as NEXYS 4 DDR.
2. Add the Verilog files and constraints files (`Nexys4DDR_Master.xdc`) to the project. Set the top-level module as `top_layer.v`.
3. Generate the bitstream and programme it to the FPGA. Enjoy the vending machine!
