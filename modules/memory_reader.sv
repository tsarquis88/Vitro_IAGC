`timescale 1ns / 1ps

module memory_reader #
(
    parameter DATA_SIZE     =   10,
    parameter DATA_DEPTH    =   7514,
    parameter ADDR_MODULE   =   13
)
(
    input i_clock,
    input i_reset,
    input i_next,
    output [ DATA_SIZE - 1 : 0 ]    o_reference,
    output [ DATA_SIZE - 1 : 0 ]    o_error
);
    
    reg                             last_next;
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
            last_next   <=  1'b0;
        end
        else begin
            if( last_next == 1'b0 && i_next == 1'b1 ) begin
                addra   <=  addra + 1'b1;
                
                if( addra   >=  DATA_DEPTH ) begin
                    addra   <=  { ADDR_MODULE { 1'b0 } };
                end
            end
            
            last_next   <=  i_next;
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
