`timescale 1ns/1ps   // 20.335 can be recognized
module tb;

// register variable is modified in initial block or always block
reg clk_in;
reg rst_n;
wire clk_out;

reg a_in;
reg a_in_1;
wire b_out;

reg [31:0] t1 = 0;
reg [31:0] t2 = 0;
reg [31:0] t = 0;

/**********************************************************/
// test
reg ref_clk = 0;
always #10 ref_clk = ~ref_clk;

reg tclk;
initial
begin
  tclk = 0;
  repeat (100) @(posedge ref_clk);// similar to delay
  forever #(20.335) tclk = ~tclk;// implement clock feature
end
/**********************************************************/


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
  #1000 a_in_1 = 0;
end

divider D1(
  .clk_in(clk_in),
  .clk_out(clk_out),
  .rst_n(rst_n),
  .a(a_in),
  .b(b_out)
);

/**************************************************/
// generate uart clock
reg uart_clk = 0;
always #10 uart_clk = ~uart_clk;

// generate one signal
reg rx_in;
initial
begin
  rx_in = 1;
  #495 rx_in = 0;
  #17 rx_in = 1;
  #450 rx_in = 0;  // start bit
  #200 rx_in = 1;
  #200 rx_in = 0;
  #200 rx_in = 1;
  #200 rx_in = 0;
  #200 rx_in = 1;
  #200 rx_in = 0;
  #200 rx_in = 1;
  #200 rx_in = 0;
  #200 rx_in = 1; // stop bit
end

// detect start bit
reg rclk = 0;
reg pre_rx = 0;
always@(posedge uart_clk)
begin
  pre_rx = rx_in;
  while(!(pre_rx === 1 && rx_in === 0))
  begin
    pre_rx = rx_in;
    repeat (3) @(negedge uart_clk);  
  end
  forever #(t/2) rclk = ~rclk;
end

reg rx_in_1 = 0;
reg rx_in_2 = 0;
// filter glitch which costs less than one cycle
// if glitch costs more than one cycle and less
// than two cycles, 3-stage DFF can be used.
always@(posedge uart_clk)
begin
  rx_in_1 <= rx_in;
  rx_in_2 <= rx_in_1;
end
wire sci_rx = rx_in_1 | rx_in_2;

// calculate the frequency of uart_clk
initial
begin
  @(posedge uart_clk);
  t1 = $time;
  @(posedge uart_clk);
  t2 = $time;
  t = t2 - t1;
end

reg rx_flag = 0;
reg flag_en = 1;
always@(negedge uart_clk)
begin
  pre_rx = 1;
  if(flag_en) begin
    if(pre_rx === 1 && rx_in === 0) begin
      rx_flag = 1;
      flag_en = 0;
    end
  end
end

reg clk_en = 0;
always@(negedge uart_clk)
begin
  if(rx_flag)
    if(pre_rx === 1 && rx_in === 1) begin
      clk_en = 1;
    end
end

reg aclk = 0;
always@(posedge rclk)
begin
  if(rx_in === 0)
    aclk = ~aclk;
end


// verify the execution of task

endmodule
