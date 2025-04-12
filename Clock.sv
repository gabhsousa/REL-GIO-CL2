module Clock (
    input rst,
    input clk, 
    /*output logic [6:0] sec_low,
    output logic [6:0] sec_high,*/
	output logic [3:0] sec_low_bcd,
  output logic [2:0] sec_high_bcd, 
    /*output logic [6:0] min_low,
    output logic [6:0] min_high,*/
	 output logic [3:0] min_low_bcd,
  output logic [2:0] min_high_bcd,
    /*output logic [6:0] hr_low,
    output logic [6:0] hr_high*/
	 output logic [3:0] hr_low_bcd,
  output logic [1:0] hr_high_bcd
);

  logic pulse_1hz;

  ClockDivider_1Hz clock_divider (
      .clk(clk),
      .rst(rst),
      .pulse_out(pulse_1hz)
  );

  /*logic [3:0] sec_low_bcd;
  logic [2:0] sec_high_bcd;*/
  logic min_inc;

  SecondCounter sec_counter (
      .clk(clk),
      .rst(rst),
      .enable(clk),
      .sec_low(sec_low_bcd),
      .sec_high(sec_high_bcd),
      .min_inc(min_inc)
  );

 /* cbd_7segmentos sec_low_display (
      .bcd_input(sec_low_bcd),
      .seg_output(sec_low)
  );

  cbd_7segmentos sec_high_display (
      .bcd_input({1'b0, sec_high_bcd}),
      .seg_output(sec_high)
  );
*/
  //logic [3:0] min_low_bcd;
  //logic [2:0] min_high_bcd;
  logic hr_inc;

  MinuteCounter  min_counter (
      .clk(clk),
      .rst(rst),
      .enable(clk),
      .min_inc(min_inc),
      .min_low(min_low_bcd),
      .min_high(min_high_bcd),
      .hr_inc(hr_inc)
  );

  /*cbd_7segmentos min_low_display (
      .bcd_input(min_low_bcd),
      .seg_output(min_low)
  );

  cbd_7segmentos min_high_display (
      .bcd_input({1'b0, min_high_bcd}),
      .seg_output(min_high)
  );
*/
 // logic [3:0] hr_low_bcd;
  //logic [1:0] hr_high_bcd;

  HourCounter hr_counter (
      .clk(clk),
      .rst(rst),
      .enable(clk),
      .hr_inc(hr_inc),
      .hr_low(hr_low_bcd),
      .hr_high(hr_high_bcd)
  );

 /* cbd_7segmentos hr_low_display (
      .bcd_input(hr_low_bcd),
      .seg_output(hr_low)
  );

  cbd_7segmentos hr_high_display (
      .bcd_input({2'd0, hr_high_bcd}),
      .seg_output(hr_high)
  );*/

endmodule