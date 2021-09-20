`timescale 1ns / 1ps
`default_nettype none

module led_unit
(
    input  wire i_clock,
    input  wire i_reset,
    input  wire i_idle,
    input  wire i_init_done,
    output wire o_led_r,
    output wire o_led_g,
    output wire o_led_b
);

    localparam  LED_PWM_TICKS   =   50;

    reg         led_pwm;
    integer     led_pwm_counter;
    reg         led_g;
    reg         led_b;
    reg         led_r;
    
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
    
    always@( i_init_done or i_idle or led_pwm ) begin
        if( i_init_done ) begin
            led_g  =   i_idle ? led_pwm : 1'b0;
            led_r  =   1'b0;
            led_b  =   i_idle ? 1'b0    : led_pwm;
        end
        else begin
            led_g  =   1'b0;
            led_r  =   led_pwm;
            led_b  =   1'b0;
        end
    end
    
    assign  o_led_r    = led_r;
    assign  o_led_g    = led_g;
    assign  o_led_b    = led_b;
    
endmodule

`default_nettype wire
