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
    
    input  wire [13:0] i_adc_data,
    inout  wire io_adc_sdio,
    input  wire i_adc_dco_clock_p,
    output wire o_adc_dco_clock_n,
    output wire o_adc_sclk,
    output wire o_adc_clock_in_n,
    output wire o_adc_clock_in_p,
    output wire o_adc_ch1_coupling_h,
    output wire o_adc_ch1_coupling_l,
    output wire o_adc_ch2_coupling_h,
    output wire o_adc_ch2_coupling_l,
    output wire o_adc_ch2_gain_h,
    output wire o_adc_ch2_gain_l,
    output wire o_adc_ch1_gain_l,
    output wire o_adc_ch1_gain_h,
    output wire o_adc_relay_com_l,
    output wire o_adc_relay_com_h,
    output wire o_adc_cs,
    output wire o_adc_sync,
    
    inout  wire io_dac_sdio,
    output wire o_dac_cs,
    output wire o_dac_sclk,
    output wire o_dac_reset,
    output wire o_dac_clkio_p,
    output wire o_dac_clkio_n,
    output wire o_dac_clkin_p,
    output wire o_dac_clkin_n,
    output wire [13:0] o_dac_data,
    output wire o_dac_set_fs_ch1,
    output wire o_dac_set_fs_ch2,
    output wire o_dac_enable
);

    /* ########################################################### */
    /* PARAMETERS & WIRES ######################################## */
    
    localparam IAGC_STATUS_SIZE     = 4;
    localparam ADDR_SIZE            = 13;
    localparam CMD_PARAM_SIZE       = 4;
    localparam DECIMATOR_SIZE       = 4;
    localparam DEF_MEMORY_SIZE      = 1024;
    localparam DEF_DECIMATOR        = 4;
    localparam ZMOD_DATA_SIZE       = 14;
    localparam SAMPLER_DATA_SIZE    = 16;
    localparam UART_DATA_SIZE       = 8;
    localparam UART_CLK_FREQ        = 100000000;
    localparam UART_BAUDRATE        = 921600;
    localparam DEF_PHASE_COUNT      = 256;
    localparam PHASE_COUNT_SIZE     = 16;
    localparam DEF_AMPLITUDE_COUNT  = 256;
    localparam AMPLITUDE_COUNT_SIZE = 16;
    localparam REMAINDER_SIZE       = 8;
    localparam AMPLITUDE_DATA_SIZE  = 14;
    localparam QUOTIENT_SIZE        = 8;
    localparam FRACTIONAL_SIZE      = 8;
    localparam DUMP_UNIT_ENABLED    = 1;
    localparam FILTER_ENABLED       = 0;
    
    wire                                    sys_clock;
    wire                                    sys_reset;
    wire                                    adc_clock;
    wire                                    dac_in_clock;
    wire                                    dac_clock;
    
    wire [ IAGC_STATUS_SIZE     - 1 : 0 ]   iagc_status;
    wire [ ADDR_SIZE            - 1 : 0 ]   iagc_memory_size;
    wire [ DECIMATOR_SIZE       - 1 : 0 ]   iagc_decimator;
    wire [ PHASE_COUNT_SIZE     - 1 : 0 ]   iagc_phase_count;
    wire [ AMPLITUDE_COUNT_SIZE - 1 : 0 ]   iagc_amplitude_count;
    
    wire                                    decimator_sample;
    
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   adc1410_ch1;
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   adc1410_ch2;
    wire                                    adc1410_init_done;
    
    wire                                    dac1411_init_done;
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   dac1411_ch1_in;
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   dac1411_ch2_in;
    
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   adc_sampler_ref_in;
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   adc_sampler_err_in;
    
    wire [ SAMPLER_DATA_SIZE    - 1 : 0 ]   sampled_ref;
    wire [ SAMPLER_DATA_SIZE    - 1 : 0 ]   sampled_err;
    wire                                    sampler_end;
    wire [ ADDR_SIZE            - 1 : 0 ]   sampler_addr;
    
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   phase_ref_in;
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   phase_err_in;
    wire                                    phase_in_phase;
    
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   amplitude_ref_in;
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   amplitude_err_in;
    wire [ AMPLITUDE_DATA_SIZE  - 1 : 0 ]   amplitude_ref_out;
    wire [ AMPLITUDE_DATA_SIZE  - 1 : 0 ]   amplitude_err_out;
    wire                                    amplitude_valid;
    
    wire [ QUOTIENT_SIZE        - 1 : 0 ]   processor_quotient;
    wire [ FRACTIONAL_SIZE      - 1 : 0 ]   processor_fractional;
    
    wire [ SAMPLER_DATA_SIZE    - 1 : 0 ]   memory_data;
    wire                                    memory_clean_end;
    
    wire                                    dump_unit_valid;
    wire [ ADDR_SIZE            - 1 : 0 ]   dump_unit_addr;
    wire                                    dump_unit_end;
    wire [ UART_DATA_SIZE       - 1 : 0 ]   dump_unit_data;
    
    wire [ UART_DATA_SIZE       - 1 : 0 ]   logger_data;
    wire                                    logger_valid;
    
    wire                                    uart_tx_ready;
    wire                                    uart_tx_valid;
    wire [ UART_DATA_SIZE       - 1 : 0 ]   uart_tx_data;
    wire [ UART_DATA_SIZE       - 1 : 0 ]   uart_rx_data;
    wire                                    uart_rx_valid;
    
    wire [ CMD_PARAM_SIZE       - 1 : 0 ]   cmd_param;
    wire [ CMD_PARAM_SIZE       - 1 : 0 ]   cmd_op;
    
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   filtered_ref;
    wire [ ZMOD_DATA_SIZE       - 1 : 0 ]   filtered_err;
    
    /* ########################################################### */
    /* CLOCK UNIT ################################################ */
    
    clock_unit #
    (
    )
    u_clock_unit
    (
        .i_clock        ( i_clock       ),
        .i_reset        ( i_reset       ),
        .o_sys_clock    ( sys_clock     ),
        .o_adc_clock    ( adc_clock     ),
        .o_dac_in_clock ( dac_in_clock  ),
        .o_dac_clock    ( dac_clock     ),
        .o_valid        ( sys_reset     )
    );
    
    /* ########################################################### */
    /* GLOBAL FSM ################################################ */
    
    iagc_fsm #
    (
        .STATUS_SIZE            ( IAGC_STATUS_SIZE      ),
        .CMD_PARAM_SIZE         ( CMD_PARAM_SIZE        ),
        .ADDR_SIZE              ( ADDR_SIZE             ),
        .DECIMATOR_SIZE         ( DECIMATOR_SIZE        ),
        .DEF_MEMORY_SIZE        ( DEF_MEMORY_SIZE       ),
        .DEF_DECIMATOR          ( DEF_DECIMATOR         ),
        .DEF_PHASE_COUNT        ( DEF_PHASE_COUNT       ),
        .PHASE_COUNT_SIZE       ( PHASE_COUNT_SIZE      ),
        .DEF_AMPLITUDE_COUNT    ( DEF_AMPLITUDE_COUNT   ),
        .AMPLITUDE_COUNT_SIZE   ( AMPLITUDE_COUNT_SIZE  )
    )
    u_iagc_fsm
    (
        .i_clock                ( sys_clock             ),
        .i_reset                ( sys_reset             ),
        .i_adc1410_init_done    ( adc1410_init_done     ),
        .i_dac1411_init_done    ( dac1411_init_done     ),
        .i_sample               ( i_sample              ),
        .i_cmd_valid            ( uart_rx_valid         ),
        .i_sample_end           ( sampler_end           ),
        .i_dump_end             ( dump_unit_end         ),
        .i_clean_end            ( memory_clean_end      ),
        .i_cmd_operation        ( cmd_op                ),
        .i_cmd_parameter        ( cmd_param             ),
        .o_memory_size          ( iagc_memory_size      ),
        .o_decimator            ( iagc_decimator        ),
        .o_phase_count          ( iagc_phase_count      ),
        .o_amplitude_count      ( iagc_amplitude_count  ),
        .o_status               ( iagc_status           )
    );
    
    /* ########################################################### */
    /* DECIMATOR ################################################# */
    
    decimator # 
    (
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE  ),
        .DECIMATOR_SIZE     ( DECIMATOR_SIZE    )
    )
    u_decimator
    (
        .i_clock            ( sys_clock         ),
        .i_gate             ( i_gate            ),
        .i_iagc_status      ( iagc_status       ),
        .i_decimator        ( iagc_decimator    ),
        .o_sample           ( decimator_sample  )
    );
    
    /* ########################################################### */
    /* ADC1410 ################################################### */
        
    adc1410 #
    (
        .ZMOD_DATA_SIZE         ( ZMOD_DATA_SIZE        ),
        .IAGC_STATUS_SIZE       ( IAGC_STATUS_SIZE      )
    )
    u_adc1410
    (
        .i_sys_clock            ( sys_clock             ),
        .i_adc_clock            ( adc_clock             ),
        .i_iagc_status          ( iagc_status           ),
        .i_adc_data             ( i_adc_data            ),
        .io_adc_sdio            ( io_adc_sdio           ),
        .i_adc_dco_clock_p      ( i_adc_dco_clock_p     ),
        .o_adc_dco_clock_n      ( o_adc_dco_clock_n     ),
        .o_adc_sclk             ( o_adc_sclk            ),
        .o_adc_clock_in_n       ( o_adc_clock_in_n      ),
        .o_adc_clock_in_p       ( o_adc_clock_in_p      ),
        .o_adc_ch1_coupling_h   ( o_adc_ch1_coupling_h  ),
        .o_adc_ch1_coupling_l   ( o_adc_ch1_coupling_l  ),
        .o_adc_ch2_coupling_h   ( o_adc_ch2_coupling_h  ),
        .o_adc_ch2_coupling_l   ( o_adc_ch2_coupling_l  ),
        .o_adc_ch2_gain_h       ( o_adc_ch2_gain_h      ),
        .o_adc_ch2_gain_l       ( o_adc_ch2_gain_l      ),
        .o_adc_ch1_gain_l       ( o_adc_ch1_gain_l      ),
        .o_adc_ch1_gain_h       ( o_adc_ch1_gain_h      ),
        .o_adc_relay_com_l      ( o_adc_relay_com_l     ),
        .o_adc_relay_com_h      ( o_adc_relay_com_h     ),
        .o_adc_cs               ( o_adc_cs              ),
        .o_adc_sync             ( o_adc_sync            ),
        .o_adc_data_out_ch1     ( adc1410_ch1           ),
        .o_adc_data_out_ch2     ( adc1410_ch2           ),
        .o_adc_init_done        ( adc1410_init_done     ) 
    );
    
    /* ########################################################### */
    /* DAC1411 ################################################### */
    
    assign dac1411_ch1_in = FILTER_ENABLED ? filtered_ref : adc1410_ch1;
    assign dac1411_ch2_in = FILTER_ENABLED ? filtered_err : adc1410_ch2;
    
    dac1411 #
    (
        .ZMOD_DATA_SIZE     ( ZMOD_DATA_SIZE    ),
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE  )
    )
    u_dac1411
    (
        .i_sys_clock        ( sys_clock         ),
        .i_dac_in_clock     ( dac_in_clock      ),
        .i_dac_clock        ( dac_clock         ),
        .i_sample           ( decimator_sample  ),
        .i_iagc_status      ( iagc_status       ),
        .i_data_ch1         ( dac1411_ch1_in    ),
        .i_data_ch2         ( dac1411_ch2_in    ),
        .io_dac_sdio        ( io_dac_sdio       ),
        .o_dac_init_done    ( dac1411_init_done ),
        .o_dac_cs           ( o_dac_cs          ),
        .o_dac_sclk         ( o_dac_sclk        ),
        .o_dac_reset        ( o_dac_reset       ),
        .o_dac_clkio_p      ( o_dac_clkio_p     ),
        .o_dac_clkio_n      ( o_dac_clkio_n     ),
        .o_dac_clkin_p      ( o_dac_clkin_p     ),
        .o_dac_clkin_n      ( o_dac_clkin_n     ),
        .o_dac_data         ( o_dac_data        ),
        .o_dac_set_fs_ch1   ( o_dac_set_fs_ch1  ),
        .o_dac_set_fs_ch2   ( o_dac_set_fs_ch2  ),
        .o_dac_enable       ( o_dac_enable      )
    );
    
    /* ########################################################### */
    /* SAMPLER ################################################### */
        
    assign adc_sampler_ref_in = FILTER_ENABLED ? filtered_ref : adc1410_ch1;
    assign adc_sampler_err_in = FILTER_ENABLED ? filtered_err : adc1410_ch2;
    
    adc_sampler #
    (
        .ZMOD_DATA_SIZE     ( ZMOD_DATA_SIZE        ),
        .SAMPLER_DATA_SIZE  ( SAMPLER_DATA_SIZE     ),
        .ADDR_SIZE          ( ADDR_SIZE             ),
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE      )
    )
    u_adc_sampler
    (
        .i_clock            ( sys_clock             ),
        .i_iagc_status      ( iagc_status           ),
        .i_reference        ( adc_sampler_ref_in    ),
        .i_error            ( adc_sampler_err_in    ),
        .i_memory_size      ( iagc_memory_size      ),
        .i_sample           ( decimator_sample      ),
        .o_reference_sample ( sampled_ref           ),
        .o_error_sample     ( sampled_err           ),
        .o_addr             ( sampler_addr          ),
        .o_end              ( sampler_end           )
    );
    
    /* ########################################################### */
    /* PHASE DETECTOR ############################################ */
    
    assign phase_ref_in = FILTER_ENABLED ? filtered_ref : adc1410_ch1;
    assign phase_err_in = FILTER_ENABLED ? filtered_err : adc1410_ch2;
    
    phase_detector #
    (
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE  ),
        .ZMOD_DATA_SIZE     ( ZMOD_DATA_SIZE    ),
        .PHASE_COUNT_SIZE   ( PHASE_COUNT_SIZE  )
    )
    u_phase_detector
    (
        .i_clock            ( sys_clock         ),
        .i_iagc_status      ( iagc_status       ),
        .i_sample           ( decimator_sample  ),
        .i_reference        ( phase_ref_in      ),
        .i_error            ( phase_err_in      ),
        .i_phase_count      ( iagc_phase_count  ),
        .o_in_phase         ( phase_in_phase    )
    );
    
    /* ########################################################### */
    /* AMPLITUDE DETECTOR ######################################## */
    
    assign amplitude_ref_in = FILTER_ENABLED ? filtered_ref : adc1410_ch1;
    assign amplitude_err_in = FILTER_ENABLED ? filtered_err : adc1410_ch2;
    
    amplitude_detector #
    (
        .IAGC_STATUS_SIZE       ( IAGC_STATUS_SIZE      ),
        .ZMOD_DATA_SIZE         ( ZMOD_DATA_SIZE        ),
        .AMPLITUDE_COUNT_SIZE   ( AMPLITUDE_COUNT_SIZE  ),
        .AMPLITUDE_DATA_SIZE    ( AMPLITUDE_DATA_SIZE   )
    )
    u_amplitude_detector
    (
        .i_clock                ( sys_clock             ),
        .i_sample               ( decimator_sample      ),
        .i_iagc_status          ( iagc_status           ),
        .i_reference            ( amplitude_ref_in      ),
        .i_error                ( amplitude_err_in      ),
        .i_amplitude_count      ( iagc_amplitude_count  ),
        .o_reference_amplitude  ( amplitude_ref_out     ),
        .o_error_amplitude      ( amplitude_err_out     ),
        .o_valid                ( amplitude_valid       )
    );
    
    /* ########################################################### */
    /* PROCESSOR ################################################# */
    
    processor #
    (
        .AMPLITUDE_DATA_SIZE    ( AMPLITUDE_DATA_SIZE   ),
        .QUOTIENT_SIZE          ( QUOTIENT_SIZE         ),
        .FRACTIONAL_SIZE        ( FRACTIONAL_SIZE       )       
    )
    u_processor
    (
        .i_clock                ( sys_clock             ),
        .i_reference            ( amplitude_ref_out     ),
        .i_error                ( amplitude_err_out     ),
        .i_valid                ( amplitude_valid       ),
        .o_quotient             ( processor_quotient    ),
        .o_fractional           ( processor_fractional  )
    ); 
    
    /* ########################################################### */
    /* RAM ####################################################### */
    
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
        .i_reference_sample ( sampled_ref       ),
        .i_error_sample     ( sampled_err       ),
        .i_memory_size      ( iagc_memory_size  ),
        .o_clean_end        ( memory_clean_end  ),
        .o_data             ( memory_data       )    
    );
    
    /* ########################################################### */
    /* DUMP UNIT ################################################# */
        
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
    /* LOGGER #################################################### */
    
    logger #
    (
        .IAGC_STATUS_SIZE       ( IAGC_STATUS_SIZE      ),
        .AMPLITUDE_DATA_SIZE    ( AMPLITUDE_DATA_SIZE   ),
        .UART_DATA_SIZE         ( UART_DATA_SIZE        )
    )
    u_logger
    (
        .i_clock                ( sys_clock             ),
        .i_iagc_status          ( iagc_status           ),
        .i_reference_amplitude  ( amplitude_ref_out     ),
        .i_error_amplitude      ( amplitude_err_out     ),
        .i_quotient             ( processor_quotient    ),
        .i_fractional           ( processor_fractional  ),
        .i_on_phase             ( phase_in_phase        ),
        .i_tx_ready             ( uart_tx_ready         ),
        .o_tx_data              ( logger_data           ),
        .o_tx_valid             ( logger_valid          )
    );
    
    /* ########################################################### */
    /* UARTS ##################################################### */
        
    assign uart_tx_valid = DUMP_UNIT_ENABLED ? dump_unit_valid : logger_valid;
    assign uart_tx_data  = DUMP_UNIT_ENABLED ? dump_unit_data  : logger_data;
    
    uart_tx #
    (
        .CLK_FREQUENCY  ( UART_CLK_FREQ         ),
        .UART_FREQUENCY ( UART_BAUDRATE         )
    )
    u_uart_tx
    (
        .user_clk       ( sys_clock             ),
        .rst_n          ( ~sys_reset            ),
        .start_tx       ( uart_tx_valid         ),
        .data           ( uart_tx_data          ),
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
        .i_in_phase         ( phase_in_phase        ),
        .o_led0_r           ( o_led0_r              ),
        .o_led0_g           ( o_led0_g              ),
        .o_led0_b           ( o_led0_b              ),
        .o_led1_r           ( o_led1_r              ),
        .o_led1_g           ( o_led1_g              ),
        .o_led1_b           ( o_led1_b              )
    );
    
    /* ########################################################### */
    /* FILTERS ################################################### */
    
    lowpass_filter #
    (
        .NB_INPUT           ( ZMOD_DATA_SIZE    ),
        .NB_OUTPUT          ( ZMOD_DATA_SIZE    ),
        .NB_COEFF           ( ZMOD_DATA_SIZE    )
    )
    u_lowpass_filter_ref 
    (
        .o_os_data          ( filtered_ref      ),
        .i_is_data          ( adc1410_ch1       ),
        .i_en               ( decimator_sample  ),
        .i_srst             ( sys_reset         ), 
        .clk                ( sys_clock         )
    );
    
    lowpass_filter #
    (
        .NB_INPUT           ( ZMOD_DATA_SIZE    ),
        .NB_OUTPUT          ( ZMOD_DATA_SIZE    ),
        .NB_COEFF           ( ZMOD_DATA_SIZE    )
    )
    u_lowpass_filter_err 
    (
        .o_os_data          ( filtered_err      ),
        .i_is_data          ( adc1410_ch2       ),
        .i_en               ( decimator_sample  ),
        .i_srst             ( sys_reset         ), 
        .clk                ( sys_clock         )
    );
        
endmodule

`default_nettype wire
