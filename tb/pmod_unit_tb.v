`timescale 1ns / 1ns

module pmod_unit_tb
(
);
    
    reg     clock;
    reg     reset;
    
    reg     adc_init;
    reg     valid;
    reg     idle;
    reg     recon;
    
    wire    led0_r;
    wire    led0_g;
    wire    led0_b;
    wire    buzzer;
    
    initial begin
        clock       =   1'b0;
        reset       =   1'b1;
        adc_init    =   1'b0;
        valid       =   1'b0;
        idle        =   1'b1;
        recon       =   1'b0;
        
        #10
        reset       =   1'b0;
        
        #20
        adc_init    =   1'b1;
        
        #20
        valid       =   1'b1;
        recon       =   1'b0;
        #20
        valid       =   1'b0;
        recon       =   1'b0;
        
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
        .i_cmd_valid        ( valid         ),
        .i_cmd_recon        ( recon         ),
        .o_led_r            ( led0_r        ),
        .o_led_g            ( led0_g        ),
        .o_led_b            ( led0_b        ),
        .o_buzzer           ( buzzer        )
    );
  
endmodule
