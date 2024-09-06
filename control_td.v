`timescale 1ns / 1ps

module state_transitions_tb();

    // 输入信号
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
    wire [7:0] input_money;
    wire [7:0] need_money;
    wire [7:0] change_money;

    // 输出信号
    wire [7:0] Bit_select;
    wire [7:0] Seg_select;
    wire [5:0] state; // 增加 state 输出信号

    // 实例化被测试模块
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

    // 时钟生成
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk; // 100MHz 时钟
    end

    // 测试激励
    initial begin
    $monitor("Time = %0t | state = %b | need_money_buf = %d | input_money_buf = %d | change_money_buf = %d | Bit_select = %b | Seg_select = %b",
                 $time, uut.state, uut.need_money_buf, uut.input_money_buf, uut.change_money_buf, Bit_select, Seg_select);
        // 初始化信号
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

        // 激活复位信号并松开
        #100 sys_rst_n = 1;
        #10 sys_rst_n = 0;

        // 模拟输入信号，延长时间
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

        // 结束仿真
        #20000 $finish;
    end

    // 监视信号的值
    initial begin
        // 监视状态、需要金额、输入金额、找零金额等
        $monitor("Time = %0t | state = %b | need_money_buf = %d | input_money_buf = %d | change_money_buf = %d | Bit_select = %b | Seg_select = %b",
                 $time, uut.state, uut.need_money_buf, uut.input_money_buf, uut.change_money_buf, Bit_select, Seg_select);
    end

endmodule

