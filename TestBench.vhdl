LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.Numeric_Std.all;

entity TestBench is
end entity TestBench;

architecture bhv of TestBench is
	component CPU is
		port (reset, clk: in std_logic);
	end component CPU;

signal clk_50: std_logic:= '1';
signal clk: std_logic:= '1';
signal reset: std_logic:= '1';
constant clk_period : time := 20 ns;
begin
	
	dut_instance: CPU port map(reset, clk);
	clk_50 <= not clk_50 after clk_period/2;
	reset <= '0' after 20 ns;

	clk <= clk_50;
end bhv;