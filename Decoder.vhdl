library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
    port( input: in  std_logic_vector(2 downto 0);
        d : out  std_logic_vector(7 downto 0));
end decoder;

architecture Str of decoder is
begin
    d(0) <= (not input(0)) and (not input(1)) and (not input(2));
    d(1) <= (input(0)) and (not input(1)) and (not input(2));
    d(2) <= (not input(0)) and (input(1)) and (not input(2));
    d(3) <= (input(0)) and (input(1)) and (not input(2));
    d(4) <= (not input(0)) and (not input(1)) and (input(2));
    d(5) <= (input(0)) and (not input(1)) and (input(2));
    d(6) <= (not input(0)) and (input(1)) and (input(2));
    d(7) <= (input(0)) and (input(1)) and (input(2));
end Str;