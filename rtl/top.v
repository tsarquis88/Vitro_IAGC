`timescale 1ns / 1ps `default_nettype none

module top #(
    parameter ZMOD_DATA_SIZE = 14
) (
    input wire i_clock,

    input wire i_reset,

    output wire o_led0_g,
    output wire o_led0_r,
    output wire o_led0_b,
    output wire o_led1_g,
    output wire o_led1_r,
    output wire o_led1_b,

    output wire o_tx,

    input wire i_rx,

    input wire i_sample,

    input wire i_gate,

    input wire [ZMOD_DATA_SIZE-1:0] i_adc_data,
    inout wire io_adc_sdio,
    input wire i_adc_dco_clock_p,
    output wire o_adc_dco_clock_n,
    output wire o_adc_sclk,
    output wire o_adc_clock_in_n,
    output wire o_adc_clock_in_p,
    output wire o_adc_ch1_coupling_h,
    output wire o_adc_ch1_coupling_l,
    output wire o_adc_ch2_coupling_h,
    output wire o_adc_ch2_coupling_l,
    output wire o_adc_ch2_gain_h,
    output wire o_adc_ch2_gain_l,
    output wire o_adc_ch1_gain_l,
    output wire o_adc_ch1_gain_h,
    output wire o_adc_relay_com_l,
    output wire o_adc_relay_com_h,
    output wire o_adc_cs,
    output wire o_adc_sync,

    inout wire io_dac_sdio,
    output wire o_dac_cs,
    output wire o_dac_sclk,
    output wire o_dac_reset,
    output wire o_dac_clkio_p,
    output wire o_dac_clkio_n,
    output wire o_dac_clkin_p,
    output wire o_dac_clkin_n,
    output wire [ZMOD_DATA_SIZE-1:0] o_dac_data,
    output wire o_dac_set_fs_ch1,
    output wire o_dac_set_fs_ch2,
    output wire o_dac_enable
);

  /* ########################################################### */
  /* PARAMETERS & WIRES ######################################## */

  localparam AXIS_DATA_SIZE = 32;
  localparam IAGC_STATUS_SIZE = 4;
  localparam UART_DATA_SIZE = 8;
  localparam UART_CLK_FREQ = 100_000_000;
  localparam UART_BAUDRATE = 9_200;
  localparam PHASE_SAMPLES_COUNT = 1500;
  localparam AMPLITUDE_SAMPLES_COUNT = 1500;
  localparam AMPLITUDE_DATA_SIZE = AXIS_DATA_SIZE / 2;
  localparam QUOTIENT_SIZE = 8;
  localparam FRACTIONAL_SIZE = 8;

  /* ########################################################### */
  /* CLOCK UNIT ################################################ */

  wire clock0;  // 100 MHz.
  wire clock1;  // 100 MHz - Shifted 90°.
  wire clock2;  // 400 MHz.
  wire clocksValid;  // Up once the clocks are ready.

  clock_unit #() u_clock_unit (
      .i_clock (i_clock),
      .i_reset (i_reset),
      .o_clock0(clock0),
      .o_clock1(clock1),
      .o_clock2(clock2),
      .o_valid (clocksValid)
  );

  /* ########################################################### */
  /* GLOBAL FSM ################################################ */

  wire [IAGC_STATUS_SIZE-1:0] iagcStatus;

  iagc_fsm #(
      .STATUS_SIZE(IAGC_STATUS_SIZE)
  ) u_iagc_fsm (
      .i_clock(clock0),
      .i_nReset(clocksValid),
      .i_adcInitDone(adc_init_done),
      .i_dacInitDone(dac_init_done),
      .o_status(iagcStatus)
  );

  /* ########################################################### */
  /* ADC1410 ################################################### */

  wire [AXIS_DATA_SIZE-1:0] adcData;
  wire adc_init_done;
  wire adc_data_valid;

  adc #(
      .ZMOD_DATA_SIZE(ZMOD_DATA_SIZE),
      .AXIS_DATA_SIZE(AXIS_DATA_SIZE)
  ) u_adc (
      .i_sys_clock(clock0),
      .i_adc_clock(clock2),
      .i_iagc_status(iagcStatus),
      .i_adc_data(i_adc_data),
      .io_adc_sdio(io_adc_sdio),
      .i_adc_dco_clock_p(i_adc_dco_clock_p),
      .o_adc_dco_clock_n(o_adc_dco_clock_n),
      .o_adc_sclk(o_adc_sclk),
      .o_adc_clock_in_n(o_adc_clock_in_n),
      .o_adc_clock_in_p(o_adc_clock_in_p),
      .o_adc_ch1_coupling_h(o_adc_ch1_coupling_h),
      .o_adc_ch1_coupling_l(o_adc_ch1_coupling_l),
      .o_adc_ch2_coupling_h(o_adc_ch2_coupling_h),
      .o_adc_ch2_coupling_l(o_adc_ch2_coupling_l),
      .o_adc_ch2_gain_h(o_adc_ch2_gain_h),
      .o_adc_ch2_gain_l(o_adc_ch2_gain_l),
      .o_adc_ch1_gain_l(o_adc_ch1_gain_l),
      .o_adc_ch1_gain_h(o_adc_ch1_gain_h),
      .o_adc_relay_com_l(o_adc_relay_com_l),
      .o_adc_relay_com_h(o_adc_relay_com_h),
      .o_adc_cs(o_adc_cs),
      .o_adc_sync(o_adc_sync),
      .o_adc_data(adcData),
      .o_adc_data_valid(adc_data_valid),
      .o_adc_init_done(adc_init_done)
  );

  /* ########################################################### */
  /* SAMPLE TRIGGER ############################################ */

  wire st_valid;

  sample_trigger u_sample_trigger (
      .i_clock(clock0),
      .i_iagc_status(iagcStatus),
      .i_gate(i_gate),
      .o_valid(st_valid)
  );

  /* ########################################################### */
  /* DAC1411 ################################################### */

  wire dac_init_done;

  dac #(
      .ZMOD_DATA_SIZE(ZMOD_DATA_SIZE),
      .AXIS_DATA_SIZE(AXIS_DATA_SIZE)
  ) u_dac (
      .i_sys_clock(clock0),
      .i_dac_in_clock(clock0),
      .i_dac_clock(clock1),
      .i_iagc_status(iagcStatus),
      .i_data(adcData),
      .i_data_valid(adc_data_valid),
      .io_dac_sdio(io_dac_sdio),
      .o_dac_init_done(dac_init_done),
      .o_dac_cs(o_dac_cs),
      .o_dac_sclk(o_dac_sclk),
      .o_dac_reset(o_dac_reset),
      .o_dac_clkio_p(o_dac_clkio_p),
      .o_dac_clkio_n(o_dac_clkio_n),
      .o_dac_clkin_p(o_dac_clkin_p),
      .o_dac_clkin_n(o_dac_clkin_n),
      .o_dac_data(o_dac_data),
      .o_dac_set_fs_ch1(o_dac_set_fs_ch1),
      .o_dac_set_fs_ch2(o_dac_set_fs_ch2),
      .o_dac_enable(o_dac_enable)
  );

  /* ########################################################### */
  /* PROCESSOR ################################################# */

  wire p_inPhase;
  wire [AMPLITUDE_DATA_SIZE-1:0] p_referenceAmplitude;
  wire [AMPLITUDE_DATA_SIZE-1:0] p_errorAmplitude;
  wire [QUOTIENT_SIZE-1:0] p_quotient;
  wire [FRACTIONAL_SIZE-1:0] p_fractional;
  
  processor #(
      .IAGC_STATUS_SIZE(IAGC_STATUS_SIZE),
      .AXIS_DATA_SIZE(AXIS_DATA_SIZE),
      .AMPLITUDE_DATA_SIZE(AMPLITUDE_DATA_SIZE),
      .ZMOD_DATA_SIZE(ZMOD_DATA_SIZE),
      .QUOTIENT_SIZE(QUOTIENT_SIZE),
      .FRACTIONAL_SIZE(FRACTIONAL_SIZE),
      .PHASE_SAMPLES_COUNT(PHASE_SAMPLES_COUNT),
      .AMPLITUDE_SAMPLES_COUNT(AMPLITUDE_SAMPLES_COUNT)
  ) u_processor (
      .i_clock(clock0),
      .i_iagcStatus(iagcStatus),
      .i_adcData(adcData),
      .i_valid(st_valid),
      .o_inPhase(p_inPhase),
      .o_referenceAmplitude(p_referenceAmplitude),
      .o_errorAmplitude(p_errorAmplitude),
      .o_quotient(p_quotient),
      .o_fractional(p_fractional)
  );

  /* ########################################################### */
  /* LOGGER #################################################### */

  wire [UART_DATA_SIZE-1:0] logger_data;
  wire logger_valid;

  logger #(
      .IAGC_STATUS_SIZE   (IAGC_STATUS_SIZE),
      .AMPLITUDE_DATA_SIZE(AMPLITUDE_DATA_SIZE),
      .UART_DATA_SIZE     (UART_DATA_SIZE)
  ) u_logger (
      .i_clock(clock0),
      .i_iagcStatus(iagcStatus),
      .i_referenceAmplitude(p_referenceAmplitude),
      .i_errorAmplitude(p_errorAmplitude),
      .i_quotient(p_quotient),
      .i_fractional(p_fractional),
      .i_onPhase(p_inPhase),
      .i_txReady(uart_tx_ready),
      .o_txData(logger_data),
      .o_txValid(logger_valid)
  );

  /* ########################################################### */
  /* UARTS ##################################################### */

  wire uart_tx_ready;

  uart_tx #(
      .CLK_FREQUENCY (UART_CLK_FREQ),
      .UART_FREQUENCY(UART_BAUDRATE)
  ) u_uart_tx (
      .user_clk     (clock0),
      .rst_n        (clocksValid),
      .start_tx     (logger_valid),
      .data         (logger_data),
      .tx_bit       (o_tx),
      .ready        (uart_tx_ready),
      .chipscope_clk()
  );

  /* ########################################################### */
  /* PMOD UNIT ################################################# */

  pmod_unit #(
      .IAGC_STATUS_SIZE(IAGC_STATUS_SIZE)
  ) u_pmod_unit (
      .i_clock      (clock0),
      .i_nReset     (clocksValid),
      .i_iagc_status(iagcStatus),
      .i_in_phase   (p_inPhase),
      .o_led0_r     (o_led0_r),
      .o_led0_g     (o_led0_g),
      .o_led0_b     (o_led0_b),
      .o_led1_r     (o_led1_r),
      .o_led1_g     (o_led1_g),
      .o_led1_b     (o_led1_b)
  );

endmodule

`default_nettype wire
