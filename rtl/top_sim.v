`timescale 1ns / 1ps
`default_nettype none

module top_sim
(
    input  wire i_clock,
    
    input  wire i_reset,
    
    input  wire i_adc_init_done,
        
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
    
    input  wire i_gate
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
    
    localparam  IAGC_STATUS_SIZE    =   4;
    
    wire    [ IAGC_STATUS_SIZE - 1 : 0 ]    iagc_status;
    
    iagc_fsm #
    (
        .STATUS_SIZE            ( IAGC_STATUS_SIZE  )
    )
    u_iagc_fsm
    (
        .i_clock                ( sys_clock         ),
        .i_reset                ( sys_reset         ),
        .i_adc1410_init_done    ( i_adc_init_done   ),
        .i_sample               ( i_sample          ),
        .i_cmd_valid            ( uart_rx_valid     ),
        .i_cmd_reset            ( cmd_reset         ),
        .i_cmd_sample           ( cmd_sample        ),
        .i_cmd_dump_mem         ( cmd_dump_mem      ),
        .i_sample_end           ( sampler_end       ),
        .i_dump_end             ( dump_unit_end     ),
        .o_status               ( iagc_status       )
    );
    
    /* ########################################################### */
    /* RAMP ###################################################### */
    
    localparam DATA_SIZE = 16;
    
    reg [ DATA_SIZE - 1 : 0 ]   ramp;
    
    always@( posedge sys_clock ) begin
        ramp <=  ~i_gate ? { DATA_SIZE { 1'b0 } } : ramp + 1'b1;
    end
    
    /* ########################################################### */
    /* SAMPLERS ################################################## */
    
    localparam SAMPLER_DATA_SIZE    = 16;
    localparam ADDR_SIZE            = 12;
    localparam MEMORY_SIZE          = 8;

    
    wire    [ SAMPLER_DATA_SIZE - 1 : 0 ]   sampler_sample;
    wire                                    sampler_end;
    wire    [ ADDR_SIZE         - 1 : 0 ]   sampler_addr;
        
    sampler #
    (
        .DATA_SIZE         ( SAMPLER_DATA_SIZE  ),
        .ADDR_SIZE         ( ADDR_SIZE          ),
        .MEMORY_SIZE       ( MEMORY_SIZE        ),
        .IAGC_STATUS_SIZE  ( IAGC_STATUS_SIZE   )
    )
    u_sampler_ch1
    (
        .i_clock            ( sys_clock         ),
        .i_iagc_status      ( iagc_status       ),
        .i_data             ( ramp              ),
        .i_gate             ( i_gate            ),
        .o_data             ( sampler_sample    ),
        .o_addr             ( sampler_addr      ),
        .o_end              ( sampler_end       )
    );
   
    /* ########################################################### */
    /* RAM ####################################################### */
    
    wire    [ SAMPLER_DATA_SIZE - 1 : 0 ]   mem_data;
    
    memory #
    (
        .DATA_SIZE         ( SAMPLER_DATA_SIZE  ),
        .ADDR_SIZE         ( ADDR_SIZE          ),
        .MEMORY_SIZE       ( MEMORY_SIZE        ),
        .IAGC_STATUS_SIZE  ( IAGC_STATUS_SIZE   )
    )
    u_memory
    (
        .i_clock            ( sys_clock         ),
        .i_iagc_status      ( iagc_status       ),
        .i_waddr            ( sampler_addr      ),
        .i_raddr            ( dump_unit_addr    ),
        .i_data             ( sampler_sample    ),
        .o_data             ( mem_data          )    
    );
    
    /* ########################################################### */
    /* DUMP UNIT ################################################# */
    
    wire                            tx_ready;
    wire                            dump_unit_valid;
    wire    [ ADDR_SIZE - 1 : 0 ]   dump_unit_addr;
    wire                            dump_unit_end;
    
    assign tx_ready = uart_tx_ready_ch1_l && uart_tx_ready_ch1_h;
    
    dump_unit #
    (
        .ADDR_SIZE          ( ADDR_SIZE         ),
        .MEMORY_SIZE        ( MEMORY_SIZE       ),
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE  )
    )
    u_dump_unit
    (
        .i_clock            ( sys_clock         ),
        .i_ready            ( tx_ready          ),
        .i_iagc_status      ( iagc_status       ),
        .o_addr             ( dump_unit_addr    ),
        .o_valid            ( dump_unit_valid   ),
        .o_end              ( dump_unit_end     )
    );
    
    /* ########################################################### */
    /* UARTS ##################################################### */
    
    localparam UART_DATA_SIZE    = 8;
    
    wire                                uart_tx_ready;
    wire                                uart_tx_ready_ch1_l;
    wire                                uart_tx_ready_ch1_h;
    wire    [ UART_DATA_SIZE - 1 : 0 ]  uart_rx_data;
    wire                                uart_rx_valid;
    
    localparam UART_CLK_FREQ    = 100000000;
    localparam UART_BAUDRATE    = 38400;
    
    assign  uart_tx_ready = uart_tx_ready_ch1_l && uart_tx_ready_ch1_h;
    
    uart_tx #
    (
        .CLK_FREQUENCY  ( UART_CLK_FREQ             ),
        .UART_FREQUENCY ( UART_BAUDRATE             )
    )
    u_uart_tx_ch1_l
    (
        .user_clk       ( sys_clock                 ),
        .rst_n          ( ~sys_reset                ),
        .start_tx       ( dump_unit_valid           ),
        .data           ( mem_data[ 7 : 0 ]         ),
        .tx_bit         ( o_tx_ch1_l                ),
        .ready          ( uart_tx_ready_ch1_l       ),
        .chipscope_clk  (                           )
    );
    
    uart_tx #
    (
        .CLK_FREQUENCY  ( UART_CLK_FREQ             ),
        .UART_FREQUENCY ( UART_BAUDRATE             )
    )
    u_uart_tx_ch1_h
    (
        .user_clk       ( sys_clock                 ),
        .rst_n          ( ~sys_reset                ),
        .start_tx       ( dump_unit_valid           ),
        .data           ( mem_data[ 13 : 8 ]        ),
        .tx_bit         ( o_tx_ch1_h                ),
        .ready          ( uart_tx_ready_ch1_h       ),
        .chipscope_clk  (                           )
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
    
    wire                                cmd_reset;
    wire                                cmd_sample;
    wire                                cmd_set_decim;
    wire                                cmd_clean_mem;                                                    
    wire                                cmd_dump_mem;
    wire    [ UART_DATA_SIZE - 1 : 0 ]  cmd_param;
    
    command_unit #
    (
        .IAGC_STATUS_SIZE   ( IAGC_STATUS_SIZE      ),
        .DATA_SIZE          ( UART_DATA_SIZE        )
    )
    u_command_unit
    (
        .i_clock            ( sys_clock             ),
        .i_iagc_status      ( iagc_status           ),
        .i_rx_data          ( uart_rx_data          ),
        .o_cmd_reset        ( cmd_reset             ),
        .o_cmd_sample       ( cmd_sample            ),
        .o_cmd_set_decim    ( cmd_set_decim         ),
        .o_cmd_clean_mem    ( cmd_clean_mem         ),
        .o_cmd_dump_mem     ( cmd_dump_mem          ),
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
