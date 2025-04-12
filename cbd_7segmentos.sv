module cbd_7segmentos (
    input [3:0] bcd_input,
    output logic [6:0] seg_output
);

  always_comb begin
    case (bcd_input)
      4'd0: seg_output = 7'b1111110; // 0
      4'd1: seg_output = 7'b0110000; // 1
      4'd2: seg_output = 7'b1101101; // 2
      4'd3: seg_output = 7'b1111001; // 3
      4'd4: seg_output = 7'b0110011; // 4
      4'd5: seg_output = 7'b1011011; // 5
      4'd6: seg_output = 7'b1011111; // 6
      4'd7: seg_output = 7'b1110000; // 7
      4'd8: seg_output = 7'b1111111; // 8
      4'd9: seg_output = 7'b1111011; // 9
      default: seg_output = 7'b0000000; // Apaga o display para valores inválidos
    endcase
  end

endmodule