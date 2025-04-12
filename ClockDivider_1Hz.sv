module ClockDivider_1Hz (
    input clk,
    input rst,
    output logic pulse_out
);

  logic [25:0] counter;

  always_ff @(posedge clk) begin
    if (!rst) begin
      counter <= 26'd0; // Reseta o contador se o reset estiver ativo
    end
    else if (counter == 26'd49999999) begin
      counter <= 26'd0; // Reinicia o contador ao atingir o valor máximo
    end
    else begin
      counter <= counter + 26'd1; // Incrementa o contador
    end
  end

  always_comb begin
    pulse_out = (counter == 26'd49999999); // Gera um pulso quando o contador atinge o valor máximo
  end

endmodule