`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/01 18:20:24
// Design Name: 
// Module Name: display_design
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: General Display module for 7-segment displayer
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//主要思路是动态循环显示
module display_design(  
    // 显示模块接口  
    input sys_clk,   
    input [6:0] need_money,         // 所需金额  
    input [7:0] input_money,        // 投币的总币值  
    input [7:0] change_money,       // 找出多余金额  
    output reg [7:0] bit_select,    // 数码管位选  
    output reg [7:0] seg_select     // 数码管段选  
);  
//定义16进制的显示编码
parameter SEG_0 = 8'b1100_0000, SEG_1 = 8'b1111_1001, 
            SEG_2 = 8'b1010_0100, SEG_3 = 8'b1011_0000, 
            SEG_4 = 8'b1001_1001, SEG_5 = 8'b1001_0010, 
            SEG_6 = 8'b1000_0010, SEG_7 = 8'b1111_1000, 
            SEG_8 = 8'b1000_0000, SEG_9 = 8'b1001_0000, 
            SEG_A = 8'b1000_1000, SEG_B = 8'b1000_0011, 
            SEG_C = 8'b1100_0110, SEG_D = 8'b1010_0001, 
            SEG_E = 8'b1000_0110, SEG_F = 8'b1000_1110,//16进制
            SEG_S = 8'b1011_1111;//空格 
// ------------------------------------------  
// 分频器，将时钟信号频率降低用于扫描数码管  
// ------------------------------------------  
reg [31:0] count_num = 32'd0;  
always @(posedge sys_clk) begin  
    if (count_num == 32'd99_999) begin  
        count_num <= 32'd0;  
    end else begin  
        count_num <= count_num + 1'd1;  
    end  
end  
  
// ------------------------------------------  
// 循环扫描不同数码管  
// ------------------------------------------  
reg [2:0] sig_num = 3'd0;  
always @(posedge sys_clk) begin  
    if (count_num == 32'd99_999) begin  
        if (sig_num == 3'd7) begin  
            sig_num <= 3'd0;  
        end else begin  
            sig_num <= sig_num + 1'd1;  
        end  
    end  
end  
  
// ------------------------------------------  
// 数码管位选和显示数字逻辑  
// ------------------------------------------  
 reg [4:0] display_num = 5'd0;  
    always @(posedge sys_clk) begin  
    case (sig_num)  
        3'd0: begin bit_select <= 8'b11111110; display_num <= need_money % 10; end  // for TEST ONLY 
        3'd1: begin bit_select <= 8'b11111101; display_num <= need_money / 10; end  
        3'd2: begin bit_select <= 8'b11111011; display_num <= 5'd16; end  // 显示 空格"-"  
        3'd3: begin bit_select <= 8'b11110111; display_num <= input_money % 10; end  
        3'd4: begin bit_select <= 8'b11101111; display_num <= input_money / 10; end  
        3'd5: begin bit_select <= 8'b11011111; display_num <= 5'd16; end  // 显示 空格"-"  
        3'd6: begin bit_select <= 8'b10111111; display_num <= change_money % 10; end  
        3'd7: begin bit_select <= 8'b01111111; display_num <= change_money / 10; end  
        default: bit_select <= 8'b11111111;  
    endcase  
end  
  
// ------------------------------------------  
// 数码管段选输出  
// ------------------------------------------  
always @(posedge sys_clk) begin  
    case (display_num)  
        5'd0: seg_select <= SEG_0;  
        5'd1: seg_select <= SEG_1;  
        5'd2: seg_select <= SEG_2;  
        5'd3: seg_select <= SEG_3;  
        5'd4: seg_select <= SEG_4;  
        5'd5: seg_select <= SEG_5;  
        5'd6: seg_select <= SEG_6;  
        5'd7: seg_select <= SEG_7;  
        5'd8: seg_select <= SEG_8;  
        5'd9: seg_select <= SEG_9;  
        5'd10: seg_select <= SEG_A;  
        5'd11: seg_select <= SEG_B;
        5'd12: seg_select <= SEG_C;
        5'd13: seg_select <= SEG_D;
        5'd14: seg_select <= SEG_E;
        5'd15: seg_select <= SEG_F;
        5'd16: seg_select <= SEG_S;
        default: ;  
    endcase  
end  
  
endmodule
