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
    input  wire                         i_cmd_decim,
    input  wire [ DATA_SIZE - 1 : 0 ]   i_cmd_param,  
    output wire [ DATA_SIZE - 1 : 0 ]   o_data,
    output wire                         o_valid,
    output wire                         o_idle
);

    localparam DECIMATE_DEFAULT =   4;    
    localparam MEM_SIZE         =   1024;
    localparam ADDR_SIZE        =   12;
    localparam STATUS_SIZE      =   3;
    
    localparam STATUS_INIT      =   0;
    localparam STATUS_WAIT      =   1;
    localparam STATUS_WRITE     =   2;
    localparam STATUS_FETCH     =   3;
    localparam STATUS_READ      =   4;
    localparam STATUS_HOLD      =   5;
    
    reg     [ STATUS_SIZE   - 1 : 0 ]   status;
    reg     [ STATUS_SIZE   - 1 : 0 ]   next_status;
    reg                                 write;
    wire                                read;
    reg     [ ADDR_SIZE     - 1 : 0 ]   addr;
    reg                                 valid;
    wire    [ DATA_SIZE     - 1 : 0 ]   data_mem;
    reg     [ DATA_SIZE     - 1 : 0 ]   decimate_order;
    
    integer                         samples_count;
    integer                         gates_count;
    integer                         hold_count;
    integer                         read_count;
    
    reg                             first_fetch;
    reg                             first_write;
    
    reg                             last_i_next;
    reg                             last_i_sample;
    reg                             last_i_gate;
    wire                            posedge_i_next;
    wire                            posedge_i_gate;
    
    always@( posedge i_clock ) begin
    
        if( i_reset || ~i_adc_init ) begin
            
            status          <= STATUS_INIT;
            decimate_order  <= DECIMATE_DEFAULT;
            
        end
        else begin
        
            status          <= next_status;
            last_i_next     <= i_next;
            last_i_sample   <= i_sample;
            last_i_gate     <= i_gate;
            
            case( status )
                
                STATUS_INIT: begin
                    addr            <= { ADDR_SIZE { 1'b0 } };
                    first_fetch     <= 1'b1;
                    first_write     <= 1'b1;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= 0;
                    hold_count      <= 0;
                    read_count      <= 0;
                    valid           <= 1'b0;
                    decimate_order  <= i_cmd_decim ? i_cmd_param : decimate_order;
                end
                
                STATUS_WAIT: begin
                    addr            <= addr;
                    first_fetch     <= 1'b1;
                    first_write     <= first_write;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= posedge_i_gate ? gates_count + 1 : gates_count;
                    hold_count      <= 0;
                    read_count      <= 0;
                    valid           <= 1'b0;
                    decimate_order  <= decimate_order;
                end
                
                STATUS_WRITE: begin
                    if( samples_count == decimate_order - 1 )
                        addr        <= first_write ? { ADDR_SIZE { 1'b0 } } : addr + 1'b1;
                    else
                        addr        <= addr;
                        
                    first_write     <= samples_count == decimate_order - 1 ? 1'b0 : first_write; 
                    first_fetch     <= 1'b1;
                    write           <= samples_count == decimate_order - 1 ? 1'b1 : 1'b0;
                    samples_count   <= samples_count == decimate_order - 1 ? 0 : samples_count + 1;
                    gates_count     <= gates_count;
                    hold_count      <= 0;
                    read_count      <= 0;
                    valid           <= 1'b0;
                    decimate_order  <= decimate_order;
                end
                
                STATUS_FETCH: begin
                    addr            <= first_fetch? { ADDR_SIZE { 1'b0 } } : addr + 1'b1;
                    first_fetch     <= 1'b0;             
                    first_write     <= first_write;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= 0;
                    hold_count      <= 0;
                    read_count      <= 0;
                    valid           <= 1'b0;
                    decimate_order  <= decimate_order;
                end
                
                STATUS_READ: begin
                    addr            <= addr;
                    first_fetch     <= 1'b0;                    
                    first_write     <= first_write;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= 0;
                    hold_count      <= 0;
                    read_count      <= read_count + 1;
                    valid           <= 1'b0;
                    decimate_order  <= decimate_order;
                end
                
                STATUS_HOLD: begin
                    valid           <= hold_count > 0 && hold_count < 5 ? 1'b1 : 1'b0;
                    addr            <= addr;
                    first_fetch     <= 1'b0;
                    first_write     <= first_write;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= 0;
                    read_count      <= 0;
                    hold_count      <= hold_count + 1;
                    decimate_order  <= decimate_order;
                end
                
                default: begin
                    addr            <= addr;
                    first_fetch     <= 1'b0;
                    first_write     <= first_write;
                    write           <= 1'b0;
                    samples_count   <= 0;
                    gates_count     <= 0;
                    hold_count      <= 0;
                    read_count      <= 0;
                    decimate_order  <= decimate_order;
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
                next_status = posedge_i_gate ? STATUS_WRITE : STATUS_WAIT;
            end
            
            STATUS_WRITE: begin
                if( addr == MEM_SIZE - 1 )
                    next_status = STATUS_FETCH;
                else
                    next_status = i_gate ? STATUS_WRITE : STATUS_WAIT;
            end
            
            STATUS_FETCH: begin
                next_status = STATUS_READ;
            end
            
            STATUS_READ: begin
                next_status = read_count > 5 ? STATUS_HOLD : STATUS_READ;
            end
            
             STATUS_HOLD: begin
                if( addr == MEM_SIZE - 1 )
                    next_status = STATUS_INIT;
                else
                    next_status = posedge_i_next ? STATUS_FETCH : STATUS_HOLD;    
            end
            
            default: begin
                next_status =   STATUS_INIT;
            end
        endcase
    end
    
    assign  posedge_i_next      = i_next && ~last_i_next ? 1'b1 : 1'b0;
    assign  posedge_i_gate      = i_gate && ~last_i_gate ? 1'b1 : 1'b0;
    assign  read                = status == STATUS_READ  ? 1'b1 : 1'b0;
    assign  o_idle              = status == STATUS_INIT ? 1'b1 : 1'b0;
    assign  o_valid             = valid;
    assign  o_data              = data_mem;
    
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
        .o_data         ( data_mem  )
    );         
    
endmodule

`default_nettype wire
