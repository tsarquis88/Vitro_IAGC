`timescale 1ns / 1ps `default_nettype none

module memory #(
    parameter DATA_SIZE        = 16,
    parameter ADDR_SIZE        = 12,
    parameter DEF_MEMORY_SIZE  = 4096,
    parameter IAGC_STATUS_SIZE = 4,
    parameter CMD_PARAM_SIZE   = 4
) (
    input  wire                            i_clock,
    input  wire [IAGC_STATUS_SIZE - 1 : 0] i_iagc_status,
    input  wire [ADDR_SIZE        - 1 : 0] i_raddr,
    input  wire [ADDR_SIZE        - 1 : 0] i_waddr,
    input  wire [DATA_SIZE        - 1 : 0] i_reference_sample,
    input  wire [DATA_SIZE        - 1 : 0] i_error_sample,
    input  wire [ADDR_SIZE        - 1 : 0] i_memory_size,
    output wire                            o_clean_end,
    output wire [DATA_SIZE        - 1 : 0] o_data
);

  localparam IAGC_STATUS_RESET = 4'b0000;
  localparam IAGC_STATUS_INIT = 4'b0001;
  localparam IAGC_STATUS_IDLE = 4'b0010;
  localparam IAGC_STATUS_SAMPLE = 4'b0011;
  localparam IAGC_STATUS_CMD_PARSE = 4'b0100;
  localparam IAGC_STATUS_CMD_READ = 4'b0101;
  localparam IAGC_STATUS_CMD_ERROR = 4'b0110;
  localparam IAGC_STATUS_DUMP_REF = 4'b0111;
  localparam IAGC_STATUS_DUMP_ERR = 4'b1000;
  localparam IAGC_STATUS_CLEAN_MEM = 4'b1001;
  localparam IAGC_STATUS_SET_MEM = 4'b1010;
  localparam IAGC_STATUS_SET_DEC = 4'b1011;
  localparam IAGC_STATUS_HALT = 4'b1100;

  reg [DATA_SIZE - 1 : 0] ref_samples [DEF_MEMORY_SIZE - 1 : 0];
  reg [DATA_SIZE - 1 : 0] err_samples [DEF_MEMORY_SIZE - 1 : 0];
  reg [DATA_SIZE - 1 : 0] data;

  reg                     clean_end;
  reg                     clean_first;
  reg [ADDR_SIZE - 1 : 0] clean_addr;
  reg [ADDR_SIZE - 1 : 0] max_addr;

  always @(posedge i_clock) begin

    case (i_iagc_status)

      IAGC_STATUS_RESET: begin
        max_addr <= DEF_MEMORY_SIZE;
      end

      IAGC_STATUS_SAMPLE: begin
        ref_samples[i_waddr] <= i_reference_sample;
        err_samples[i_waddr] <= i_error_sample;
        clean_end            <= 1'b0;
        clean_addr           <= {ADDR_SIZE{1'b0}};
        clean_first          <= 1'b1;
        max_addr             <= max_addr;
      end

      IAGC_STATUS_DUMP_REF: begin
        data        <= ref_samples[i_raddr];
        clean_end   <= 1'b0;
        clean_addr  <= {ADDR_SIZE{1'b0}};
        clean_first <= 1'b1;
        max_addr    <= max_addr;
      end

      IAGC_STATUS_DUMP_ERR: begin
        data        <= err_samples[i_raddr];
        clean_end   <= 1'b0;
        clean_addr  <= {ADDR_SIZE{1'b0}};
        clean_first <= 1'b1;
        max_addr    <= max_addr;
      end

      IAGC_STATUS_CLEAN_MEM: begin
        if (clean_addr >= max_addr - 1) begin
          clean_end  <= 1'b1;
          clean_addr <= clean_addr;
        end else begin
          clean_end  <= 1'b0;
          clean_addr <= clean_first ? {ADDR_SIZE{1'b0}} : clean_addr + 1'b1;
        end

        ref_samples[clean_addr] <= {DATA_SIZE{1'b0}};
        err_samples[clean_addr] <= {DATA_SIZE{1'b0}};
        clean_first             <= 1'b0;
        max_addr                <= max_addr;
      end

      IAGC_STATUS_SET_MEM: begin
        max_addr <= i_memory_size;
      end

      default: begin
        clean_end   <= 1'b0;
        clean_addr  <= { ADDR_SIZE { 1'b0 } };
        clean_first <= 1'b1;
        max_addr    <= max_addr;
      end
    endcase
  end

  assign o_data      = data;
  assign o_clean_end = clean_end;

endmodule

`default_nettype wire
