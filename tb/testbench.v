`timescale 1ns / 1ns

module testbench
(
);

    localparam      SYS_CLOCK_PERIOD    =   8;
    localparam      DCO_CLOCK_PERIOD    =   10;   
    
    reg         clock;
    reg         reset;
    reg [13:0]  adc_data;
    
    wire    tx;
    wire    led0_g;
    wire    led0_r;
    wire    adc_sdio;
    reg     adc_dco_clock_p;
    wire    adc_dco_clock_n;
    wire    adc_sclk;
    wire    adc_clock_in_n;
    wire    adc_clock_in_p;
    wire    adc_ch1_coupling_h;
    wire    adc_ch1_coupling_l;
    wire    adc_ch2_coupling_h;
    wire    adc_ch2_coupling_l;
    wire    adc_ch2_gain_h;
    wire    adc_ch2_gain_l;
    wire    adc_ch1_gain_l;
    wire    adc_ch1_gain_h;
    wire    adc_relay_com_l;
    wire    adc_relay_com_h;
    wire    adc_cs;
    wire    adc_sync;
    
    initial begin
        clock           =   1'b0;
        adc_dco_clock_p =   1'b0;
        adc_data        =   14'b00000000000000;
                
        #10
        reset       =   1'b1;
        
        #50
        reset       =   1'b0;
    end
    
    always begin
        #( SYS_CLOCK_PERIOD / 2 )
        clock           =   ~clock;
    end
    
    always begin
        #( DCO_CLOCK_PERIOD / 2 )
        adc_dco_clock_p =   ~adc_dco_clock_p;
    end
    
    always@( posedge adc_dco_clock_p ) begin
        adc_data        =   adc_data + 1'b1;
    end
    
    always@( posedge led0_g ) begin
        $display( "INIT DONE" );
    end
    
    top
    u_top
    (
        .i_reset                (reset),
        .i_clock                (clock),
        .o_tx                   (tx),
        .o_led0_g               (led0_g),        
        .o_led0_r               (led0_r),
        .i_adc_data_0           (adc_data[0]),
        .i_adc_data_1           (adc_data[1]),
        .i_adc_data_2           (adc_data[2]),
        .i_adc_data_3           (adc_data[3]),
        .i_adc_data_4           (adc_data[4]),
        .i_adc_data_5           (adc_data[5]),
        .i_adc_data_6           (adc_data[6]),
        .i_adc_data_7           (adc_data[7]),
        .i_adc_data_8           (adc_data[8]),
        .i_adc_data_9           (adc_data[9]),
        .i_adc_data_10          (adc_data[10]),
        .i_adc_data_11          (adc_data[11]),
        .i_adc_data_12          (adc_data[12]),
        .i_adc_data_13          (adc_data[13]),
        .io_adc_sdio            (adc_sdio),   
        .i_adc_dco_clock_p      (adc_dco_clock_p),
        .o_adc_dco_clock_n      (adc_dco_clock_n),
        .o_adc_sclk             (adc_sclk),
        .o_adc_clock_in_n       (adc_clock_in_n),
        .o_adc_clock_in_p       (adc_clock_in_p),
        .o_ch1_coupling_h       (adc_ch1_coupling_h),
        .o_ch1_coupling_l       (adc_ch1_coupling_l),
        .o_ch2_coupling_h       (adc_ch2_coupling_h),
        .o_ch2_coupling_l       (adc_ch2_coupling_l),
        .o_ch2_gain_h           (adc_ch2_gain_h),
        .o_ch2_gain_l           (adc_ch2_gain_l),
        .o_ch1_gain_l           (adc_ch1_gain_l),  
        .o_ch1_gain_h           (adc_ch1_gain_h),
        .o_adc_relay_com_l      (adc_relay_com_l),
        .o_adc_relay_com_h      (adc_relay_com_h),
        .o_adc_cs               (adc_cs),
        .o_adc_sync             (adc_sync)
    );       
  
endmodule
