`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/9/4 11:17
// Design Name:
// Module Name: STATE_TRANSITIONS_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Testbench for state_transitions module
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module STATE_TRANSITIONS_tb();

    // �����źŶ���
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

  // ����źŶ���
  wire [7:0] input_money;
  wire [6:0] need_money;
  wire [7:0] change_money;
  wire [5:0] state_out;

  // ʵ����������ģ��
  STATE_TRANSITIONS uut (
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
    .input_money(input_money),
    .need_money(need_money),
    .change_money(change_money),
    .state_out(state_out)
  );

    // ʱ������
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk; // 100MHz ʱ��
    end

    // ���Լ���
    initial begin
        
        // ��ʼ���ź�
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

        // ���λ�źŲ��ɿ�
        //#100 sys_rst_n = 1;
        //#10 sys_rst_n = 0;
        sys_rst_n = 1; // ��ʼ״̬Ϊ��λ
        // �����źų�ʼ��

        #10; // ���ָ�λ�ź�һ��ʱ��
        sys_rst_n = 0; // �����λ

        // ģ�������źţ��ӳ�ʱ��
        #200 sys_Confirm = 1; #10 sys_Confirm = 0;
        #100 type_SW_high = 3'd2;
        #100 type_SW_low = 3'd3;
        #100 num_SW = 2'd3;
        #100 sys_Goods = 1; #10 sys_Goods = 0;
        #100 type_SW_high = 3'd1;
        #100 type_SW_low = 3'd1;
        #100 num_SW = 2'd1;
        #100 sys_Confirm = 1; #10 sys_Confirm = 0;
        #100 in_money_one = 1; #10 in_money_one = 0;
        #100 in_money_five = 1; #10 in_money_five = 0;
        #100 in_money_ten = 1; #10 in_money_ten = 0;
        #100 in_money_twenty = 1; #10 in_money_twenty = 0;
        #100 in_money_fifty = 1; #10 in_money_fifty = 0;
        #100 sys_Confirm = 1; #10 sys_Confirm = 0;
        #100 sys_Change = 1; #10 sys_Change = 0;
        #100 sys_Change = 1; #10 sys_Change = 0;
        #100 sys_Change = 1; #10 sys_Change = 0;
        #100 sys_Change = 1; #10 sys_Change = 0;
        #2000;
        sys_rst_n = 0; // ��ʼ״̬Ϊ��λ
        #10; // ���ָ�λ�ź�һ��ʱ��
        sys_rst_n = 1; // �����λ
        #10000
        // simulation #2 test cancel
        
        sys_rst_n = 0;
        #100 sys_Confirm=1; #10 sys_Confirm=0;
        #100 type_SW_high=3'd2;
        #100 type_SW_low=3'd1;

        #100 num_SW=3'd1;
        #100 sys_Confirm=1; #10 sys_Confirm=0;
        #100 in_money_fifty=1; #10 in_money_fifty=0;
        #100 
        #100 sys_Cancel=1; #10 sys_Cancel=0;
        #100 sys_Confirm=1; #10 sys_Confirm=0;
        #2000 sys_Change=1; #10 sys_Change=0;
        #2000 sys_Change=1; #10 sys_Change=0;
        #2000 sys_Change=1; #10 sys_Change=0;
        // ��������
        #20000 $finish;
    end

    // ���� GTKwave ���ɲ���ͼ
    initial begin
        $dumpfile("wave.vcd");  //���ɲ���ͼ�ļ�
        $dumpvars(0,STATE_TRANSITIONS_tb); // tbģ������ 
    end
endmodule

