`timescale 1ns / 1ps

module led_unit #
(
    parameter   LED_PWM_TICKS   =   50 
)
(
    input       i_clock,
    input       i_reset,
    input       i_calib_enabled,
    input       i_adc_init_done,
    output      o_led_r,
    output      o_led_g,
    output      o_led_b
);

    reg         led_pwm;
    integer     led_pwm_counter;
    reg         led_g;
    reg         led_b;
    reg         led_r;
    
    always@( posedge i_clock ) begin
        
        if( i_reset )
            led_pwm_counter <= 0;
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
    
    always@( i_adc_init_done or i_calib_enabled or led_pwm ) begin
        if( i_adc_init_done ) begin
            if( i_calib_enabled ) begin
                led_g  =   1'b0;
                led_r  =   1'b0;
                led_b  =   led_pwm;
            end
            else begin
                led_g  =   led_pwm;
                led_r  =   1'b0;
                led_b  =   1'b0;
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
    
endmodule
