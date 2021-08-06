`timescale 1ns / 1ps

module top
(
    input   i_clock,
    
    input   i_reset,
        
    output  o_led0_g,
    output  o_led0_r,
    output  o_led0_b,
    
    output  o_tx_ch1,
    output  o_tx_ch2,
    
    input   i_calib,
    
    input   i_gate,   
    
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
    /* CLOCK GENERATOR ########################################### */
    
    wire    sys_clock;
    wire    sys_reset;
    wire    adc_clock;
    
    clock_unit #
    (
    )
    u_clock_unit
    (
        .i_clock        (i_clock),
        .i_reset        (i_reset),
        .o_adc_clock    (adc_clock),
        .o_sys_clock    (sys_clock),
        .o_valid        (sys_reset)
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
    
    adc1410 #
    (
        .ADC_CHDATA_SIZE    (ADC_CHDATA_SIZE),
        .ADC_DATA_SIZE      (ADC_DATA_SIZE),
        .ADC_CALIB_SIZE     (ADC_CALIB_SIZE)
    )
    u_adc1410
    (
        .i_sys_clock        (sys_clock),
        .i_adc_clock        (adc_clock),
        .i_reset            (~sys_reset),
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
    /* CALIBRATION ############################################### */
    
    localparam  ADC_CALIB_TICKS =   7500;
    
    wire                calib_enabled;
    
    calibrator #
    (
        .CALIB_SIZE     (ADC_CALIB_SIZE),
        .CALIB_TICKS    (ADC_CALIB_TICKS)
    )
    u_calibrator
    (
        .i_clock            (sys_clock),
        .i_reset            (sys_reset),   
        .i_toggle           (i_calib),
        .o_calib_enabled    (calib_enabled),
        .o_calib_value      (adc_calib)
    );   
    
    /* ########################################################### */
    /* DATA CONVERSORS ############################################ */
    
    localparam  CONVERSOR_DATA_SIZE =   14;
    
    wire    [ CONVERSOR_DATA_SIZE - 1 : 0 ] data_converted_ch1;
    wire    [ CONVERSOR_DATA_SIZE - 1 : 0 ] data_converted_ch2;
    
    data_conversor #
    (
        .CONVERSOR_DATA_SIZE    (CONVERSOR_DATA_SIZE)
    )
    u_data_conversor_ch1
    (
        .i_data                 (adc_out_ch1[15:2]),
        .o_data                 (data_converted_ch1)
    );
    
    data_conversor #
    (
        .CONVERSOR_DATA_SIZE    (CONVERSOR_DATA_SIZE)
    )
    u_data_conversor_ch2
    (
        .i_data                 (adc_out_ch2[15:2]),
        .o_data                 (data_converted_ch2)
    );
    
    /* ########################################################### */
    /* GATE BUFFER ############################################### */
    
    wire    [ CONVERSOR_DATA_SIZE - 1 : 0 ] gatered_data_ch1;
    wire    [ CONVERSOR_DATA_SIZE - 1 : 0 ] gatered_data_ch2;
    wire                                    valid_ch1;
    wire                                    valid_ch2;
    
    gate_buffer #
    (
        .DATA_SIZE      ( CONVERSOR_DATA_SIZE   )
    )
    u_gate_buffer_ch1
    (
        .i_clock        ( sys_clock             ),
        .i_reset        ( sys_reset             ),
        .i_next         ( tx_ready_ch1          ),
        .i_data         ( data_converted_ch1    ),
        .i_gate         ( i_gate                ),
        .i_adc_init     ( adc_init_done         ),
        .o_data         ( gatered_data_ch1      ),
        .o_valid        ( valid_ch1             )
    );
    
    gate_buffer #
    (
        .DATA_SIZE      ( CONVERSOR_DATA_SIZE   )
    )
    u_gate_buffer_ch2
    (
        .i_clock        ( sys_clock             ),
        .i_reset        ( sys_reset             ),
        .i_next         ( tx_ready_ch2          ),
        .i_data         ( data_converted_ch2    ),
        .i_gate         ( i_gate                ),
        .i_adc_init     ( adc_init_done         ),
        .o_data         ( gatered_data_ch2      ),
        .o_valid        ( valid_ch2             )
    );
   
    /* ########################################################### */
    /* TX UNIT ################################################### */
    
    localparam  TX_DATA_SIZE  =   8;
    
    wire    tx_ready_ch1;
    wire    tx_ready_ch2;
    
    tx_unit #
    (
        .TX_DATA_SIZE       ( TX_DATA_SIZE  )
    )
    u_tx_unit_ch1
    (
        .i_clock            ( sys_clock                 ),
        .i_reset            ( sys_reset                 ),
        .i_send             ( valid_ch1                 ),
        .i_txdata           ( gatered_data_ch1[13 : 6 ] ),
        .o_txready          ( tx_ready_ch1              ),
        .o_tx               ( o_tx_ch1                  )
    );
    
    tx_unit #
    (
        .TX_DATA_SIZE       ( TX_DATA_SIZE  )
    )
    u_tx_unit_ch2
    (
        .i_clock            ( sys_clock                 ),
        .i_reset            ( sys_reset                 ),
        .i_send             ( valid_ch2                 ),
        .i_txdata           ( gatered_data_ch2[13 : 6 ] ),
        .o_txready          ( tx_ready_ch2              ),
        .o_tx               ( o_tx_ch2                  )
    );
        
    /* ########################################################### */
    /* LED UNIT ################################################## */
    
    localparam  LED_PWM_TICKS   = 50;
    
    led_unit #
    (
        .LED_PWM_TICKS      (LED_PWM_TICKS)
    )
    u_led_unit
    (
        .i_clock            (sys_clock),
        .i_reset            (sys_reset),
        .i_calib_enabled    (calib_enabled),
        .i_adc_init_done    (adc_init_done),
        .o_led_r            (o_led0_r),
        .o_led_g            (o_led0_g),
        .o_led_b            (o_led0_b)
    );
        
endmodule
