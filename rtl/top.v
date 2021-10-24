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
    
    output wire o_tx,
    
    input  wire i_rx,
    
    input  wire i_sample,
    
    input  wire i_gate,   
    
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
    /* GLOBAL FSM ################################################ */
    
    localparam IAGC_STATUS_SIZE = 4;
    localparam ADDR_SIZE        = 13;
    localparam CMD_PARAM_SIZE   = 4;
    localparam DECIMATOR_SIZE   = 4;
    localparam DEF_MEMORY_SIZE  = 4096;
    localparam DEF_DECIMATOR    = 4;
    
    wire    [ IAGC_STATUS_SIZE - 1 : 0 ]    iagc_status;
    wire    [ ADDR_SIZE        - 1 : 0 ]    iagc_memory_size;
    wire    [ DECIMATOR_SIZE   - 1 : 0 ]    iagc_decimator;
    
    iagc_fsm #
    (
        .STATUS_SIZE            ( IAGC_STATUS_SIZE  ),
        .CMD_PARAM_SIZE         ( CMD_PARAM_SIZE    ),
        .ADDR_SIZE              ( ADDR_SIZE         ),
        .DECIMATOR_SIZE         ( DECIMATOR_SIZE    ),
        .DEF_MEMORY_SIZE        ( DEF_MEMORY_SIZE   ),
        .DEF_DECIMATOR          ( DEF_DECIMATOR     )
    )
    u_iagc_fsm
    (
        .i_clock                ( sys_clock         ),
        .i_reset                ( sys_reset         ),
        .i_adc1410_init_done    ( adc1410_init_done ),
        .i_sample               ( i_sample          ),
        .i_cmd_valid            ( uart_rx_valid     ),
        .i_sample_end           ( sampler_end       ),
        .i_dump_end             ( dump_unit_end     ),
        .i_clean_end            ( memory_clean_end  ),
        .i_cmd_operation        ( cmd_op            ),
        .i_cmd_parameter        ( cmd_param         ),
        .o_memory_size          ( iagc_memory_size  ),
        .o_decimator            ( iagc_decimator    ),
        .o_status               ( iagc_status       )
    );
    
    /* ########################################################### */
    /* ADC1410 ################################################### */
    
    localparam  ADC1410_DATA_SIZE   =   14;
    
    wire    [ ADC1410_DATA_SIZE - 1 : 0 ]   adc1410_ch1;
    wire    [ ADC1410_DATA_SIZE - 1 : 0 ]   adc1410_ch2;
    wire                                    adc1410_init_done;
        
    adc1410 #
    (
        .DATA_SIZE          ( ADC1410_DATA_SIZE ),
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE  )
    )
    u_adc1410
    (
        .i_sys_clock        ( sys_clock         ),
        .i_adc_clock        ( adc_clock         ),
        .i_iagc_status      ( iagc_status       ),
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
        
    wire    [ ADC1410_DATA_SIZE - 1 : 0 ] conversor_ch1;
    wire    [ ADC1410_DATA_SIZE - 1 : 0 ] conversor_ch2;
    
    data_conversor #
    (
        .CONVERSOR_DATA_SIZE    ( ADC1410_DATA_SIZE     )
    )
    u_data_conversor_ch1
    (
        .i_data                 ( adc1410_ch1           ),
        .o_data                 ( conversor_ch1         )
    );
    
    data_conversor #
    (
        .CONVERSOR_DATA_SIZE    ( ADC1410_DATA_SIZE     )
    )
    u_data_conversor_ch2
    (
        .i_data                 ( adc1410_ch2           ),
        .o_data                 ( conversor_ch2         )
    );
    
    /* ########################################################### */
    /* RAMP ###################################################### */
    
    reg [ ADC1410_DATA_SIZE - 1 : 0 ] ramp;
    
    always@( posedge sys_clock ) begin
        ramp <=  ~i_gate ? { ADC1410_DATA_SIZE { 1'b0 } } : ramp + 1'b1;
    end
    
    /* ########################################################### */
    /* SAMPLERS ################################################## */
    
    localparam SAMPLER_DATA_SIZE    = 16;

    
    wire    [ SAMPLER_DATA_SIZE - 1 : 0 ]   sampler_sample;
    wire                                    sampler_end;
    wire    [ ADDR_SIZE         - 1 : 0 ]   sampler_addr;
        
    sampler #
    (
        .DATA_SIZE          ( SAMPLER_DATA_SIZE ),
        .ADDR_SIZE          ( ADDR_SIZE         ),
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE  ),
        .DECIMATOR_SIZE     ( DECIMATOR_SIZE    )
    )
    u_sampler_ch1
    (
        .i_clock            ( sys_clock         ),
        .i_iagc_status      ( iagc_status       ),
        .i_data             ( conversor_ch1     ),
        .i_gate             ( i_gate            ),
        .i_memory_size      ( iagc_memory_size  ),
        .i_decimator        ( iagc_decimator    ),
        .o_data             ( sampler_sample    ),
        .o_addr             ( sampler_addr      ),
        .o_end              ( sampler_end       )
    );
   
    /* ########################################################### */
    /* RAM ####################################################### */
    
    wire    [ SAMPLER_DATA_SIZE - 1 : 0 ]   memory_data;
    wire                                    memory_clean_end;
    
    memory #
    (
        .DATA_SIZE         ( SAMPLER_DATA_SIZE  ),
        .ADDR_SIZE         ( ADDR_SIZE          ),
        .DEF_MEMORY_SIZE   ( DEF_MEMORY_SIZE    ),
        .IAGC_STATUS_SIZE  ( IAGC_STATUS_SIZE   )
    )
    u_memory
    (
        .i_clock            ( sys_clock         ),
        .i_iagc_status      ( iagc_status       ),
        .i_waddr            ( sampler_addr      ),
        .i_raddr            ( dump_unit_addr    ),
        .i_data             ( sampler_sample    ),
        .i_memory_size      ( iagc_memory_size  ),
        .o_clean_end        ( memory_clean_end  ),
        .o_data             ( memory_data       )    
    );
    
    /* ########################################################### */
    /* DUMP UNIT ################################################# */
    
    localparam UART_DATA_SIZE    = 8;

    wire                                dump_unit_valid;
    wire    [ ADDR_SIZE      - 1 : 0 ]  dump_unit_addr;
    wire                                dump_unit_end;
    wire    [ UART_DATA_SIZE - 1 : 0 ]  dump_unit_data;
        
    dump_unit #
    (
        .ADDR_SIZE          ( ADDR_SIZE         ),
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE  ),
        .SAMPLER_DATA_SIZE  ( SAMPLER_DATA_SIZE ),
        .UART_DATA_SIZE     ( UART_DATA_SIZE    )
    )
    u_dump_unit
    (
        .i_clock            ( sys_clock         ),
        .i_ready            ( uart_tx_ready     ),
        .i_iagc_status      ( iagc_status       ),
        .i_memory_size      ( iagc_memory_size  ),
        .i_memory_data      ( memory_data       ),
        .o_data             ( dump_unit_data    ),
        .o_addr             ( dump_unit_addr    ),
        .o_valid            ( dump_unit_valid   ),
        .o_end              ( dump_unit_end     )
    );
    
    /* ########################################################### */
    /* UARTS ##################################################### */
    
    wire                                uart_tx_ready;
    wire    [ UART_DATA_SIZE - 1 : 0 ]  uart_rx_data;
    wire                                uart_rx_valid;
    
    localparam UART_CLK_FREQ    = 100000000;
    localparam UART_BAUDRATE    = 38400;
        
    uart_tx #
    (
        .CLK_FREQUENCY  ( UART_CLK_FREQ         ),
        .UART_FREQUENCY ( UART_BAUDRATE         )
    )
    u_uart_tx_ch1_l
    (
        .user_clk       ( sys_clock             ),
        .rst_n          ( ~sys_reset            ),
        .start_tx       ( dump_unit_valid       ),
        .data           ( dump_unit_data        ),
        .tx_bit         ( o_tx                  ),
        .ready          ( uart_tx_ready         ),
        .chipscope_clk  (                       )
    );
    
    uart_rx #
    (
        .CLK_FREQUENCY  ( UART_CLK_FREQ         ),
        .UART_FREQUENCY ( UART_BAUDRATE         )
    )
    u_uart_rx
    (
        .clk            ( sys_clock             ),
        .rst_n          ( ~sys_reset            ),
        .data           ( uart_rx_data          ),
        .rx             ( i_rx                  ),
        .valid          ( uart_rx_valid         )
    );
    
    /* ########################################################### */
    /* COMMAND UNIT ############################################## */
        
    wire    [ CMD_PARAM_SIZE - 1 : 0 ]  cmd_param;
    wire    [ CMD_PARAM_SIZE - 1 : 0 ]  cmd_op;
    
    command_unit #
    (
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE      ),
        .DATA_SIZE          ( UART_DATA_SIZE        ),
        .CMD_PARAM_SIZE     ( CMD_PARAM_SIZE        )
    )
    u_command_unit
    (
        .i_clock            ( sys_clock             ),
        .i_iagc_status      ( iagc_status           ),
        .i_cmd              ( uart_rx_data          ),
        .o_cmd_op           ( cmd_op                ),
        .o_cmd_param        ( cmd_param             )
    );
        
    /* ########################################################### */
    /* PMOD UNIT ################################################# */
    
    pmod_unit #
    (
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE      )
    )
    u_pmod_unit
    (
        .i_clock            ( sys_clock             ),
        .i_reset            ( sys_reset             ),
        .i_iagc_status      ( iagc_status           ),
        .o_led0_r           ( o_led0_r              ),
        .o_led0_g           ( o_led0_g              ),
        .o_led0_b           ( o_led0_b              ),
        .o_led1_r           ( o_led1_r              ),
        .o_led1_g           ( o_led1_g              ),
        .o_led1_b           ( o_led1_b              )
    );
        
endmodule

`default_nettype wire
