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
    input wire sys_clk,       // ϵͳʱ��
    // input wire sys_rst_n,     // ȫ�ָ�λ
    input wire key_in,        // ���������ź�
    output reg key_posedge    // �������⵽������������
);

// ���������ֵ������Ϊ����ʱ�䣨����20ms���ļ���ֵ
parameter CNT_MAX = 20'hf_ffff;  // Լ��20λ�ļ���ֵ

// �ڲ��Ĵ�������
reg [1:0] key_in_r;        // ���ڴ洢�������������ʱ������ֵ
(*keep*) reg [19:0] cnt_base;       // �ӳټ����������ڼ��������ȶ�ʱ��
reg key_value_r;           // ����ֵ�Ĵ��������ڱ���������İ���ֵ
reg key_value_rd;          // ����ֵ�Ĵ��������ڱ���ǰһ���ڵİ���ֵ

// ��¼���������źŵ�����״̬�����ڱ��ؼ��
always @(posedge sys_clk) begin
     key_in_r <= {key_in_r[0], key_in};  // ��λ�Ĵ������水�������ǰ����״̬
end

// �ӳټ������߼�������⵽����״̬�����仯ʱ������������
always @(posedge sys_clk) begin  
    if (key_in_r[0] != key_in_r[1])
        cnt_base <= 20'b0;  // �������״̬�����仯������������
    else if (cnt_base < CNT_MAX)
        cnt_base <= cnt_base + 1'b1;  // �������������
end

// ����ֵ�Ĵ����߼������ӳټ������ﵽ���ֵʱ�����°���״̬
always @(posedge sys_clk) begin
    if (cnt_base == CNT_MAX)
        key_value_r <= key_in_r[0];  // ���������ﵽ���ֵʱ���°���״̬
end

// ������һ��ʱ�����ڵİ���ֵ�����ڱ��ؼ��
always @(posedge sys_clk) begin
        key_value_rd <= key_value_r;  // ������һ�����ڵİ���ֵ
end

// ��ⰴ����������
always @(posedge sys_clk) begin
        key_posedge <= key_value_r & ~key_value_rd;  // ���ڰ���ֵ��0��Ϊ1ʱ����ߵ�ƽ
end
endmodule