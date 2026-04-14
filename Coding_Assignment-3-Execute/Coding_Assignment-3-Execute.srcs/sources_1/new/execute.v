`timescale 1ns / 1ps

module execute(
    input wire        clk,
    input wire [1:0]  ctlwb_in,
    input wire [2:0]  ctlm_in,
    input wire [31:0] npc,
    input wire [31:0] rdata1,
    input wire [31:0] rdata2,
    input wire [31:0] s_extend,
    input wire [4:0]  instr_2016,
    input wire [4:0]  instr_1511,
    input wire [1:0]  alu_op,
    input wire [5:0]  funct,
    input wire        alusrc,
    input wire        regdst,

    output wire [1:0]  ctlwb_out,
    output wire [2:0]  ctlm_out,
    output wire [31:0] adder_out,
    output wire [31:0] alu_result_out,
    output wire [31:0] rdata2_out,
    output wire [4:0]  muxout_out
);

    wire [31:0] adder_result_internal;
    wire [31:0] alu_b_internal;
    wire [31:0] alu_result_internal;
    wire [4:0]  dest_reg_internal;
    wire [2:0]  alu_select_internal;
    wire        zero_internal;

    // Branch/add result
    adder adder0(
        .add_in1(npc),
        .add_in2(s_extend),
        .add_out(adder_result_internal)
    );

    // Choose ALU input B
    top_mux top_mux0(
        .a(rdata2),          // sel=0 -> use register data
        .b(s_extend),        // sel=1 -> use sign-extended immediate
        .sel(alusrc),
        .y(alu_b_internal)
    );

    // ALU control
    alu_control alu_control0(
        .funct(funct),
        .aluop(alu_op),
        .select(alu_select_internal)
    );

    // ALU
    alu alu0(
        .a(rdata1),
        .b(alu_b_internal),
        .control(alu_select_internal),
        .result(alu_result_internal),
        .zero(zero_internal)
    );

    // Choose destination register
    bottom_mux bottom_mux0(
        .a(instr_2016),      // sel=0 -> rt
        .b(instr_1511),      // sel=1 -> rd
        .sel(regdst),
        .y(dest_reg_internal)
    );

    // EX/MEM latch
    ex_mem ex_mem0(
        .clk(clk),
        .ctlwb_in(ctlwb_in),
        .ctlm_in(ctlm_in),
        .adder_in(adder_result_internal),
        .zero_in(zero_internal),
        .alu_result_in(alu_result_internal),
        .rdata2_in(rdata2),
        .muxout_in(dest_reg_internal),

        .ctlwb_out(ctlwb_out),
        .ctlm_out(ctlm_out),
        .adder_out(adder_out),
        .zero_out(),                 // not used by this TB
        .alu_result_out(alu_result_out),
        .rdata2_out(rdata2_out),
        .muxout_out(muxout_out)
    );

endmodule