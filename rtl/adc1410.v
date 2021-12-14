`timescale 1ns / 1ps
`default_nettype none

module adc1410 #
(
    parameter   ZMOD_DATA_SIZE      = 14,
    parameter   IAGC_STATUS_SIZE    = 4
)
(
    input  wire                                 i_sys_clock,
    input  wire                                 i_adc_sampling_clock,
    input  wire                                 i_adc_in_clock,
    input  wire                                 i_sample,
    input  wire [ IAGC_STATUS_SIZE  - 1 : 0 ]   i_iagc_status,
    input  wire [ ZMOD_DATA_SIZE    - 1 : 0 ]   i_adc_data,
    inout  wire                                 io_adc_sdio,
    input  wire                                 i_adc_dco_clock_p,
    output wire                                 o_adc_dco_clock_n,
    output wire                                 o_adc_sclk,
    output wire                                 o_adc_clock_in_n,
    output wire                                 o_adc_clock_in_p,
    output wire                                 o_adc_ch1_coupling_h,
    output wire                                 o_adc_ch1_coupling_l,
    output wire                                 o_adc_ch2_coupling_h,
    output wire                                 o_adc_ch2_coupling_l,
    output wire                                 o_adc_ch2_gain_h,
    output wire                                 o_adc_ch2_gain_l,
    output wire                                 o_adc_ch1_gain_l,
    output wire                                 o_adc_ch1_gain_h,
    output wire                                 o_adc_relay_com_l,
    output wire                                 o_adc_relay_com_h,
    output wire                                 o_adc_cs,
    output wire                                 o_adc_sync,
    output wire [ ZMOD_DATA_SIZE    - 1 : 0 ]   o_adc_data_out_ch1,
    output wire [ ZMOD_DATA_SIZE    - 1 : 0 ]   o_adc_data_out_ch2,
    output wire                                 o_adc_init_done
);

    localparam IAGC_STATUS_RESET    = 4'b0000;
    
    localparam ADC_OUT_DATA_SIZE    = 32;
    
    wire                                test_mode;
    wire                                init_error;
    wire                                reset;
    wire                                reset_busy;
    wire [ ADC_OUT_DATA_SIZE - 1 : 0 ]  tdata;                               
    
    assign reset                = i_iagc_status == IAGC_STATUS_RESET ? 1'b0 : 1'b1;
    assign test_mode            = 1'b0;
    assign o_adc_dco_clock_n    = 1'b0;
    assign o_adc_data_out_ch1   = tdata[ 31 : 18 ];
    assign o_adc_data_out_ch2   = tdata[ 15 : 2  ];
    
    /*
               <--- IP Configuration --->
        Ch1CouplingStatic   =   1
        Ch2CouplingStatic   =   1
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
        
        Prefijo 's' -> sincrono a SysClk100
        Prefijo 'c' -> sincrono a ADC_SamplingClk
        Prefijo 'i' -> sincrono a ADC_InClk
        Prefijo 'd' -> sincrono a ZmodDcoClk
    */    
    ZmodScopeController_0
    u_ZmodScopeController_0
    (        
        .SysClk100          ( i_sys_clock           ),
        .ADC_SamplingClk    ( i_adc_sampling_clock  ),
        .ADC_InClk          ( i_adc_in_clock        ),
        .aRst_n             ( reset                 ),
        .sRstBusy           ( reset_busy            ),
        .sInitDoneADC       ( o_adc_init_done       ),
        .sConfigError       ( init_error            ),
        .sInitDoneRelay     (),
        .sDataOverflow      (),
        .cDataAxisTvalid    (),
        .cDataAxisTready    ( i_sample              ),
        .cDataAxisTdata     ( tdata                 ),
        .sTestMode          ( test_mode             ),
        .ZmodAdcClkIn_p     ( o_adc_clock_in_p      ),
        .ZmodAdcClkIn_n     ( o_adc_clock_in_n      ),
        .iZmodSync          (),
        .ZmodDcoClk         ( i_adc_dco_clock_p     ),
        .dZmodADC_Data      ( i_adc_data            ),
        .sZmodADC_SDIO      ( io_adc_sdio           ),
        .sZmodADC_CS        ( o_adc_cs              ),
        .sZmodADC_Sclk      ( o_adc_sclk            ),
        .sZmodCh1CouplingH  ( o_adc_ch1_coupling_h  ),
        .sZmodCh1CouplingL  ( o_adc_ch1_coupling_l  ),
        .sZmodCh2CouplingH  ( o_adc_ch2_coupling_h  ),
        .sZmodCh2CouplingL  ( o_adc_ch2_coupling_l  ),
        .sZmodCh1GainH      ( o_adc_ch1_gain_h      ),
        .sZmodCh1GainL      ( o_adc_ch1_gain_l      ),
        .sZmodCh2GainH      ( o_adc_ch2_gain_h      ),
        .sZmodCh2GainL      ( o_adc_ch2_gain_l      ),
        .sZmodRelayComH     ( o_adc_relay_com_h     ),
        .sZmodRelayComL     ( o_adc_relay_com_l     )
    );
    
endmodule

`default_nettype wire