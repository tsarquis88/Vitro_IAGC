`timescale 1ns / 1ps
`default_nettype none

module pmod_unit
(
    input  wire i_clock,
    input  wire i_reset,
    input  wire i_idle,
    input  wire i_init_done,
    input  wire i_wait_cmd,
    input  wire i_error,
    input  wire i_succes,
    output wire o_led0_r,
    output wire o_led0_g,
    output wire o_led0_b,
    output wire o_led1_r,
    output wire o_led1_g,
    output wire o_led1_b
);

    localparam  LED_PWM_TICKS       =   50;
    localparam  SEG_TICKS           =   100000000;

    reg         led_pwm;
    integer     led_pwm_counter;
    
    reg         led0_g;
    reg         led0_b;
    reg         led0_r;
    reg         led1_g;
    reg         led1_b;
    reg         led1_r;
    
    integer     led1_c;
    reg         error;
    reg         succes;
    
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
    
    /* LED 0 */    
    always@( i_init_done or i_idle or led_pwm or i_wait_cmd ) begin
        if( i_init_done ) begin
            if( i_idle ) begin
                led0_g =   led_pwm;
                led0_r =   i_wait_cmd ? led_pwm : 1'b0;
                led0_b =   1'b0;
            end
            else begin
                led0_g =   1'b0;
                led0_r =   1'b0;
                led0_b =   led_pwm;
            end
        end
        else begin
            led0_g =   1'b0;
            led0_r =   led_pwm;
            led0_b =   1'b0;
        end
    end
    
    /* LED 1 */
    always@( posedge i_clock ) begin
        if( i_reset ) begin
            led1_r  <= 1'b0;
            led1_g  <= 1'b0;
            led1_b  <= 1'b0;
            led1_c  <= 0;
            error   <= 1'b0;
            succes  <= 1'b0;
        end
        else begin
        
            led1_r  <= error  ? led_pwm : 1'b0;
            led1_g  <= 1'b0;
            led1_b  <= succes ? led_pwm : 1'b0;
            
            if( error || succes ) begin
                led1_c  <= led1_c + 1;
                error   <= led1_c >= SEG_TICKS ? 1'b0 : error;
                succes  <= led1_c >= SEG_TICKS ? 1'b0 : succes;
            end
            else begin
                led1_c  <= 0;
                error   <= i_error;
                succes  <= i_succes;
            end
        end
    end
    
    assign  o_led0_r    = led0_r;
    assign  o_led0_g    = led0_g;
    assign  o_led0_b    = led0_b;
    assign  o_led1_r    = led1_r;
    assign  o_led1_g    = led1_g;
    assign  o_led1_b    = led1_b;
    
endmodule

`default_nettype wire
