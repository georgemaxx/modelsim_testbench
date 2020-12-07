module divider(// synchronous logic block
               input clk_in,
               output clk_out,
               input rst_n,
               // combinational logic block
               input a,
               output b);

reg period;
reg [7:0] clk_cnt;
wire [7:0] cnt;
wire c;
reg b_out;

assign cnt = {1'b1, clk_cnt[6:0]};
assign c = clk_cnt == 7 ? 1'b1 : 1'b0;

always @(posedge clk_in or negedge rst_n)
begin : clkcnt_gen
  if(!rst_n)
    clk_cnt <= 0;
  else if(clk_cnt == 7)
    clk_cnt <= 0;
  else
    clk_cnt <= clk_cnt + 1;
end

always @(posedge clk_in or negedge rst_n)
begin : period_gen
  if(!rst_n)
    period <= 0;
  else if(clk_cnt <= 3)
    period <= 1;
  else
    period <= 0;
end

assign clk_out = period;

always @(*)
begin
  b_out = ~a;
end

assign b = b_out;

endmodule
