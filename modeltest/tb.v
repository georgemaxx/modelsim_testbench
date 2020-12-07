`timescale 1ns/1ns
module tb;

reg clk_in;
reg rst_n;
wire clk_out;

reg a_in;
reg a_in_1;
wire b_out;

// test
reg ref_clk = 0;
always #10 ref_clk = ~ref_clk;

reg tclk;
initial
begin
  tclk = 0;
  repeat (100) @(posedge ref_clk);
  forever #(20.335) tclk = ~tclk;
end

initial
begin
  clk_in = 0;
  repeat (100) #10 clk_in = ~clk_in;
end

initial
begin
  rst_n = 0;
  #10;
  rst_n = 1;
end

initial
begin
  a_in = 0;
  a_in_1 = 0;
  repeat (10) @(posedge clk_in);
  force clk_in = 0;
  a_in = 1;
  a_in_1 = 1;
  //#10 a_in = 1;
  //#10 a_in = 0;
end

divider D1(
  .clk_in(clk_in),
  .clk_out(clk_out),
  .rst_n(rst_n),
  .a(a_in),
  .b(b_out)
);



endmodule