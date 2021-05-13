`timescale 1ns/1ps
module tb ();
  initial begin
    $dumpfile("bcd_encoder_tb.vcd");
    $dumpvars(0, benc);
  end

  parameter bit_size = 7;
  parameter deci_size = 4;


  reg clk;
  reg [bit_size-1:0] binary_data = 54;
  wire [(deci_size*4)-1:0] bcd_data;
  wire bcd_ready;

  initial begin
		clk = 1'b0;
	end

  always begin
    #31 clk = !clk;
  end

  initial begin
    repeat(15) @(posedge clk);

    binary_data = 122;

    repeat(15) @(posedge clk);

    binary_data = 23;

    repeat(30) @(posedge clk);

      $finish;
  end

  bcd_encoder #(.BINARY_LENGTH(bit_size), .DECIMAL_LENGTH(deci_size)) 
    benc (.CLK(clk),
    .binary_data(binary_data),
    .BCD_data(bcd_data),
    .BCD_ready(bcd_ready));

endmodule // tb
