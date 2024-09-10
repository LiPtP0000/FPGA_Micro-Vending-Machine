`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/8/27 18:36
// Design Name:
// Module Name: STATE_TRANSITIONS
// Project Name:
// Target Devices:
// Tool Versions:
// Description: FSM for Micro-Vending-Machine
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module STATE_TRANSITIONS (
    // ����
    input wire sys_clk,
    input wire sys_rst_n,               //BTNU
    input wire sys_Goods,               //BTNL
    input wire sys_Confirm,             //BTNR
    input wire sys_Change,              //BTND
    input wire sys_Cancel,              //BTNC
    input wire in_money_one,
    input wire in_money_five,
    input wire in_money_ten,
    input wire in_money_twenty,
    input wire in_money_fifty,
    input [2:0] type_SW_high,
    input [2:0] type_SW_low,
    input [1:0] num_SW,

    // ���
    output wire [7:0] input_money,
    output reg [6:0] need_money,
    output wire [7:0] change_money,
    output wire [5:0] state_out
  );


  //����״̬
  parameter IDLE = 6'b000001;       //01H
  parameter GOODS_one = 6'b000010;  //02H
  parameter GOODS_two = 6'b000100;  //04H
  parameter PAYMENT = 6'b001000;    //08H
  parameter CHANGE = 6'b010000;     //10H
  parameter TEMP = 6'b100000;       //20H

  reg  [5:0] state;
  reg  [6:0] need_money_buf = 7'd0;  // ������
  reg  [7:0] input_money_buf = 8'd0;  // Ͷ�ҵ��ܱ�ֵ
  reg  [7:0] change_money_buf = 8'd0;  // �ҳ����������ֵΪ0����ֹ��������
  reg  [5:0] need_money_1 = 6'd0;  // ��Ʒ 1 ������
  reg  [5:0] need_money_2 = 6'd0;  // ��Ʒ 2 ������
  reg        flag = 1'd1;

  assign input_money = input_money_buf;  // Ͷ�ҵ��ܱ�ֵ
  assign change_money = change_money_buf;  // �ҳ�������
  assign state_out = state;
  wire [7:0] goods_code;  // ��Ʒ���
  assign goods_code  = {1'b0, type_SW_high, 1'b0, type_SW_low};//����������԰���16���ƴ���������Ʒ��ſ��Լ��һЩ

  //FSM

  always @(posedge sys_clk or posedge sys_rst_n) // ͬ����λ
  begin
    if (sys_rst_n)
      state <= IDLE;
    else
    begin
      case (state)
        IDLE:// ��ʼ״̬
          if (sys_Confirm)
          begin
            state <= GOODS_one;  
          end

        GOODS_one:// ѡ����Ʒһ
        begin
          if (sys_Goods)
          begin
            state <= GOODS_two;
          end
          else if (sys_Confirm)
          begin
            state <= PAYMENT;
          end
          else if(sys_Cancel)
          begin
            state <= IDLE;
          end
          else
            state <= GOODS_one;
        end

        GOODS_two:// ѡ����Ʒ��
        begin
          if (sys_Cancel)
            state <= GOODS_one;  
          else if (sys_Confirm)
          begin
            state <= PAYMENT;

          end
          else
            state <= GOODS_two;  
        end

        PAYMENT:// ����״̬
        begin
          if (sys_Cancel)
            state <= TEMP;  // ȡ����ת��TEMP״̬
          else if (input_money_buf >= need_money_buf & sys_Confirm)
            state <= CHANGE;  // Ͷ���㹻��ת������״̬
          else
            state <= PAYMENT;  // Ͷ�Ҳ��㹻�����ֵ�ǰ״̬
        end

        CHANGE: // ����
        begin
          if (change_money_buf == 0 & sys_Change)
            state <= IDLE;  // upd: ����һ��change��
          else
            state <= CHANGE;  
        end

        TEMP: // ����״̬
        begin
          if (sys_Cancel)
            state <= GOODS_one;  // ����ѡ����Ʒ
          else if (sys_Confirm) // ��ʼ�˿�
            state <= CHANGE;
          else
            state <= TEMP;  
        end

        default:
          state <= IDLE;  
      endcase
    end
  end
  

  always @(posedge sys_clk or posedge sys_rst_n)  //��Ʒһ��״̬����
  begin
    if (sys_rst_n)  
      need_money_1 <= 6'd0;
    else if (state == GOODS_one) 
    begin
      case (goods_code)  
        8'h11:
          need_money_1 <= num_SW * 6'd3;
        8'h12:
          need_money_1 <= num_SW * 6'd4;
        8'h13:
          need_money_1 <= num_SW * 6'd6;
        8'h14:
          need_money_1 <= num_SW * 6'd3;
        8'h21:
          need_money_1 <= num_SW * 6'd10;
        8'h22:
          need_money_1 <= num_SW * 6'd8;
        8'h23:
          need_money_1 <= num_SW * 6'd9;
        8'h24:
          need_money_1 <= num_SW * 6'd7;
        8'h31:
          need_money_1 <= num_SW * 6'd4;
        8'h32:
          need_money_1 <= num_SW * 6'd6;
        8'h33:
          need_money_1 <= num_SW * 6'd15;
        8'h34:
          need_money_1 <= num_SW * 6'd8;
        8'h41:
          need_money_1 <= num_SW * 6'd9;
        8'h42:
          need_money_1 <= num_SW * 6'd4;
        8'h43:
          need_money_1 <= num_SW * 6'd5;
        8'h44:
          need_money_1 <= num_SW * 6'd5;
        default:
          need_money_1 <= 6'd0;
      endcase
    end
  end

  always @(posedge sys_clk or posedge sys_rst_n)
  begin  // ��Ʒ����״̬����
    if (sys_rst_n)
    begin  
      need_money_2 <= 6'd0;
    end
    else if (state == GOODS_two)
    begin  
      case (goods_code)  
        8'h11:
          need_money_2 <= num_SW * 6'd3;
        8'h12:
          need_money_2 <= num_SW * 6'd4;
        8'h13:
          need_money_2 <= num_SW * 6'd6;
        8'h14:
          need_money_2 <= num_SW * 6'd3;
        8'h21:
          need_money_2 <= num_SW * 6'd10;
        8'h22:
          need_money_2 <= num_SW * 6'd8;
        8'h23:
          need_money_2 <= num_SW * 6'd9;
        8'h24:
          need_money_2 <= num_SW * 6'd7;
        8'h31:
          need_money_2 <= num_SW * 6'd4;
        8'h32:
          need_money_2 <= num_SW * 6'd6;
        8'h33:
          need_money_2 <= num_SW * 6'd15;
        8'h34:
          need_money_2 <= num_SW * 6'd8;
        8'h41:
          need_money_2 <= num_SW * 6'd9;
        8'h42:
          need_money_2 <= num_SW * 6'd4;
        8'h43:
          need_money_2 <= num_SW * 6'd5;
        8'h44:
          need_money_2 <= num_SW * 6'd5;
        default:
          need_money_2 <= 6'd0;  
      endcase
    end
  end


  always @(posedge sys_clk or posedge sys_rst_n)
  begin  // �����״̬����
    if (sys_rst_n)
    begin
      need_money_buf <= 7'd0;     // ������
      input_money_buf <= 8'd0;    // Ͷ�ҵ��ܱ�ֵ
      change_money_buf <= 8'd0;   // �ҳ�������
      flag <= 1'd1;               // ����flag
    end
    else
    begin
      case (state)
        IDLE:
        begin
          input_money_buf <= 8'd0;  // Ͷ�ҵ��ܱ�ֵ
          change_money_buf <= 8'd0;  // �ҳ�������
          need_money_buf <= 7'd0;  // ������
          flag <= 1'd1;  // ����flag
          need_money <= 7'd0;  // ������
        end
        GOODS_one:
        begin
          //����Ҫ����input����ֹ��Ǯ
          change_money_buf <= 8'd0;  // �ҳ�������
          need_money_buf <= need_money_1;  // ��Ʒ 1 ������
          need_money <= need_money_buf;
        end
        GOODS_two:
        begin
          input_money_buf <= 8'd0;  // Ͷ�ҵ��ܱ�ֵ
          change_money_buf <= 8'd0;  // �ҳ����������ֵΪ0����ֹ��������
          need_money_buf <= need_money_2+need_money_1;  // ��Ʒ 2 ������
          need_money <= need_money_buf;
        end
        PAYMENT: // ����״̬������������۸�
        begin
          if (in_money_one)
          begin
            input_money_buf <= input_money_buf + 8'd1;
          end
          else if (in_money_five)
          begin
            input_money_buf <= input_money_buf + 8'd5;
          end
          else if (in_money_ten)
          begin
            input_money_buf <= input_money_buf + 8'd10;
          end
          else if (in_money_twenty)
          begin
            input_money_buf <= input_money_buf + 8'd20;
          end
          else if (in_money_fifty)
          begin
            input_money_buf <= input_money_buf + 8'd50;
          end
          else
          begin
          end
        end

        CHANGE: // ���㣬ʵʱ����������
        begin
          if (input_money_buf > need_money_buf)
          begin
            if(flag)
            begin
              change_money_buf <= input_money_buf - need_money_buf;
              flag=1'd0;
            end
            if (sys_Change)
            begin
              if(change_money_buf >= 8'd50)
              begin
                change_money_buf <= change_money_buf - 8'd50;
              end
              else if (change_money_buf >= 8'd20)
              begin
                change_money_buf <= change_money_buf - 8'd20;
              end
              else if (change_money_buf >= 8'd10)
              begin
                change_money_buf <= change_money_buf - 8'd10;
              end
              else if (change_money_buf >= 8'd5)
              begin
                change_money_buf <= change_money_buf - 8'd5;
              end
              else if (change_money_buf >= 8'd1)
              begin
                change_money_buf <= change_money_buf - 8'd1;
              end
              else
              begin
                change_money_buf <= 8'd0;
              end
            end
          end
        end
        TEMP:
        begin
          need_money_buf <= 7'd0;
          need_money <= 7'd0;  // ����ȡ�������ǲ�ȡ����������Ѿ���ʱ����Ϊ��Ʒ���ֱ��ȡ��
        end

      endcase
    end
  end

endmodule
