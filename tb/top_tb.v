`timescale 1ns / 1ns

module top_tb
(
);

    localparam      SYS_CLOCK_PERIOD    =   8;
    localparam      DCO_CLOCK_PERIOD    =   2.5;
    localparam      ADC_DATA_IN_SIZE    =   14;
    
    reg                                 clock;
    reg                                 dco;
    reg                                 reset;
    reg                                 gate;
    reg   [ ADC_DATA_IN_SIZE - 1 : 0 ]  data_in;
    
    initial begin        
        clock       =   1'b0;
        dco         =   1'b0;
        gate        =   1'b1;
                
        #10
        reset       =   1'b1;
        
        #50
        reset       =   1'b0;
    end
    
    always begin
        #( SYS_CLOCK_PERIOD / 2 )
        clock   =   ~clock;
    end
    
    always begin
        #( DCO_CLOCK_PERIOD / 2 )
        dco     =   ~dco;
    end
    
    always@( posedge clock ) begin
        if( reset )
            data_in <=  { ADC_DATA_IN_SIZE { 1'b0 } };
        else
            data_in <=  data_in + 1'b1;
    end
    
    top
    u_top
    (
        .i_clock            ( clock             ),
        .i_reset            ( reset             ),
            
        .o_led0_g           ( led0_g            ),
        .o_led0_r           ( led0_r            ),
        .o_led0_b           ( led0_b            ),
        
        .o_tx_ch1_l         ( tx_ch1_l          ),
        .o_tx_ch1_h         ( tx_ch1_h          ),
        
        .i_gate             ( gate              ),   
        
        .i_adc_data_0       ( data_in[ 0  ]     ),
        .i_adc_data_1       ( data_in[ 1  ]     ),
        .i_adc_data_2       ( data_in[ 2  ]     ),
        .i_adc_data_3       ( data_in[ 3  ]     ),
        .i_adc_data_4       ( data_in[ 4  ]     ),
        .i_adc_data_5       ( data_in[ 5  ]     ),
        .i_adc_data_6       ( data_in[ 6  ]     ),
        .i_adc_data_7       ( data_in[ 7  ]     ),
        .i_adc_data_8       ( data_in[ 8  ]     ),
        .i_adc_data_9       ( data_in[ 9  ]     ),
        .i_adc_data_10      ( data_in[ 10 ]     ),
        .i_adc_data_11      ( data_in[ 11 ]     ),
        .i_adc_data_12      ( data_in[ 12 ]     ),
        .i_adc_data_13      ( data_in[ 13 ]     ),
        .io_adc_sdio        ( adc_sdio          ),
        .i_adc_dco_clock_p  ( dco               ),
        .o_adc_dco_clock_n  ( adc_dco_clock_n   ),
        .o_adc_sclk         ( adc_sclk          ),
        .o_adc_clock_in_n   ( adc_clock_in_n    ),
        .o_adc_clock_in_p   ( adc_clock_in_p    ),
        .o_ch1_coupling_h   ( ch1_coupling_h    ),
        .o_ch1_coupling_l   ( ch1_coupling_l    ),
        .o_ch2_coupling_h   ( ch2_coupling_h    ),
        .o_ch2_coupling_l   ( ch2_coupling_l    ),
        .o_ch2_gain_h       ( ch2_gain_h        ),
        .o_ch2_gain_l       ( ch2_gain_l        ),
        .o_ch1_gain_l       ( ch1_gain_l        ),
        .o_ch1_gain_h       ( ch1_gain_h        ),
        .o_adc_relay_com_l  ( adc_relay_com_l   ),
        .o_adc_relay_com_h  ( adc_relay_com_h   ),
        .o_adc_cs           ( adc_cs            ),
        .o_adc_sync         ( adc_sync          )       
    );
  
endmodule
