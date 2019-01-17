library IEEE;
library work;
use work.commonPackage.all;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity control_unit is
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
--        error_out_of_bound_output : out std_logic;
        test_led : out std_logic_vector(2 downto 0);
        error_out_of_bound : out std_logic;
        error_division_by_zero : out std_logic
    );
end control_unit;

architecture Behavioral of control_unit is

--    signal test_led : std_logic_vector(3 downto 0) := "0000";
    
    signal reg : rpn_type_register := (others => ( others => '0'));
    
    signal add : std_logic;
    signal last_add_state : std_logic;
    
    signal subtract : std_logic;
    signal last_subtract_state : std_logic;
    
    signal multiply : std_logic;
    signal last_multiply_state : std_logic;
        
        
    signal divide : std_logic;
    signal last_divide_state : std_logic;
    
    signal enter : std_logic;
    signal last_enter_state : std_logic;
    
    signal int_data : integer;
    signal output_string : string(3 downto 1) := "   ";
    signal signed_output : signed( DATA_SIZE -1 DOWNTO 0);
    signal operation_signal : std_logic_vector(4 - 1 downto 0);
    signal s_ascii_out : std_logic ; 
    signal last_keypress_state : std_logic;
    signal keypad_input : std_logic_vector(3 downto 0 );
    
    signal error_check : signed( DATA_SIZE DOWNTO 0);
    
    -- error string
--    signal error_out_of_bound : std_logic;
--    signal error_division_by_zero : std_logic;
--    signal temp_for_error_testing : signed(DATA_SIZE - 1 downto 0);
    
--    signal input2_signal : signed(DATA_SIZE - 1 downto 0);
--    signal input1_signal : signed(DATA_SIZE - 1 DOWNTO 0);
    
    
    -- division circuit dummies
--    signal signal_busy : std_logic;
--    signal mul_result : std_logic_vector(2 * DATA_SIZE - 1 downto 0);
--    signal signal_s : std_logic;
--    signal done : std_logic; 
--    signal hello_temp : std_logic_vector(DATA_SIZE - 1 downto 0);
    
--    component ALU is
--      Port (
--            clk    : in std_logic;
--            Reset  : in std_logic; 
--            input1 : in signed(DATA_SIZE - 1 DOWNTO 0);
--            input2 : in signed(DATA_SIZE - 1 DOWNTO 0);
--            output : out signed(DATA_SIZE - 1 DOWNTO 0);
--            operation : in std_logic_vector(4 - 1 downto 0)
--            );
--    end component;

--    component division_controller IS
--     PORT(
--         clock : IN STD_LOGIC; --system clock
--         reset_n : IN STD_LOGIC; --resets on logic low
--         enable : IN STD_LOGIC; --signal high for division to start
--         busy : OUT STD_LOGIC; --goes high when busy, low when done
--         divisor : IN STD_LOGIC_VECTOR(7 DOWNTO 0); --2 digit divisor
--         dividend : IN STD_LOGIC_VECTOR(23 DOWNTO 0); --6 digit dividend
--         quotient : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);--6 digit quotient result
--         remainder : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --2 digit remainder result
--         subtrahend : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);--output to bcd adder
--         minuend : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);--output to bcd adder
--         result : IN STD_LOGIC_VECTOR(11 DOWNTO 0)); --input from bcd adder
--    END component;
    
    
    component multiply_CIR IS
        GENERIC 
        ( 
            N : integer;
            NN : integer  -- stands for 2 * N
        );
        PORT ( 
            Clock : IN STD_LOGIC ;
            Resetn : IN STD_LOGIC ;
            Load_A, Load_B, s : IN STD_LOGIC ;
            DataA : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            DataB : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            P_out : out STD_LOGIC_VECTOR(NN-1 DOWNTO 0);
            Done : OUT STD_LOGIC 
        );
    END component ;
    
    signal signal_s : std_logic;
    signal load_A_signal : std_logic;
    signal load_B_signal : std_logic;
    signal dataB_temp : std_logic_vector(DATA_SIZE - 1 downto 0);
    signal dataA_temp : std_logic_vector(DATA_SIZE - 1 downto 0);
    signal mul_result : std_logic_vector(2 * DATA_SIZE - 1 downto 0);
    signal done : std_logic;
    type mul_state is (stop, go);
    signal current_mul_state : mul_state;
    
    signal to_temp : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
