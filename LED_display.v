module LED_display #(
    parameter CNT_MAX = 25'd49_999_999;
)(
    input sys_clk,
    input sys_rst_n,
    input [2:0] in_goods_high,
    input [2:0] in_goods_low,
    input [1:0] in_goods_num,
    input [5:0] state,
    output wire RGB1_Blue,
    output wire RGB1_Green,
    output wire RGB1_Red,
    output wire RGB2_Blue,
    output wire RGB2_Green,
    output wire RGB2_Red,
    output wire LED_num ,
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
  reg [24:0] cnt;
  reg cnt_flag;

  // 计数器计时1s
  always@(posedge sys_clk or posedge sys_rst_n)
    if(sys_rst_n == 1'b1)
      cnt <= 25'b0;
    else if(cnt == CNT_MAX)
      cnt <= 25'b0;
    else
      cnt <= cnt + 1'b1;

  //cnt_flag:计数器计数到最大值后，产生标志信号复位
  always@(posedge sys_clk or posedge sys_rst_n)
    if(sys_rst_n == 1'b1)
      cnt_flag <= 1'b0;
    else if(cnt == CNT_MAX - 1)
      cnt_flag <= 1'b1;
    else
      cnt_flag <= 1'b0;


  // 16个按键LED灯模块
  always(posedge sys_clk or posedge sys_rst_n)
  begin
    if(sys_rst_n)
    begin
      led_out_reg <= 16'h0001; //初始化为1，实现流水灯
    end
    else
    begin
      if(state == IDLE)
      begin
        if(sys_rst_n == 1'b0)
          led_out_reg <= 16'h0001;
        else if(led_out_reg == 4'h8000 && cnt_flag == 1'b1)
          led_out_reg <= 16'h0001;
        else if(cnt_flag == 1'b1)
          led_out_reg <= led_out_reg << 1'b1; //左移，实现流水灯
      end
      if(state == GOODS_one || state == GOODS_two)
      begin
        led_out_reg <= {8'b0, in_goods_num, in_goods_high, in_goods_low};
        // 显示商品信息,若选中则灯亮起
      end
      else
      begin
        led_out_reg <= 16'hffff; // 全部灯亮起
      end
    end
  end
  // 6个状态显示的重写，写到RGB1里面
  always(posedge sys_clk or posedge sys_rst_n)
  begin
    if(sys_rst_n)
    begin
      RGB1_Blue = 1'b0;
      RGB1_Green = 1'b0;
      RGB1_Red = 1'b0;
    end
    else
    begin
      case(state)
        IDLE:
        begin // nothing to show
          RGB1_Blue = 1'b0;
          RGB1_Green = 1'b0;
          RGB1_Red = 1'b0;
        end
        GOODS_one:
        begin //red
          RGB1_Blue = 1'b0;
          RGB1_Green = 1'b0;
          RGB1_Red = 1'b1;
        end
        GOODS_two:
        begin //green
          RGB1_Blue = 1'b0;
          RGB1_Green = 1'b1;
          RGB1_Red = 1'b0;
        end
        PAYMENT:
        begin //blue
          RGB1_Blue = 1'b1;
          RGB1_Green = 1'b0;
          RGB1_Red = 1'b0;
        end
        CHANGE:
        begin //yellow
          RGB1_Blue = 1'b0;
          RGB1_Green = 1'b1;
          RGB1_Red = 1'b1;
        end
        TEMP:
        begin //white
          RGB1_Blue = 1'b1;
          RGB1_Green = 1'b1;
          RGB1_Red = 1'b0;
        end
        default:
        begin //nothing to show
          RGB1_Blue = 1'b0;
          RGB1_Green = 1'b0;
          RGB1_Red = 1'b0;
        end
      endcase
    end
  end
endmodule
