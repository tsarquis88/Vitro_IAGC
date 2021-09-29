`timescale 1ns / 1ps
`default_nettype none

module top
(
    input  wire i_clock,
    
    input  wire i_reset,
        
    output wire o_led0_g,
    output wire o_led0_r,
    output wire o_led0_b,
    
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
    /* SAMPLERS ################################################## */
    
    localparam  SAMPLER_DATA_SIZE  =   8;
    
    wire                                    sample;
    wire    [ SAMPLER_DATA_SIZE - 1 : 0 ]   sampler_ch1_l;
    wire    [ SAMPLER_DATA_SIZE - 1 : 0 ]   sampler_ch1_h;
    wire                                    sampler_valid_ch1_l;
    wire                                    sampler_valid_ch1_h;
    wire                                    sampler_idle_ch1_l;
    wire                                    sampler_idle_ch1_h;
    
    assign sample = i_sample || cmd_sample;
    
    sampler #
    (
        .DATA_SIZE      ( SAMPLER_DATA_SIZE             )
    )
    u_sampler_ch1_l
    (
        .i_clock        ( sys_clock                     ),
        .i_reset        ( sys_reset                     ),
        .i_next         ( uart_tx_ready_ch1_l           ),
        .i_data         ( conversor_ch1[ 7 : 0 ]        ),
        .i_gate         ( i_gate                        ),
        .i_sample       ( sample                        ),
        .i_adc_init     ( adc1410_init_done             ),
        .i_cmd_decim    ( cmd_decim                     ),
        .i_cmd_param    ( cmd_param                     ),
        .o_data         ( sampler_ch1_l                 ),
        .o_valid        ( sampler_valid_ch1_l           ),
        .o_idle         ( sampler_idle_ch1_l            )
    );
    
    sampler #
    (
        .DATA_SIZE      ( SAMPLER_DATA_SIZE             )
    )
    u_sampler_ch1_h
    (
        .i_clock        ( sys_clock                     ),
        .i_reset        ( sys_reset                     ),
        .i_next         ( uart_tx_ready_ch1_h           ),
        .i_data         ( conversor_ch1[ 13 : 8 ]       ),
        .i_gate         ( i_gate                        ),
        .i_sample       ( sample                        ),
        .i_adc_init     ( adc1410_init_done             ),
        .i_cmd_decim    ( cmd_decim                     ),
        .i_cmd_param    ( cmd_param                     ),
        .o_data         ( sampler_ch1_h                 ),
        .o_valid        ( sampler_valid_ch1_h           ),
        .o_idle         ( sampler_idle_ch1_h            )
    );
   
    /* ########################################################### */
    /* TX UARTS ################################################## */
    
    localparam UART_DATA_SIZE    = 8;
    localparam UART_PRESCALE     = 16'b0000000101000101; /* 38400 */
    // localparam UART_TX_PRESCALE     = 16'b0000001010001011; /* 19200 */
    // localparam UART_TX_PRESCALE     = 16'b0000010100010110; /* 9600 */
    // localparam UART_TX_PRESCALE     = 16'b0000101000101100; /* 4800 */
    
    wire    uart_tx_ready_ch1_l;
    wire    uart_tx_ready_ch1_h;
    wire    uart_tx_busy_ch1_l;
    wire    uart_tx_busy_ch1_h;
    
    uart_tx #
    (
        .DATA_WIDTH         ( UART_DATA_SIZE        )
    )
    u_uart_tx_ch1_l
    (
        .clk                ( sys_clock             ),
        .rst                ( sys_reset             ),   
        .s_axis_tdata       ( sampler_ch1_l         ),
        .s_axis_tvalid      ( sampler_valid_ch1_l   ),
        .s_axis_tready      ( uart_tx_ready_ch1_l   ),
        .txd                ( o_tx_ch1_l            ),
        .busy               ( uart_tx_busy_ch1_l    ),
        .prescale           ( UART_PRESCALE         )
    );
    
    uart_tx #
    (
        .DATA_WIDTH         ( UART_DATA_SIZE        )
    )
    u_uart_tx_ch1_h
    (
        .clk                ( sys_clock             ),
        .rst                ( sys_reset             ),   
        .s_axis_tdata       ( sampler_ch1_h         ),
        .s_axis_tvalid      ( sampler_valid_ch1_h   ),
        .s_axis_tready      ( uart_tx_ready_ch1_h   ),
        .txd                ( o_tx_ch1_h            ),
        .busy               ( uart_tx_busy_ch1_h    ),
        .prescale           ( UART_PRESCALE         )
    );
    
    /* ########################################################### */
    /* COMMAND UNIT ############################################## */
    
    wire                                cmd_reset;
    wire                                cmd_sample;
    wire                                cmd_decim;
    wire    [ UART_DATA_SIZE - 1 : 0 ]  cmd_param;
    wire                                cmd_valid;
    
    command_unit #
    (
        .DATA_SIZE          ( UART_DATA_SIZE        )
    )
    u_command_unit
    (
        .i_clock            ( sys_clock             ),
        .i_reset            ( sys_reset             ),
        .i_rx               ( i_rx                  ),
        .i_ready            ( sampler_idle_ch1_h    ),
        .o_sample           ( cmd_sample            ),
        .o_reset            ( cmd_reset             ),
        .o_decim            ( cmd_decim             ),
        .o_param            ( cmd_param             ),
        .o_valid            ( cmd_valid             )
    );
        
    /* ########################################################### */
    /* PMOD UNIT ################################################# */
    
    pmod_unit
    u_pmod_unit
    (
        .i_clock            ( sys_clock             ),
        .i_reset            ( sys_reset             ),
        .i_init_done        ( adc1410_init_done     ),
        .i_idle             ( sampler_idle_ch1_l    ),
        .i_cmd_valid        ( cmd_valid             ),
        .o_led_r            ( o_led0_r              ),
        .o_led_g            ( o_led0_g              ),
        .o_led_b            ( o_led0_b              ),
        .o_buzzer           ( o_buzzer              )
    );
        
endmodule

`default_nettype wire
