library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity down_count_tb is
end;

architecture bench of down_count_tb is

  component down_count
      generic ( modulus : integer );
      port ( 
          Clock : in std_logic; 
          EC : in std_logic; 
          LC : in std_logic; 
          Count : out integer 
      );
  end component;

  signal Clock: std_logic;
  signal EC: std_logic;
  signal LC: std_logic;
  signal Count: integer ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: down_count generic map ( modulus => 11 )
                     port map ( Clock   => Clock,
                                EC      => EC,
                                LC      => LC,
                                Count   => Count );

  stimulus: process
  begin
  
    -- Put initialisation code here
    
    EC <= '0'; -- disable
    LC <= '0'; -- load 
    wait for 10 ns;
    EC <= '1';  -- continue
    LC <= '1';  -- continue
    wait for 50 ns;
    LC <= '0'; -- load
    wait for 10ns;
    LC <= '1';  -- continue

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