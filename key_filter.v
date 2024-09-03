`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/03 10:33:00
// Design Name: 
// Module Name: key_filter
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
module key_filter(
    input wire sys_clk,       // 系统时钟
    // input wire sys_rst_n,     // 全局复位
    input wire key_in,        // 按键输入信号
    output reg key_posedge    // 消抖后检测到按键的上升沿
);

// 计数器最大值，定义为消抖时间（例如20ms）的计数值
parameter CNT_MAX = 20'hf_ffff;  // 约定20位的计数值

// 内部寄存器定义
reg [1:0] key_in_r;        // 用于存储按键输入的两个时钟周期值
reg [19:0] cnt_base;       // 延迟计数器，用于计数按键稳定时间
reg key_value_r;           // 按键值寄存器，用于保存消抖后的按键值
reg key_value_rd;          // 按键值寄存器，用于保存前一周期的按键值

// 记录按键输入信号的两次状态，用于边沿检测
always @(posedge sys_clk) begin
     key_in_r <= {key_in_r[0], key_in};  // 移位寄存器保存按键输入的前两次状态
end

// 延迟计数器逻辑：当检测到按键状态发生变化时，计数器清零
always @(posedge sys_clk) begin  
    if (key_in_r[0] != key_in_r[1])
        cnt_base <= 20'b0;  // 如果按键状态发生变化，计数器清零
    else if (cnt_base < CNT_MAX)
        cnt_base <= cnt_base + 1'b1;  // 否则计数器自增
end

// 按键值寄存器逻辑：当延迟计数器达到最大值时，更新按键状态
always @(posedge sys_clk) begin
    if (cnt_base == CNT_MAX)
        key_value_r <= key_in_r[0];  // 当计数器达到最大值时更新按键状态
end

// 保存上一个时钟周期的按键值，用于边沿检测
always @(posedge sys_clk) begin
        key_value_rd <= key_value_r;  // 更新上一个周期的按键值
end

// 检测按键的上升沿
always @(posedge sys_clk) begin
        key_posedge <= key_value_r & ~key_value_rd;  // 仅在按键值从0变为1时输出高电平
end
endmodule