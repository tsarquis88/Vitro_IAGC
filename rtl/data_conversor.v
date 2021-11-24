`timescale 1ns / 1ps
`default_nettype none

module data_conversor #
(
    parameter ZMOD_DATA_SIZE    = 14,
    parameter SAMPLER_DATA_SIZE = 16
)
(
    input  wire [ ZMOD_DATA_SIZE    - 1 : 0 ] i_raw_reference,
    input  wire [ ZMOD_DATA_SIZE    - 1 : 0 ] i_raw_error,
    output wire [ SAMPLER_DATA_SIZE - 1 : 0 ] o_reference,
    output wire [ SAMPLER_DATA_SIZE - 1 : 0 ] o_error
);
    
    localparam OFFSET = 16'h2000;
    
    assign o_reference = i_raw_reference > OFFSET ? i_raw_reference - OFFSET : i_raw_reference + OFFSET;
    assign o_error     = i_raw_error     > OFFSET ? i_raw_error     - OFFSET : i_raw_error     + OFFSET;
    
endmodule

`default_nettype wire

/*
    La salida del ADC1410 está en complemento a 2.
    
    La conversion que se hace en este modulo no es la conversión tipica 
    de complemeto a 2 a binario natural, Sin embargo, se hizo asi para
    que al graficar (en la PC) se vea como en el segundo grafico. 
    
    La salida de este modulo no deberia entrar en ningun modulo que requiera
    algun formato especifico, ya que no lo hay.
    
            Salida 
              ADC
       [14-bit, s/signo]
            
            16000   |                xx 
            15000   |              xx
            14000   |            xx
            13000   |          xx
            12000   |        xx
            11000   |      xx 
            10000   |    xx 
            9000    |  xx
            8000    |xx                               xx  
            7000    |                               xx
            6000    |                             xx
            5000    |                           xx
            4000    |                         xx
            3000    |                       xx
            2000    |                     xx
            1000    |                   xx
            0       |                 xx
                    |_____________________________________
                    
                    -1                0               1       Voltaje de entrada [V]
                    
                    
                    
           Salida 
          conversor
      [14-bit, s/signo]
            
            16000   |                                xx
            15000   |                              xx
            14000   |                            xx
            13000   |                          xx
            12000   |                        xx
            11000   |                      xx
            10000   |                    xx
            9000    |                  xx
            8000    |                xx  
            7000    |              xx
            6000    |            xx
            5000    |          xx
            4000    |        xx
            3000    |      xx
            2000    |    xx
            1000    |  xx
            0       |xx
                    |_____________________________________
                    
                    -1                0               1       Voltaje de entrada [V]
        
 */