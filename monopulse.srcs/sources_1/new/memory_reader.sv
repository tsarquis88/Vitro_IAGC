`timescale 1ns / 1ps

module memory_reader #
(
    parameter DATA_SIZE     =   64,
    parameter DATA_DEPTH    =   20,
    parameter ADDR_MODULE   =   10
)
(
    input i_clock,
    input i_reset,
    output [ DATA_SIZE - 1 : 0 ] o_reference,
    output [ DATA_SIZE - 1 : 0 ] o_error
);
    
    reg                             ena;
    reg                             wea;
    reg     [ ADDR_MODULE - 1 : 0 ] addra;
    
    always@( posedge i_reset )
    begin
        addra   =   { ADDR_MODULE { 1'b0 } };
        ena     =   1'b1;
        wea     =   1'b0;
    end
    
    always@( posedge i_clock )
    begin
        addra   <=  addra + 1'b1;
        
        if( addra   >=  DATA_DEPTH )
        begin
            addra   <=  { ADDR_MODULE { 1'b0 } };;
        end
    end
    
    blk_mem_gen_0
    u_blk_mem_gen_0
    (
        .clka       (i_clock),
        .ena        (ena),
        .wea        (wea),
        .addra      (addra),
        .dina       (),
        .douta      (o_reference)
    );
    
    blk_mem_gen_1
    u_blk_mem_gen_1
    (
        .clka       (i_clock),
        .ena        (ena),
        .wea        (wea),
        .addra      (addra),
        .dina       (),
        .douta      (o_error)
    );

endmodule
