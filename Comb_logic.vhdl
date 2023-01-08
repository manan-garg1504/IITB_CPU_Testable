library ieee;
use ieee.std_logic_1164.all;

entity Comb_logic is
    port(Instruction: in std_logic_vector(15 downto 0);
            NandAdd, ADI, StoreLoad, LHI, BEQ, JAL, JLR, END_ins: out std_logic);
end entity Comb_logic;

architecture struct of Comb_logic is
    signal  ALU, ADI_LHI, Branches, NotBEQ: std_logic;
begin
    ALU <= Instruction(14) nor Instruction(15);
    NandAdd <= ALU and not(Instruction(12));
    ADI_LHI <= ALU and Instruction(12);
    LHI <= ADI_LHI and Instruction(13);
    ADI <= ADI_LHI and not(Instruction(13));

    StoreLoad <= (not(Instruction(15))) and Instruction(14);

    Branches <= Instruction(15) and not(Instruction(13));
    BEQ <= Branches and Instruction(14);
    NotBEQ <= Branches and not(Instruction(14));
    JAL <= NotBEQ and not(Instruction(12));
    JLR <= NotBEQ and Instruction(12);
    END_ins <= Instruction(15) and Instruction(14) and Instruction(13) and Instruction(12);
end struct;