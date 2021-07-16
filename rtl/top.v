`timescale 1ns / 1ps

module top
(
    input   i_clock,
    
    input   i_reset,
        
    output  o_led0_g,
    output  o_led0_r,
    output  o_led0_b,
    
    output  o_tx_0,
    output  o_tx_1,
    
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
    /* PROCESSOR ################################################# */
    
    localparam  PROCESSOR_DATA_SIZE         =   8;
    localparam  PROCESSOR_REMAINDER_SIZE    =   8;
    
    wire    [ PROCESSOR_DATA_SIZE - 1 : 0 ] processor_quotient;
    wire    [ PROCESSOR_DATA_SIZE - 1 : 0 ] processor_remainder;
    wire                                    processor_valid;
    
    processor #
    (
        .DATA_SIZE          (PROCESSOR_DATA_SIZE),
        .REMAINDER_SIZE     (PROCESSOR_REMAINDER_SIZE)
    )
    u_processor
    (
        .i_clock        (sys_clock),
        .i_reset        (~locked),
        .i_reference    (adc_out_ch1[15:8]),
        .i_error        (adc_out_ch2[15:8]),
        .i_start        (1'b1),
        .o_quotient     (processor_quotient),
        .o_remainder    (processor_remainder),
        .o_valid        (processor_valid)
    );
    
    /* ########################################################### */
    /* DATA CONVERSOR ############################################ */
    
    localparam  CONVERTED_DATA_SIZE =   8;
    
    reg [ CONVERTED_DATA_SIZE - 1 : 0 ] data_ch1_converted;
    reg [ CONVERTED_DATA_SIZE - 1 : 0 ] data_ch2_converted;
    
    always@( adc_out_ch1 ) begin
        if( adc_out_ch1[15:8] < 256 && adc_out_ch1[15:8] > 128 ) begin
            data_ch1_converted = adc_out_ch1[15:8] - 128;
        end
        else begin
            data_ch1_converted = adc_out_ch1[15:8] + 128;
        end
    end
    
    always@( adc_out_ch2 ) begin
        if( adc_out_ch2[15:8] < 256 && adc_out_ch2[15:8] > 128 ) begin
            data_ch2_converted = adc_out_ch2[15:8] - 128;
        end
        else begin
            data_ch2_converted = adc_out_ch2[15:8] + 128;
        end
    end
    
    /* ########################################################### */
    /* TX UNIT ################################################### */
    
    localparam  TX_DATA_SIZE  =   8;
    
    tx_unit #
    (
        .TX_DATA_SIZE        (TX_DATA_SIZE)
    )
    u_tx_unit
    (
        .i_clock            (sys_clock),
        .i_reset            (~locked),
        .i_txdata_0         (data_ch1_converted),
        .i_txdata_1         (data_ch2_converted),
        .o_tx_0             (o_tx_0),
        .o_tx_1             (o_tx_1)
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

/*
    Lecturas con fuente (8 MSB)
     
    Polo positivo
    0 [V] -> 0x00 = 0 
    1 [V] -> 0x7F = 127
    
    Polo negativo
    0 [V] -> 0xFF = 255
    1 [V] -> 0x81 = 129
    
    
*/







