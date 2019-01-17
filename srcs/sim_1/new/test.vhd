library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity topmodule_tb is
end;

architecture bench of topmodule_tb is

  component topmodule
      generic 
      (
          N_top : integer := 11;
          NN_top : integer := 22
      );
      Port 
      (
          clk : in std_logic;
          resetN : in std_logic;
          Load_A, Load_b, s : in std_logic;
          DataA, DataB : in std_logic_vector(N_top - 1 downto 0);
          output : inout std_logic_vector(NN_top - 1 downto 0);
          done : out std_logic
      );
  end component;

  signal clk: std_logic;
  signal resetN: std_logic;
  signal Load_A, Load_b, s: std_logic;
  signal DataA, DataB: std_logic_vector(11 - 1 downto 0);
  signal output: std_logic_vector(22 - 1 downto 0) ;
  signal done : std_logic;

begin

  -- Insert values for generic parameters !!
  uut: topmodule generic map ( N_top  => 11,
                               NN_top => 22 )
                    port map ( clk    => clk,
                               resetN => resetN,
                               Load_A => Load_A,
                               Load_b => Load_b,
                               s      => s,
                               DataA  => DataA,
                               DataB  => DataB,
                               output => output, 
                               done => done );

  stimulus: process
  begin
  
    -- Put initialisation code here
    wait for 20ns;
    s <= '0';
    DataA <= "00000000101";
    DataB <= "00000000011";
    -- expected outcome "00000001111"
    Load_A <= '1';
    Load_B <= '1'; 
    wait for 20ns;
    Load_A <= '0';
    Load_B <= '0';
    wait for 20ns;
    s <= '1';
    
    -- Put test bench stimulus code here

    wait;
  end process;


end;

