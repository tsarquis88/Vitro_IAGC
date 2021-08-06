`timescale 1ns / 1ps

module gate_buffer # 
(
    parameter   DATA_SIZE   =   14
)
(
    input                           i_clock,
    input                           i_reset,
    input                           i_next,
    input   [ DATA_SIZE - 1 : 0 ]   i_data,
    input                           i_gate,
    input                           i_adc_init,
    output  [ DATA_SIZE - 1 : 0 ]   o_data,
    output                          o_valid
);

    localparam  MEM_SIZE    =   1000;
    localparam  ADDR_SIZE   =   19;
    
    localparam  STATUS_WAIT     =   0;
    localparam  STATUS_WRITE    =   1;
    localparam  STATUS_READ     =   2;
    localparam  STATUS_HALT     =   3;
    
    reg     [ 2 - 1 : 0 ]           status;
    reg     [ 2 - 1 : 0 ]           next_status;
    wire    [ DATA_SIZE - 1 : 0 ]   data;
    wire                            write;
    wire                            read;
    reg     [ ADDR_SIZE - 1 : 0 ]   addr;
    reg                             last_i_next;
    
    always@( posedge i_clock ) begin
    
        if( i_reset || ~i_adc_init ) begin
            status      <=  STATUS_WAIT;
            addr        <=  { ADDR_SIZE { 1'b0 } };
            last_i_next <=  1'b0;
        end
        else begin
            status      <=  next_status;
            last_i_next <=  i_next;
            
            case( status )
                
                STATUS_WAIT: begin
                    addr    <=  addr;
                end
                
                STATUS_WRITE: begin
                    addr    <=  addr + 1'b1;
                    
                    if( addr == MEM_SIZE - 1 )
                        addr    <=  { ADDR_SIZE { 1'b0 } };
                end
                
                STATUS_READ: begin                    
                    if( i_next && ~last_i_next ) begin
                        addr    <=  addr + 1'b1;
                    end
                    
                    if( addr == MEM_SIZE - 1 )
                        addr    <=  { ADDR_SIZE { 1'b0 } };
                end
                
                STATUS_HALT: begin
                    addr    <=  { ADDR_SIZE { 1'b0 } };
                end
                
                default: begin
                    addr    <=  { ADDR_SIZE { 1'b0 } };
                end
                
            endcase 
        end
    end
    
    always@( * ) begin
        case( status )
        
            STATUS_WAIT: begin
                if( i_gate )
                    next_status =   STATUS_WRITE;
                else     
                    next_status =   STATUS_WAIT;
            end
            
            STATUS_WRITE: begin
                if( addr == MEM_SIZE - 1 ) begin
                    next_status =   STATUS_READ;
                end
                else begin
                    if( i_gate )
                        next_status =   STATUS_WRITE;
                    else
                        next_status =   STATUS_WAIT;
                end
            end
            
            STATUS_READ: begin
                if( addr == MEM_SIZE - 1 )
                    next_status =   STATUS_HALT;
                else
                    next_status =   STATUS_READ;
            end
            
            STATUS_HALT: begin
                next_status =   STATUS_HALT;
            end
            
            default: begin
                next_status =   STATUS_WAIT;
            end
        endcase
    end
    
    assign  write   =   status == STATUS_WRITE ? 1'b1 : 1'b0;
    assign  read    =   status == STATUS_READ  ? 1'b1 : 1'b0; 
    
    assign  o_data  =   data;
    assign  o_valid =   read;
    
    gate_memory #                      
    (
        .DATA_SIZE      ( DATA_SIZE ),
        .ADDR_SIZE      ( ADDR_SIZE ),
        .MEMORY_SIZE    ( MEM_SIZE  )
    )
    u_gate_memory
    (
        .i_clock        ( i_clock   ),
        .i_reset        ( i_reset   ),
        .i_addr         ( addr      ),
        .i_read         ( read      ),
        .i_write        ( write     ),
        .i_data         ( i_data    ),
        .o_data         ( data      )
    );         
    
endmodule
