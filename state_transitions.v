module state_transitions (
    // 输入
    input wire sys_clk,
    input wire sys_rst_n,
    input wire sys_Goods,
    input wire sys_Confirm,
    input wire sys_Change,
    input wire sys_Cancel,
    input wire in_money_one,
    input wire in_money_five,
    input wire in_money_ten,
    input wire in_money_twenty,
    input wire in_money_fifty,
    input [2:0] type_SW_high,
    input [2:0] type_SW_low,
    input [1:0] num_SW,

    // 输出
    output reg [7:0] Bit_select,  // 需要在模块中定义
    output reg [7:0] Seg_select,  // 需要在模块中定义
    output wire [7:0] input_money,
    output wire [7:0] need_money,
    output wire [7:0] change_money,
    output wire [5:0] state_out

  );
  //定义状态
  parameter IDLE = 6'b000001;       //01H
  parameter GOODS_one = 6'b000010;  //02H
  parameter GOODS_two = 6'b000100;  //04H
  parameter PAYMENT = 6'b001000;    //08H
  parameter CHANGE = 6'b010000;     //10H
  parameter TEMP = 6'b100000;       //20H

  reg  [5:0] state;
  reg  [7:0] need_money_buf = 8'd0;  // 所需金额
  reg  [7:0] input_money_buf = 8'd0;  // 投币的总币值
  reg  [7:0] change_money_buf = 8'd0;  // 找出多余金额，不赋值为0，防止竞争条件
  reg  [7:0] need_money_1 = 8'd0;  // 商品 1 所需金额
  reg  [7:0] need_money_2 = 8'd0;  // 商品 2 所需金额
  reg        flag = 1'd1;
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
  wire [7:0] goods_code;  // 商品编号
  assign goods_code  = {1'b0, type_SW_high, 1'b0, type_SW_low};

  assign total_money = {money_one, money_five, money_ten, money_twenty, money_fifty};


  /*State Machine layer 1
  *Distinguish states, and state transform
  */

  always @(posedge sys_clk or negedge sys_rst_n) // 异步复位，分别在时钟上升沿和复位信号下降沿触发
  begin
    if (!sys_rst_n)
      state <= IDLE;
    else
    begin
      case (state)
        IDLE:
          if (sys_Confirm)
          begin
            state <= GOODS_one;  // 从IDLE转到GOODS_one
          end

        GOODS_one:
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

        GOODS_two:
        begin
          if (sys_Cancel)
            state <= GOODS_one;  // 选择商品 1
          else if (sys_Confirm)
          begin
            state <= PAYMENT;

          end
          else
            state <= GOODS_two;  // 保持当前状态
        end

        PAYMENT:
        begin
          if (sys_Cancel)
            state <= TEMP;  // 取消并转到TEMP状态
          else if (input_money_buf >= need_money_buf & sys_Confirm)
            state <= CHANGE;  // 投币足够，转到找零状态
          else
            state <= PAYMENT;  // 保持当前状态
        end

        CHANGE:
        begin
          if (change_money_buf == 0)
            #20 state <= IDLE;  // 找零完成，回到IDLE状态
          else
            state <= CHANGE;  // 继续找零
        end

        TEMP:
        begin
          if (sys_Cancel)
            state <= IDLE;  // 重新选择商品
          else if (sys_Confirm) // 假设使用sys_Change而不是sys_cancel作为手动找零的信号名
            state <= CHANGE;
          else
            state <= TEMP;  // 保持当前状态
        end

        default:
          state <= IDLE;  // 处理未知状态，确保状态机不会进入未知状态
      endcase
    end
  end
  /* State Machine layer 2
  * Processing payment status
  * Adding different notes inserted by users, and store the final inserted price in the input_money_buf reg
  *
  */
  always @(posedge sys_clk or negedge sys_rst_n)  //商品一的状态处理
  begin
    if (!sys_rst_n)  // 异步复位
      need_money_1 <= 8'd0;
    else if (state == GOODS_one) // 第一次的商品数量和种类
    begin
      case (goods_code)  //calculate price,result stored in need_money_1
        8'h11:
          need_money_1 <= num_SW * 8'd3;
        8'h12:
          need_money_1 <= num_SW * 8'd4;
        8'h13:
          need_money_1 <= num_SW * 8'd6;
        8'h14:
          need_money_1 <= num_SW * 8'd3;
        8'h21:
          need_money_1 <= num_SW * 8'd10;
        8'h22:
          need_money_1 <= num_SW * 8'd8;
        8'h23:
          need_money_1 <= num_SW * 8'd9;
        8'h24:
          need_money_1 <= num_SW * 8'd7;
        8'h31:
          need_money_1 <= num_SW * 8'd4;
        8'h32:
          need_money_1 <= num_SW * 8'd6;
        8'h33:
          need_money_1 <= num_SW * 8'd15;
        8'h34:
          need_money_1 <= num_SW * 8'd8;
        8'h41:
          need_money_1 <= num_SW * 8'd9;
        8'h42:
          need_money_1 <= num_SW * 8'd4;
        8'h43:
          need_money_1 <= num_SW * 8'd5;
        8'h44:
          need_money_1 <= num_SW * 8'd5;
        default:
          need_money_1 <= 8'd0;
      endcase
    end
  end

  always @(posedge sys_clk or negedge sys_rst_n)
  begin  // 商品二的状态处理
    if (!sys_rst_n)
    begin  // 异步复位
      need_money_2 <= 8'd0;
    end
    else if (state == GOODS_two)
    begin  // 第2次的商品数量和种类
      case (goods_code)  // 商品编号
        8'h11:
          need_money_2 <= num_SW * 8'd3;
        8'h12:
          need_money_2 <= num_SW * 8'd4;
        8'h13:
          need_money_2 <= num_SW * 8'd6;
        8'h14:
          need_money_2 <= num_SW * 8'd3;
        8'h21:
          need_money_2 <= num_SW * 8'd10;
        8'h22:
          need_money_2 <= num_SW * 8'd8;
        8'h23:
          need_money_2 <= num_SW * 8'd9;
        8'h24:
          need_money_2 <= num_SW * 8'd7;
        8'h31:
          need_money_2 <= num_SW * 8'd4;
        8'h32:
          need_money_2 <= num_SW * 8'd6;
        8'h33:
          need_money_2 <= num_SW * 8'd15;
        8'h34:
          need_money_2 <= num_SW * 8'd8;
        8'h41:
          need_money_2 <= num_SW * 8'd9;
        8'h42:
          need_money_2 <= num_SW * 8'd4;
        8'h43:
          need_money_2 <= num_SW * 8'd5;
        8'h44:
          need_money_2 <= num_SW * 8'd5;
        default:
          need_money_2 <= 8'd0;  // 如果没有匹配的goods_code，将need_money_2设置为0
      endcase
    end
  end


  always @(posedge sys_clk or negedge sys_rst_n)
  begin  // 付款的状态处理
    if (!sys_rst_n)
    begin  // 异步复位
      input_money_buf <= 8'd0;
    end
    else if (state == IDLE)
    begin
      need_money_buf <= 8'd0;     // 所需金额
      input_money_buf <= 8'd0;    // 投币的总币值
      change_money_buf <= 8'd0;   // 找出多余金额，不赋值为0，防止竞争条件
      flag <= 1'd1;               // 重置flag
    end
    else if (state == GOODS_one)
    begin
      need_money_buf <= need_money_1;  // 商品 1 所需金额
      input_money_buf <= 8'd0;  // 投币的总币值
      change_money_buf <= 8'd0;  // 找出多余金额，不赋值为0，防止竞争条件
    end
    else if (state == GOODS_two)
    begin
      need_money_buf <= need_money_1+need_money_2;  // 商品 2 所需金额
      input_money_buf <= 8'd0;  // 投币的总币值
      change_money_buf <= 8'd0;  // 找出多余金额，不赋值为0，防止竞争条件
    end
    else if (state == PAYMENT)
    begin
      //Need display: show user the amount of inserted money
      // 投币状态
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
    else if (state == CHANGE)
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
  end
  assign input_money = input_money_buf;  // 投币的总币值
  assign need_money = need_money_buf;
  assign change_money = change_money_buf;  // 找出多余金额
  assign state_out = state;
endmodule

