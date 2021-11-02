`timescale 1ns / 1ps
`default_nettype none

module adc1410 #
(
    parameter   DATA_SIZE           = 14,
    parameter   IAGC_STATUS_SIZE    = 4
)
(
    input  wire                                 i_sys_clock,
    input  wire                                 i_adc_clock,
    input  wire [ IAGC_STATUS_SIZE - 1 : 0 ]    i_iagc_status,
    input  wire                                 i_adc_data_0,
    input  wire                                 i_adc_data_1,
    input  wire                                 i_adc_data_2,
    input  wire                                 i_adc_data_3,
    input  wire                                 i_adc_data_4,
    input  wire                                 i_adc_data_5,
    input  wire                                 i_adc_data_6,
    input  wire                                 i_adc_data_7,
    input  wire                                 i_adc_data_8,
    input  wire                                 i_adc_data_9,
    input  wire                                 i_adc_data_10,
    input  wire                                 i_adc_data_11,
    input  wire                                 i_adc_data_12,
    input  wire                                 i_adc_data_13,
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
    output wire     [ DATA_SIZE       - 1 : 0 ] o_adc_data_out_ch1,
    output wire     [ DATA_SIZE       - 1 : 0 ] o_adc_data_out_ch2,
    output wire                                 o_adc_init_done
);

    localparam IAGC_STATUS_RESET        = 4'b0000;
    localparam IAGC_STATUS_INIT         = 4'b0001;
    localparam IAGC_STATUS_IDLE         = 4'b0010;
    localparam IAGC_STATUS_SAMPLE       = 4'b0011;
    localparam IAGC_STATUS_CMD_PARSE    = 4'b0100;
    localparam IAGC_STATUS_CMD_READ     = 4'b0101;
    localparam IAGC_STATUS_CMD_ERROR    = 4'b0110;
    localparam IAGC_STATUS_DUMP_REF     = 4'b0111;
    localparam IAGC_STATUS_DUMP_ERR     = 4'b1000;
    localparam IAGC_STATUS_CLEAN_MEM    = 4'b1001;
    localparam IAGC_STATUS_SET_MEM      = 4'b1010;
    localparam IAGC_STATUS_SET_DEC      = 4'b1011;
    localparam IAGC_STATUS_HALT         = 4'b1100;
    
    localparam ADC_IN_DATA_SIZE     = 14;
    localparam ADC_OUT_DATA_SIZE    = 16;
    
    wire    [ ADC_IN_DATA_SIZE - 1 : 0 ]    data_in;
    wire                                    test_mode;
    wire                                    init_done;
    wire                                    reset;
    wire    [ ADC_OUT_DATA_SIZE - 1 : 0 ]   data_out_ch1;
    wire    [ ADC_OUT_DATA_SIZE - 1 : 0 ]   data_out_ch2;
    
    assign reset                = i_iagc_status == IAGC_STATUS_RESET ? 1'b0 : 1'b1;
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
    assign o_adc_init_done      = ~init_done;
    assign o_adc_data_out_ch1   = data_out_ch1[ 15 : 2 ];
    assign o_adc_data_out_ch2   = data_out_ch2[ 15 : 2 ];
    
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
        .sRst_n             ( reset                 ),
        .sInitDone_n        ( init_done             ),
        .FIFO_EMPTY_CHA     (                       ),
        .FIFO_EMPTY_CHB     (                       ),
        .sCh1Out            ( data_out_ch1          ),
        .sCh2Out            ( data_out_ch2          ),
        .sTestMode          ( test_mode             ),
        .adcClkIn_p         ( o_adc_clock_in_p      ),
        .adcClkIn_n         ( o_adc_clock_in_n      ),
        .adcSync            ( o_adc_sync            ),
        .DcoClk             ( i_adc_dco_clock_p     ),
        .dADC_Data          ( data_in               ),
        .sADC_SDIO          ( io_adc_sdio           ),
        .sADC_CS            ( o_adc_cs              ),
        .sADC_Sclk          ( o_adc_sclk            ),
        .sCh1CouplingH      ( o_adc_ch1_coupling_h  ),
        .sCh1CouplingL      ( o_adc_ch1_coupling_l  ),
        .sCh2CouplingH      ( o_adc_ch2_coupling_h  ),
        .sCh2CouplingL      ( o_adc_ch2_coupling_l  ),
        .sCh1GainH          ( o_adc_ch1_gain_h      ),
        .sCh1GainL          ( o_adc_ch1_gain_l      ),
        .sCh2GainH          ( o_adc_ch2_gain_h      ),
        .sCh2GainL          ( o_adc_ch2_gain_l      ),
        .sRelayComH         ( o_adc_relay_com_h     ),
        .sRelayComL         ( o_adc_relay_com_l     )
    );
    
endmodule

`default_nettype wire