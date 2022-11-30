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
0 => "0011001000011001",
1 => "0011010000100100",
2 => "0000001010011000",
3 => "0000001010100010",
4 => "0010001010101000",
5 => "0100101000000110",
6 => "0000000001011001",
7 => "1111000000000000",
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