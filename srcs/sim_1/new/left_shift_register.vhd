library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity left_shift_register is
    generic (N : integer);
    port ( 
        Ain : in std_logic_vector(N - 1 downto 0);
        LoadA : IN STD_LOGIC;
        Enable_register_A : in std_logic;  
        Zero : in std_logic;
        Clock : in std_logic;
        A : inout std_logic_vector(N - 1 downto 0)
        );
end left_shift_register;

architecture Behavioral of left_shift_register is

begin
    process(clock) 
    begin 
        if rising_edge(clock) then
            if LoadA = '1' then
                A <= Ain;
            elsif Enable_register_A = '1' then
                A(N - 1 downto 1) <= A(N - 2 downto 0);
                A(0) <= '0';
            end if; 
        end if;
    end process;

end Behavioral;
