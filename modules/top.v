`timescale 1ns / 1ps

module top
(
    input   i_reset,
    input   i_clock,
    
    output  o_tx,
    
    output  syzygy_d_n_0,       /* sc1_ac_l         */
    output  syzygy_d_p_0,       /* sc1_ac_h         */
    output  syzygy_d_n_1,       /* sc2_ac_l         */
    output  syzygy_d_p_1,       /* sc2_ac_h         */
    output  syzygy_d_n_2,       /* sclk_sc          */
    inout   syzygy_d_p_2,       /* sdio_sc          */
    output  syzygy_d_n_3,       /* sc2_gain_l       */
    output  syzygy_d_p_3,       /* sc2_gain_h       */
    input   syzygy_d_n_4,       /* data 2           */
    input   syzygy_d_p_4,       /* data 9           */
    output  syzygy_d_n_5,       /* sc1_gain_l       */
    output  syzygy_d_p_5,       /* sc1_gain_h       */
    input   syzygy_d_n_6,       /* data 4           */
    input   syzygy_d_p_6,       /* data 3           */
    output  syzygy_d_n_7,       /* com_sc_l         */
    output  syzygy_d_p_7,       /* com_sc_h         */
    input   syzygy_s_16,        /* data 5           */
    input   syzygy_s_17,        /* data 8           */
    input   syzygy_s_18,        /* data 6           */
    input   syzygy_s_19,        /* data 10          */
    input   syzygy_s_20,        /* data 7           */
    input   syzygy_s_21,        /* data 11          */
    input   syzygy_s_22,        /* data 1           */
    input   syzygy_s_23,        /* data 12          */
    input   syzygy_s_24,        /* data 0           */
    input   syzygy_s_25,        /* data 13          */
    output  syzygy_s_26,        /* cs_sc1n          */
    output  syzygy_s_27,        /* sync_adc         */
    output  syzygy_c2p_clk_n,   /* adc clock in n   */
    output  syzygy_c2p_clk_p,   /* adc clock in p   */
    input   syzygy_p2c_clk_p,   /* clkout adc       */
    output  syzygy_p2c_clk_n    /* GND              */
);      
    
    /* System */
    wire            clock;
    wire            locked;
        
    /* ADC */
    localparam  ADC_DATA_OUT_SIZE   =   16;
    localparam  ADC_DATA_IN_SIZE    =   14;
    wire                                    adc_init_done;
    wire                                    adc_clock;
    wire    [ ADC_DATA_OUT_SIZE - 1 : 0 ]   adc_data_out_ch1;
    wire    [ ADC_DATA_OUT_SIZE - 1 : 0 ]   adc_data_out_ch2;
    wire    [ ADC_DATA_IN_SIZE  - 1 : 0 ]   adc_data_in;
    wire                                    adc_test_mode;
    wire                                    adc_fifo_empty_ch1;
    wire                                    adc_fifo_empty_ch2;
    integer                                 adc_data_count;
    
    /* Serial */
    localparam  SERIAL_DATA_SIZE    =   8;
    localparam  SERIAL_CLK_COUNT    =   31000000;   
    reg                                     serial_send;
    wire                                    serial_ready;
    reg     [ SERIAL_DATA_SIZE - 1 : 0 ]    serial_data_l;
    reg     [ SERIAL_DATA_SIZE - 1 : 0 ]    serial_data_h;
    integer                                 clk_counter;
    
    always@( posedge clock ) begin
        if( ~locked ) begin
            clk_counter <= 0;
        end
        else begin
            clk_counter <= clk_counter + 1;
        
            if( clk_counter == SERIAL_CLK_COUNT ) begin
                clk_counter <= 0;
                if( serial_ready )
                    serial_send <= 1'b1;
            end
            else begin
                serial_send <= 1'b0;
            end
            
        end
    end
    
    always@( adc_data_out_ch1 ) begin
        serial_data_l = adc_data_out_ch1[7:0 ];
        serial_data_h = adc_data_out_ch1[15:8];    
    end
    
    assign  syzygy_p2c_clk_n    =   1'b0;
    assign  adc_test_mode       =   1'b0;
    assign  adc_data_in[ 0  ]   =   syzygy_s_24;
    assign  adc_data_in[ 1  ]   =   syzygy_s_22;
    assign  adc_data_in[ 2  ]   =   syzygy_d_n_4;
    assign  adc_data_in[ 3  ]   =   syzygy_d_p_6;
    assign  adc_data_in[ 4  ]   =   syzygy_d_n_6;
    assign  adc_data_in[ 5  ]   =   syzygy_s_16;
    assign  adc_data_in[ 6  ]   =   syzygy_s_18;
    assign  adc_data_in[ 7  ]   =   syzygy_s_20;
    assign  adc_data_in[ 8  ]   =   syzygy_s_17;
    assign  adc_data_in[ 9  ]   =   syzygy_d_p_4;
    assign  adc_data_in[ 10 ]   =   syzygy_s_19;
    assign  adc_data_in[ 11 ]   =   syzygy_s_21;
    assign  adc_data_in[ 12 ]   =   syzygy_s_23;
    assign  adc_data_in[ 13 ]   =   syzygy_s_25;
    
    /* ###################################### */
    clk_wiz_0
    u_clk_wiz_0
    (
        .clk_in1                (i_clock),
        .reset                  (i_reset),
        .clk_out1               (clock),
        .clk_out2               (adc_clock),
        .locked                 (locked)
    );
    /* ###################################### */
    serial #
    (
        .SERIAL_DATA_SIZE       (SERIAL_DATA_SIZE)
    )
    u_serial
    (
        .i_clock                (clock),
        .i_reset                (~locked),
        .i_send                 (serial_send),
        .i_data_h               (serial_data_h),
        .i_data_l               (serial_data_l),
        .o_ready                (serial_ready),
        .o_tx                   (o_tx)
    );
    /* ###################################### */
    ZmodADC1410_Controller_0
    u_ZmodADC1410_Controller_0
    (
        .SysClk             (clock),                //  IN STD_LOGIC;
        .ADC_InClk          (adc_clock),            //  IN STD_LOGIC;
        .sRst_n             (locked),               //  IN STD_LOGIC;
        .sInitDone_n        (adc_init_done),        //  OUT STD_LOGIC;
        .FIFO_EMPTY_CHA     (adc_fifo_empty_ch1),   //  OUT STD_LOGIC;
        .FIFO_EMPTY_CHB     (adc_fifo_empty_ch2),   //  OUT STD_LOGIC;
        .sCh1Out            (adc_data_out_ch1),     //  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        .sCh2Out            (adc_data_out_ch2),     //  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        .sTestMode          (adc_test_mode),        //  IN STD_LOGIC;
        .adcClkIn_p         (syzygy_c2p_clk_p),     //  OUT STD_LOGIC;
        .adcClkIn_n         (syzygy_c2p_clk_n),     //  OUT STD_LOGIC;
        .adcSync            (syzygy_s_27),          //  OUT STD_LOGIC;
        .DcoClk             (syzygy_p2c_clk_p),     //  IN STD_LOGIC;
        .dADC_Data          (adc_data_in),          //  IN STD_LOGIC_VECTOR(13 DOWNTO 0);
        .sADC_SDIO          (syzygy_d_p_2),         //  INOUT STD_LOGIC;
        .sADC_CS            (syzygy_s_26),          //  OUT STD_LOGIC;
        .sADC_Sclk          (syzygy_d_n_2),         //  OUT STD_LOGIC;
        .sCh1CouplingH      (syzygy_d_p_0),         //  OUT STD_LOGIC;
        .sCh1CouplingL      (syzygy_d_n_0),         //  OUT STD_LOGIC;
        .sCh2CouplingH      (syzygy_d_p_1),         //  OUT STD_LOGIC;
        .sCh2CouplingL      (syzygy_d_n_1),         //  OUT STD_LOGIC;
        .sCh1GainH          (syzygy_d_p_5),         //  OUT STD_LOGIC;
        .sCh1GainL          (syzygy_d_n_5),         //  OUT STD_LOGIC;
        .sCh2GainH          (syzygy_d_p_3),         //  OUT STD_LOGIC;
        .sCh2GainL          (syzygy_d_n_3),         //  OUT STD_LOGIC;
        .sRelayComH         (syzygy_d_p_7),         //  OUT STD_LOGIC;
        .sRelayComL         (syzygy_d_n_7)          //  OUT STD_LOGIC
    );
    /* ###################################### */

endmodule
