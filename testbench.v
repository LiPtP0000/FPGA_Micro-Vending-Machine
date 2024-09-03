`timescale  1ns / 1ps

module tb_state_transitions;

// state_transitions Parameters
parameter PERIOD     = 10       ;
parameter IDLE       = 6'b000001;
parameter GOODS_one  = 6'b000010;
parameter GOODS_two  = 6'b000100;
parameter PAYMENT    = 6'b001000;
parameter CHANGE     = 6'b010000;
parameter TEMP       = 6'b100000;

// state_transitions Inputs
reg   sys_clk                              = 0 ;
reg   sys_rst_n                            = 0 ;
reg   sys_Goods                            = 0 ;
reg   sys_Confirm                          = 0 ;
reg   sys_Change                           = 0 ;
reg   sys_Cancel                           = 0 ;
reg   in_money_one                         = 0 ;
reg   in_money_five                        = 0 ;
reg   in_money_ten                         = 0 ;
reg   in_money_twenty                      = 0 ;
reg   in_money_fifty                       = 0 ;
reg   [2:0]  rows_num                      = 0 ;
reg   [2:0]  column_num                    = 0 ;
reg   [1:0]  commodity_num                 = 0 ;
reg   [2:0]  type_SW1                      = 0 ;
reg   [2:0]  type_SW2                      = 0 ;
reg   [1:0]  num_SW                        = 0 ;
reg   _money_buf                           = 0 ;
reg   _money_buf >                         = 0 ;
reg   _money_buf <                         = 0 ;
reg   _money_buf <                         = 0 ;
reg   _money_buf <                         = 0 ;
reg   _money_buf <                         = 0 ;
reg   _money_buf <                         = 0 ;
reg   _money_buf <                         = 0 ;
reg   _money_buf > need_money_buf          = 0 ;
reg   _money_buf - need_money_buf          = 0 ;

// state_transitions Outputs
wire  [7:0]  Bit_select                    ;
wire  [7:0]  Seg_select                    ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

state_transitions (
    .IDLE      ( IDLE      ),
    .GOODS_one ( GOODS_one ),
    .GOODS_two ( GOODS_two ),
    .PAYMENT   ( PAYMENT   ),
    .CHANGE    ( CHANGE    ),
    .TEMP      ( TEMP      ))
 u_state_transitions (
    .sys_clk                      ( sys_clk                            ),
    .sys_rst_n                    ( sys_rst_n                          ),
    .sys_Goods                    ( sys_Goods                          ),
    .sys_Confirm                  ( sys_Confirm                        ),
    .sys_Change                   ( sys_Change                         ),
    .sys_Cancel                   ( sys_Cancel                         ),
    .in_money_one                 ( in_money_one                       ),
    .in_money_five                ( in_money_five                      ),
    .in_money_ten                 ( in_money_ten                       ),
    .in_money_twenty              ( in_money_twenty                    ),
    .in_money_fifty               ( in_money_fifty                     ),
    .rows_num                     ( rows_num                     [2:0] ),
    .column_num                   ( column_num                   [2:0] ),
    .commodity_num                ( commodity_num                [1:0] ),
    .type_SW1                     ( type_SW1                     [2:0] ),
    .type_SW2                     ( type_SW2                     [2:0] ),
    .num_SW                       ( num_SW                       [1:0] ),
    ._money_buf                   ( _money_buf                         ),
    ._money_buf >                 ( _money_buf >                       ),
    ._money_buf <                 ( _money_buf <                       ),
    ._money_buf <                 ( _money_buf <                       ),
    ._money_buf <                 ( _money_buf <                       ),
    ._money_buf <                 ( _money_buf <                       ),
    ._money_buf <                 ( _money_buf <                       ),
    ._money_buf <                 ( _money_buf <                       ),
    ._money_buf > need_money_buf  ( _money_buf > need_money_buf        ),
    ._money_buf - need_money_buf  ( _money_buf - need_money_buf        ),

    .Bit_select                   ( Bit_select                   [7:0] ),
    .Seg_select                   ( Seg_select                   [7:0] )
);

initial
begin

    $finish;
end

endmodule