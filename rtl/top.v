`timescale 1ns / 1ps
`default_nettype none

module top
(
    input  wire i_clock,
    
    input  wire i_reset,
        
    output wire o_led0_g,
    output wire o_led0_r,
    output wire o_led0_b,
    output wire o_led1_g,
    output wire o_led1_r,
    output wire o_led1_b,
    
    output wire o_tx_ch1_l,
    output wire o_tx_ch1_h,
    
    input  wire i_rx,
    
    input  wire i_sample,
    
    input  wire i_gate,
    
    output wire o_buzzer,   
    
    input  wire i_adc_data_0,
    input  wire i_adc_data_1,
    input  wire i_adc_data_2,
    input  wire i_adc_data_3,
    input  wire i_adc_data_4,
    input  wire i_adc_data_5,
    input  wire i_adc_data_6,
    input  wire i_adc_data_7,
    input  wire i_adc_data_8,
    input  wire i_adc_data_9,
    input  wire i_adc_data_10,
    input  wire i_adc_data_11,
    input  wire i_adc_data_12,
    input  wire i_adc_data_13,
    inout  wire io_adc_sdio,
    input  wire i_adc_dco_clock_p,
    output wire o_adc_dco_clock_n,
    output wire o_adc_sclk,
    output wire o_adc_clock_in_n,
    output wire o_adc_clock_in_p,
    output wire o_ch1_coupling_h,
    output wire o_ch1_coupling_l,
    output wire o_ch2_coupling_h,
    output wire o_ch2_coupling_l,
    output wire o_ch2_gain_h,
    output wire o_ch2_gain_l,
    output wire o_ch1_gain_l,
    output wire o_ch1_gain_h,
    output wire o_adc_relay_com_l,
    output wire o_adc_relay_com_h,
    output wire o_adc_cs,
    output wire o_adc_sync       
);
    
    /* ########################################################### */
    /* CLOCK UNIT ################################################ */
    
    wire    sys_clock;
    wire    sys_reset;
    wire    adc_clock;
    
    clock_unit #
    (
    )
    u_clock_unit
    (
        .i_clock        ( i_clock   ),
        .i_reset        ( i_reset   ),
        .o_adc_clock    ( adc_clock ),
        .o_sys_clock    ( sys_clock ),
        .o_valid        ( sys_reset )
    );
    
    /* ########################################################### */
    /* ADC1410 ################################################### */
    
    localparam  ADC1410_DATA_SIZE   =   16;
    
    wire                                    adc1410_reset;
    wire    [ ADC1410_DATA_SIZE - 1 : 0 ]   adc1410_ch1;
    wire    [ ADC1410_DATA_SIZE - 1 : 0 ]   adc1410_ch2;
    wire                                    adc1410_init_done;
    
    assign adc1410_reset = sys_reset || cmd_reset;
    
    adc1410 #
    (
        .DATA_SIZE          ( ADC1410_DATA_SIZE )
    )
    u_adc1410
    (
        .i_sys_clock        ( sys_clock         ),
        .i_adc_clock        ( adc_clock         ),
        .i_reset            ( adc1410_reset     ),
        .i_adc_data_0       ( i_adc_data_0      ),
        .i_adc_data_1       ( i_adc_data_1      ),
        .i_adc_data_2       ( i_adc_data_2      ),
        .i_adc_data_3       ( i_adc_data_3      ),
        .i_adc_data_4       ( i_adc_data_4      ),
        .i_adc_data_5       ( i_adc_data_5      ),
        .i_adc_data_6       ( i_adc_data_6      ),
        .i_adc_data_7       ( i_adc_data_7      ),
        .i_adc_data_8       ( i_adc_data_8      ),
        .i_adc_data_9       ( i_adc_data_9      ),
        .i_adc_data_10      ( i_adc_data_10     ),
        .i_adc_data_11      ( i_adc_data_11     ),
        .i_adc_data_12      ( i_adc_data_12     ),
        .i_adc_data_13      ( i_adc_data_13     ),
        .io_adc_sdio        ( io_adc_sdio       ),
        .i_adc_dco_clock_p  ( i_adc_dco_clock_p ),
        .o_adc_dco_clock_n  ( o_adc_dco_clock_n ),
        .o_adc_sclk         ( o_adc_sclk        ),
        .o_adc_clock_in_n   ( o_adc_clock_in_n  ),
        .o_adc_clock_in_p   ( o_adc_clock_in_p  ),
        .o_ch1_coupling_h   ( o_ch1_coupling_h  ),
        .o_ch1_coupling_l   ( o_ch1_coupling_l  ),
        .o_ch2_coupling_h   ( o_ch2_coupling_h  ),
        .o_ch2_coupling_l   ( o_ch2_coupling_l  ),
        .o_ch2_gain_h       ( o_ch2_gain_h      ),
        .o_ch2_gain_l       ( o_ch2_gain_l      ),
        .o_ch1_gain_l       ( o_ch1_gain_l      ),
        .o_ch1_gain_h       ( o_ch1_gain_h      ),
        .o_adc_relay_com_l  ( o_adc_relay_com_l ),
        .o_adc_relay_com_h  ( o_adc_relay_com_h ),
        .o_adc_cs           ( o_adc_cs          ),
        .o_adc_sync         ( o_adc_sync        ),
        .o_data_out_ch1     ( adc1410_ch1       ),
        .o_data_out_ch2     ( adc1410_ch2       ),
        .o_init_done        ( adc1410_init_done ) 
    );
    
    /* ########################################################### */
    /* DATA CONVERSORS ########################################### */
    
    localparam  CONVERSOR_DATA_SIZE =   14;
    
    wire    [ CONVERSOR_DATA_SIZE - 1 : 0 ] conversor_ch1;
    wire    [ CONVERSOR_DATA_SIZE - 1 : 0 ] conversor_ch2;
    
    data_conversor #
    (
        .CONVERSOR_DATA_SIZE    ( CONVERSOR_DATA_SIZE   )
    )
    u_data_conversor_ch1
    (
        .i_data                 ( adc1410_ch1[15:2]     ),
        .o_data                 ( conversor_ch1         )
    );
    
    data_conversor #
    (
        .CONVERSOR_DATA_SIZE    ( CONVERSOR_DATA_SIZE   )
    )
    u_data_conversor_ch2
    (
        .i_data                 ( adc1410_ch2[15:2]     ),
        .o_data                 ( conversor_ch2         )
    );
    
    /* ########################################################### */
    /* RAMP ###################################################### */
    
    reg [ CONVERSOR_DATA_SIZE - 1 : 0 ] ramp;
    
    always@( posedge sys_clock ) begin
        ramp <=  ~i_gate ? { CONVERSOR_DATA_SIZE { 1'b0 } } : ramp + 1'b1;
    end
    
    /* ########################################################### */
    /* SAMPLERS ################################################## */
    
    localparam  SAMPLER_DATA_SIZE  =   16;
    
    wire                                    sample;
    wire    [ SAMPLER_DATA_SIZE - 1 : 0 ]   sampler_ch1;
    wire                                    sampler_valid_ch1;
    wire                                    sampler_idle_ch1;
    
    assign sample = i_sample || cmd_sample;
    
    sampler #
    (
        .DATA_SIZE      ( SAMPLER_DATA_SIZE             )
    )
    u_sampler_ch1
    (
        .i_clock        ( sys_clock                     ),
        .i_reset        ( sys_reset                     ),
        .i_next         ( uart_tx_ready                 ),
        .i_data         ( conversor_ch1                 ),
        .i_gate         ( i_gate                        ),
        .i_sample       ( sample                        ),
        .i_adc_init     ( adc1410_init_done             ),
        .i_cmd_decim    ( cmd_set_decim                 ),
        .i_cmd_param    ( cmd_param                     ),
        .o_data         ( sampler_ch1                   ),
        .o_valid        ( sampler_valid_ch1             ),
        .o_idle         ( sampler_idle_ch1              )
    );
   
    /* ########################################################### */
    /* TX UARTS ################################################## */
    
    localparam UART_DATA_SIZE    = 8;
    
    wire    uart_tx_ready;
    wire    uart_tx_ready_ch1_l;
    wire    uart_tx_ready_ch1_h;
    wire    uart_tx_busy_ch1_l;
    wire    uart_tx_busy_ch1_h;
    
    assign  uart_tx_ready = uart_tx_ready_ch1_l && uart_tx_ready_ch1_h;
    
    uart_tx #
    (
        .CLK_FREQUENCY  ( 100000000             ),
        .UART_FREQUENCY ( 9600                  )
    )
    u_uart_tx_ch1_l
    (
        .user_clk       ( sys_clock             ),
        .rst_n          ( ~sys_reset            ),
        .start_tx       ( sampler_valid_ch1     ),
        .data           ( sampler_ch1[ 7 : 0 ]  ),
        .tx_bit         ( o_tx_ch1_l            ),
        .ready          ( uart_tx_ready_ch1_l   ),
        .chipscope_clk  ()
    );
    
    uart_tx #
    (
        .CLK_FREQUENCY  ( 100000000             ),
        .UART_FREQUENCY ( 9600                  )
    )
    u_uart_tx_ch1_h
    (
        .user_clk       ( sys_clock             ),
        .rst_n          ( ~sys_reset            ),
        .start_tx       ( sampler_valid_ch1     ),
        .data           ( sampler_ch1[ 13 : 6 ] ),
        .tx_bit         ( o_tx_ch1_h            ),
        .ready          ( uart_tx_ready_ch1_h   ),
        .chipscope_clk  ()
    );
    
    /* ########################################################### */
    /* COMMAND UNIT ############################################## */
    
    wire                                wait_cmd;
    wire                                cmd_reset;
    wire                                cmd_sample;
    wire                                cmd_set_decim;
    wire    [ UART_DATA_SIZE - 1 : 0 ]  cmd_param;
    wire                                cmd_succes;
    wire                                cmd_error;
    
    command_unit #
    (
        .DATA_SIZE          ( UART_DATA_SIZE        )
    )
    u_command_unit
    (
        .i_clock            ( sys_clock             ),
        .i_reset            ( sys_reset             ),
        .i_rx               ( i_rx                  ),
        .o_wait_cmd         ( wait_cmd              ),
        .o_cmd_reset        ( cmd_reset             ),
        .o_cmd_sample       ( cmd_sample            ),
        .o_cmd_set_decim    ( cmd_set_decim         ),
        .o_cmd_param        ( cmd_param             ),
        .o_error            ( cmd_error             ),
        .o_succes           ( cmd_succes            )
    );
        
    /* ########################################################### */
    /* PMOD UNIT ################################################# */
    
    pmod_unit
    u_pmod_unit
    (
        .i_clock            ( sys_clock             ),
        .i_reset            ( sys_reset             ),
        .i_init_done        ( adc1410_init_done     ),
        .i_idle             ( sampler_idle_ch1      ),
        .i_wait_cmd         ( wait_cmd              ),
        .i_error            ( cmd_error             ),
        .i_succes           ( cmd_succes            ),
        .o_led0_r           ( o_led0_r              ),
        .o_led0_g           ( o_led0_g              ),
        .o_led0_b           ( o_led0_b              ),
        .o_led1_r           ( o_led1_r              ),
        .o_led1_g           ( o_led1_g              ),
        .o_led1_b           ( o_led1_b              )
    );
        
endmodule

`default_nettype wire
