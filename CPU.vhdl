library ieee;
use ieee.std_logic_1164.all;

entity CPU is
    port(reset, clk : in std_logic);
end entity CPU;

architecture bhv of CPU is

    --signal declaration

    signal PC_out:std_logic_vector(15 downto 0);

    signal Curr_Ins, Mem_out: std_logic_vector(15 downto 0);
    signal Mem_Data: std_logic_vector(15 downto 0);
    signal Mem_Add: std_logic_vector(15 downto 0);
    signal S0, S1, S2, S3, FlagC, FlagZ, set_pc: std_logic;

    signal ALU_1, ALU_2, ALU_Out: std_logic_vector(15 downto 0);
    signal Count, RegAddrA, RegAddrB, RegAddrC: std_logic_vector(2 downto 0);

    signal Reg_Out_1, Reg_Out_2, RF_IN: std_logic_vector(15 downto 0);
    signal Load_Enable, memWriteEn, BEQ_Add, Multiple: std_logic:= '0';

    signal Immediate, StoreLoad, NandAdd, ADI, LHI, BEQ, JAL, JLR, END_ins: std_logic; 

    -- components declaration
    component mem_logic is
        port(alu_out, PC, D1: in std_logic_vector(15 downto 0);
			OpCode: in std_logic_vector(3 downto 0);
            clock, S0, S2, S3, StoreLoad, activate: in std_logic;
            write_enable: out std_logic;
            Address: out std_logic_vector(15 downto 0));
    end component;

    component Memory is 
        port (
            clk, write_en: in std_logic; 
            Addr_in, D_in: in std_logic_vector(15 downto 0);
            Mem_out: out std_logic_vector(15 downto 0)
        ); 
    end component; 

    component Comb_logic is
        port(Instruction: in std_logic_vector(15 downto 0);
                NandAdd, ADI, StoreLoad, LHI, BEQ, JAL, JLR, END_ins: out std_logic);
    end component;

    component reg_logic is port
      (curr_ins, mem_out, alu_out, pc: in std_logic_vector(15 downto 0);
		counter: in std_logic_vector(2 downto 0);
		S2, S3, NandAdd, ADI, StoreLoad, LHI, BEQ, JAL, JLR, C, Z: in std_logic; --C=carry Z=zero
		ra, rb, rc: out std_logic_vector(2 downto 0);
		write_data: out std_logic_vector(15 downto 0);
		load_enable, activate: out std_logic);
    end component;

    component RegisterFile is 
        port( 
        RA,RB,RC: in std_logic_vector(2 downto 0);
		write_data, ALU_out: in std_logic_vector(15 downto 0);
		clock, S0, set_pc, BEQ, JAL, JLR: in std_logic;
		rst, write_enable: in std_logic ;
		D1, D2: out std_logic_vector(15 downto 0);
		PC_out: out std_logic_vector(15 downto 0));
    end component;

    component alu_logic is
        port (curr_ins, pc, D1, D2: in std_logic_vector(15 downto 0);
			StoreLoad, NandAdd, BEQ, JAL: in std_logic; --C=carry Z=zero
			ALU_IN1, ALU_IN2: out std_logic_vector(15 downto 0));
    end component;

    component ALU is
        port(NandAdd, S0, ADI, StoreLoad: in std_logic;
        Data1, Data2: in std_logic_vector(15 downto 0);
        OpCode: in std_logic_vector(2 downto 0); -- 14-12
        Output: out std_logic_vector(15 downto 0);
        C,Z: out std_logic
    );
    end component;

    component FSM is
        port(reset, clock, Multiple, END_ins: in std_logic;
                S0, S1, S2, S3: out std_logic;
                bits: out std_logic_vector(2 downto 0));
    end component;
begin

    update : process(S0)
	begin
		if (falling_edge(S0)) then
			Curr_Ins <= mem_out;
		end if;
	end process;

    PreMem: mem_logic port map (
        alu_out => ALU_Out, PC => PC_out, D1 => Reg_Out_1, OpCode => curr_ins(15 downto 12),
        clock => clk, S0 => S0, S2 => S2, S3 => S3,StoreLoad => StoreLoad, activate => Immediate, 
        write_enable => memWriteEn, Address => Mem_Add);

    Mem: Memory port map(
        clk => clk, write_en => memWriteEn, Addr_in => Mem_Add, D_in => Reg_Out_2, Mem_out => Mem_out); 

    Main_comb: Comb_logic port map(
        Instruction => Curr_Ins, NandAdd => NandAdd, ADI => ADI, StoreLoad => StoreLoad, END_ins => END_ins,
        LHI => LHI, BEQ => BEQ, JAL => JAL, JLR => JLR);

    PreReg: reg_logic port map (
        curr_ins => Curr_Ins, mem_out => Mem_out, alu_out =>ALU_Out, pc => PC_out,
        counter => Count, S2 => S2, S3 => S3, NandAdd => NandAdd, ADI => ADI, StoreLoad => StoreLoad,
        LHI => LHI, BEQ => BEQ, JAL => JAL, JLR => JLR, C => FlagC, Z => FlagZ, ra => RegAddrA, 
		rb => RegAddrB, rc => RegAddrC, write_data => RF_IN, load_enable => Load_Enable, activate => Immediate);
    
    set_pc <= S2 or S3;
    RF: RegisterFile port map( 
        RA => RegAddrA, RB => RegAddrB, RC => RegAddrC, write_data => RF_IN, ALU_out => ALU_Out,
		clock => clk, S0 => S0, set_pc => set_pc, BEQ => BEQ, JAL => JAL, JLR => JLR, rst => reset, write_enable => Load_Enable, 
        D1 => Reg_Out_1, D2 => Reg_Out_2, PC_out => PC_out);

    PreAlu: alu_logic port map (
        curr_ins => Curr_ins, pc => PC_out, D1 => Reg_Out_1, D2 => Reg_Out_2,
        StoreLoad => StoreLoad, NandAdd => NandAdd, BEQ => BEQ, JAL => JAL,
        ALU_IN1 => ALU_1, ALU_IN2 => ALU_2);

    TheAlu: ALU port map(
        NandAdd => NandAdd, S0 => S0, ADI => ADI, StoreLoad => StoreLoad, Data1 => ALU_1, Data2 => ALU_2,
        OpCode => Curr_Ins(14 downto 12), Output => ALU_Out, C => FlagC, Z => FlagZ);

    Multiple <= StoreLoad and Curr_Ins(13);
    Main: FSM port map(
        reset => reset, clock => clk, Multiple => Multiple, END_ins => END_ins,
        S0 => S0, S1 => S1, S2 => S2, S3 => S3, bits => Count);

end bhv;