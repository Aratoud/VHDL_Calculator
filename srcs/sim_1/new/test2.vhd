library IEEE;
library work;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.commonPackage.all;

entity multiply_CIRCUIT_tb is
end;

architecture bench of multiply_CIRCUIT_tb is

  component multiply_CIRCUIT
      GENERIC 
      ( 
          N : integer;
          NN : integer
      );
      PORT ( 
          Clock : IN STD_LOGIC ;
          Resetn : IN STD_LOGIC ;
          Load_A, Load_B, s : IN STD_LOGIC ;
          DataA : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          DataB : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
          P_out : inout STD_LOGIC_VECTOR(NN-1 DOWNTO 0);
          Done : OUT STD_LOGIC;
          state_out : out state_type;
          A_out : out std_logic_vector(NN - 1 downto 0);
          B_out : out std_logic_vector(N - 1 downto 0)
      );
  end component;

  signal Clock: STD_LOGIC;
  signal Resetn: STD_LOGIC := '0';
  signal Load_A, Load_B: STD_LOGIC := '0';
  signal s : std_logic := '0';
  signal DataA: STD_LOGIC_VECTOR(11-1 DOWNTO 0) := "00000000000";
  signal DataB: STD_LOGIC_VECTOR(11-1 DOWNTO 0) := "00000000000";
  signal P: STD_LOGIC_VECTOR(22-1 DOWNTO 0);
  signal Done: STD_LOGIC ;
  signal state_out : state_type;
  signal A_signal : std_logic_vector(22 - 1 downto 0);
  signal B_signal : std_logic_vector(11 - 1 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: multiply_CIRCUIT generic map ( N      => 11,
                                      NN     => 22)
                           port map ( Clock  => Clock,
                                      Resetn => Resetn,
                                      Load_A => Load_A,
                                      Load_B => Load_B,
                                      s      => s,
                                      DataA  => DataA,
                                      DataB  => DataB,
                                      P_out      => P,
                                      Done   => Done,
                                      state_out => state_out,
                                      A_out => A_signal,
                                      B_out => B_signal);

  stimulus: process
  begin
  
    -- Put initialisation code here
    wait for 10ns;
    resetn <= '1';
    wait for 10 ns;
    s <= '0';
    DataA <= "00000001101";
    DataB <= "00000000011";
    -- expected outcome "00000001111"
    Load_A <= '1';
    Load_B <= '1'; 
    wait for 20ns;
    Load_A <= '0';
    Load_B <= '0';
    wait for 20ns;
    s <= '1';
    wait for 300ns;
    s <= '0';
    Load_A <= '1';
    Load_B <= '1';
    DataA <= "00000001010";
    DataB <= "00000000010";
    wait for 20ns;
    Load_A <= '0';
    Load_B <= '0';
    wait for 20ns;
    s <= '1';
--    resetn <= '1';
--    wait for 5 ns;

    -- Put test bench stimulus code here

--    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clock <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;