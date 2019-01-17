library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_Dff is
    port 
    (
        Zero : in std_logic;
        A_N_1 : in std_logic; 
        ER0 : in std_logic;
        Clock : in std_logic; 
        R0 : out std_logic
    );

end mux_Dff;

architecture Behavioral of mux_Dff is
    signal temp : std_logic;
begin

    with ER0 select 
        temp <= Zero when '0',
                A_N_1 when others;

    process (clock) 
    begin 
        if rising_edge(clock) then
            R0 <= temp;
        end if;
    end process;
    
end Behavioral;
