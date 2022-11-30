library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_logic is
	port(   alu_out, PC_Next, D1: in std_logic_vector(15 downto 0);
			OpCode: in std_logic_vector(3 downto 0);
			clock, S0 ,S2, S3,activate, StoreLoad: in std_logic;
			write_enable: out std_logic;
			Address: out std_logic_vector(15 downto 0));
end entity mem_logic;

architecture memory_logic of mem_logic is
	signal Temp_Reg: std_logic_vector(15 downto 0):= (others => '0');

begin
	
	Address <= PC_next when S0 = '1' else
			   Temp_Reg when OpCode(1) = '1' else
			   alu_out;

	TempRegProc: process(clock)
	begin
		if(rising_edge(clock)) then
			if(S3 = '0' and StoreLoad = '1' and Opcode(1) = '1') then
				Temp_Reg <= D1;
			end if;

			if(S3 = '1' and (activate = '1')) then
				Temp_Reg <= std_logic_vector(unsigned(Temp_Reg) + 1);
			end if;
		end if;
	end process;

	write_enable <= OpCode(0) and ((S2 and StoreLoad) or (S3 and activate));
end architecture;
			