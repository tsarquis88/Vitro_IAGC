`timescale 1ns / 1ps

module data_conversor #
(
    parameter   CONVERSOR_DATA_SIZE =   8
)
(
    input   [ CONVERSOR_DATA_SIZE - 1 : 0 ] i_data,
    output  [ CONVERSOR_DATA_SIZE - 1 : 0 ] o_data
);
    
    localparam  OFFSET  =   16'h2000;
  
    assign  o_data  =   i_data > OFFSET ? i_data - OFFSET : i_data + OFFSET;
    
endmodule
