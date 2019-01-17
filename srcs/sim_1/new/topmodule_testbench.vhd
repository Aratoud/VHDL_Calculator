library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
library work;
use work.commonPackage.all;

entity topmodule_tb is
end;

architecture bench of topmodule_tb is

  component topmodule 
      port (
          clk      : in std_logic;
          push_btn : in std_logic_vector(2 downto 0);
          input    : in std_logic_vector(DATA_SIZE - 1 downto 0);
          h_sync    : out STD_LOGIC;
          v_sync    : out STD_LOGIC;
          VGA_RED   : out STD_LOGIC_VECTOR (3 downto 0);
          VGA_BLUE  : out STD_LOGIC_VECTOR (3 downto 0);
          VGA_GREEN : out STD_LOGIC_VECTOR (3 downto 0));
  end component;

  signal clk: std_logic;
  signal push_btn: std_logic_vector(2 downto 0);
  signal input: std_logic_vector(DATA_SIZE - 1 downto 0);
  signal h_sync: STD_LOGIC;
  signal v_sync: STD_LOGIC;
  signal VGA_RED: STD_LOGIC_VECTOR (3 downto 0);
  signal VGA_BLUE: STD_LOGIC_VECTOR (3 downto 0);
  signal VGA_GREEN: STD_LOGIC_VECTOR (3 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: topmodule port map ( clk       => clk,
                            push_btn  => push_btn,
                            input     => input,
                            h_sync    => h_sync,
                            v_sync    => v_sync,
                            VGA_RED   => VGA_RED,
                            VGA_BLUE  => VGA_BLUE,
                            VGA_GREEN => VGA_GREEN );

  stimulus: process
  begin
  
    -- Put initialisation code here
    input <= REGISTER_ZERO;
    

    -- Put test bench stimulus code here
    wait for 50ms;
    push_btn <= "100";
    wait for 50ms;
    input <= "0000000000011001";
    wait for 50ms;
    push_btn <= "100";
    wait for 50ms;
    push_btn <= "001";

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;