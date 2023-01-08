library ieee;
use ieee.std_logic_1164.all;
use ieee.Numeric_Std.all;

entity FSM is
    port(reset, clock, Multiple, END_ins: in std_logic;
            S0, S1, S2, S3: out std_logic;
            bits: out std_logic_vector(2 downto 0));
end entity FSM;

architecture bhv of FSM is
	signal states: std_logic_vector(3 downto 0):= "0001";
	signal counter: std_logic_vector(2 downto 0) := "000";

begin
    Main_proc:process(clock)
    begin
        if(reset = '1') then
            states(0) <= '1';
            states(1) <= '0';
            states(2) <= '0';
            states(3) <= '0';

        elsif(rising_edge(clock)) then
            if(states(0) = '1') then
                states(0) <= '0';
                states(1) <= '1';
                states(2) <= '0';
                states(3) <= '0';
                counter <= (others => '0');
            elsif(states(1) = '1') then
                if(END_ins = '1') then
                    states(1) <= '1';
                    states(3) <= '0';
                    states(2) <= '0';
                elsif(Multiple = '1') then
                    states(3) <= '1';
                    states(2) <= '0';
                    states(1) <= '0';
                else
                    states(1) <= '0';
                    states(2) <= '1';
                    states(3) <= '0';
                end if;              
                states(0) <= '0';
                counter <= "000";

            elsif(states(2) = '1') then
                states(2) <= '0';
                states(0) <= '1';
                states(1) <= '0';
                states(3) <= '0';
            else
                if(unsigned(counter) = 7) then
                    states(3) <= '0';
                    states(0) <= '1';
                else
                    states(3) <= '1';
                    states(0) <= '0';
                end if;

                states(1) <= '0';
                states(2) <= '0';
                counter <= std_logic_vector(unsigned(counter) + 1);
            end if;
        end if;
    end process;

    S0 <= states(0);
    S1 <= states(1);
    S2 <= states(2);
    S3 <= states(3);
    bits <= counter;

end bhv;