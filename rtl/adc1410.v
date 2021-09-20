`timescale 1ns / 1ps

module adc1410 #
(
    parameter   DATA_SIZE = 16
)
(
    input                           i_sys_clock,
    input                           i_adc_clock,
    input                           i_reset,
    input                           i_adc_data_0,
    input                           i_adc_data_1,
    input                           i_adc_data_2,
    input                           i_adc_data_3,
    input                           i_adc_data_4,
    input                           i_adc_data_5,
    input                           i_adc_data_6,
    input                           i_adc_data_7,
    input                           i_adc_data_8,
    input                           i_adc_data_9,
    input                           i_adc_data_10,
    input                           i_adc_data_11,
    input                           i_adc_data_12,
    input                           i_adc_data_13,
    inout                           io_adc_sdio,
    input                           i_adc_dco_clock_p,
    output                          o_adc_dco_clock_n,
    output                          o_adc_sclk,
    output                          o_adc_clock_in_n,
    output                          o_adc_clock_in_p,
    output                          o_ch1_coupling_h,
    output                          o_ch1_coupling_l,
    output                          o_ch2_coupling_h,
    output                          o_ch2_coupling_l,
    output                          o_ch2_gain_h,
    output                          o_ch2_gain_l,
    output                          o_ch1_gain_l,
    output                          o_ch1_gain_h,
    output                          o_adc_relay_com_l,
    output                          o_adc_relay_com_h,
    output                          o_adc_cs,
    output                          o_adc_sync,
    output  [ DATA_SIZE - 1 : 0 ]   o_data_out_ch1,
    output  [ DATA_SIZE - 1 : 0 ]   o_data_out_ch2,
    output                          o_init_done
);
    
    localparam  ADC_IN_DATA_SIZE    =   14;
    
    wire    [ ADC_IN_DATA_SIZE - 1 : 0 ]    data_in;
    wire                                    test_mode;
    wire                                    init_done;
    
    assign test_mode            = 1'b0;
    assign data_in[ 0  ]        = i_adc_data_0;
    assign data_in[ 1  ]        = i_adc_data_1;
    assign data_in[ 2  ]        = i_adc_data_2;
    assign data_in[ 3  ]        = i_adc_data_3;
    assign data_in[ 4  ]        = i_adc_data_4;
    assign data_in[ 5  ]        = i_adc_data_5;
    assign data_in[ 6  ]        = i_adc_data_6;
    assign data_in[ 7  ]        = i_adc_data_7;
    assign data_in[ 8  ]        = i_adc_data_8;
    assign data_in[ 9  ]        = i_adc_data_9;
    assign data_in[ 10 ]        = i_adc_data_10;
    assign data_in[ 11 ]        = i_adc_data_11;
    assign data_in[ 12 ]        = i_adc_data_12;
    assign data_in[ 13 ]        = i_adc_data_13;
    assign o_adc_dco_clock_n    = 1'b0;
    assign o_init_done          = ~init_done;
    
    /*
               <--- IP Configuration --->
        Ch1CouplingStatic   =   1
        Ch2CouplingStatic   =   0
        Ch1GainStatic       =   1
        Ch2GainStatic       =   1
        Ch1HgAddCoefStatic  =   000000000000000000
        Ch2HgAddCoefStatic  =   000000000000000000
        Ch1LgAddCoefStatic  =   000000000000000000
        Ch2LgAddCoefStatic  =   000000000000000000
        Ch1HgMultCoefStatic =   010000000000000000
        Ch2HgMultCoefStatic =   010000000000000000
        Ch1LgMultCoefStatic =   010000000000000000
        Ch2LgMultCoefStatic =   010000000000000000   
    */
    ZmodADC1410_Controller_0
    u_ZmodADC1410_Controller_0
    (
        .SysClk             ( i_sys_clock           ),
        .ADC_InClk          ( i_adc_clock           ),
        .sRst_n             ( i_reset               ),
        .sInitDone_n        ( init_done             ),
        .FIFO_EMPTY_CHA     (                       ),
        .FIFO_EMPTY_CHB     (                       ),
        .sCh1Out            ( o_data_out_ch1        ),
        .sCh2Out            ( o_data_out_ch2        ),
        .sTestMode          ( test_mode             ),
        .adcClkIn_p         ( o_adc_clock_in_p      ),
        .adcClkIn_n         ( o_adc_clock_in_n      ),
        .adcSync            ( o_adc_sync            ),
        .DcoClk             ( i_adc_dco_clock_p     ),
        .dADC_Data          ( data_in               ),
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
    
endmodule
