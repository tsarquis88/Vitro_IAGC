`timescale 1ns / 1ns

module gate_buffer_tb
(
);
   
    localparam      IN_DATA_SIZE    =   14;
    localparam      OUT_DATA_SIZE   =   8;
    
    reg                                 clock;
    reg                                 reset;
    wire                                next;
    reg                                 gate;
    reg     [ IN_DATA_SIZE - 1 : 0 ]    data;
    reg                                 adc_init;
    wire                                valid;
    wire    [ OUT_DATA_SIZE - 1 : 0 ]   gatered_data;
    wire                                tx;
    
    initial begin
        clock       =   1'b0;
        reset       =   1'b1;
        adc_init    =   1'b0;
        gate        =   1'b0;
        data        =   { IN_DATA_SIZE { 1'b0 } };
        
        #10
        reset       =   1'b0;
        
        #20
        
        adc_init    =   1'b1;
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
   
    gate_buffer #
    (
        .IN_DATA_SIZE      ( IN_DATA_SIZE         ),
        .OUT_DATA_SIZE      ( OUT_DATA_SIZE         )
    )
    u_gate_buffer
    (
        .i_clock        ( clock             ),
        .i_reset        ( reset             ),
        .i_next         ( next              ),
        .i_data         ( data              ),
        .i_adc_init     ( adc_init          ),
        .i_gate         ( gate              ),
        .o_data         ( gatered_data      ),
        .o_valid        ( valid             )
    );
    
    tx_unit #
    (
        .TX_DATA_SIZE       ( OUT_DATA_SIZE             )
    )
    u_tx_unit_ch1
    (
        .i_clock            ( clock                     ),
        .i_reset            ( reset                     ),
        .i_send             ( valid                     ),
        .i_txdata           ( gatered_data              ),
        .o_txready          ( next                      ),
        .o_tx               ( tx                        )
    );
  
endmodule
