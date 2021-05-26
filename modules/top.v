`timescale 1ns / 1ps

module top
(
    input   i_clock,
    
    input   i_reset,
    
    output  o_tx,
    
    output  o_led0_g,
    output  o_led0_r,
    
    output  o_syzygy_a_c2p_clk_n,
    output  o_syzygy_a_c2p_clk_p,
    output  o_syzygy_a_d_n_0,
    output  o_syzygy_a_d_p_0,
    output  o_syzygy_a_d_n_1,
    output  o_syzygy_a_d_p_1,
    output  o_syzygy_a_d_n_2,
    inout   io_syzygy_a_d_p_2,
    output  o_syzygy_a_d_n_3,
    output  o_syzygy_a_d_p_3,
    input   i_syzygy_a_d_n_4,
    input   i_syzygy_a_d_p_4,
    output  o_syzygy_a_d_n_5,
    output  o_syzygy_a_d_p_5,
    input   i_syzygy_a_d_n_6,
    input   i_syzygy_a_d_p_6,
    output  o_syzygy_a_d_n_7,
    output  o_syzygy_a_d_p_7,
    output  o_syzygy_a_p2c_clk_n,
    input   i_syzygy_a_p2c_clk_p,
    input   i_syzygy_a_s_16,
    input   i_syzygy_a_s_17,
    input   i_syzygy_a_s_18,
    input   i_syzygy_a_s_19,
    input   i_syzygy_a_s_20,
    input   i_syzygy_a_s_21,
    input   i_syzygy_a_s_22,
    input   i_syzygy_a_s_23,
    input   i_syzygy_a_s_24,
    input   i_syzygy_a_s_25,
    output  o_syzygy_a_s_26,
    output  o_syzygy_a_s_27
       
);
    
    /* ########################################################### */
    /* CLOCK WIZARD ############################################## */
    
    wire    sys_clock;
    wire    adc_clock;
    wire    locked;
    
    clk_wiz_0
    u_clk_wiz_0
    (
        .clk_out1           ( sys_clock ),
        .clk_out2           ( adc_clock ),
        .reset              ( i_reset   ),
        .locked             ( locked    ),
        .clk_in1            ( i_clock   )
    );
    
    /* ########################################################### */
    /* ADC1410 ################################################### */
    
    localparam  ADC_CHDATA_SIZE = 16;
    localparam  ADC_DATA_SIZE   = 14;
    
    wire    [ ADC_CHDATA_SIZE - 1 : 0 ] adc_data_ch1;
    wire    [ ADC_CHDATA_SIZE - 1 : 0 ] adc_data_ch2;
    reg     [ ADC_DATA_SIZE   - 1 : 0 ] adc_data;
    wire                                adc_init_done;
    wire                                adc_fifo_empty_cha;
    wire                                adc_fifo_empty_chb;
    reg                                 adc_test_mode;
    
    always@( * ) begin
        adc_data[ 0  ]          = i_syzygy_a_s_24;
        adc_data[ 1  ]          = i_syzygy_a_s_22;
        adc_data[ 2  ]          = i_syzygy_a_d_n_4;
        adc_data[ 3  ]          = i_syzygy_a_d_p_6;
        adc_data[ 4  ]          = i_syzygy_a_d_n_6;
        adc_data[ 5  ]          = i_syzygy_a_s_16;
        adc_data[ 6  ]          = i_syzygy_a_s_18;
        adc_data[ 7  ]          = i_syzygy_a_s_20;
        adc_data[ 8  ]          = i_syzygy_a_s_17;
        adc_data[ 9  ]          = i_syzygy_a_d_p_4;
        adc_data[ 10 ]          = i_syzygy_a_s_19;
        adc_data[ 11 ]          = i_syzygy_a_s_21;
        adc_data[ 12 ]          = i_syzygy_a_s_23;
        adc_data[ 13 ]          = i_syzygy_a_s_25;
        
        adc_test_mode           = 1'b0;
    end
    
    assign  o_syzygy_a_p2c_clk_n    = 1'b0;
    
    ZmodADC1410_Controller_0
    u_ZmodADC1410_Controller_0
    (
        .SysClk             ( sys_clock             ),             // IN STD_LOGIC;
        .ADC_InClk          ( adc_clock             ),             // IN STD_LOGIC;
        .sRst_n             ( locked                ),             // IN STD_LOGIC;
        .sInitDone_n        ( adc_init_done         ),             // OUT STD_LOGIC;
        .FIFO_EMPTY_CHA     ( adc_fifo_empty_cha    ),             // OUT STD_LOGIC;
        .FIFO_EMPTY_CHB     ( adc_fifo_empty_chb    ),             // OUT STD_LOGIC;
        .sCh1Out            ( adc_data_ch1          ),             // OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        .sCh2Out            ( adc_data_ch2          ),             // OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        .sTestMode          ( adc_test_mode         ),             // IN STD_LOGIC;
        .adcClkIn_p         ( o_syzygy_a_c2p_clk_p  ),             // OUT STD_LOGIC;
        .adcClkIn_n         ( o_syzygy_a_c2p_clk_n  ),             // OUT STD_LOGIC;
        .adcSync            ( o_syzygy_a_s_27       ),             // OUT STD_LOGIC;
        .DcoClk             ( i_syzygy_a_p2c_clk_p  ),             // IN STD_LOGIC;
        .dADC_Data          ( adc_data              ),             // IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        .sADC_SDIO          ( io_syzygy_a_d_p_2     ),             // INOUT STD_LOGIC;
        .sADC_CS            ( o_syzygy_a_s_26       ),             // OUT STD_LOGIC;
        .sADC_Sclk          ( o_syzygy_a_d_n_2      ),             // OUT STD_LOGIC;
        .sCh1CouplingH      ( o_syzygy_a_d_p_0      ),             // OUT STD_LOGIC;
        .sCh1CouplingL      ( o_syzygy_a_d_n_0      ),             // OUT STD_LOGIC;
        .sCh2CouplingH      ( o_syzygy_a_d_p_1      ),             // OUT STD_LOGIC;
        .sCh2CouplingL      ( o_syzygy_a_d_n_1      ),             // OUT STD_LOGIC;
        .sCh1GainH          ( o_syzygy_a_d_p_5      ),             // OUT STD_LOGIC;
        .sCh1GainL          ( o_syzygy_a_d_n_5      ),             // OUT STD_LOGIC;
        .sCh2GainH          ( o_syzygy_a_d_p_3      ),             // OUT STD_LOGIC;
        .sCh2GainL          ( o_syzygy_a_d_n_3      ),             // OUT STD_LOGIC;
        .sRelayComH         ( o_syzygy_a_d_p_7      ),             // OUT STD_LOGIC;
        .sRelayComL         ( o_syzygy_a_d_n_7      )              // OUT STD_LOGIC
    );
    
    /* ########################################################### */
    /* UART TX ################################################### */
    
    localparam  UART_DATA_SIZE      = 8;
    localparam  UART_CLOCK_COUNT    = 2000000;
    
    reg     [ UART_DATA_SIZE - 1 : 0 ]  uart_txdata_l;
    reg     [ UART_DATA_SIZE - 1 : 0 ]  uart_txdata_h;
    reg                                 uart_send;
    wire                                uart_ready;
    integer                             uart_send_counter;
    
    always@( posedge sys_clock ) begin
    
        if( ~locked ) begin
            uart_send           <= 1'b0;    
            uart_send_counter   <= 0;
        end
        else begin
            if( uart_send_counter == UART_CLOCK_COUNT ) begin
                uart_send           <= uart_ready ? 1'b1 : 1'b0;
                uart_txdata_l       <= adc_data_ch1[ 7  : 0 ];
                uart_txdata_h       <= adc_data_ch1[ 15 : 8 ];
                uart_send_counter   <= 0;
            end
            else begin
                uart_send           <= 1'b0;
                uart_send_counter   <= uart_send_counter + 1;
            end   
        end
    end
    
    uart #
    (
        .UART_DATA_SIZE ( UART_DATA_SIZE    )
    )
    u_uart
    (
        .i_clock        ( sys_clock         ),
        .i_reset        ( ~locked           ),
        .i_data_l       ( uart_txdata_l     ),
        .i_data_h       ( uart_txdata_h     ),
        .i_send         ( uart_send         ),
        .o_ready        ( uart_ready        ),
        .o_tx           ( o_tx              )
    );
    
    /* ########################################################### */
    /* LED'S ##################################################### */
    
    localparam  LED_CLOCK_COUNT = 50;
    
    reg         led_pwm;
    integer     led_pwm_counter;
    
    always@( posedge sys_clock ) begin
        
        if( ~locked )
            led_pwm_counter <= 0;
        else begin
            if( led_pwm_counter == LED_CLOCK_COUNT ) begin
                led_pwm         <= 1'b1;
                led_pwm_counter <= 0;
            end
            else begin
                led_pwm         <= 1'b0;
                led_pwm_counter <= led_pwm_counter + 1;
            end   
        end
    end 
    
    assign  o_led0_g    = adc_init_done ? 1'b0      : led_pwm;
    assign  o_led0_r    = adc_init_done ? led_pwm   : 1'b0;
    
endmodule