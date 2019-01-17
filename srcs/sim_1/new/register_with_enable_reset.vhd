library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_with_enable_reset is
    generic (N : integer);
    port (
        DataP : in std_logic_vector(N - 1 downto 0); 
        ResetN : in std_logic;
        Enable_register_P : in std_logic;
        Clock : in std_logic;
        P : out STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
end register_with_enable_reset;

architecture Behavioral of register_with_enable_reset is

begin
    process(clock, resetN) 
    begin 
        if resetn = '0' then
            p <= (others => '0');
        elsif rising_edge(clock) then
            if Enable_register_P = '1' then
                P <= DataP;
            end if;
        end if;
    end process;

end Behavioral;
