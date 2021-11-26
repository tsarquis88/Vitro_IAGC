`timescale 1ns / 1ns

module amplitude_detector_tb
(
);
       
    reg         clock;
    reg  [3:0]  iagc_status;
    reg         sample;
    reg  [15:0] reference;
    reg  [15:0] error;
    reg  [15:0] amplitude_count;
    
    wire [15:0] ref_amp;
    wire [15:0] err_amp;
    
    initial begin
        clock           = 1'b0;
        sample          = 1'b0;
        reference       = { 16 { 1'b0 } };
        error           = { 16 { 1'b0 } };
        amplitude_count = 32;
        iagc_status     = 4'b0000;
        
        #100
        iagc_status = 4'b0001;
        
        #100
        iagc_status = 4'b0010;
    end
    
    always begin
        #5
        clock   =   ~clock;
    end
    
    always begin
        #10
        sample  =   ~sample;
    end
    
    always@( posedge clock ) begin
        reference   <=  reference + 1'b1;
        error       <=  error     + 1'b1;
    end
   
    amplitude_detector #
    (
        .IAGC_STATUS_SIZE       ( 4                 ),
        .SAMPLER_DATA_SIZE      ( 16                ),
        .AMPLITUDE_COUNT_SIZE   ( 16                )
    )
    u_amplitude_detector
    (
        .i_clock                ( clock             ),
        .i_sample               ( sample            ),
        .i_iagc_status          ( iagc_status       ),
        .i_reference            ( reference         ),
        .i_error                ( error             ),
        .i_amplitude_count      ( amplitude_count   ),
        .o_reference_amplitude  ( ref_amp           ),
        .o_error_amplitude      ( err_amp           )
    );
    
endmodule