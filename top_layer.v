`timescale 1ns / 1ps
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

    input wire sys_clk,
    input wire sys_rst_n,   //复位-BTND 
    input wire sys_Goods,   //商品选择键-BTNL 
    input wire sys_Confirm, //确认-BTNU 
    input wire sys_Change,  //找零按键-BTNR 
    input wire sys_Cancel,  //取消-BTNC 
    input wire in_money_one,
    input wire in_money_five,
    input wire in_money_ten,
    input wire in_money_twenty,
    input wire in_money_fifty,

    input [7:0] need_money,         // 所需金额  
    input [7:0] input_money,        // 投币的总币值  
    input [7:0] change_money,       // 找出多余金额  
    output reg [7:0] bit_select,    // 数码管位选  
    output reg [7:0] seg_select,     // 数码管段选

    input wire key_in,  
    output reg key_posedge
);
    // Instantiation
    state_transitions(
        sys_clk(sys_clk),
        sys_rst_n(sys_rst_n),
        sys_Goods(sys_Goods),
        sys_Confirm(sys_Confirm),
        sys_Change(sys_Change),
        sys_Cancel(sys_Cancel),
        in_money_one(in_money_one),
        in_money_five(in_money_five),
        in_money_ten(in_money_ten),
        in_money_twenty(in_money_twenty),
        in_money_fifty(in_money_fifty)
    );

    display_design(
        sys_clk(sys_clk),
        need_money(need_money),
        input_money(input_money),
        change_money(change_money),
        bit_select(bit_select),
        seg_select(seg_select)
    );
    
    key_filter(
        sys_clk(sys_clk),
        sys_rst_n(sys_rst_n),
        key_in(key_in),
        key_posedge(key_posedge)
    );

    
endmodule