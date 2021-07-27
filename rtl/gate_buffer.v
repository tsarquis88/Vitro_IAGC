`timescale 1ns / 1ps

module gate_buffer # 
(
    parameter   DATA_SIZE   =   14
)
(
    input   [ DATA_SIZE - 1 : 0 ]   i_data,
    input                           i_gate,
    output  [ DATA_SIZE - 1 : 0 ]   o_data
);

    reg [ DATA_SIZE - 1 : 0 ]   data;
    
    always@( * ) begin
        if( i_gate ) begin
            data    =   i_data;
        end
    end
    
    assign  o_data  =   data;
    
endmodule
