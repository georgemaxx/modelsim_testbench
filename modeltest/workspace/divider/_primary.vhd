library verilog;
use verilog.vl_types.all;
entity divider is
    port(
        clk_in          : in     vl_logic;
        clk_out         : out    vl_logic;
        rst_n           : in     vl_logic;
        a               : in     vl_logic;
        b               : out    vl_logic
    );
end divider;
