`timescale 1ns / 1ps

module top
(
    input   i_clock,
    
    input   i_reset,
        
    output  o_led0_g,
    output  o_led0_r,
    output  o_led0_b,
    
    output  o_tx,
    
    input   i_calib,
    
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
    
    /*
               <--- IP Configuration --->
        clk_in1     =   125 MHz
        clk_out1    =   100 MHz
        clk_out1    =   400 MHz
    */
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
    
    localparam  ADC_CHDATA_SIZE =   16;
    localparam  ADC_DATA_SIZE   =   14;
    localparam  ADC_CALIB_SIZE  =   18;
    
    wire    [ ADC_CHDATA_SIZE - 1 : 0 ] adc_out_ch1;
    wire    [ ADC_CHDATA_SIZE - 1 : 0 ] adc_out_ch2;
    wire                                adc_init_done;
    wire    [ ADC_CALIB_SIZE  - 1 : 0 ] adc_calib;
    
    adc #
    (
        .ADC_CHDATA_SIZE    (ADC_CHDATA_SIZE),
        .ADC_DATA_SIZE      (ADC_DATA_SIZE),
        .ADC_CALIB_SIZE     (ADC_CALIB_SIZE)
    )
    u_adc
    (
        .i_sys_clock        (sys_clock),
        .i_adc_clock        (adc_clock),
        .i_reset            (locked),
        .i_calib_value      (adc_calib),
        .i_adc_data_0       (i_adc_data_0),
        .i_adc_data_1       (i_adc_data_1),
        .i_adc_data_2       (i_adc_data_2),
        .i_adc_data_3       (i_adc_data_3),
        .i_adc_data_4       (i_adc_data_4),
        .i_adc_data_5       (i_adc_data_5),
        .i_adc_data_6       (i_adc_data_6),
        .i_adc_data_7       (i_adc_data_7),
        .i_adc_data_8       (i_adc_data_8),
        .i_adc_data_9       (i_adc_data_9),
        .i_adc_data_10      (i_adc_data_10),
        .i_adc_data_11      (i_adc_data_11),
        .i_adc_data_12      (i_adc_data_12),
        .i_adc_data_13      (i_adc_data_13),
        .io_adc_sdio        (io_adc_sdio),
        .i_adc_dco_clock_p  (i_adc_dco_clock_p),
        .o_adc_dco_clock_n  (o_adc_dco_clock_n),
        .o_adc_sclk         (o_adc_sclk),
        .o_adc_clock_in_n   (o_adc_clock_in_n),
        .o_adc_clock_in_p   (o_adc_clock_in_p),
        .o_ch1_coupling_h   (o_ch1_coupling_h),
        .o_ch1_coupling_l   (o_ch1_coupling_l),
        .o_ch2_coupling_h   (o_ch2_coupling_h),
        .o_ch2_coupling_l   (o_ch2_coupling_l),
        .o_ch2_gain_h       (o_ch2_gain_h),
        .o_ch2_gain_l       (o_ch2_gain_l),
        .o_ch1_gain_l       (o_ch1_gain_l),
        .o_ch1_gain_h       (o_ch1_gain_h),
        .o_adc_relay_com_l  (o_adc_relay_com_l),
        .o_adc_relay_com_h  (o_adc_relay_com_h),
        .o_adc_cs           (o_adc_cs),
        .o_adc_sync         (o_adc_sync),
        .o_data_out_ch1     (adc_out_ch1),
        .o_data_out_ch2     (adc_out_ch2),
        .o_init_done        (adc_init_done) 
    );
   
    /* ########################################################### */
    /* UART TX ################################################### */
    
    localparam  UART_DATA_SIZE  =   8;
    localparam  PRESCALE_SIZE   =   16;
    
    wire    [ UART_DATA_SIZE - 1 : 0 ]  tx_data;
    reg                                 tx_valid;
    wire                                tx_ready;
    wire                                tx_busy;
    
    wire    [ PRESCALE_SIZE - 1 : 0 ]   uart_prescale;
    
    assign  tx_data         = adc_out_ch2[15:8];
    assign  uart_prescale   = 16'b0000010100010110;   /* 9600 BR 8-bit    */
    
    always@( posedge sys_clock ) begin
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
    
    /* ########################################################### */
    /* ADC CALIBRATION ########################################### */
    
    localparam  ADC_CALIB_TICKS =   7500;
    
    wire                calib_enabled;
    
    adc_calibrator #
    (
        .CALIB_SIZE     (ADC_CALIB_SIZE),
        .CALIB_TICKS    (ADC_CALIB_TICKS)
    )
    u_adc_calibrator
    (
        .i_clock            (sys_clock),
        .i_reset            (~locked),   
        .i_toggle           (i_calib),
        .o_calib_enabled    (calib_enabled),
        .o_calib_value      (adc_calib)
    );    
        
    /* ########################################################### */
    /* ONBOARD LED'S ############################################# */
    
    localparam  LED_PWM_TICKS   = 50;
    
    led_unit #
    (
        .LED_PWM_TICKS      (LED_PWM_TICKS)
    )
    u_led_unit
    (
        .i_clock            (sys_clock),
        .i_reset            (~locked),
        .i_calib_enabled    (calib_enabled),
        .i_adc_init_done    (adc_init_done),
        .o_led_r            (o_led0_r),
        .o_led_g            (o_led0_g),
        .o_led_b            (o_led0_b)
    );
        
endmodule