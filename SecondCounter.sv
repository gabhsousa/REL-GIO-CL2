module SecondCounter(
    input rst,
    input clk,
    input enable,
    output logic [3:0] sec_low,
    output logic [2:0] sec_high,
    output logic min_inc
);

  always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
      sec_low    <= 4'd0; // Reseta o dígito das unidades dos segundos
      sec_high   <= 3'd0; // Reseta o dígito das dezenas dos segundos
      min_inc  <= 1'd0; // Reseta o sinal de carry para minutos
    end
    else if (enable) begin
      if (sec_high == 3'd5 && sec_low == 4'd8) begin
        // Prepara o carry para minutos no próximo incremento
        sec_low    <= sec_low + 1'd1;
        min_inc  <= 1'd1; // Gera um carry para incrementar os minutos
      end
      else if (sec_high == 3'd5 && sec_low == 4'd9) begin
        // Reinicia o contador quando atinge 59 segundos
        sec_low    <= 4'd0;
        sec_high   <= 3'd0;
        min_inc  <= 1'd0; // Zera o carry após o reinício
      end
      else if (sec_low == 4'd9) begin
        // Incrementa as dezenas dos segundos quando as unidades atingem 9
        sec_low    <= 4'd0;
        sec_high   <= sec_high + 1'd1;
        min_inc  <= 1'd0; // Não há carry para minutos
      end
      else begin
        // Incrementa as unidades dos segundos
        sec_low    <= sec_low + 1'd1;
        min_inc  <= 1'd0; // Não há carry para minutos
      end
    end
  end

endmodule