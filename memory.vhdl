library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is 
	port (
			clk, write_en: in std_logic; 
			Addr_in, D_in: in std_logic_vector(15 downto 0);
			Mem_out: out std_logic_vector(15 downto 0)
	); 
end entity; 

architecture behave of Memory is 

	type mem is array(255 downto 0) of std_logic_vector(15 downto 0);
	signal mem_reg : mem := (
0 => "0001000000011001",
1 => "0001001001100111",
2 => "0000000001010000",
3 => "0000000000010010",
4 => "0000000001010000",
5 => "0000001001010000",
6 => "0000000001010000",
7 => "0001000000111111",
8 => "0010001000010000",
9 => "0010001001010010",
10 => "0100000011001100",
11 => "1000001000000010",
12 => "0000000001001110",
13 => "0011110000110010",
14 => "0101110011001100",
15 => "0100000011001100",
16 => "0001001001000111",
17 => "0001100100000101",
18 => "1100100101000011",
19 => "0001100100111011",
20 => "1001001001000000",
21 => "0011000000001001",
22 => "0001101101011001",
23 => "0111101001011111",
24 => "1000101000000111",
25 => "0000000000000010",
26 => "0000000000000100",
27 => "0000000000001000",
28 => "0000000000010000",
29 => "0000000000100000",
30 => "0000000001000000",
31 => "0110101001001011",
32 => "1111000000000000",
others => x"0000");

begin

	process(clk)
	begin
		if(rising_edge(clk) and write_en = '1') then
			mem_reg(to_integer(unsigned(Addr_in))) <= D_in;
		end if;
	end process;

	Mem_out <= mem_reg(to_integer(unsigned(Addr_in(7 downto 0))));
end behave;
