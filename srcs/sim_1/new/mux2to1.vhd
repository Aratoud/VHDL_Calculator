library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1 is
    PORT ( 
        Zero : in std_logic;
        Sum_i : in std_logic;
        Psel : in std_logic; 
        DataP_i : out std_logic
        );
end mux2to1;

architecture Behavioral of mux2to1 is

begin

        DataP_i <= Zero when (Psel = '0') else Sum_i;
        
        
end Behavioral;
