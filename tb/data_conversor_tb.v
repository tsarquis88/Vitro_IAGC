`timescale 1ns / 1ns

module adc_data_conversor_tb
(
);

    localparam      SYS_CLOCK_PERIOD    =   10;   
    
    reg         clock;
    reg         reset;
    
    initial begin
        clock       =   1'b0;
                
        #10
        reset       =   1'b1;
        
        #50
        reset       =   1'b0;  
        
        #10
        data        =   16'h0000;
        
        #10
        data        =   16'hffff;
        
        #10
        data        =   16'h2000;
    end
    
    always begin
        #( SYS_CLOCK_PERIOD / 2 )
        clock           =   ~clock;
    end
    
    /*
    always@( posedge clock ) begin
        data    <=   data + 1'b1;
    end
    */
    
    /* ########################################################### */
    /* DATA CONVERSORS ############################################ */
    
    localparam  CONVERSOR_DATA_SIZE =   14;
    
    wire    [ CONVERSOR_DATA_SIZE - 1 : 0 ] data_converted;
    reg     [ CONVERSOR_DATA_SIZE - 1 : 0 ] data;
    
    data_conversor #
    (
        .CONVERSOR_DATA_SIZE    (CONVERSOR_DATA_SIZE)
    )
    u_data_conversor_ch1
    (
        .i_data                 (data),
        .o_data                 (data_converted)
    );   
  
endmodule
