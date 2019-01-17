LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all ;

entity down_count is
    generic ( modulus : integer ); -- for example 11
    port ( 
        Clock : in std_logic; 
        EC : in std_logic; 
        LC : in std_logic; 
        Count : out integer 
    );
end down_count;

architecture Behavioral of down_count is
    signal count_signal : integer ;
    
begin
    process(clock, EC) 
    begin 
        if EC = '0' then
            count_signal <= modulus - 1;
        elsif rising_edge(clock) then
--            if LC = '1' then
--                count_signal <= modulus - 1;
            if LC = '1' then --  EC = '0' reset!
               count_signal <= modulus - 1;
            else
                count_signal <= count_signal - 1;
            end if;
        end if;
    end process;

    count <= count_signal;
    
end Behavioral;
