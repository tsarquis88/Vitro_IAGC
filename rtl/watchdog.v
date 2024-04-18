`timescale 1ns / 1ps `default_nettype none

module watchdog #(
    parameter IAGC_STATUS_SIZE = 4,
    parameter TICKS = 120000000
) (
    input wire i_clock,
    input wire [IAGC_STATUS_SIZE-1:0] i_iagcStatus,
    input wire i_gate,
    output wire o_valid
);
  localparam IAGC_STATUS_IDLE = 4'b0010;
  localparam STATUS_RESET = 3'b000;
  localparam STATUS_INIT = 3'b001;
  localparam STATUS_WATCH = 3'b010;
  localparam STATUS_VALIDATE = 3'b011;
  localparam STATUS_MAINTAIN = 3'b100;
  localparam STATUS_SIZE = 3;
  reg [STATUS_SIZE-1:0] status;
  reg [STATUS_SIZE-1:0] nextStatus;
  integer counter;
  reg gateAlive;
  reg valid;

  always @(posedge i_clock) begin
    if (i_iagcStatus != IAGC_STATUS_IDLE) begin
      status <= STATUS_RESET;
    end else begin
      status <= nextStatus;
    end

    case (status)
      STATUS_RESET: begin
        counter <= 0;
        gateAlive <= 1'b0;
        valid <= 1'b0;
      end
      STATUS_INIT: begin
        counter <= 0;
        gateAlive <= 1'b0;
        valid <= valid;
      end
      STATUS_WATCH: begin
        counter <= counter + 1;
        gateAlive <= i_gate ? 1'b1 : gateAlive;
        valid <= valid;
      end
      STATUS_VALIDATE: begin
        counter <= counter;
        gateAlive <= gateAlive;
        valid <= gateAlive;
      end
      STATUS_MAINTAIN: begin
        counter <= counter;
        gateAlive <= gateAlive;
        valid <= valid;
      end
    endcase
  end

  always @(*) begin
    if (i_iagcStatus != IAGC_STATUS_IDLE) begin
      nextStatus = STATUS_RESET;
    end else begin
      case (status)
        STATUS_RESET: begin
          nextStatus = STATUS_INIT;
        end
        STATUS_INIT: begin
          nextStatus = STATUS_WATCH;
        end
        STATUS_WATCH: begin
          nextStatus = (counter == TICKS) ? STATUS_VALIDATE : STATUS_WATCH;
        end
        STATUS_VALIDATE: begin
          nextStatus = STATUS_MAINTAIN;
        end
        STATUS_MAINTAIN: begin
          nextStatus = STATUS_INIT;
        end
      endcase
    end
  end

  assign o_valid = valid;
endmodule

`default_nettype wire
