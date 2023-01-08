library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity reg_logic is
	port (curr_ins, mem_out, alu_out, pc: in std_logic_vector(15 downto 0);
		counter: in std_logic_vector(2 downto 0);
		S2, S3, NandAdd, ADI, StoreLoad, LHI, BEQ, JAL, JLR, C, Z: in std_logic; --C=carry Z=zero
		ra, rb, rc: out std_logic_vector(2 downto 0);
		write_data: out std_logic_vector(15 downto 0);
		load_enable, activate: out std_logic);
end entity;

architecture logic of reg_logic is
	signal Loadwr_en, wr_en, Nandwr_en: std_logic:= '0';
	signal immediate: std_logic;

begin

	immediate <= curr_ins(to_integer(unsigned(counter) + 8));
	activate <= immediate;

	ra <= curr_ins(8 downto 6) when ((StoreLoad and not curr_ins(13))='1') else
		  curr_ins(11 downto 9);

	rb <= curr_ins(8 downto 6) when StoreLoad = '0' else
		  counter when curr_ins(13) = '1' else
		  curr_ins(11 downto 9);

	rc <= curr_ins(5 downto 3) when NandAdd = '1' else
		  curr_ins(8 downto 6) when ADI = '1' else
		  counter when ((StoreLoad  and curr_ins(13)) = '1') else
		  curr_ins(11 downto 9);

	Nandwr_en <= NandAdd and ((curr_ins(1) and (not C)) nor ((curr_ins(0) and (not Z))));
	Loadwr_en <= StoreLoad and (not curr_ins(12)) and ((not curr_ins(13)) or (immediate));
	wr_en <= Nandwr_en or Loadwr_en or ADI or LHI or JAL or JLR;

	write_data <= (curr_ins(8 downto 0) & "0000000") when LHI = '1' else
				  mem_out when StoreLoad = '1' else
				  pc when ((JAL or JLR) = '1') else
				  alu_out;

	load_enable <= wr_en and (S2 or S3);
end architecture;