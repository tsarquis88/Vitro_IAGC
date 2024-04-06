`timescale 1ns / 1ns

module sample_trigger_tb ();

  localparam SYS_CLOCK_PERIOD = 8;
  localparam IAGC_STATUS_SIZE = 4;
  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;
  localparam IAGC_STATUS_IDLE = 4'b0010;

  reg clock;
  reg [IAGC_STATUS_SIZE-1:0] iagc_status;
  reg adc_data_valid;
  reg gate;
  wire valid;

  initial begin
    clock = 1'b0;
    adc_data_valid = 1'b0;
    gate = 1'b0;
    iagc_status = IAGC_STATUS_RESET;

    #100 iagc_status = IAGC_STATUS_INIT;

    #100 iagc_status = IAGC_STATUS_IDLE;

    #100 adc_data_valid = 1'b1;

    #100 gate = 1'b1;

    #100 gate = 1'b0;

    #100 adc_data_valid = 1'b0;
  end

  always begin
    #(SYS_CLOCK_PERIOD / 2) clock = ~clock;
  end

  sample_trigger u_sample_trigger (
      .i_clock(clock),
      .i_iagc_status(iagc_status),
      .i_adc_data_valid(adc_data_valid),
      .i_gate(gate),
      .o_valid(valid)
  );

endmodule
