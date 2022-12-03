library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use STD.textio.all;
use ieee.std_logic_textio.all;

entity RegisterFile is 
	port( 
		RA,RB,RC: in std_logic_vector(2 downto 0);
		write_data, ALU_out: in std_logic_vector(15 downto 0);
		clock, S0, BEQ, JAL, JLR: in std_logic;
		rst, write_enable: in std_logic ;
		D1, D2: out std_logic_vector(15 downto 0);
		PC_out, next_PC_out : out std_logic_vector(15 downto 0));
end entity;

architecture behave of RegisterFile is 
	
	type RF is array(0 to 7) of std_logic_vector(15 downto 0);
	signal registers: RF:= (7 => "1111111111111111", others => "0000000000000000");
	signal next_PC, PC_carry, PC_plus: std_logic_vector(15 downto 0);
	signal Equals: std_logic:= '0';
	signal regA, regB : std_logic_vector(15 downto 0);

	function bin (lvec: in std_logic_vector) return string is
		variable text: string(16 downto 1) := (others => '9');
	begin
		for k in 16 downto 1 loop
			case lvec(k-1) is
				when '0' => text(k) := '0';
				when '1' => text(k) := '1';
				when others => text(k) := '?';
			end case;
		end loop;
		return text;
	end function;

	file file_RESULTS : text;
	
begin 
	regA <= registers(to_integer(unsigned(RA)));
	regB <= registers(to_integer(unsigned(RB)));
	D1 <= regA; D2 <= regB;

	Equals <= '1' when (regA = regB) else '0';

	process(clock)
	begin 
		if(rising_edge(clock)) then
			if(write_enable = '1') then
					registers(to_integer(unsigned(RC))) <= write_data;
			end if;
			if(S0 = '1')then
				registers(7) <= next_PC;
			end if;
		end if;
		
		if (rst = '1') then
			for i in 0 to 6 loop
				registers(i) <= "0000000000000000";
			end loop;

			registers(7) <= "1111111111111111";
		end if;
	end process;

	PC_plus(0) <= not registers(7)(0);
	PC_carry(0) <= registers(7)(0);
	
	Gen: for i in 1 to 15 generate
		PC_carry(i) <= PC_carry(i-1) and registers(7)(i);
		PC_plus(i) <= PC_carry(i-1) xor registers(7)(i);
	end generate;

	PC_out <= registers(7);
	next_PC <= regB when JLR = '1' else
		ALU_out when ((BEQ and Equals) or JAL) = '1' else
		PC_plus;
	next_PC_out <= next_PC;
	
	file_open(file_RESULTS, "..\..\output.txt", write_mode);
	test_proc: process(S0)
		variable message: string(1 to 18);
		variable v_OLINE: line;
	begin
		if (falling_edge(S0)) then
			repLoop: for i in 0 to 7 loop
				message := integer'image(i) & ":" & bin(registers(i));
				write(v_OLINE, message);
				writeline(file_RESULTS, v_OLINE);
			end loop;
			
			write(v_OLINE, string'(""));  
			writeline(file_RESULTS, v_OLINE);
		end if;
	end process;
	
end behave;