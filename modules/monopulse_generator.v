`timescale 1ns / 1ps

module monopulse_simulator #
(
    parameter DATA_SIZE     =   16,
    parameter DATA_DEPTH    =   7514,
    parameter ADDR_MODULE   =   13
)
(
    input i_clock,
    input i_reset,
    output [ DATA_SIZE - 1 : 0 ]    o_reference,
    output [ DATA_SIZE - 1 : 0 ]    o_error
);
    
    reg                             ena;
    reg                             wea;
    reg     [ ADDR_MODULE - 1 : 0 ] addra;
    reg     [ DATA_SIZE - 1 : 0 ]   dina;
    
    always@( posedge i_clock ) begin
        if( i_reset ) begin
            addra       <=  { ADDR_MODULE { 1'b0 } };
            dina        <=  { ADDR_MODULE { 1'b0 } };
            ena         <=  1'b1;
            wea         <=  1'b0;
        end
        else begin
            addra   <=  addra + 1'b1;
            if( addra   >=  DATA_DEPTH )
                addra   <=  { ADDR_MODULE { 1'b0 } };
        end
    end
    
    blk_mem_gen_0
    u_blk_mem_gen_0
    (
        .clka       (i_clock),
        .ena        (ena),
        .wea        (wea),
        .addra      (addra),
        .dina       (dina),
        .douta      (o_reference)
    );
    
    blk_mem_gen_1
    u_blk_mem_gen_1
    (
        .clka       (i_clock),
        .ena        (ena),
        .wea        (wea),
        .addra      (addra),
        .dina       (dina),
        .douta      (o_error)
    );

endmodule
