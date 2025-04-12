`timescale 1ns / 1ps
module Clockp2;

  // Sinais para instanciar o DUT (Dispositivo Sob Teste)
  logic clk;
  logic rst;
  logic [6:0] sec_low, sec_high, min_low, min_high, hr_low, hr_high;

  // Instanciação do módulo TimerModule
  TimerModule dut (
      .rst(rst),
      .clk(clk),
      .sec_low(sec_low),
      .sec_high(sec_high),
      .min_low(min_low),
      .min_high(min_high),
      .hr_low(hr_low),
      .hr_high(hr_high)
  );

  // Geração do clock de 50MHz (período de 20 ns)
  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  // Geração do reset (assumindo reset ativo em 0)
  initial begin
    rst = 0;
    #50;  // mantém reset ativo por 50 ns
    rst = 1;  // libera o reset
  end

  // Função para converter a codificação dos 7 segmentos para o dígito correspondente
  function automatic string seg_to_digit(input logic [6:0] seg);
    case (seg)
      7'b1111110: seg_to_digit = "0";
      7'b0110000: seg_to_digit = "1";
      7'b1101101: seg_to_digit = "2";
      7'b1111001: seg_to_digit = "3";
      7'b0110011: seg_to_digit = "4";
      7'b1011011: seg_to_digit = "5";
      7'b1011111: seg_to_digit = "6";
      7'b1110000: seg_to_digit = "7";
      7'b1111111: seg_to_digit = "8";
      7'b1111011: seg_to_digit = "9";
      default:    seg_to_digit = "?";
    endcase
  endfunction

  // Monitoramento periódico dos sinais convertidos
  initial begin
    // Aguarda um tempo para que os sinais se estabilizem (ajuste conforme necessário)
    #2000;
    forever begin
      $display("Tempo: %0t | Horas: %s%s  Minutos: %s%s  Segundos: %s%s", $time,
               seg_to_digit(hr_high), seg_to_digit(hr_low), seg_to_digit(min_high),
               seg_to_digit(min_low), seg_to_digit(sec_high), seg_to_digit(sec_low));
      #5000;  // exibe a cada 20 us (ajuste conforme a sua simulação)
    end
  end

  // Variáveis para armazenar o valor anterior dos sinais de carry
  logic prev_min_inc;
  logic prev_hr_inc;

  // Inicializa os registradores para detectar bordas
  initial begin
    prev_min_inc = 0;
    prev_hr_inc  = 0;
  end

  // Sempre que houver uma borda de clock, verifica se houve transição de 0 para 1
  always @(posedge clk) begin
    // Detecta a borda de subida para o carry de segundos para minutos
    if (!prev_min_inc && dut.min_inc) begin
      $display("Tempo: %0t - Rising edge: Carry de segundos para minutos detectado", $time);
    end
    // Detecta a borda de subida para o carry de minutos para horas
    if (!prev_hr_inc && dut.hr_inc) begin
      $display("Tempo: %0t - Rising edge: Carry de minutos para horas detectado", $time);
    end

    // Atualiza os valores anteriores para a próxima comparação
    prev_min_inc <= dut.min_inc;
    prev_hr_inc  <= dut.hr_inc;
  end

  // Monitoramento dos sinais internos para debug
  always @(posedge clk) begin
    if (dut.hr_inc == 1) begin
      $display(
          "Debug - hr_inc=1: pulse_1hz=%b, min_inc=%b, hr_inc=%b",
          dut.pulse_1hz, dut.min_inc, dut.hr_inc);
    end
  end

  // Finaliza a simulação após um tempo determinado
  //  initial begin
  //    #2000001; // simulação de 1 ms, por exemplo
  //    $finish;
  //  end

endmodule