`timescale 1ns / 1ps

module testbench
(
);

    localparam      CLOCK_PERIOD    =   8;
    
    reg         clock;
    reg         dco;
    reg         reset;
    reg [13:0]  data;
    
    initial begin
        clock       =   1'b0;
        dco         =   1'b0;
        data        =   13'b00000000000000;
                
        #10
        reset       =   1'b1;
        
        #50
        reset       =   1'b0;
    end
    
    always begin
        #( CLOCK_PERIOD / 2 )
        clock       =   ~clock;
    end
    
    always begin
        #( CLOCK_PERIOD * 2 )
        dco         =   ~dco;
    end
    
    always begin
        #( CLOCK_PERIOD * 4 )
        data        =   data + 1'b1;;
    end
    
    top
    u_top
    (
        .i_reset            (reset),
        .i_clock            (clock),
        .syzygy_s_24        (data[0 ]),
        .syzygy_s_22        (data[1 ]),
        .syzygy_d_n_4       (data[2 ]),
        .syzygy_d_p_6       (data[3 ]),
        .syzygy_d_n_6       (data[4 ]),
        .syzygy_s_16        (data[5 ]),
        .syzygy_s_18        (data[6 ]),
        .syzygy_s_20        (data[7 ]),
        .syzygy_s_17        (data[8 ]),
        .syzygy_d_p_4       (data[9 ]),
        .syzygy_s_19        (data[10]),
        .syzygy_s_21        (data[11]),
        .syzygy_s_23        (data[12]),
        .syzygy_s_25        (data[13]),
        .syzygy_p2c_clk_p   (dco)
    );
  
endmodule
