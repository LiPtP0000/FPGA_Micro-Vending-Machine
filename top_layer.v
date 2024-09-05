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

    input wire key_Cancel,  //取消-BTNC 
    input wire key_Confirm, //确认-BTNU 
    input wire key_Change,  //找零按键-BTNR 
    input wire key_Goods,   //商品选择键-BTNL 
    input wire key_Rst,     //复位-BTND 

    //input money
    input wire key_in_money_one,
    input wire key_in_money_five,
    input wire key_in_money_ten,
    input wire key_in_money_twenty,
    input wire key_in_money_fifty,

    //goods input
    input wire [2:0] key_in_goods_high,
    input wire [2:0] key_in_goods_low,
    input wire [1:0] key_in_goods_num, // 商品数量

    // 输出端口
    output wire [7:0] bit_select,
    output wire [7:0] seg_select
);
    wire money_one, money_five, money_ten, money_twenty, money_fifty;
    wire sys_clk, sys_rst_n, sys_Goods, sys_Confirm, sys_Change, sys_Cancel;

    wire [7:0] need_money;         // 所需金额  
    wire [7:0] input_money;        // 投币的总币值  
    wire [7:0] change_money;       // 找出多余金额  

    wire [2:0] in_goods_high;      // 商品1 对应状态机中的SW1
    wire [2:0] in_goods_low;       // 商品2 对应状态机中的SW2
    wire [1:0] in_goods_num;       // 商品数量

    // Instantiation
    state_transitions transist(
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .sys_Goods(sys_Goods),
        .sys_Confirm(sys_Confirm),
        .sys_Change(sys_Change),
        .sys_Cancel(sys_Cancel),
        .in_money_one(money_one),
        .in_money_five(money_five),
        .in_money_ten(money_ten),
        .in_money_twenty(money_twenty),
        .in_money_fifty(money_fifty),
        .type_SW_high(in_goods_high), //商品1 对应状态机中的SW1
        .type_SW_low(in_goods_low),  //商品2 对应状态机中的SW2
        .num_SW(in_goods_num) //商品数量
    );

    display_design display(
        .sys_clk(sys_clk),
        .need_money(need_money),
        .input_money(input_money),
        .change_money(change_money),
        .bit_select(bit_select),    // 显示屏选择位
        .seg_select(seg_select)     // 显示屏选择段
    );
    
    // 输入钱 消抖
    key_filter one_key(
        .sys_clk(sys_clk),
        .key_in(key_in_money_one),
        .key_posedge(money_one)
    );

    key_filter five_key(
        .sys_clk(sys_clk),
        .key_in(key_in_money_five),
        .key_posedge(money_five)
    );

    key_filter ten_key(
        .sys_clk(sys_clk),
        .key_in(key_in_money_ten),
        .key_posedge(money_ten)
    );

    key_filter twenty_key(
        .sys_clk(sys_clk),
        .key_in(key_in_money_twenty),
        .key_posedge(money_twenty)
    );

    key_filter fifty_key(
        .sys_clk(sys_clk),
        .key_in(key_in_money_fifty),
        .key_posedge(money_fifty)
    );

    //选择商品按键

    key_filter Confirm(
        .sys_clk(sys_clk),
        .key_in(key_Confirm),
        .key_posedge(sys_Confirm)
    );

    key_filter Goods(
        .sys_clk(sys_clk),
        .key_in(key_Goods),
        .key_posedge(sys_Goods)
    );

    key_filter Cancel(
        .sys_clk(sys_clk),
        .key_in(key_Cancel),
        .key_posedge(sys_Cancel)
    );

    key_filter Change(
        .sys_clk(sys_clk),
        .key_in(key_Change),
        .key_posedge(sys_Change)
    );

    key_filter Rst(
        .sys_clk(sys_clk),
        .key_in(key_Rst),
        .key_posedge(sys_rst_n)
    );

    // 选择商品编号、数目按键消抖

    key_filter enum_1(

        .sys_clk(sys_clk),
        .key_in(key_in_goods_high[0]),
        .key_posedge(in_goods_high[0])
    );

    key_filter enum_2(

        .sys_clk(sys_clk),
        .key_in(key_in_goods_high[1]),
        .key_posedge(in_goods_high[1])
    );

    key_filter enum_3(

        .sys_clk(sys_clk),
        .key_in(key_in_goods_high[2]),
        .key_posedge(in_goods_high[2])
    );

    key_filter enum_4(

        .sys_clk(sys_clk),
        .key_in(key_in_goods_low[0]),
        .key_posedge(in_goods_low[0])
    );

    key_filter enum_5(

        .sys_clk(sys_clk),
        .key_in(key_in_goods_low[1]),
        .key_posedge(in_goods_low[1])
    );

    key_filter enum_6(

        .sys_clk(sys_clk),
        .key_in(key_in_goods_low[2]),
        .key_posedge(in_goods_low[2])
    );

    key_filter num(

        .sys_clk(sys_clk),
        .key_in(key_in_goods_num[1]),
        .key_posedge(in_goods_num[1])
    );

    key_filter num_0(

        .sys_clk(sys_clk),
        .key_in(key_in_goods_num[0]),
        .key_posedge(in_goods_num[0])
    );
endmodule