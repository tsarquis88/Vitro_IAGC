`timescale 1ns / 1ns

module gate_buffer_tb
(
);
   
    localparam      DATA_SIZE           =   14;
    
    reg                             gate;
    reg     [ DATA_SIZE - 1 : 0 ]   data;
    wire    [ DATA_SIZE - 1 : 0 ]   gatered_data;
    
    initial begin
                
        #10
        gate        =   1'b1;
        data        =   4000;
        
        #10
        gate        =   1'b0;
        data        =   1111;
        
        #10
        data        =   16'h2000;
        
        #10
        gate        =   1'b1;
        
        #10
        data        =   9999;
    end
   
    gate_buffer #
    (
        .DATA_SIZE      (DATA_SIZE)
    )
    u_gate_buffer
    (
        .i_data         (data),
        .i_gate         (gate),
        .o_data         (gatered_data)
    );  
  
endmodule
