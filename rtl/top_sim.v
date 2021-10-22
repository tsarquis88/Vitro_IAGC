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
    
    output wire o_tx,
    
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
    
    localparam IAGC_STATUS_SIZE = 4;
    localparam ADDR_SIZE        = 13;
    localparam CMD_PARAM_SIZE   = 4;
    localparam DECIMATOR_SIZE   = 4;
    localparam DEF_MEMORY_SIZE  = 8;
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
        .i_adc1410_init_done    ( i_adc_init_done   ),
        .i_sample               ( i_sample          ),
        .i_cmd_valid            ( uart_rx_valid     ),
        .i_cmd_reset            ( cmd_reset         ),
        .i_cmd_sample           ( cmd_sample        ),
        .i_cmd_dump_mem         ( cmd_dump_mem      ),
        .i_cmd_clean_mem        ( cmd_clean_mem     ),
        .i_cmd_set_mem          ( cmd_set_mem       ),
        .i_cmd_set_decim        ( cmd_set_decim     ),
        .i_sample_end           ( sampler_end       ),
        .i_dump_end             ( dump_unit_end     ),
        .i_clean_end            ( mem_clean_end     ),
        .i_cmd_parameter        ( cmd_param         ),
        .o_memory_size          ( iagc_memory_size  ),
        .o_decimator            ( iagc_decimator    ),
        .o_status               ( iagc_status       )
    );
    
    /* ########################################################### */
    /* RAMP ###################################################### */
    
    localparam SAMPLER_DATA_SIZE    = 16;

    reg [ SAMPLER_DATA_SIZE - 1 : 0 ] ramp;
    
    always@( posedge sys_clock ) begin
        ramp <=  ~i_gate ? { SAMPLER_DATA_SIZE { 1'b0 } } : ramp + 1'b1;
    end
    
    /* ########################################################### */
    /* SAMPLERS ################################################## */

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
        .i_data             ( ramp              ),
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
    wire                                    mem_clean_end;
    
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
        .o_clean_end        ( mem_clean_end     ),
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
    localparam UART_BAUDRATE    = 9600;
    
    
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
        
    wire                                cmd_reset;
    wire                                cmd_sample;
    wire                                cmd_set_decim;
    wire                                cmd_clean_mem;                                                    
    wire                                cmd_dump_mem;
    wire                                cmd_set_mem;
    wire    [ CMD_PARAM_SIZE - 1 : 0 ]  cmd_param;
    
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
        .o_cmd_reset        ( cmd_reset             ),
        .o_cmd_sample       ( cmd_sample            ),
        .o_cmd_set_decim    ( cmd_set_decim         ),
        .o_cmd_clean_mem    ( cmd_clean_mem         ),
        .o_cmd_dump_mem     ( cmd_dump_mem          ),
        .o_cmd_set_mem      ( cmd_set_mem           ),
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
