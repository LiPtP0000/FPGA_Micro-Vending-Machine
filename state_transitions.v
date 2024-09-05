`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/29 21:55:00
// Design Name: 
// Module Name: fpga_test
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


module state_transitions (
    //����
    input wire sys_clk,
    input wire sys_rst_n,    //��λ-BTND 
    input wire sys_Goods,    //��Ʒѡ���-BTNL 
    input wire sys_Confirm,  //ȷ��-BTNU 
    input wire sys_Change,   //���㰴��-BTNR 
    input wire sys_Cancel,   //ȡ��-BTNC 

    input wire in_money_one,
    input wire in_money_five,
    input wire in_money_ten,
    input wire in_money_twenty,
    input wire in_money_fifty,

    input [2:0] type_SW_high,   //������Ʒ�ı�� ��λ
    input [2:0] type_SW_low,   //������Ʒ�ı�� ��λ
    input [1:0] num_SW,     //������Ʒ������ 


    //���
    output [7:0] Bit_select,
    output [7:0] Seg_select
);
  //����״̬
  parameter IDLE = 6'b000001;
  parameter GOODS_one = 6'b000010;
  parameter GOODS_two = 6'b000100;
  parameter PAYMENT = 6'b001000;
  parameter CHANGE = 6'b010000;
  parameter TEMP = 6'b100000;

  reg  [5:0] state;
  reg  [7:0] need_money_buf = 8'd0;  // ������ 
  reg  [7:0] input_money_buf = 8'd0;  // Ͷ�ҵ��ܱ�ֵ 
  reg  [7:0] change_money_buf = 8'd0;  // �ҳ������� 
  reg  [7:0] need_money_1 = 8'd0;  // ��Ʒ 1 ������ 
  reg  [7:0] need_money_2 = 8'd0;  // ��Ʒ 2 ������ 

  wire [7:0] Price_Money;  // ��Ǯ
  wire [7:0] Input_Money;  // �����Ǯ 
  wire [7:0] Change_Money;  // ���� 
  wire       Goods_btn;
  wire       Confirm_btn;
  wire       Change_btn;
  wire       Cancle_btn;
  wire       money_one;
  wire       money_five;
  wire       money_ten;
  wire       money_twenty;
  wire       money_fifty;
  wire       total_money;
  wire [7:0] goods_code;  // ��Ʒ���
  assign goods_code  = {1'b0, type_SW_high, 1'b0, type_SW_low};

  assign total_money = {money_one, money_five, money_ten, money_twenty, money_fifty};


  /*State Machine layer 1
 *Distinguish states, and state transform
*/

  always @(posedge sys_clk or negedge sys_rst_n) // �첽��λ���ֱ���ʱ�������غ͸�λ�ź��½��ش���  
   begin
    if (sys_rst_n) state <= IDLE;
    else begin
      case (state)
        IDLE:
        if (sys_Confirm)  // ����sys_ConfirmΪ�ߵ�ƽ��Ч�Դ���״̬ת��  
          state <= GOODS_one;  // ��IDLEת��GOODS_one  

        GOODS_one: begin
          if (sys_Goods) begin
            state <= GOODS_two;
          end else if (sys_Confirm) begin
            need_money_buf <= need_money_1;
            state <= PAYMENT;
          end else state <= GOODS_one;
        end

        GOODS_two: begin
          if (sys_Cancel)  // ����ʹ��Cancel������Cancle��Ϊ�ź���  
            state <= GOODS_one;  // ѡ����Ʒ 1  
          else if (sys_Confirm) begin
            state <= PAYMENT;
            need_money_buf <= need_money_1 + need_money_2;  // ����������  
          end else state <= GOODS_two;  // ���ֵ�ǰ״̬  
        end

        PAYMENT: begin
          if (sys_Cancel) state <= TEMP;  // ȡ����ת��TEMP״̬  
          else if (input_money_buf >= need_money_buf & sys_Confirm)
            state <= CHANGE;  // Ͷ���㹻��ת������״̬  
          else state <= PAYMENT;  // ���ֵ�ǰ״̬  
        end

        CHANGE: begin
          if (change_money_buf == 0) state <= IDLE;  // ������ɣ��ص�IDLE״̬  
          else state <= CHANGE;  // ��������  
        end

        TEMP: begin
          if (sys_Confirm) state <= GOODS_one;  // ����ѡ����Ʒ  
          else if (sys_Change) // ����ʹ��sys_Change������sys_cancel��Ϊ�ֶ�������ź���  
            state <= CHANGE;
          else state <= TEMP;  // ���ֵ�ǰ״̬  
        end

        default: state <= IDLE;  // ����δ֪״̬��ȷ��״̬���������δ֪״̬  
      endcase
    end
  end
  /* State Machine layer 2
 * Processing payment status
 * Adding different notes inserted by users, and store the final inserted price in the input_money_buf reg
 *
*/
  always @(posedge sys_clk or negedge sys_rst_n)  //��Ʒһ��״̬���� 
   begin
    if (!sys_rst_n)  // �첽��λ  
      need_money_1 <= 8'd0;
    else if (state == GOODS_one) // ��һ�ε���Ʒ����������  
       begin
      case (goods_code)  //calculate price,result stored in need_money_1  
        8'h11:   need_money_1 <= num_SW * 8'd3;
        8'h12:   need_money_1 <= num_SW * 8'd4;
        8'h13:   need_money_1 <= num_SW * 8'd6;
        8'h14:   need_money_1 <= num_SW * 8'd3;
        8'h21:   need_money_1 <= num_SW * 8'd10;
        8'h22:   need_money_1 <= num_SW * 8'd8;
        8'h23:   need_money_1 <= num_SW * 8'd9;
        8'h24:   need_money_1 <= num_SW * 8'd7;
        8'h31:   need_money_1 <= num_SW * 8'd4;
        8'h32:   need_money_1 <= num_SW * 8'd6;
        8'h33:   need_money_1 <= num_SW * 8'd15;
        8'h34:   need_money_1 <= num_SW * 8'd8;
        8'h41:   need_money_1 <= num_SW * 8'd9;
        8'h42:   need_money_1 <= num_SW * 8'd4;
        8'h43:   need_money_1 <= num_SW * 8'd5;
        8'h44:   need_money_1 <= num_SW * 8'd5;
        default: need_money_1 <= 8'd0;
      endcase
    end
  end

  always @(posedge sys_clk or negedge sys_rst_n) begin  // ��Ʒ����״̬����  
    if (!sys_rst_n) begin  // �첽��λ  
      need_money_2 <= 8'd0;
    end else if (state == GOODS_two) begin  // ��2�ε���Ʒ����������  
      case (goods_code)  // ��Ʒ���  
        8'h11: need_money_2 <= num_SW * 8'd3;
        8'h12: need_money_2 <= num_SW * 8'd4;
        8'h13: need_money_2 <= num_SW * 8'd6;
        8'h14: need_money_2 <= num_SW * 8'd3;
        8'h21: need_money_2 <= num_SW * 8'd10;
        8'h22: need_money_2 <= num_SW * 8'd8;
        8'h23: need_money_2 <= num_SW * 8'd9;
        8'h24: need_money_2 <= num_SW * 8'd7;
        8'h31: need_money_2 <= num_SW * 8'd4;
        8'h32: need_money_2 <= num_SW * 8'd6;
        8'h33: need_money_2 <= num_SW * 8'd15;
        8'h34: need_money_2 <= num_SW * 8'd8;
        8'h41: need_money_2 <= num_SW * 8'd9;
        8'h42: need_money_2 <= num_SW * 8'd4;
        8'h43: need_money_2 <= num_SW * 8'd5;
        8'h44: need_money_2 <= num_SW * 8'd5;
        default:
        need_money_2 <= 8'd0;  // ���û��ƥ���goods_code����need_money_2����Ϊ0  
      endcase
    end
  end


  always @(posedge sys_clk or negedge sys_rst_n) begin  // �����״̬����  
    if (!sys_rst_n) begin  // �첽��λ  
      input_money_buf <= 8'd0;
    end else if (state == PAYMENT) begin
      //Need display: show user the amount of inserted money
      // Ͷ��״̬  
      if (in_money_one) begin
        input_money_buf <= input_money_buf + 8'd1;
      end else if (in_money_five) begin
        input_money_buf <= input_money_buf + 8'd5;
      end else if (in_money_ten) begin
        input_money_buf <= input_money_buf + 8'd10;
      end else if (in_money_twenty) begin
        input_money_buf <= input_money_buf + 8'd20;
      end else if (in_money_fifty) begin
        input_money_buf <= input_money_buf + 8'd50;
      end else begin
      end
    end
  end
  always @(posedge sys_clk or negedge sys_rst_n) begin
    //Change & Refund
    //no rst
    if (state == CHANGE) begin
      if (input_money_buf > need_money_buf) begin
        change_money_buf <= input_money_buf - need_money_buf;
        if (sys_Change) begin
          change_money_buf <= change_money_buf - 8'd1;
        end
      end
    end
  end

endmodule
