`timescale 1ns / 1ps

module calibrator #
(
    parameter   CALIB_SIZE  =   18,
    parameter   CALIB_TICKS =   7500
)
(
    input                           i_clock,
    input                           i_reset,
    input                           i_toggle,
    output                          o_calib_enabled,
    output  [ CALIB_SIZE - 1 : 0 ]  o_calib_value
);
    
    integer                         calib_counter;
    reg                             calib_enabled;
    reg                             last_i_toggle;
    reg     [ CALIB_SIZE - 1 : 0 ]  calib_value;
    
    always@( posedge i_clock ) begin
        if( i_reset ) begin
            calib_counter   <= 0;
            calib_value     <= 18'b000000000000000000;
            last_i_toggle   <= 1'b0;
            calib_enabled   <= 1'b0;
        end
        else begin                
            if( calib_enabled ) begin
                calib_counter   <= calib_counter + 1;
                
                if( calib_counter == CALIB_TICKS ) begin
                    calib_counter   <= 0;
                    calib_value     <= calib_value + 1'b1; 
                end
            end
            
            if( i_toggle&& ~last_i_toggle )
                calib_enabled   <= ~calib_enabled;
            else
                calib_enabled   <= calib_enabled;
            
            last_i_toggle   <=   i_toggle;
        end
    end
    
    assign  o_calib_enabled =   calib_enabled;
    assign  o_calib_value   =   calib_value;

endmodule
