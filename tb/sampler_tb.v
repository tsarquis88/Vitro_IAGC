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
    
    initial begin
        clock       =   1'b0;
        reset       =   1'b1;
        adc_init    =   1'b0;
        gate        =   1'b0;
        data        =   { DATA_SIZE { 1'b0 } };
        
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
        #10000
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
        .o_data         ( sampler_data      ),
        .o_valid        ( valid             )
    );
    
    tx_unit #
    (
        .TX_DATA_SIZE       ( DATA_SIZE     )
    )
    u_tx_unit_ch1
    (
        .i_clock            ( clock         ),
        .i_reset            ( reset         ),
        .i_send             ( valid         ),
        .i_txdata           ( sampler_data  ),
        .o_txready          ( next          ),
        .o_tx               ( tx            )
    );
  
endmodule
