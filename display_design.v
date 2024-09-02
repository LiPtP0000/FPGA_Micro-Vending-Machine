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
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module display_design(
//显示模块  
input sys_clk, 
input [7:0] need_money,//所需金额 
input [7:0] input_money,//投币的总币值 
input [7:0] change_money,//找出多余金额 
output reg [7:0] bit_select,//数码管位选 
output reg [7:0] seg_select//数码管段选 
); 
 //分频器，将时钟信号频率降低用于扫描数码管
reg [31:0] count_num = 32'd0;
always @(posedge sys_clk)
begin
 if(count_num == 32'd99_999)
 begin
 count_num <= 32'd0;
 end
 else begin
 count_num <=count_num + 1'd1;
 end
end
//循环扫描不同数码管
reg [2:0] sig_num = 3'd0;
always @(posedge sys_clk)
begin
if(count_num == 32'd99_999)
begin
 if(sig_num == 3'd7)
 begin
 sig_num <= 3'd0;
 end
 else begin
 sig_num <= sig_num + 1'd1;
 end
end
end
//给每一位确定输出的信息
reg [3:0] display_num = 4'd0;
always @(posedge sys_clk)
begin
 case (sig_num)
 3'd0: begin bit_select <= 8'b11111110; display_num <= need_money % 10; end
 3'd1: begin bit_select <= 8'b11111101; display_num <= need_money / 10; end
 3'd2: begin bit_select <= 8'b11111011; display_num <= 4'd10; end // 显示 "-"
 3'd3: begin bit_select <= 8'b11110111; display_num <= input_money % 10; end
 3'd4: begin bit_select <= 8'b11101111; display_num <= input_money / 10; end
 3'd5: begin bit_select <= 8'b11011111; display_num <= 4'd10; end // 显示 "-"
 3'd6: begin bit_select <= 8'b10111111; display_num <= change_money % 10; end
 3'd7: begin bit_select <= 8'b01111111; display_num <= change_money / 10; end
  default: bit_select <= 8'b11111111;
 endcase
end
 //段选输出，分别定义显示0到9
 always @(posedge sys_clk)
 begin
  case (display_num)
  4'd0: seg_select <= 8'b1100_0000;
  4'd1: seg_select <= 8'b1111_1001;
  4'd2: seg_select <= 8'b1010_0100;
  4'd3: seg_select <= 8'b1011_0000;
  4'd4: seg_select <= 8'b1001_1001;
  4'd5: seg_select <= 8'b1001_0010;
  4'd6: seg_select <= 8'b1000_0010;
  4'd7: seg_select <= 8'b1111_1000;
  4'd8: seg_select <= 8'b1000_0000;
  4'd9: seg_select <= 8'b1001_0000;
  4'd10: seg_select <= 8'b1011_1111; // "-"
   default: ;
  endcase
 end
endmodule
