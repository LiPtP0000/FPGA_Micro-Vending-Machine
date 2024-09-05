`timescale 1ns / 1ps

module state_transitions_tb();

    // �����ź�
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
    reg [7:0] input_money;
    reg [7:0] need_money;
    reg [7:0] change_money;

    // ����ź�
    wire [7:0] Bit_select;
    wire [7:0] Seg_select;
    wire [5:0] state; // ���� state ����ź�

    // ʵ����������ģ��
    state_transitions uut (
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
        .Bit_select(Bit_select),
        .Seg_select(Seg_select),
        .input_money_out(input_money),
        .state_out(state),
        .need_money_out(need_money),
        .change_money_out(change_money)
    );

    // ʱ������
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk; // 100MHz ʱ��
    end

    // ���Լ���
    initial begin
    $monitor("Time = %0t | state = %b | need_money_buf = %d | input_money_buf = %d | change_money_buf = %d | Bit_select = %b | Seg_select = %b",
                 $time, uut.state, uut.need_money_buf, uut.input_money_buf, uut.change_money_buf, Bit_select, Seg_select);
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
        #100 sys_rst_n = 1;
        #10 sys_rst_n = 0;

        // ģ�������źţ��ӳ�ʱ��
        #200 sys_Confirm = 1; #10 sys_Confirm = 0;
        #100 type_SW_high = 3'd2;
        #100 type_SW_low = 3'd1;
        #100 num_SW = 2'd3;
        #100 sys_Goods = 1; #10 sys_Goods = 0;
        #100 type_SW_high = 3'd3;
        #100 type_SW_low = 3'd3;
        #100 num_SW = 2'd1;
        #100 sys_Confirm = 1; #10 sys_Confirm = 0;
        #100 in_money_one = 1; #10 in_money_one = 0;
        #100 in_money_five = 1; #10 in_money_five = 0;
        #100 in_money_ten = 1; #10 in_money_ten = 0;
        #100 in_money_twenty = 1; #10 in_money_twenty = 0;
        #100 in_money_fifty = 1; #10 in_money_fifty = 0;
        #100 sys_Change = 1; #10 sys_Change = 0;
        #100 sys_Change = 1; #10 sys_Change = 0;
        #100 sys_Change = 1; #10 sys_Change = 0;
        #100 sys_Change = 1; #10 sys_Change = 0;

        // ��������
        #20000 $finish;
    end

    // �����źŵ�ֵ
    initial begin
        // ����״̬����Ҫ��������������
        $monitor("Time = %0t | state = %b | need_money_buf = %d | input_money_buf = %d | change_money_buf = %d | Bit_select = %b | Seg_select = %b",
                 $time, uut.state, uut.need_money_buf, uut.input_money_buf, uut.change_money_buf, Bit_select, Seg_select);
    end

endmodule

