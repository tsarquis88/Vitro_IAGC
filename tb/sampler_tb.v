`timescale 1ns / 1ns

module sampler_tb
(
);
   
    localparam      DATA_SIZE   =   8;
    
    reg                             clock;
    reg                             reset;
    wire                            next;
    reg                             gate;
    reg     [ DATA_SIZE - 1 : 0 ]   data;
    reg                             adc_init;
    wire                            valid;
    wire    [ DATA_SIZE - 1 : 0 ]   sampler_data;
    wire                            tx;
    reg                             sample;
    wire                            idle;
    
    initial begin
        clock       =   1'b0;
        reset       =   1'b1;
        adc_init    =   1'b0;
        gate        =   1'b0;
        data        =   { DATA_SIZE { 1'b0 } };
        sample      =   1'b0;
        
        #10
        reset       =   1'b0;
        
        #20
        
        adc_init    =   1'b1;
        
        #1000
        sample      =   1'b1;
        #10
        sample      =   1'b0;
    end
    
    always begin
        #5
        clock   =   ~clock;
    end
    
    always begin
        #100
        gate    =   ~gate;
    end
    
    always@( posedge clock ) begin
        data    <=  data + 1'b1;
    end
   
    sampler #
    (
        .DATA_SIZE      ( DATA_SIZE         )
    )
    u_sampler
    (
        .i_clock        ( clock             ),
        .i_reset        ( reset             ),
        .i_next         ( next              ),
        .i_data         ( data              ),
        .i_adc_init     ( adc_init          ),
        .i_gate         ( gate              ),
        .i_sample       ( sample            ),
        .i_cmd_decim    ( 1'b0              ),
        .i_cmd_param    ( 4'b0000           ),
        .o_data         ( sampler_data      ),
        .o_valid        ( valid             ),
        .o_idle         ( idle              )
    );
    
    localparam UART_TX_DATA_SIZE    = 8;
    localparam UART_TX_PRESCALE     = 16'b0000010100010110;
    
    uart_tx #
    (
        .DATA_WIDTH         ( UART_TX_DATA_SIZE     )
    )
    u_uart_tx
    (
        .clk                ( clock                 ),
        .rst                ( reset                 ),   
        .s_axis_tdata       ( sampler_data          ),
        .s_axis_tvalid      ( valid                 ),
        .s_axis_tready      ( next                  ),
        .txd                ( tx                    ),
        .busy               ( busy                  ),
        .prescale           ( UART_TX_PRESCALE      )
    );
  
endmodule
