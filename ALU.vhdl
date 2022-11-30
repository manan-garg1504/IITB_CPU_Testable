library ieee;
use ieee.std_logic_1164.all;
--look at the C Z stuff

entity ALU is
    port(NandAdd, S0, ADI, StoreLoad: in std_logic;
        Data1, Data2: in std_logic_vector(15 downto 0);
        OpCode: in std_logic_vector(2 downto 0); -- 14-12
        Output: out std_logic_vector(15 downto 0);
        C,Z: out std_logic
    );
end entity ALU;

architecture arch of ALU is
    signal carry : std_logic_vector(15 downto 0):= (others =>'0');
	signal sum_buf : std_logic_vector(15 downto 0):= (others=>'0');
    signal nand_buf : std_logic_vector(15 downto 0):= (others=>'0');
    signal NorPair : std_logic_vector(7 downto 0):= (others => '0');
    signal ALU_out: std_logic_vector(15 downto 0);
    signal Z_current, NandIns: std_logic:= '0';

begin
	NandIns <= NandAdd and OpCode(1);
	 
	ALU_out <= nand_buf when NandIns = '1' else
			   sum_buf;
    
    Output <= ALU_out;

    sum_buf(0) <= Data1(0) xor Data2(0);
	carry(0) <= Data1(0) and Data2(0);
    L1: for i in 1 to 15 generate
        sum_buf(i) <= Data1(i) xor Data2(i) xor carry(i-1);
        carry(i) <= (Data1(i) and Data2(i)) or (Data2(i) and carry(i-1)) or (Data1(i) and carry(i-1));
    end generate;

    L2: for i in 0 to 15 generate
        nand_buf(i) <= Data1(i) nand Data2(i);
    end generate;

    Nors: for i in 0 to 7 generate
        NorPair(i) <= ALU_out(2*i) nor ALU_out(2*i + 1);
    end generate Nors;

    Z_current <= NorPair(7) and NorPair(6) and NorPair(5) and NorPair(4) and NorPair(3) and NorPair(2) and NorPair(1) and NorPair(0);

    update: process(S0)
    begin
        if(rising_edge(S0)) then
            if((NandAdd or ADI or (StoreLoad and (OpCode(1) nor OpCode(0)))) = '1') then
                Z <= Z_current;
            end if;
            if(((NandAdd and not(OpCode(1))) or ADI) = '1') then
                C <= carry(15);
            end if;
        end if;
    end process;
end arch;