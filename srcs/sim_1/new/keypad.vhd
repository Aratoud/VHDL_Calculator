LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;



entity matrix_keypad is
	port(
		clk,rst       : in  std_logic;
		col_line      : in  std_logic_vector(3 downto 0);
		row_line      : out std_logic_vector(3 downto 0);
		keypad_output : out std_logic_vector(15 downto 0)
	);
end matrix_keypad;


architecture Behavioral of matrix_keypad is
	
	signal temp : std_logic_vector(29 downto 0);
	
begin
	test : process(clk,rst) is
	begin
		if(rst='0') then
			keypad_output <= "1111111111111111";
			
		elsif rising_edge(clk) then
			temp <= temp + 1;
			
			case temp(10 downto 8) is -- every 5 micro seconds
					
				when "000" => 
					
					row_line <= "0111"; --first row
					
				when "001" => 
					
					if col_line = "0111" then
						
						keypad_output <= "0011001100110011"; -- 1
						
					elsif col_line = "1011" then
						
						keypad_output <= "0010001000100010"; -- 2
						
					elsif col_line = "1101" then
						
						keypad_output <= "0001000100010001"; -- 3
						
					elsif col_line = "1110" then
						
						keypad_output <= "0000000000000000"; -- A
						
					end if;
					
				when "010" => 
					
					row_line <= "1011"; --second row
					
				when "011" => 
					
					if col_line = "1110" then
						
						keypad_output <= "0100010001000100"; -- B
						
					elsif col_line = "1101" then
						
						keypad_output <= "0101010101010101"; -- 6
						
					elsif col_line = "1011" then
						
						keypad_output <= "0110011001100110"; -- 5
						
					elsif col_line = "0111" then
						
						keypad_output <= "0111011101110111"; -- 4
						
					end if;
					
				when "100" => 
					
					row_line <= "1101"; --third row
					
				when "101" => 
					
					if col_line = "1110" then
						
						keypad_output <= "1000100010001000"; -- C
						
					elsif col_line = "1101" then
						
						keypad_output <= "1001100110011001"; -- 9
						
					elsif col_line = "1011" then
						
						keypad_output <= "1010101010101010"; -- 8
						
					elsif col_line = "0111" then
						
						keypad_output <= "1011101110111011"; -- 7
						
					end if;
					
				when "110" => 
					
					row_line <= "1110"; --fourth row
					
				when "111" => 
					
					if col_line = "1110" then
						
						keypad_output <= "1100110011001100"; -- D
						
					elsif col_line = "1101" then
						
						keypad_output <= "1101110111011101"; -- #
						
					elsif col_line = "1011" then
						
						keypad_output <= "1110111011101110"; -- 0
						
					elsif col_line = "0111" then
						
						keypad_output <= "1111111111111111"; -- *
						
					end if;
					
				when others => keypad_output <= "0000000000000000";
					
			end case;
			
		end if;
		
	end process;
	
end Behavioral;