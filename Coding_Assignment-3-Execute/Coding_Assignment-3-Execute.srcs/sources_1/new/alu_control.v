`timescale 1ns / 1ps

module alu_control(
    input wire [5:0] funct,
    input wire [1:0] aluop,
    output reg [2:0] select
);

    always @(*) begin
        case (aluop)
            2'b00: select = 3'b010; // LW, SW -> add
            2'b01: select = 3'b110; // BEQ -> subtract
            2'b10: begin            // R-type -> use funct field
                case (funct)
                    6'b100000: select = 3'b010; // add
                    6'b100010: select = 3'b110; // sub
                    6'b100100: select = 3'b000; // and
                    6'b100101: select = 3'b001; // or
                    6'b101010: select = 3'b111; // slt
                    default:   select = 3'b011; // invalid
                endcase
            end
            default: select = 3'b011; // invalid
        endcase
    end

endmodule