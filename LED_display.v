//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/9/5 12:30
// Design Name:
// Module Name: LED_DISPLAY
// Project Name:
// Target Devices:
// Tool Versions:
// Description: LED display module
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module LED_DISPLAY (
    input sys_clk,
    input sys_rst_n,
    input [2:0] in_goods_high,
    input [2:0] in_goods_low,
    input [1:0] in_goods_num,
    input [4:0] money,
    input [5:0] state,
    output  RGB1_Blue,
    output  RGB1_Green,
    output  RGB1_Red,
    // output RGB2_Blue,
    // output  RGB2_Green,
    // output  RGB2_Red,
    output [15:0] LED_btn  // 16个按键LED灯输出端口
  );

  // 状态定义
  parameter IDLE = 6'b000001;       //01H
  parameter GOODS_one = 6'b000010;  //02H
  parameter GOODS_two = 6'b000100;  //04H
  parameter PAYMENT = 6'b001000;    //08H
  parameter CHANGE = 6'b010000;     //10H
  parameter TEMP = 6'b100000;       //20H

  // 寄存器定义
  reg [15:0] led_out_reg;
  reg rgb_1b, rgb_1g, rgb_1r;

  // 将内部寄存器的值分配给LED和RGB灯的输出信号
  assign LED_btn = led_out_reg;
  assign RGB1_Blue = rgb_1b;
  assign RGB1_Green = rgb_1g;
  assign RGB1_Red = rgb_1r;
  assign state_in = state;

  // 16个按键LED灯模块
  always@(posedge sys_clk or posedge sys_rst_n)
  begin
    if(sys_rst_n)
    begin
      led_out_reg <= 16'h0000; 
    end
    else
    begin
      if(state == IDLE)
      begin
        led_out_reg <= 16'h0; // 全部灯灭
      end
      else if(state == GOODS_one || state == GOODS_two)
      begin
        led_out_reg <= {8'b0, in_goods_num, in_goods_high, in_goods_low};
        // 显示商品信息,若选中则灯亮起
      end
      else if(state == PAYMENT)
        begin
          led_out_reg<={money, 11'b11111111111};
        end
      else
      begin
        led_out_reg <= 16'hffff; // 全部灯亮起
      end
    end
  end

  // 6个状态显示的重写，写到RGB1里面
  always@(posedge sys_clk or posedge sys_rst_n)
  begin
    if(sys_rst_n)
    begin
      rgb_1b = 1'b0;
      rgb_1g = 1'b0;
      rgb_1r = 1'b0;
    end
    else
    begin
      case(state)
        IDLE:
        begin // nothing to show
          rgb_1b = 1'b0;
          rgb_1g = 1'b0;
          rgb_1r = 1'b0;
        end
        GOODS_one:
        begin //red
          rgb_1b = 1'b0;
          rgb_1g = 1'b0;
          rgb_1r = 1'b1;
        end
        GOODS_two:
        begin //green
          rgb_1b = 1'b0;
          rgb_1g = 1'b1;
          rgb_1r = 1'b0;
        end
        PAYMENT:
        begin //blue
          rgb_1b = 1'b1;
          rgb_1g = 1'b0;
          rgb_1r = 1'b0;
        end
        CHANGE:
        begin //yellow
          rgb_1b = 1'b1;
          rgb_1g = 1'b1;
          rgb_1r = 1'b0;
        end
        TEMP:
        begin //white
          rgb_1b = 1'b1;
          rgb_1g = 1'b1;
          rgb_1r = 1'b1;
        end
        default:
        begin //nothing to show
          rgb_1b = 1'b0;
          rgb_1g = 1'b0;
          rgb_1r = 1'b0;
        end
      endcase
    end
  end
endmodule
