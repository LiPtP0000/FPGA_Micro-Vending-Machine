`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/01 18:20:24
// Design Name: 
// Module Name: DISPLAY_DESIGN
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 7-segment display design for Micro-Vending-Machine
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module DISPLAY_DESIGN(    
    input sys_clk,   
    input [6:0] need_money,         // 所需金额  
    input [7:0] input_money,        // 投币的总币值  
    input [7:0] change_money,       // 找出多余金额
    input [5:0] state,
    input [2:0] in_goods_high,
    input [2:0] in_goods_low,
    input [1:0] in_goods_num,
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
            SEG_E = 8'b1000_0110, SEG_F = 8'b1000_1110,
            SEG_S = 8'b1011_1111, SEG_r = 8'b1010_1111, 
            SEG_o = 8'b1010_0011, SEG_n = 8'b1111_1111, 
            SEG_ot =8'b1001_1100, SEG_left = 8'b1111_1100, 
            SEG_right = 8'b1101_1110, SEG_happy =8'b1110_0011,
            SEG_sad = 8'b1010_1011; 


// ------------------------------------------  
// 分频器，将时钟信号频率降低用于扫描数码管  
// ------------------------------------------  
  
reg [17:0] count_num = 17'd0; 
reg [25:0] count_o = 26'd0;  
always @(posedge sys_clk) begin  
    if (count_num == 17'd99_999) begin  
        count_num <= 17'd0;  
    end else begin  
        count_num <= count_num + 1'd1;  
    end  
end  
reg status = 1'b0;  
  
// ------------------------------------------  
// 循环扫描不同数码管  
// ------------------------------------------  
reg [2:0] sig_num = 3'd0;  
always @(posedge sys_clk) begin  
    if (count_num == 17'd99_999) begin  
        if (sig_num == 3'd7) begin  
            sig_num <= 3'd0;  
        end else begin  
            sig_num <= sig_num + 1'd1;  
        end  
    end  
end  
 
// ------------------------------------------  
//  'o' 的动态显示
// ------------------------------------------ 
reg [7:0] display_o = 8'b0000_0001; // 下面的o，从右往左
reg [7:0] display_ot = 8'b1000_0000; // 上面的o 
// 计时 0.5s
always @(posedge sys_clk) begin 
    if(count_o == 26'd49_999_999) begin
        count_o <= 26'd0;
        
    end else begin
            count_o <= count_o + 1'd1;
        end
end

// 状态切换
always @(posedge sys_clk) begin
    if (count_o == 26'd49_999_999) begin
        if(display_o == 8'b1000_0000) begin
            status <= 1'b1;
        end
        else if (display_ot ==  8'b0000_0001) begin
            status <= 1'b0;
        end
    end
end

// 'o' 的移动
always @(posedge sys_clk) begin
    if(count_o == 26'd49_999_999) begin
        if(status == 1'b1) begin
            if(display_ot == 8'b0000_0001) begin
                display_ot <= 8'b1000_0000;
                display_o <= 8'b0000_0001;
            end else begin
                display_ot <= display_ot >> 1;
            end
        end else begin
            if(display_o == 8'b1000_0000) begin
                display_o <= 8'b0000_0001;
                display_ot <= 8'b1000_0000;
            end else begin
                display_o <= display_o << 1;
            end
        end
    end
end
// ------------------------------------------  
// 数码管位选和显示数字逻辑  
// ------------------------------------------  

reg [4:0] display_num = 5'd0;  
always @(posedge sys_clk) begin
    case (state)
        6'b000001: begin
            // IDLE 状态：流水灯显示
            if(status == 1'b0) begin
                case (sig_num)
                3'd0: begin bit_select <= 8'b11111110; display_num <= display_o[0] == 1'b1 ? 5'd18 : 5'd19; end  
                3'd1: begin bit_select <= 8'b11111101; display_num <= display_o[1] == 1'b1 ? 5'd18 : 5'd19; end  
                3'd2: begin bit_select <= 8'b11111011; display_num <= display_o[2] == 1'b1 ? 5'd18 : 5'd19; end  
                3'd3: begin bit_select <= 8'b11110111; display_num <= display_o[3] == 1'b1 ? 5'd18 : 5'd19; end  
                3'd4: begin bit_select <= 8'b11101111; display_num <= display_o[4] == 1'b1 ? 5'd18 : 5'd19; end  
                3'd5: begin bit_select <= 8'b11011111; display_num <= display_o[5] == 1'b1 ? 5'd18 : 5'd19; end  
                3'd6: begin bit_select <= 8'b10111111; display_num <= display_o[6] == 1'b1 ? 5'd18 : 5'd19; end  
                3'd7: begin bit_select <= 8'b01111111; display_num <= display_o[7] == 1'b1 ? 5'd18 : 5'd19; end  
                default: bit_select <= 8'b11111111;  
            endcase
            end else begin
                case (sig_num)
                3'd0: begin bit_select <= 8'b11111110; display_num <= display_ot[0] == 1'b1 ? 5'd20 : 5'd19; end
                3'd1: begin bit_select <= 8'b11111101; display_num <= display_ot[1] == 1'b1 ? 5'd20 : 5'd19; end  
                3'd2: begin bit_select <= 8'b11111011; display_num <= display_ot[2] == 1'b1 ? 5'd20 : 5'd19; end  
                3'd3: begin bit_select <= 8'b11110111; display_num <= display_ot[3] == 1'b1 ? 5'd20 : 5'd19; end  
                3'd4: begin bit_select <= 8'b11101111; display_num <= display_ot[4] == 1'b1 ? 5'd20 : 5'd19; end  
                3'd5: begin bit_select <= 8'b11011111; display_num <= display_ot[5] == 1'b1 ? 5'd20 : 5'd19; end  
                3'd6: begin bit_select <= 8'b10111111; display_num <= display_ot[6] == 1'b1 ? 5'd20 : 5'd19; end  
                3'd7: begin bit_select <= 8'b01111111; display_num <= display_ot[7] == 1'b1 ? 5'd20 : 5'd19; end  
                default: bit_select <= 8'b11111111;    
                endcase
            end
        end
        6'b001000, 6'b010000, 6'b100000:begin
            case (sig_num)
                3'd0: begin bit_select <= 8'b11111110; display_num <= need_money % 10; end  
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
        6'b000010, 6'b000100: begin
            // 判断商品输入是否有效
            if(in_goods_low >= 3'd1 && in_goods_low <= 3'd4 && in_goods_high >= 3'd1 && in_goods_high <= 3'd4 ) begin
              // 商品显示
            case (sig_num)
                3'd0: begin bit_select <= 8'b11111110; display_num <= 5'd22; end  // 
                3'd1: begin bit_select <= 8'b11111101; display_num <= 5'd23; end  
                3'd2: begin bit_select <= 8'b11111011; display_num <= 5'd21; end  
                3'd3: begin bit_select <= 8'b11110111; display_num <= in_goods_num; end  
                3'd4: begin bit_select <= 8'b11101111; display_num <= 5'd16; end  
                3'd5: begin bit_select <= 8'b11011111; display_num <= in_goods_low; end  
                3'd6: begin bit_select <= 8'b10111111; display_num <= in_goods_high; end  
                3'd7: begin bit_select <= 8'b01111111; display_num <= 5'd10; end  // A
                default: bit_select <= 8'b11111111;
            endcase
        end
        else begin
            // Error 显示
            case (sig_num)
                3'd0: begin bit_select <= 8'b11111110; display_num <= 5'd22; end  // 
                3'd1: begin bit_select <= 8'b11111101; display_num <= 5'd24; end  // 
                3'd2: begin bit_select <= 8'b11111011; display_num <= 5'd21; end  // 
                3'd3: begin bit_select <= 8'b11110111; display_num <= 5'd17; end  // r
                3'd4: begin bit_select <= 8'b11101111; display_num <= 5'd18; end  // o
                3'd5: begin bit_select <= 8'b11011111; display_num <= 5'd17; end  // r
                3'd6: begin bit_select <= 8'b10111111; display_num <= 5'd17; end  // r
                3'd7: begin bit_select <= 8'b01111111; display_num <= 5'd14; end  // E
                default: bit_select <= 8'b11111111;
            endcase
        end
        end
        default: begin
            // 默认状态下关闭所有显示
            bit_select <= 8'b11111111;
            display_num <= 5'd16;  // 空格
        end
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
        5'd17: seg_select <= SEG_r;
        5'd18: seg_select <= SEG_o;
        5'd19: seg_select <= SEG_n;
        5'd20: seg_select <= SEG_ot;
        5'd21: seg_select <= SEG_left;
        5'd22: seg_select <= SEG_right;
        5'd23: seg_select <= SEG_happy;
        5'd24: seg_select <= SEG_sad;
        default: ;  
    endcase  
end  
  
endmodule