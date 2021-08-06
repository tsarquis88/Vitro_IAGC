`timescale 1ns / 1ns

module gate_buffer_tb
(
);
   
    localparam      DATA_SIZE           =   14;
    
    reg                             clock;
    reg                             reset;
    reg                             next;
    reg                             gate;
    reg     [ DATA_SIZE - 1 : 0 ]   data;
    reg                             adc_init;
    wire                            valid;
    wire    [ DATA_SIZE - 1 : 0 ]   gatered_data;
    
    initial begin
        clock       =   1'b0;
        reset       =   1'b1;
        adc_init    =   1'b0;
        next        =   1'b0;
        gate        =   1'b0;
        data        =   { DATA_SIZE { 1'b0 } };
        
        #10
        reset       =   1'b0;
        
        #20
        
        adc_init    =   1'b1;
    end
    
    always begin
        #5
        clock   =   ~clock;
    end
    
    always begin
        #50
        next    =   ~next;
    end
    
    always begin
        #100
        gate    =   ~gate;
    end
    
    always@( posedge clock ) begin
        data    <=  data + 1'b1;
    end
   
    gate_buffer #
    (
        .DATA_SIZE      ( DATA_SIZE         )
    )
    u_gate_buffer
    (
        .i_clock        ( clock             ),
        .i_reset        ( reset             ),
        .i_next         ( next              ),
        .i_data         ( data              ),
        .i_adc_init     ( adc_init          ),
        .i_gate         ( gate              ),
        .o_data         ( gatered_data      ),
        .o_valid        ( valid             )
    );
  
endmodule
