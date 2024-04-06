`timescale 1ns / 1ns

module top_tb ();

  localparam SYS_CLOCK_PERIOD = 8;

  reg        clock;
  reg        reset;
  reg        gate;
  reg        adc_init_done;
  reg        sample;

  wire       rx;
  wire       tx;

  wire       led0_r;
  wire       led0_g;
  wire       led0_b;
  wire       led1_r;
  wire       led1_g;
  wire       led1_b;

  reg        tx_valid;
  reg  [7:0] tx_data;
  wire       tx_ready;
  wire [7:0] rx_data;
  wire       rx_valid;

  initial begin
    clock         = 1'b0;
    gate          = 1'b0;
    reset         = 1'b1;
    adc_init_done = 1'b0;
    sample        = 1'b0;
    tx_valid      = 1'b0;
    tx_data       = {8{1'b0}};

    #100 reset = 1'b0;

    #10000 adc_init_done = 1'b1;

    #1000 sample = 1'b1;
    #100 sample = 1'b0;

    #10000 tx_data = 8'b01000000;
    tx_valid = 1'b1;
    #100 tx_valid = 1'b0;
  end

  always begin
    #(SYS_CLOCK_PERIOD / 2) clock = ~clock;
  end

  always begin
    #(200) gate = ~gate;
  end

  top_sim u_top_sim (
      .i_clock        (clock),
      .i_reset        (reset),
      .i_adc_init_done(adc_init_done),
      .i_rx           (rx),
      .i_sample       (sample),
      .i_gate         (gate),
      .o_led0_g       (led0_g),
      .o_led0_r       (led0_r),
      .o_led0_b       (led0_b),
      .o_led1_g       (led1_g),
      .o_led1_r       (led1_r),
      .o_led1_b       (led1_b),
      .o_tx           (tx)
  );

  uart_tx #(
      .CLK_FREQUENCY (125000000),
      .UART_FREQUENCY(9600)
  ) u_uart_tx (
      .user_clk     (clock),
      .rst_n        (~reset),
      .start_tx     (tx_valid),
      .data         (tx_data),
      .tx_bit       (rx),
      .ready        (tx_ready),
      .chipscope_clk()
  );

  uart_rx #(
      .CLK_FREQUENCY (125000000),
      .UART_FREQUENCY(9600)
  ) u_uart_rx (
      .clk  (clock),
      .rst_n(~reset),
      .data (rx_data),
      .rx   (tx),
      .valid(rx_valid)
  );

endmodule
