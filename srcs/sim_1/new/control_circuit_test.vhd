library IEEE;
library work;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.commonPackage.all;

entity control_circuit_test is
end;

architecture bench of control_circuit_test is

    component control_unit is
        port (
            clk : in std_logic;
            clear_rst : in std_logic;
            output_reg : out rpn_type_register;
            
            add_input : in std_logic;
            subtract_input : in std_logic;
            multiply_input : in std_logic;
            divide_input : in std_logic;
            enter_input : in std_logic;
            s_ascii_out_input : in std_logic;
            input_keypad_input : in std_logic_vector(3 downto 0 );
            
            -- outputs
            output_string_output : out string(3 downto 1);
            error_out_of_bound_output : out std_logic
        );
        
     end component;
     
     signal clk : std_logic;
     signal clear_rst : std_logic;
     signal output_reg : rpn_type_register;
     
     signal add_input : std_logic;
     signal subtract_input : std_logic;
     signal multiply_input : std_logic;
     signal divide_input : std_logic;
     signal enter_input : std_logic;
     signal s_ascii_out_input : std_logic;
     signal input_keypad_input : std_logic_vector(3 downto 0 );
     
     -- outputs
     signal output_string_output : string(3 downto 1);
     signal error_out_of_bound_output : std_logic;
     
     constant clock_period: time := 10 ns;
     signal stop_the_clock: boolean;
     
begin
    
    uut: control_unit
        port map (
            clk => clk,
            clear_rst => clear_rst,
            output_reg => output_reg,
            add_input => add_input,
            subtract_input => subtract_input,
            multiply_input => multiply_input,
            divide_input => divide_input,
            enter_input => enter_input,
            s_ascii_out_input => s_ascii_out_input,
            input_keypad_input => input_keypad_input,
            
            -- outputs
            output_string_output => output_string_output,
            error_out_of_bound_output => error_out_of_bound_output
        );
        
    stimulus : process
    begin 
        clear_rst <= '0';
        wait for 10ns;
        clear_rst <= '1';
        wait for 10ns;
        s_ascii_out_input <= '0';
        wait for 10ns;
        -- hard since debounce... I give up here!
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
end bench;
