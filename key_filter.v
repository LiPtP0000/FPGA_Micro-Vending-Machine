`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/03 10:33:00
// Design Name: 
// Module Name: KEY_FILTER
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Key jitter for micro-vending-machine
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module KEY_FILTER(
    input wire sys_clk,       
    input wire key_in,        // 输入按键信号
    output reg key_posedge    // 消抖后输出
);
 
// 计数器最大值
parameter CNT_MAX = 20'hf_ffff;
 
// 寄存器定义
reg [1:0] key_in_r;        
(*keep*) reg [19:0] cnt_base;       
reg key_value_r;           
reg key_value_rd;          
 
// 按键信号同步处理
always @(posedge sys_clk) begin
     key_in_r <= {key_in_r[0], key_in};
end
 
// 按键信号变化，那么开始计数
always @(posedge sys_clk) begin  
    if (key_in_r[0] != key_in_r[1])
        cnt_base <= 20'b0;  
    else if (cnt_base < CNT_MAX)
        cnt_base <= cnt_base + 1'b1;  
end
 
// 按键稳定状态检测，当计数器达到最大值时，认为按键稳定
always @(posedge sys_clk) begin
    if (cnt_base == CNT_MAX)
        key_value_r <= key_in_r[0];  
end
 
// 寄存此时按键值，用于下一时钟周期的按键稳定状态检测
always @(posedge sys_clk) begin
        key_value_rd <= key_value_r;  
end
 
// 仅允许上升沿触发按键
always @(posedge sys_clk) begin
        key_posedge <= key_value_r & ~key_value_rd;  
end
endmodule