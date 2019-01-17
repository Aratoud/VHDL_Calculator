--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

--entity button_debouncer is
--    Port ( 
--        clk : in STD_LOGIC;
--        btn_in : in STD_LOGIC;
--        btn_out : out STD_LOGIC
--      );
--end button_debouncer;

--architecture Behavioral of button_debouncer is
--    constant COUNTER_SIZE : integer := 20;
    
--    signal flipflop1 : std_logic;
--    signal flipflop2 : std_logic;
--    signal counter_reset : std_logic;
--    signal counter_out : std_logic_vector(COUNTER_SIZE-1 downto 0) := (others => '0');
    
--begin
    
--    process(clk) 
--    begin 
--        if (rising_edge(clk)) then
--            flipflop1 <= btn_in;
--            flipflop2 <= flipflop1;
--            if ( counter_reset = '1') then
--                counter_out <= (others => '0');
--            elsif counter_out(COUNTER_SIZE-1) = '0' then -- signal is not stable yet
--                counter_out <= counter_out + 1; -- keep counting
--            else 
--                btn_out <= flipflop2;
--            end if;
--        end if;
--    end process;
--end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
ENTITY debounce IS
--  GENERIC(
--    counter_size  :  INTEGER := 19); --counter size (19 bits gives 10.5ms with 50MHz clock)
  PORT(
    clk     : IN  STD_LOGIC;  --input clock
    button  : IN  STD_LOGIC;  --input signal to be debounced
    result  : OUT STD_LOGIC); --debounced signal
END debounce;
ARCHITECTURE logic OF debounce IS
  constant counter_size : integer := 19;  

  SIGNAL flipflops   : STD_LOGIC_VECTOR(1 DOWNTO 0); --input flip flops
  SIGNAL counter_set : STD_LOGIC;                    --sync reset to zero
  SIGNAL counter_out : STD_LOGIC_VECTOR(counter_size DOWNTO 0) := (OTHERS => '0'); --counter output
  
BEGIN
  counter_set <= flipflops(0) xor flipflops(1);   --determine when to start/reset counter
  
  PROCESS(clk)
  BEGIN
    IF(clk'EVENT and clk = '1') THEN
      flipflops(0) <= button;
      flipflops(1) <= flipflops(0);
      If(counter_set = '1') THEN                  --reset counter because input is changing
        counter_out <= (OTHERS => '0');
      ELSIF(counter_out(counter_size) = '0') THEN --stable input time is not yet met
        counter_out <= counter_out + 1;
      ELSE                                        --stable input time is met
        result <= flipflops(1);
      END IF;    
    END IF;
  END PROCESS;
END logic;