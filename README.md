# 微型自动售货机

该自动售货机为基于Verilog的FPGA项目，本项目为东南大学《数字系统课程设计》课程大作业。

---

_这个项目源于两位正在参加东南大学暑期学校的大二学生。项目致力于帮助你速通东南大学，本项目鼓励借鉴，并期望在此基础上创新，但是请不要直接抄袭:D_

## 开发环境

- 开发板：NEXYS 4 DDR
- 语言：Verilog
- 平台：Vivado 2017.4

## 主要功能

### 自动售货机

- **商品选择状态**：用户通过指定商品编号选择商品，板上的七段解码器将显示商品的单价。此外，售货机支持一次购买两件商品，并显示总价。按下`确认`按钮（`BTNR`）将进入支付状态。
- **支付状态**：进入支付状态时，售货机将在七段显示器上显示所购商品的总价。用户可以通过切换FPGA上的左侧5个开关选择插入1元硬币、5元、10元、20元或50元纸币。用户支付的总金额将被计算并显示在七段显示器上。用户可以按下`取消`按钮（`BTNC`）退出支付状态。售货机将进入临时状态，等待用户决定重新选择商品还是退款退出。
- **找零状态**：如果用户支付的金额超过所购商品的总价，售货机将显示找零金额。在找零过程中，用户可以按下`找零`按钮（`BTND`）以返回当前状态下的最大面值找零。

- **重置状态**：如果用户想重新开始，只需在交易过程中随时按下`退出`按钮（`BTNU`）即可退出。

### 灯光显示

- 一个RGB LED显示器（`LD26`）用于指示售货机的状态。LED将根据售货机的状态显示不同的颜色。颜色状态如下：

| 颜色 | 状态 |
|:-------:|:--------:|
| 关闭 | 空闲 |
| 红色 | 选择第一个商品 |
| 绿色 | 选择第二个商品 |
| 蓝色 | 购买状态 |
| 白色 | 退出确认（退出到找零或商品选择）|
| 薄荷色 | 找零状态 |

- 16个LED（`LD0-LD15`）用于指示开关状态（开/关，在商品选择状态期间）。但在支付状态和找零状态期间，所有LED将全部点亮。

## Vivado中的配置

1. 将开发板设置为NEXYS 4 DDR。
2. 将 Verilog 文件和约束文件（`Nexys4DDR_Master.xdc`）添加到项目中。将顶层模块设置为`top_layer.v`。
3. 生成比特流文件并烧录到FPGA中。配置已完成！
---
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
