`timescale 1ns / 1ns

module pmod_unit_tb
(
);
    
    reg     clock;
    reg     reset;
    
    reg     adc_init;
    reg     wait_cmd;
    reg     idle;
    reg     error;
    reg     succes;
    
    wire    led0_r;
    wire    led0_g;
    wire    led0_b;
    wire    led1_r;
    wire    led1_g;
    wire    led1_b;
    
    initial begin
        clock       =   1'b0;
        reset       =   1'b1;
        adc_init    =   1'b0;
        wait_cmd    =   1'b0;
        idle        =   1'b1;
        error       =   1'b0;
        succes      =   1'b0;
        
        #10
        reset       =   1'b0;
        
        #20
        adc_init    =   1'b1;
        
        #100
        error       =   1'b1;
        #15
        error       =   1'b0;
        
        #30
        succes      =   1'b1;
        #10
        succes      =   1'b0;
        
        #500
        succes      =   1'b1;
        #20
        succes      =   1'b0;
        
        #50000
        succes      =   1'b1;
        #20
        succes      =   1'b0;
        
    end
    
    always begin
        #5
        clock   =   ~clock;
    end
        
    pmod_unit
    u_pmod_unit
    (
        .i_clock            ( clock         ),
        .i_reset            ( reset         ),
        .i_init_done        ( adc_init      ),
        .i_idle             ( idle          ),
        .i_wait_cmd         ( wait_cmd      ),
        .i_error            ( error         ),
        .i_succes           ( succes        ),
        .o_led0_r           ( led0_r        ),
        .o_led0_g           ( led0_g        ),
        .o_led0_b           ( led0_b        ),
        .o_led1_r           ( led1_r        ),
        .o_led1_g           ( led1_g        ),
        .o_led1_b           ( led1_b        )
    );
  
endmodule
