`timescale 1ns / 1ps

module ex_mem(
    input wire        clk,
    input wire [1:0]  ctlwb_in,
    input wire [2:0]  ctlm_in,
    input wire [31:0] adder_in,
    input wire        zero_in,
    input wire [31:0] alu_result_in,
    input wire [31:0] rdata2_in,
    input wire [4:0]  muxout_in,

    output reg [1:0]  ctlwb_out,
    output reg [2:0]  ctlm_out,
    output reg [31:0] adder_out,
    output reg        zero_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] rdata2_out,
    output reg [4:0]  muxout_out
);

    initial begin
        ctlwb_out      = 2'b00;
        ctlm_out       = 3'b000;
        adder_out      = 32'b0;
        zero_out       = 1'b0;
        alu_result_out = 32'b0;
        rdata2_out     = 32'b0;
        muxout_out     = 5'b0;
    end

    always @(posedge clk) begin
        ctlwb_out      <= ctlwb_in;
        ctlm_out       <= ctlm_in;
        adder_out      <= adder_in;
        zero_out       <= zero_in;
        alu_result_out <= alu_result_in;
        rdata2_out     <= rdata2_in;
        muxout_out     <= muxout_in;
    end

endmodule