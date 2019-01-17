library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity right_shift_register is
    generic (N : integer);
    port (
        DataB : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        LoadB : IN STD_LOGIC;
        Enable_register_B : in std_logic;
        Zero : in std_logic;
        Clock : in std_logic;
        B : inout std_logic_vector(N - 1 downto 0)
        );
end right_shift_register;

architecture Behavioral of right_shift_register is

begin
    process(clock) 
    begin 
        if rising_edge(clock) then
            if LoadB = '1' then  -- synchronous load
                B <= DataB;
            elsif Enable_register_B = '1' then
                B(N - 2 downto 0) <= B(N - 1 downto 1);
                B(N - 1) <= '0';
            end if;
        end if;
    end process;

end Behavioral;
