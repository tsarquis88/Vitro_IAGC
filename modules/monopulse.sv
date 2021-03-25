`timescale 1ns / 1ps

module monopulse #
(
    parameter DATA_SIZE     =   64
)
(
    input   i_reset,
    input   i_clock,
    input   [ DATA_SIZE - 1 : 0 ]   i_reference,
    input   [ DATA_SIZE - 1 : 0 ]   i_error,
    output  [ DATA_SIZE - 1 : 0 ]   o_relation
);

    reg [ DATA_SIZE - 1 : 0 ]   abs_reference;
    reg [ DATA_SIZE - 1 : 0 ]   abs_error;
    reg [ DATA_SIZE - 1 : 0 ]   relation;
    
    always@( posedge i_clock )
    begin
    
        if( i_reset )
        begin
            abs_reference   <=   { DATA_SIZE { 1'b0 } };
            abs_error       <=   { DATA_SIZE { 1'b0 } };
            relation        <=   { DATA_SIZE { 1'b0 } };
        end
        
        else
        begin
        
            if( i_reference[ DATA_SIZE - 1 ] == 1'b1 ) 
            begin
                abs_reference   <=  -i_reference;
            end
            else 
            begin
                abs_reference   <=  i_reference;
            end
            
            if( i_error[ DATA_SIZE - 1 ] == 1'b1 ) 
            begin
                abs_error       <=  -i_error;
            end
            else 
            begin
                abs_error       <=  i_error;
            end
            
            relation    <=  abs_error   *   abs_reference;
            
        end
    end
    
    assign o_relation   =   relation;

endmodule
