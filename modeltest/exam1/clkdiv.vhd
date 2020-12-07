library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;

-- entity clkdiv
entity clkdiv is
  port
  (
    clk_in: in std_logic;
    clk_out: out std_logic;
    rst_n: in std_logic
  );
end clkdiv;

-- architecture
architecture behavior of clkdiv is
  -- declare signals
  signal cnt : std_logic_vector(7 downto 0);
  signal temp : std_logic;
begin
-- count process
PROCESS_CNT: process(clk_in, rst_n)
begin
    if(rst_n = '0') then
      cnt <= "00000000";
    --elsif(clk_in'event and clk_in='1') then
    elsif rising_edge(clk_in) then
	  if(cnt = 9) then
        cnt <= "00000000";
      else
        cnt <= cnt + 1;
      end if;
    end if;
end process;

-- divider process
PROCESS_DIV: process(clk_in, rst_n)
begin
    if(rst_n = '0') then
        temp <= '0';
    --elsif((clk_in'event) and (clk_in = '1')) then
    elsif rising_edge(clk_in) then
        if(cnt < 5) then
          temp <= '1';
        else
          temp <= '0';
        end if;
    end if;
end process;

-- assign clk_out = temp
clk_out <= temp;

end behavior;