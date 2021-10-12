`timescale 1ns / 1ps
`default_nettype none

module pmod_unit
(
    input  wire i_clock,
    input  wire i_reset,
    input  wire i_idle,
    input  wire i_init_done,
    input  wire i_wait_cmd,
    output wire o_led_r,
    output wire o_led_g,
    output wire o_led_b,
    output wire o_buzzer
);

    localparam  LED_PWM_TICKS       =   50;
    localparam  BUZZER_TICKS_SHORT  =   2000000;
    localparam  BUZZER_TICKS_LONG   =   30000000;

    reg         led_pwm;
    integer     led_pwm_counter;
    reg         led_g;
    reg         led_b;
    reg         led_r;
    
    integer     buzzer_counter;
    reg         buzzer;
    reg         last_i_cmd_valid;
    
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
    
    /*
    always@( posedge i_clock ) begin
        if( i_reset ) begin
            buzzer_counter      <= 0;
            buzzer              <= 1'b0;
        end
        else begin
            if( buzzer ) begin
                buzzer          <= buzzer_counter >= BUZZER_TICKS_SHORT ? 1'b0 : 1'b1;
                buzzer_counter  <= buzzer_counter >= BUZZER_TICKS_SHORT ? 0    : buzzer_counter + 1;
            end
            else begin
                buzzer          <= ~last_i_cmd_valid && i_cmd_valid ? 1'b1 : 1'b0;                
                buzzer_counter  <= 0;
            end 
        end
        
        last_i_cmd_valid    <= 1'b0;
    end
    */
    
    always@( i_init_done or i_idle or led_pwm or i_wait_cmd ) begin
        if( i_init_done ) begin
            if( i_idle ) begin
                led_g  =   led_pwm;
                led_r  =   i_wait_cmd ? led_pwm : 1'b0;
                led_b  =   1'b0;
            end
            else begin
                led_g  =   1'b0;
                led_r  =   1'b0;
                led_b  =   led_pwm;
            end
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
    assign  o_buzzer   = buzzer;
    
endmodule

`default_nettype wire
