library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

package commonPackage is

    constant FONT_WIDTH : integer := 8;
    constant FONT_HEIGHT : integer := 16;
    constant DATA_SIZE : integer := 11;
    constant MOST_SIGNIFICANT_BIT_NUMBER : integer := DATA_SIZE - 1;
    
    
    constant REGISTER_COUNT : integer := 4;
    constant REGISTER_ZERO : signed := "00000000000"; -- 11 bit
    
    constant STRING_DATA_SIZE : integer := 4;
    constant DATA_SIZED_NULL_STRING : string(1 to STRING_DATA_SIZE) := "    ";
    
    type State_type_division IS ( S1, S2, S3, s4 );
    
    type vector_2d is 
    record 
        x : integer;
        y : integer;
    end record;
    
    type rpn_type_register is array(REGISTER_COUNT - 1 downto 0) of signed(DATA_SIZE - 1 downto 0);
    
    function to_string(a : std_logic_vector) return String;    

end commonPackage;

package body commonPackage is
    function to_string ( a: std_logic_vector) return string is
        variable b : string (1 to a'length) := (others => NUL);
        variable stri : integer := 1; 
    begin
        for i in a'length downto 1 loop
            b(stri) := std_logic'image(a((i-1)))(2);
        stri := stri+1;
        end loop;
    return b;
    end function;
end commonPackage;