`timescale 1ns / 1ns

module sampler_tb
(
);
       
    reg         clock;
    reg  [3:0]  iagc_status;
    reg         gate;
    reg  [15:0] data;
    wire [15:0] sample;
    wire [11:0] addr;
    wire        idle;
    
    
    initial begin
        clock       = 1'b0;
        gate        = 1'b0;
        data        = { 12 { 1'b0 } };
        iagc_status = 4'b0000;
        
        #100
        iagc_status = 4'b0001;
        
        #100
        iagc_status = 4'b0011;
        
        #100
        iagc_status = 4'b0001;
    end
    
    always begin
        #5
        clock   =   ~clock;
    end
    
    always begin
        #300
        gate    =   ~gate;
    end
    
    always@( posedge clock ) begin
        data    <=  data + 1'b1;
    end
   
    sampler
    u_sampler
    (
        .i_clock            ( clock             ),
        .i_iagc_status      ( iagc_status       ),
        .i_data             ( data              ),
        .i_gate             ( gate              ),
        .o_data             ( sample            ),
        .o_addr             ( addr              ),
        .o_idle             ( idle              )
    );
    
endmodule