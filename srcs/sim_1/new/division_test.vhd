library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity divisor_tb is
end;

architecture bench of divisor_tb is

  component divisor
      Port ( Dividend : in  STD_LOGIC_VECTOR (21 downto 0);
             Divis : in  STD_LOGIC_VECTOR (10 downto 0);
             clk : in  STD_LOGIC;
             Start : in  STD_LOGIC;
             Remainder : out  STD_LOGIC_VECTOR (10 downto 0);
  	   Quotient : out  STD_LOGIC_VECTOR (10 downto 0);
             Done : out  STD_LOGIC;
             Acc_out : out STD_LOGIC_VECTOR (21 downto 0));
  end component;

  signal Dividend: STD_LOGIC_VECTOR (21 downto 0);
  signal Divis: STD_LOGIC_VECTOR (10 downto 0);
  signal clk: STD_LOGIC;
  signal Start: STD_LOGIC;
  signal Remainder: STD_LOGIC_VECTOR (10 downto 0);
  signal Quotient: STD_LOGIC_VECTOR (10 downto 0);
  signal Done: STD_LOGIC;
  signal Acc_out : STD_LOGIC_VECTOR (21 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: divisor port map ( Dividend  => Dividend,
                          Divis     => Divis,
                          clk       => clk,
                          Start     => Start,
                          Remainder => Remainder,
                          Quotient  => Quotient,
                          Done      => Done,
                          acc_out => acc_out );

  stimulus: process
  begin
  
    -- Put initialisation code here

    start <= '1';
    wait for 10 ns;
    start <= '0';
    wait for 10 ns;
    Dividend <= "0000000000000000001100";
    Divis    <= "00000000011";
    wait for 200ns;
    -- Put test bench stimulus code here

--    stop_the_clock <= true;
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