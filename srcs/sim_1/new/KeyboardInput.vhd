library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity KeyboardInput is
	GENERIC(
		clk_freq : INTEGER := 100_000_000; --system clock frequency in Hz
		ps2_debounce_counter_size : INTEGER := 9); --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)
	Port (
		clk : in STD_LOGIC; -- System Clock
		ps2_clk : in STD_LOGIC; --Clock Signal from ps2 keyboard
		ps2_data : in STD_LOGIC; --Data signal from ps2 keyboard
		ascii_new_out : out STD_LOGIC;
		Action : out STD_LOGIC_VECTOR (3 downto 0)); --Action to be taken when a certain key is pressed.
end KeyboardInput;
architecture Behavioral of KeyboardInput is
	COMPONENT ps2_keyboard_to_ascii IS
		GENERIC(
			clk_freq : INTEGER; --system clock frequency in Hz
			debounce_counter_size : INTEGER); --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)
		PORT(
			clk : IN STD_LOGIC; --system clock
			ps2_clk : IN STD_LOGIC; --clock signal from PS2 keyboard
			ps2_data : IN STD_LOGIC; --data signal from PS2 keyboard
			ascii_new : OUT STD_LOGIC; --output flag indicating new ASCII value
			ascii_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)); --ASCII value
	END COMPONENT;
	signal ascii_new : STD_LOGIC;
	signal ascii_code : STD_LOGIC_VECTOR(6 DOWNTO 0);
begin
	ps2_keyboard_0 : ps2_keyboard_to_ascii
		GENERIC MAP(clk_freq => clk_freq, debounce_counter_size => ps2_debounce_counter_size)
		PORT MAP(clk => clk, ps2_clk => ps2_clk, ps2_data => ps2_data, ascii_new => ascii_new, ascii_code => ascii_code);
	Process(ascii_new)	
	BEGIN	
		If( ascii_new = '1') Then	
			CASE ascii_code IS		
				WHEN x"30" => 	
					Action <= "0000" ; --0		
				WHEN x"31" => 	
					Action <= "0001"; --1	
				WHEN x"32" => 	
					Action <= "0010"; --2			
				WHEN x"33" => 	
					Action <= "0011"; --3		
				WHEN x"34" => 	
					Action <= "0100"; --4	
				WHEN x"35" => 	
					Action <= "0101"; --5	
				WHEN x"36" => 	
					Action <= "0110"; --6	
				WHEN x"37" => 	
					Action <= "0111"; --7
				WHEN x"38" => 	
					Action <= "1000"; --8	
				WHEN x"39" => 	
					Action <= "1001"; --9	
				WHEN x"66" => 	
					Action <= "1010";	
				WHEN OTHERS => null;		
			END CASE;
		END IF;	
	END PROCESS;	
	ascii_new_out <= ascii_new;	
end Behavioral;