`timescale 1ns / 1ps
`default_nettype none

module pmod_unit #
(
    parameter IAGC_STATUS_SIZE  =   4
)
(
    input  wire                                 i_clock,
    input  wire                                 i_reset,
    input  wire [ IAGC_STATUS_SIZE - 1 : 0 ]    i_iagc_status,
    output wire                                 o_led0_r,
    output wire                                 o_led0_g,
    output wire                                 o_led0_b,
    output wire                                 o_led1_r,
    output wire                                 o_led1_g,
    output wire                                 o_led1_b
);

    localparam IAGC_STATUS_RESET        = 4'b0000;
    localparam IAGC_STATUS_INIT         = 4'b0001;
    localparam IAGC_STATUS_IDLE         = 4'b0010;
    localparam IAGC_STATUS_SAMPLE       = 4'b0011;
    localparam IAGC_STATUS_CMD_PARSE    = 4'b0100;
    localparam IAGC_STATUS_CMD_READ     = 4'b0101;
    localparam IAGC_STATUS_CMD_ERROR    = 4'b0110;
    localparam IAGC_STATUS_DUMP_MEM     = 4'b0111;
    
    localparam  LED_PWM_TICKS       =   50;
    localparam  SEC_TICKS           =   100000000;

    reg         led_pwm;
    integer     led_pwm_counter;
    
    reg         led0_g;
    reg         led0_b;
    reg         led0_r;
    reg         led1_g;
    reg         led1_b;
    reg         led1_r;
    
    integer     sec_counter;
    
    /* PWM generation */
    always@( posedge i_clock ) begin
        if( i_reset ) begin
            led_pwm_counter <= 0;
        end
        else begin
            if( led_pwm_counter == LED_PWM_TICKS ) begin
                led_pwm         <= 1'b1;
                led_pwm_counter <= 0;
            end
            else begin
                led_pwm         <= 1'b0;
                led_pwm_counter <= led_pwm_counter + 1;
            end   
        end
    end 
    
    always@( posedge i_clock ) begin
        if( i_reset ) begin
            sec_counter <= 0;
        end
        else begin
            if( sec_counter == 0 ) begin
                sec_counter <= i_iagc_status == IAGC_STATUS_CMD_ERROR ? 1 : 0;
            end
            else begin    
                sec_counter <= sec_counter >= SEC_TICKS ? 0 : sec_counter + 1;
            end
        end
    end
        
    always@( * ) begin
        
        case( i_iagc_status ) 
            
            IAGC_STATUS_INIT: begin
                led0_r  = led_pwm;
                led0_g  = 1'b0;
                led0_b  = 1'b0;
                
                led1_r  = 1'b0;
                led1_g  = 1'b0;
                led1_b  = 1'b0;
            end
            
            IAGC_STATUS_IDLE: begin
                led0_r  = 1'b0;
                led0_g  = led_pwm;
                led0_b  = 1'b0;
                
                led1_r  = sec_counter > 0 ? led_pwm : 1'b0;
                led1_g  = 1'b0;
                led1_b  = 1'b0;
            end
            
            IAGC_STATUS_SAMPLE: begin
                led0_r  = 1'b0;
                led0_g  = 1'b0;
                led0_b  = led_pwm;
                
                led1_r  = 1'b0;
                led1_g  = 1'b0;
                led1_b  = 1'b0;
            end
            
            IAGC_STATUS_DUMP_MEM: begin
                led0_r  = led_pwm;
                led0_g  = led_pwm;
                led0_b  = 1'b0;
                
                led1_r  = 1'b0;
                led1_g  = 1'b0;
                led1_b  = 1'b0;
            end
            
            default: begin
                led0_r  = 1'b0;
                led0_g  = 1'b0;
                led0_b  = 1'b0;
                
                led1_r  = 1'b0;
                led1_g  = 1'b0;
                led1_b  = 1'b0;
            end
        
        endcase 
    end
    
    assign  o_led0_r    = led0_r;
    assign  o_led0_g    = led0_g;
    assign  o_led0_b    = led0_b;
    assign  o_led1_r    = led1_r;
    assign  o_led1_g    = led1_g;
    assign  o_led1_b    = led1_b;
    
endmodule

`default_nettype wire
