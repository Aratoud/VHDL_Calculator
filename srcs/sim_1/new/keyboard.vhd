library IEEE;

use IEEE.STD_LOGIC_1164.all;



entity KeyboardInput is

  generic(

    clk_freq : integer := 100_000_000;  --system clock frequency in Hz

    ps2_debounce_counter_size : integer := 9);  --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)

  port (

    clk : in std_logic;                 -- System Clock

    ps2_clk : in std_logic;             --Clock Signal from ps2 keyboard

    ps2_data : in std_logic;            --Data signal from ps2 keyboard

    ascii_new_out : out std_logic;

    Action : out std_logic_vector (3 downto 0));  --Action to be taken when a certain key is pressed.

end KeyboardInput;


architecture Behavioral of KeyboardInput is

  component ps2_keyboard_to_ascii is

    generic(

      clk_freq : integer;               --system clock frequency in Hz

      debounce_counter_size : integer);  --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)

    port(

      clk : in std_logic;               --system clock

      ps2_clk : in std_logic;           --clock signal from PS2 keyboard

      ps2_data : in std_logic;          --data signal from PS2 keyboard

      ascii_new : out std_logic;  --output flag indicating new ASCII value

      ascii_code : out std_logic_vector(6 downto 0));  --ASCII value

  end component;

  signal ascii_new : std_logic;

  signal ascii_code : std_logic_vector(6 downto 0);

begin

  ps2_keyboard_0 : ps2_keyboard_to_ascii

    generic map(clk_freq => clk_freq, debounce_counter_size => ps2_debounce_counter_size)

    port map(clk => clk, ps2_clk => ps2_clk, ps2_data => ps2_data, ascii_new => ascii_new, ascii_code => ascii_code);

  process(ascii_new)

  begin

    if(ascii_new = '1') then

      case ascii_code is

        when x"30" =>

          Action <= "0000";             --0

        when x"31" =>

          Action <= "0001";             --1

        when x"32" =>

          Action <= "0010";             --2


        when x"33" =>

          Action <= "0011";             --3


        when x"34" =>

          Action <= "0100";             --4


        when x"35" =>

          Action <= "0101";             --5


        when x"36" =>

          Action <= "0110";             --6


        when x"37" =>

          Action <= "0111";             --7


        when x"38" =>

          Action <= "1000";             --8


        when x"39" =>

          Action <= "1001";             --9

        when x"66" =>

          Action <= "1010";


        when others => null;

      end case;

      --ELSE

      -- Action <= "0000000000";


    end if;

  end process;

  ascii_new_out <= ascii_new;


end Behavioral;