begin
--    with current_mul_state select test_led(1 downto 0)
--        <= "10" when go, 
--           "01" when others;
--    test_led(2) <= done; 
           
    dataB_temp <= std_logic_vector(to_signed(int_data, reg(0)'length));
    dataA_temp <= std_logic_vector(reg(0));
--    to_temp <= mul_result(2 * DATA_SIZE -1 DOWNTO DATA_SIZE);
    
--    with to_temp select
--        error_out_of_bound <= '0' when "00000000000",
--                              '1' when others;
--    process(error_check, clear_rst) 
--    begin 
--        if clear_rst = '0' then
--            error_out_of_bound <= '0';
        

--    end process;
    
    mul_FSM : process(clear_rst, clk) 
    begin 
        if clear_rst = '0' then
                current_mul_state <= stop;
                test_led <= "000";
            elsif rising_edge(clk) then
                case current_mul_state is 
                    when stop => 
                        if multiply = '1' and last_multiply_state = '0' then 
                            current_mul_state <= go;
                            test_led(1 downto 0) <= "00";
                            test_led(2) <= '1';
                        else 
                            current_mul_state <= stop;
                            test_led(1 downto 0) <= "01";
                        end if;
                    when go =>
                        if done = '1' then -- done! can go to stable state  multiply = '1' and last_multiply_state = '0' and 
                            current_mul_state <= stop;
                            test_led(1 downto 0) <= "10";
                        else 
                            current_mul_state <= go;  -- remain in multiplication period
                            test_led(1 downto 0) <= "11";
                        end if;
                end case;
                
                last_multiply_state <= multiply;
                
            end if;         
    end process;
    
    test : process(current_mul_state) 
    begin 
        if current_mul_state = go then
            
            signal_s <= '1';
            load_A_signal <= '0';
            load_B_signal <= '0'; 
                                     
        elsif current_mul_state = stop then
            
            signal_s <= '0';
            load_A_signal <= '1';
            load_B_signal <= '1';

        end if;
    end process;
    
--    mul_data_FSM : process(current_mul_state) 
--    begin 
--        if current_mul_state = go then--multiply = '1' and last_multiply_state = '0' then
----            operation_signal <= "0100";
----            reg(0) <= signed_output;
----            reg(0) <= reg(0) * to_signed(int_data, reg(0)'length);
--            reg(0) <= signed(mul_result(DATA_SIZE -1 DOWNTO 0));
--            output_string <= "   ";            
--        end if;
--    end process;
    
    
    
    mul_uut : multiply_CIR
        GENERIC map 
        ( 
            N => DATA_SIZE,
            NN => 2 * DATA_SIZE
        )
        PORT map( 
            Clock => CLK,
            Resetn => clear_rst,
            s => signal_s,
            Load_A => load_A_signal,
            Load_B => load_B_signal,
            DataA => dataA_temp,
            DataB => dataB_temp,
            P_out => mul_result,
            Done => done
        );
    
--    division_uut : division_controller port map (
--        clock => clk, 
--        reset_n => clear_rst,
--        enable => '1',
--        busy => signal_busy,
--        divisor : std_logic_vector(to_signed(int_data, reg(0)'length)),
--        dividend : std_logic_vector(reg(0)),
--        quotient : division_result,
--        remainder : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --2 digit remainder result
--        subtrahend : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);--output to bcd adder
--        minuend : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);--output to bcd adder
--        result : IN STD_LOGIC_VECTOR(11 DOWNTO 0)); --input from bcd adder
--    test_led <= keypad_input;
--    input2_signal <= to_signed(int_data, reg(0)'length); -- good
--    input1_signal <= reg(0);  -- good 
    
    
--    process(operation_signal) 
--    begin 
--        case operation_signal is 
--            when "0001" => signed_output <= input2_signal + input1_signal;
--            when "0010" => signed_output <= input2_signal - input1_signal;
--            when "0100" => signed_output <= input2_signal + input1_signal;
--            when "1000" => signed_output <= input2_signal - input1_signal;
--            when others => signed_output <= REGISTER_ZERO;
--        end case;       
--    end process;
--    ALU_uut : ALU port map 
--    (
--        clk => clk, 
--        Reset => clear_rst,
--        input1 => input1_signal,
--        input2 => input2_signal,
--        output => signed_output, 
--        operation => operation_signal 
--    );
        
--    error_check : process(clk) 
--    begin 
--        temp_for_error_testing <= reg(1) + reg(0);
--        if ( add = '1' and last_add_state = '0' ) then
        
--            if (reg(1)(MOST_SIGNIFICANT_BIT_NUMBER) = '0' and reg(0)(MOST_SIGNIFICANT_BIT_NUMBER) = '0' 
--                    and temp_for_error_testing(MOST_SIGNIFICANT_BIT_NUMBER) = '1') 
--                OR (reg(1)(MOST_SIGNIFICANT_BIT_NUMBER) = '1' and reg(0)(MOST_SIGNIFICANT_BIT_NUMBER) = '1' 
--                    and temp_for_error_testing(MOST_SIGNIFICANT_BIT_NUMBER) = '0') then
--                error_out_of_bound <= '1';
--            else
--                error_out_of_bound <= '0'; 
--            end if;
            
--        elsif ( subtract = '1' and last_subtract_state = '0' ) then
            
--            if (reg(1)(MOST_SIGNIFICANT_BIT_NUMBER) = '0' and reg(0)(MOST_SIGNIFICANT_BIT_NUMBER) = '0' 
--                    and temp_for_error_testing(MOST_SIGNIFICANT_BIT_NUMBER) = '1') 
--                OR (reg(1)(MOST_SIGNIFICANT_BIT_NUMBER) = '1' and reg(0)(MOST_SIGNIFICANT_BIT_NUMBER) = '1' 
--                    and temp_for_error_testing(MOST_SIGNIFICANT_BIT_NUMBER) = '0') then
--                error_out_of_bound <= '1';
--            else
--                error_out_of_bound <= '0'; 
--            end if;
        
--        end if;                    
--    end process;
    
    rpn_calculator : process(clk, clear_rst) 
    begin 
    if clear_rst = '0' then
        reg <= (others => ( others => '0'));    
        output_string <= "   ";
        error_division_by_zero <= '0';
        error_out_of_bound <= '0';
        
    elsif rising_edge(clk) then

        if add = '1' and last_add_state = '0' and current_mul_state = stop then
    --            operation_signal <= "0001";
    --            reg(0) <= signed_output;
            reg(0) <= reg(0) + to_signed(int_data, reg(0)'length);
            output_string <= "   ";
            
            error_check <= ('0' & reg(0)) + ('0' & to_signed(int_data, reg(0)'length));
                                       
    --            signal_s <= '0';
    --            load_A_signal <= '1';
    --            load_B_signal <= '1';
                
        elsif subtract = '1' and last_subtract_state = '0' and current_mul_state = stop then
    --            operation_signal <= "0010";
    --            reg(0) <= signed_output;
            reg(0) <= reg(0) - to_signed(int_data, reg(0)'length);
            output_string <= "   ";
            
            error_check <= ('0' & reg(0)) - ('0' & to_signed(int_data, reg(0)'length));
            
        elsif current_mul_state = go then--multiply = '1' and last_multiply_state = '0' then
            
            reg(0) <= signed(mul_result(DATA_SIZE -1 DOWNTO 0));
            output_string <= "   "; 
            
            to_temp <= mul_result(2 * DATA_SIZE -1 DOWNTO DATA_SIZE);
            if to_temp = "00000000000" then
                error_out_of_bound <= '0';
            else
                error_out_of_bound <= '1';
            end if;
            
            --error_check <= reg(0) + to_signed(int_data, reg(0)'length);
            
        elsif divide = '1' and last_divide_state = '0' then
            reg(0) <= reg(0) / to_signed(int_data, reg(0)'length);
            output_string <= "   ";
            
            error_check <= ('0' & reg(0)) / ('0' & to_signed(int_data, reg(0)'length));
            
            if to_signed(int_data, reg(0)'length) = "00000000000" then
                error_division_by_zero <= '1';
            else 
                error_division_by_zero <= '0';
                
            end if;
            
        -- append the third string from right
        elsif output_string = "   "    and keypad_input = "0001" and (s_ascii_out = '1' and last_keypress_state = '0') then
            output_string(3) <= '1';
            int_data <= 1;
        elsif output_string = "   " and keypad_input = "0010" and (s_ascii_out = '1' and last_keypress_state = '0') then
            output_string(3) <= '2';
            int_data <= 2;
        elsif output_string = "   " and keypad_input = "0011" and (s_ascii_out = '1' and last_keypress_state = '0') then
            output_string(3) <= '3';
            int_data <= 3;
        elsif output_string = "   " and keypad_input = "0100" and (s_ascii_out = '1' and last_keypress_state = '0') then
            output_string(3) <= '4';
            int_data <= 4;
        elsif output_string = "   " and keypad_input = "0101" and (s_ascii_out = '1' and last_keypress_state = '0') then
            output_string(3) <= '5';
            int_data <= 5;
        elsif output_string = "   " and keypad_input = "0110" and (s_ascii_out = '1' and last_keypress_state = '0') then
            output_string(3) <= '6';
            int_data <= 6;
        elsif output_string = "   " and keypad_input = "0111" and (s_ascii_out = '1' and last_keypress_state = '0') then
            output_string(3) <= '7';
            int_data <= 7;
        elsif output_string = "   " and keypad_input = "1000" and (s_ascii_out = '1' and last_keypress_state = '0') then
            output_string(3) <= '8';
            int_data <= 8;
        elsif output_string = "   " and keypad_input = "1001" and (s_ascii_out = '1' and last_keypress_state = '0') then
            output_string(3) <= '9';
            int_data <= 9;
        elsif output_string = "   " and keypad_input = "0000" and (s_ascii_out = '1' and last_keypress_state = '0') then
            output_string(3) <= '0';
            int_data <= 0;
        
        -- append the second string from right
        elsif output_string(3) /= ' ' and output_string(2 downto 1) = "  " and keypad_input = "0001" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(2) <= '1';
            int_data <= (int_data * 10) + 1;
            
        elsif output_string(3) /= ' ' and output_string(2 downto 1) = "  " and keypad_input = "0010" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
           
            output_string(2) <= '2';
            int_data <= (int_data * 10) + 2;
            
        elsif output_string(3) /= ' ' and output_string(2 downto 1) = "  " and keypad_input = "0011" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(2) <= '3';
            int_data <= (int_data * 10) + 3;
        
        elsif output_string(3) /= ' ' and output_string(2 downto 1) = "  " and keypad_input = "0100" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(2) <= '4';
            int_data <= (int_data * 10) + 4;
            
        elsif output_string(3) /= ' ' and output_string(2 downto 1) = "  " and keypad_input = "0101" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(2) <= '5';
            int_data <= (int_data * 10) + 5;
            
        elsif output_string(3) /= ' ' and output_string(2 downto 1) = "  " and keypad_input = "0110" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(2) <= '6';
            int_data <= (int_data * 10) + 6;
            
        elsif output_string(3) /= ' ' and output_string(2 downto 1) = "  " and keypad_input = "0111" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(2) <= '7';
            int_data <= (int_data * 10) + 7;
            
        elsif output_string(3) /= ' ' and output_string(2 downto 1) = "  " and keypad_input = "1000" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(2) <= '8';
            int_data <= (int_data * 10) + 8;
            
        elsif output_string(3) /= ' ' and output_string(2 downto 1) = "  " and keypad_input = "1001"    
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(2) <= '9';
            int_data <= (int_data * 10) + 9;
            
        elsif output_string(3) /= ' ' and output_string(2 downto 1) = "  " and keypad_input = "0000" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(2) <= '0';
            int_data <= (int_data * 10) + 0;
            
        -- append the first string from right
        elsif output_string(3) /= ' ' and output_string(2) /= ' ' and output_string(1) = ' ' and keypad_input = "0001" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(1) <= '1';
            int_data <= (int_data * 10) + 1;
            
        elsif output_string(3) /= ' ' and output_string(2) /= ' ' and output_string(1) = ' ' and keypad_input = "0010" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(1) <= '2';
            int_data <= (int_data * 10) + 2;
            
        elsif output_string(3) /= ' ' and output_string(2) /= ' ' and output_string(1) = ' ' and keypad_input = "0011" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
           
            output_string(1) <= '3';
            int_data <= (int_data * 10) + 3;
            
        elsif output_string(3) /= ' ' and output_string(2) /= ' ' and output_string(1) = ' ' and keypad_input = "0100" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(1) <= '4';
            int_data <= (int_data * 10) + 4;
            
        elsif output_string(3) /= ' ' and output_string(2) /= ' ' and output_string(1) = ' ' and keypad_input = "0101" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(1) <= '5';
            int_data <= (int_data * 10) + 5;
            
        elsif output_string(3) /= ' ' and output_string(2) /= ' ' and output_string(1) = ' ' and keypad_input = "0110" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(1) <= '6';
            int_data <= (int_data * 10) + 6;
            
        elsif output_string(3) /= ' ' and output_string(2) /= ' ' and output_string(1) = ' ' and keypad_input = "0111" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(1) <= '7';
            int_data <= (int_data * 10) + 7;
            
        elsif output_string(3) /= ' ' and output_string(2) /= ' ' and output_string(1) = ' ' and keypad_input = "1000" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(1) <= '8';
            int_data <= (int_data * 10) + 8;
            
        elsif output_string(3) /= ' ' and output_string(2) /= ' ' and output_string(1) = ' ' and keypad_input = "1001" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(1) <= '9';
            int_data <= (int_data * 10) + 9;
            
        elsif output_string(3) /= ' ' and output_string(2) /= ' ' and output_string(1) = ' ' and keypad_input = "0000" 
            and (s_ascii_out = '1' and last_keypress_state = '0') then
            
            output_string(1) <= '0';
            int_data <= (int_data * 10) + 0;      
              
        end if;
        
        last_add_state <= add;
        
        last_subtract_state <= subtract;
        
        
        
        last_divide_state <= divide;
        
        last_enter_state <= enter;
        
        last_keypress_state <= s_ascii_out;
        
        
        
        --last_keypad_input_state <= keypad_input;
    end if;
    end process;
    
    -- inputs
    -- signals <= entity inputs
    add <= add_input;
    subtract <= subtract_input;
    multiply <= multiply_input;
    divide <= divide_input;
    enter <= enter_input; 
    s_ascii_out <= s_ascii_out_input;
    keypad_input <= input_keypad_input;
    
    -- output
    -- entity outputs <= signals
    output_string_output <= output_string;
    output_reg <= reg;
    
end Behavioral;
