//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/9/3 10:17
// Design Name:
// Module Name: top_layer
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

module top_layer(
    //通过约束文件确定接口
    input wire sys_clk,    //系统时钟-CLK
    input wire [4:0] key_button,  //按键输入
    //input money
    input wire [4:0] key_in_money,
    //goods input
    input wire [2:0] key_in_goods_high,
    input wire [2:0] key_in_goods_low,
    input wire [1:0] key_in_goods_num, // 商品数量

    // 输出端口
    output wire [7:0] bit_select,
    output wire [7:0] seg_select,

    //状态LED输出
    output wire [15:0] LED_out,
    output wire RGB1_Blue,
    output wire RGB1_Green,
    output wire RGB1_Red,
    output wire RGB2_Blue,
    output wire RGB2_Green,
    output wire RGB2_Red
  );
  wire [4:0] money;
  wire [4:0] sys;
  wire [5:0] state_out;
  wire [6:0] need_money;         // 所需金额
  wire [7:0] input_money;        // 投币的总币值
  wire [7:0] change_money;       // 找出多余金额
  wire [2:0] in_goods_high;      // 商品1 对应状态机中的SW1
  wire [2:0] in_goods_low;       // 商品2 对应状态机中的SW2
  wire [1:0] in_goods_num;       // 商品数量

  // Instantiation
  state_transitions transist(
                      .sys_clk(sys_clk),
                      .sys_rst_n(sys[0]),
                      .sys_Goods(sys[1]),
                      .sys_Confirm(sys[2]),
                      .sys_Change(sys[3]),
                      .sys_Cancel(sys[4]),
                      .in_money_one(money[0]),
                      .in_money_five(money[1]),
                      .in_money_ten(money[2]),
                      .in_money_twenty(money[3]),
                      .in_money_fifty(money[4]),
                      .type_SW_high(in_goods_high), //商品1 对应状态机中的SW1
                      .type_SW_low(in_goods_low),  //商品2 对应状态机中的SW2
                      .num_SW(in_goods_num),  //商品数量
                      .state_out(state_out),
                      .need_money(need_money),
                      .input_money(input_money),
                      .change_money(change_money)
                    );


  display_design display(
                   .sys_clk(sys_clk),
                   .need_money(need_money),
                   .input_money(input_money),
                   .change_money(change_money),
                   .bit_select(bit_select),    // 显示屏选择位
                   .seg_select(seg_select)     // 显示屏选择段
                   .state(state_out),
                   .in_goods_high(in_goods_high),
                   .in_goods_low(in_goods_low),
                   .in_goods_num(in_goods_num)
                 );

  LED_design LED(
               .sys_clk(sys_clk),
               .sys_rst_n(sys[0]),
               in_goods_high(in_goods_high),
               in_goods_low(in_goods_low),
               in_goods_num(in_goods_num),
               .state(state_out),
               .LED_btn(LED_out),
               .RGB1_Blue(RGB1_Blue),
               .RGB1_Green(RGB1_Green),
               .RGB1_Red(RGB1_Red),
               .RGB2_Blue(RGB2_Blue),
               .RGB2_Green(RGB2_Green),
               .RGB2_Red(RGB2_Red)
             );
  // 输入钱 消抖
  genvar i;
  generate
    for (i = 0; i < 5; i = i + 1)
    begin : money_key_filter
      key_filter money_key(
                   .sys_clk(sys_clk),
                   .key_in(key_in_money[i]),
                   .key_posedge(money[i])
                 );
    end
  endgenerate

  //选择商品按键
  generate
    for(i=0;i<5;i=i+1)
    begin : button_filter
      key_filter button(
                   .sys_clk(sys_clk),
                   .key_in(key_button[i]),
                   .key_posedge(sys[i])
                 );
    end
  endgenerate

  // 选择商品编号、数目按键消抖

  generate
    for(i=0;i<=2;i=i+1)
    begin : goods_key_filter
      key_filter goods_key(
                   .sys_clk(sys_clk),
                   .key_in(key_in_goods_high[i]),
                   .key_posedge(in_goods_high[i])
                 );
    end
  endgenerate

  generate
    for(i=0;i<=2;i=i+1)
    begin : goods_key_filter_low
      key_filter goods_key_low(
                   .sys_clk(sys_clk),
                   .key_in(key_in_goods_low[i]),
                   .key_posedge(in_goods_low[i])
                 );
    end
  endgenerate

  generate
    for(i=0;i<=1;i=i+1)
    begin : goods_key_filter_num
      key_filter goods_key_num(
                   .sys_clk(sys_clk),
                   .key_in(key_in_goods_num[i]),
                   .key_posedge(in_goods_num[i])
                 );
    end
  endgenerate

endmodule
