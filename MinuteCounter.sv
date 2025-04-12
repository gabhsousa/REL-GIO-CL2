module MinuteCounter (
    input rst,
    input clk,
    input enable,
    input min_inc,
    output logic [3:0] min_low,
    output logic [2:0] min_high,
    output logic hr_inc
);

  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      min_low     <= 4'd0; // Reseta o dígito das unidades dos minutos
      min_high    <= 3'd0; // Reseta o dígito das dezenas dos minutos
      hr_inc  <= 1'd0; // Reseta o sinal de carry para horas
    end
    else if (enable && min_inc) begin
      if (min_high == 3'd5 && min_low == 4'd9) begin
        // Reinicia o contador quando atinge 59 minutos
        min_low     <= 4'd0;
        min_high    <= 3'd0;
        hr_inc  <= 1'd1; // Gera um carry para incrementar as horas
      end
      else if (min_low == 4'd9) begin
        // Incrementa as dezenas dos minutos quando as unidades atingem 9
        min_low     <= 4'd0;
        min_high    <= min_high + 1'd1;
        hr_inc  <= 1'd0; // Não há carry para horas
      end
      else begin
        // Incrementa as unidades dos minutos
        min_low     <= min_low + 1'd1;
        hr_inc  <= 1'd0; // Não há carry para horas
      end
    end
    else begin
      hr_inc <= 1'd0; // Garante que o carry seja zerado se não houver incremento
    end
  end

endmodule