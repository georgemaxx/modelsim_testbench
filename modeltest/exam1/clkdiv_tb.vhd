library ieee;
use ieee.std_logic_1164.all;

entity tb is -- testbench empty entity, no need to define port
end tb;

architecture behavior of tb is
  
  component clkdiv   -- declaration of test entity
    port(
      clk_in, rst_n: in std_logic;
      clk_out: out std_logic
    );
  end component;
  
  -- port input signal
  signal clkin: std_logic;
  signal rst: std_logic;
  -- port output signal
  signal clkout: std_logic;
  
  -- clock cycle definition
  constant clk_period: time :=20 ns;

begin  -- architecture begin
    b1: clkdiv
    port map(
    clk_in=> clkin,
    rst_n => rst,
    clk_out => clkout
  );
  
  -- generate test clock
  clk_gen: process
  begin
    clkin <= '0';
    wait for clk_period/2;
    clkin <= '1';
    wait for clk_period/2;
  end process;
  
  rst_gen: process
  begin
    rst <= '0';
    wait for 15 ns;
    rst <= '1';
    wait;
  end process;
  
end behavior; -- architecture end