`timescale 1ns / 1ps
`default_nettype none

module sampler # 
(
    parameter   DATA_SIZE   =   8
)
(
    input  wire                         i_clock,
    input  wire                         i_reset,
    input  wire                         i_next,
    input  wire [ DATA_SIZE - 1 : 0 ]   i_data,
    input  wire                         i_gate,
    input  wire                         i_sample,
    input  wire                         i_adc_init,
    output wire [ DATA_SIZE - 1 : 0 ]   o_data,
    output wire                         o_valid,
    output wire                         o_idle
);

    localparam  MEM_SIZE        =   2048;
    localparam  ADDR_SIZE       =   12;
    localparam  STATUS_SIZE     =   3;
    localparam  DECIMATE_ORDER  =   8;
    
    localparam  STATUS_INIT     =   0;
    localparam  STATUS_WAIT     =   1;
    localparam  STATUS_WRITE    =   2;
    localparam  STATUS_READ     =   3;
    localparam  STATUS_HOLD     =   4;
    
    reg     [ STATUS_SIZE - 1 : 0 ] status;
    reg     [ STATUS_SIZE - 1 : 0 ] next_status;
    reg                             write;
    wire                            read;
    reg     [ ADDR_SIZE - 1 : 0 ]   addr;
    
    integer                         samples_count;
    integer                         gates_count;
    
    reg                             first_read;
    reg                             first_write;
    
    reg                             last_i_next;
    reg                             last_i_sample;
    reg                             last_i_gate;
    wire                            posedge_i_next;
    wire                            posedge_i_sample;
    wire                            posedge_i_gate;
    
    always@( posedge i_clock ) begin
    
        if( i_reset || ~i_adc_init ) begin
            
            status  <= STATUS_INIT;
            
        end
        else begin
        
            status          <= next_status;
            last_i_next     <= i_next;
            last_i_sample   <= i_sample;
            last_i_gate     <= i_gate;
            
            case( status )
                
                STATUS_INIT: begin
                    addr            <= { ADDR_SIZE { 1'b0 } };
                    first_read      <= 1'b1;
                    first_write     <= 1'b1;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= 0;
                end
                
                STATUS_WAIT: begin
                    addr            <= addr;
                    first_read      <= first_read;
                    first_write     <= first_write;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= posedge_i_gate ? gates_count + 1 : gates_count;
                end
                
                STATUS_WRITE: begin
                    if( samples_count == DECIMATE_ORDER - 1 )
                        addr        <= first_write ? { ADDR_SIZE { 1'b0 } } : addr + 1'b1;
                    else
                        addr        <= addr;
                        
                    first_write     <= samples_count == DECIMATE_ORDER - 1 ? 1'b0 : first_write; 
                    first_read      <= first_read;
                    write           <= samples_count == DECIMATE_ORDER - 1 ? 1'b1 : 1'b0;
                    samples_count   <= samples_count == DECIMATE_ORDER - 1 ? 0 : samples_count + 1;
                    gates_count     <= gates_count;
                end
                
                STATUS_READ: begin
                    addr            <= first_read ? { ADDR_SIZE { 1'b0 } } : addr + 1'b1;
                    first_read      <= 1'b0;
                    first_write     <= first_write;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= 0;
                end
                
                STATUS_HOLD: begin
                    addr            <= addr;
                    first_read      <= first_read;
                    first_write     <= first_write;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= 0;
                end
                
                default: begin
                    addr            <= addr;
                    first_read      <= first_read;
                    first_write     <= first_write;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= 0;
                end
                
            endcase 
        end
    end
    
    always@( * ) begin
        case( status )
        
            STATUS_INIT: begin
                next_status = i_sample ? STATUS_WAIT : STATUS_INIT;
            end
        
            STATUS_WAIT: begin
                next_status = i_gate ? STATUS_WRITE : STATUS_WAIT;
            end
            
            STATUS_WRITE: begin
                if( addr == MEM_SIZE - 1 )
                    next_status = STATUS_READ;
                else
                    next_status = i_gate ? STATUS_WRITE : STATUS_WAIT;
            end
            
            STATUS_READ: begin
                next_status = STATUS_HOLD;
            end
            
             STATUS_HOLD: begin
                if( addr == MEM_SIZE - 1 )
                    next_status = STATUS_INIT;
                else
                    next_status = i_next && ~last_i_next ? STATUS_READ : STATUS_HOLD;    
            end
            
            default: begin
                next_status =   STATUS_INIT;
            end
        endcase
    end
    
    assign  posedge_i_next      = i_next && ~last_i_next ? 1'b1 : 1'b0;
    assign  posedge_i_sample    = i_sample && ~last_i_sample ? 1'b1 : 1'b0;
    assign  posedge_i_gate      = i_gate && ~last_i_gate ? 1'b1 : 1'b0;
    assign  read                = status == STATUS_READ  ? 1'b1 : 1'b0;
    assign  o_idle              = status == STATUS_INIT ? 1'b1 : 1'b0;
    assign  o_valid             = status == STATUS_HOLD ? 1'b1 : 1'b0;
    
    memory #                      
    (
        .DATA_SIZE      ( DATA_SIZE ),
        .ADDR_SIZE      ( ADDR_SIZE ),
        .MEMORY_SIZE    ( MEM_SIZE  )
    )
    u_memory
    (
        .i_clock        ( i_clock   ),
        .i_reset        ( i_reset   ),
        .i_addr         ( addr      ),
        .i_read         ( read      ),
        .i_write        ( write     ),
        .i_data         ( i_data    ),
        .o_data         ( o_data    )
    );         
    
endmodule

`default_nettype wire
