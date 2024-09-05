`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/05 20:57:46
// Design Name: 
// Module Name: control_td
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


`timescale 1ns / 1ps

module state_transitions_tb();

    // 输入信号
    reg sys_clk;
    reg sys_rst_n;
    reg sys_Goods;
    reg sys_Confirm;
    reg sys_Change;
    reg sys_Cancel;
    reg in_money_one;
    reg in_money_five;
    reg in_money_ten;
    reg in_money_twenty;
    reg in_money_fifty;
    reg [2:0] type_SW_high;
    reg [2:0] type_SW_low;
    reg [1:0] num_SW;

    // 输出信号
    wire [7:0] Bit_select;
    wire [7:0] Seg_select;

    // 实例化被测试模块
    state_transitions uut (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .sys_Goods(sys_Goods),
        .sys_Confirm(sys_Confirm),
        .sys_Change(sys_Change),
        .sys_Cancel(sys_Cancel),
        .in_money_one(in_money_one),
        .in_money_five(in_money_five),
        .in_money_ten(in_money_ten),
        .in_money_twenty(in_money_twenty),
        .in_money_fifty(in_money_fifty),
        .type_SW_high(type_SW_high),
        .type_SW_low(type_SW_low),
        .num_SW(num_SW),
        .Bit_select(Bit_select),
        .Seg_select(Seg_select)
    );

    // 时钟生成
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk; // 100MHz 时钟
    end

    // 测试激励
    initial begin
        // 初始化信号
        sys_rst_n = 0;
        sys_Goods = 0;
        sys_Confirm = 0;
        sys_Change = 0;
        sys_Cancel = 0;
        in_money_one = 0;
        in_money_five = 0;
        in_money_ten = 0;
        in_money_twenty = 0;
        in_money_fifty = 0;
        type_SW_high = 3'b000;
        type_SW_low = 3'b000;
        num_SW = 2'b00;

        // 复位信号
        #100 sys_rst_n = 1;

        // 模拟输入信号
        #100 sys_Confirm = 1;
        #100 type_SW_high = 3'd2;
        #100 type_SW_low = 3'd1;
        #100 num_SW = 2'd3;
        #100 sys_Goods = 1;
        #100 type_SW_high = 3'd3;
        #100 type_SW_low = 3'd3;
        #100 num_SW = 2'd1;
        #100 sys_Confirm = 1;
        #100 in_money_one = 1;
        #100 in_money_five = 1;
        #100 in_money_ten = 1;
        #100 in_money_twenty = 1;
        #100 in_money_fifty = 1;
        #100 sys_Change = 1;
        #10 sys_Change = 0;
        #100 sys_Change = 1;
        #10 sys_Change = 0;
        #100 sys_Change = 1;
        #10 sys_Change = 0;
        #100 sys_Change = 1;
        #10 sys_Change = 0;

        // 结束仿真
        #100 $finish;
    end

endmodule
