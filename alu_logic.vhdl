library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library ieee;
use ieee.numeric_std.all; 


entity alu_logic is
	port (curr_ins, pc, D1, D2: in std_logic_vector(15 downto 0);
         --counter: in std_logic_vector(2 downto 0);
			StoreLoad, NandAdd, BEQ, JAL: in std_logic; --C=carry Z=zero
			ALU_IN1, ALU_IN2: out std_logic_vector(15 downto 0));
end entity;

architecture logic of alu_logic is
	signal Ext6, Ext9: std_logic_vector(15 downto 0);
begin

	Ext6(15 downto 5) <= (others => curr_ins(5));
	Ext6(4 downto 0) <= curr_ins(4 downto 0);

	Ext9(15 downto 8) <= (others => curr_ins(8));
	Ext9(8 downto 0) <= curr_ins(8 downto 0);
	
	ALU_IN1 <= pc when ((BEQ or JAL) = '1') else
			   D1;

	ALU_IN2 <= Ext9 when JAL = '1' else
			   D2 when NandAdd = '1' else
			   Ext6;
end architecture;