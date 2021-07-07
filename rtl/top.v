`timescale 1ns / 1ps

module top
(
    input   i_clock,
    
    input   i_reset,
        
    output  o_led0_g,
    output  o_led0_r,
    
    output  o_tx,
    
    
    input   i_adc_data_0,
    input   i_adc_data_1,
    input   i_adc_data_2,
    input   i_adc_data_3,
    input   i_adc_data_4,
    input   i_adc_data_5,
    input   i_adc_data_6,
    input   i_adc_data_7,
    input   i_adc_data_8,
    input   i_adc_data_9,
    input   i_adc_data_10,
    input   i_adc_data_11,
    input   i_adc_data_12,
    input   i_adc_data_13,
    inout   io_adc_sdio,
    input   i_adc_dco_clock_p,
    output  o_adc_dco_clock_n,
    output  o_adc_sclk,
    output  o_adc_clock_in_n,
    output  o_adc_clock_in_p,
    output  o_ch1_coupling_h,
    output  o_ch1_coupling_l,
    output  o_ch2_coupling_h,
    output  o_ch2_coupling_l,
    output  o_ch2_gain_h,
    output  o_ch2_gain_l,
    output  o_ch1_gain_l,
    output  o_ch1_gain_h,
    output  o_adc_relay_com_l,
    output  o_adc_relay_com_h,
    output  o_adc_cs,
    output  o_adc_sync       
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
    localparam  ADC_CALIB_SIZE  = 8;
    
    wire    [ ADC_CHDATA_SIZE - 1 : 0 ] adc_data_out_ch1;
    wire    [ ADC_CHDATA_SIZE - 1 : 0 ] adc_data_out_ch2;
    wire    [ ADC_DATA_SIZE   - 1 : 0 ] adc_data_in;
    wire                                adc_init_done;
    wire                                adc_fifo_empty_cha;
    wire                                adc_fifo_empty_chb;
    wire                                adc_test_mode;
    wire    [ ADC_CALIB_SIZE  - 1 : 0 ] adc_calib;
    reg     [ ADC_CALIB_SIZE  - 1 : 0 ] adc_calib_reg;
    
    assign adc_test_mode        = 1'b0;
    assign adc_calib            = adc_calib_reg;
    assign adc_data_in[ 0  ]    = i_adc_data_0;
    assign adc_data_in[ 1  ]    = i_adc_data_1;
    assign adc_data_in[ 2  ]    = i_adc_data_2;
    assign adc_data_in[ 3  ]    = i_adc_data_3;
    assign adc_data_in[ 4  ]    = i_adc_data_4;
    assign adc_data_in[ 5  ]    = i_adc_data_5;
    assign adc_data_in[ 6  ]    = i_adc_data_6;
    assign adc_data_in[ 7  ]    = i_adc_data_7;
    assign adc_data_in[ 8  ]    = i_adc_data_8;
    assign adc_data_in[ 9  ]    = i_adc_data_9;
    assign adc_data_in[ 10 ]    = i_adc_data_10;
    assign adc_data_in[ 11 ]    = i_adc_data_11;
    assign adc_data_in[ 12 ]    = i_adc_data_12;
    assign adc_data_in[ 13 ]    = i_adc_data_13;
    assign o_adc_dco_clock_n    = 1'b0;
    
    ZmodADC1410_Controller_0
    u_ZmodADC1410_Controller_0
    (
        .SysClk             ( sys_clock             ),
        .ADC_InClk          ( adc_clock             ),
        .sRst_n             ( locked                ),
        .sInitDone_n        ( adc_init_done         ),
        .FIFO_EMPTY_CHA     ( adc_fifo_empty_cha    ),
        .FIFO_EMPTY_CHB     ( adc_fifo_empty_chb    ),
        .sCh1Out            ( adc_data_out_ch1      ),
        .sCh2Out            ( adc_data_out_ch2      ),
        .sTestMode          ( adc_test_mode         ),
        .adcClkIn_p         ( o_adc_clock_in_p      ),
        .adcClkIn_n         ( o_adc_clock_in_n      ),
        .adcSync            ( o_adc_sync            ),
        .DcoClk             ( i_adc_dco_clock_p     ),
        .dADC_Data          ( adc_data_in           ),
        .sADC_SDIO          ( io_adc_sdio           ),
        .sADC_CS            ( o_adc_cs              ),
        .sADC_Sclk          ( o_adc_sclk            ),
        .sCh1CouplingH      ( o_ch1_coupling_h      ),
        .sCh1CouplingL      ( o_ch1_coupling_l      ),
        .sCh2CouplingH      ( o_ch2_coupling_h      ),
        .sCh2CouplingL      ( o_ch2_coupling_l      ),
        .sCh1GainH          ( o_ch1_gain_h          ),
        .sCh1GainL          ( o_ch1_gain_l          ),
        .sCh2GainH          ( o_ch2_gain_h          ),
        .sCh2GainL          ( o_ch2_gain_l          ),
        .sRelayComH         ( o_adc_relay_com_h     ),
        .sRelayComL         ( o_adc_relay_com_l     )
    );
    
    /* ########################################################### */
    /* ONBOARD INIT LED'S ######################################## */
    
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
   
    /* ########################################################### */
    /* UART TX ################################################### */
    
    localparam  UART_DATA_SIZE  =   8;
    localparam  PRESCALE_SIZE   =   16;
    
    wire    [ UART_DATA_SIZE - 1 : 0 ]  tx_data;
    reg                                 tx_valid;
    wire                                tx_ready;
    wire                                tx_busy;
    
    wire    [ PRESCALE_SIZE - 1 : 0 ]   uart_prescale;
    
    assign  tx_data         = adc_data_out_ch1[15:8];
    assign  uart_prescale   = 16'b0000010100010110;   /* 9600 BR 8-bit    */
    
    always@( sys_clock ) begin
        if( ~locked )
            tx_valid    <= 1'b0;
        else begin
            if( tx_ready && ~tx_busy )
                tx_valid    <= 1'b1;
            else
                tx_valid    <= 1'b0;
        end
    end
    
    uart_tx #
    (
        .DATA_WIDTH         (UART_DATA_SIZE)
    )
    u_uart_tx
    (
        .clk                (sys_clock),
        .rst                (~locked),   
        .s_axis_tdata       (tx_data),
        .s_axis_tvalid      (tx_valid),
        .s_axis_tready      (tx_ready),
        .txd                (o_tx),
        .busy               (tx_busy),
        .prescale           (uart_prescale)
    );
        
endmodule