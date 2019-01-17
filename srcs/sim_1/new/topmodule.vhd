library IEEE;
library work;
use work.commonPackage.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity topmodule is 
    generic (
        clk_freq : integer := 100_000_000;
        ps2_debounce_counter_size : INTEGER := 9);
    port (
        clk      : in std_logic;
        ps2_clk  : in std_logic;
        ps2_data : in std_logic;
        push_btn : in std_logic_vector(5 - 1 downto 0);
        clear_rst     : in std_logic;     
        
        test_led : out std_logic_vector(2 downto 0);
        
        -- vga outputs 
        h_sync    : out STD_LOGIC;
        v_sync    : out STD_LOGIC;
        VGA_RED   : out STD_LOGIC_VECTOR (3 downto 0);
        VGA_BLUE  : out STD_LOGIC_VECTOR (3 downto 0);
        VGA_GREEN : out STD_LOGIC_VECTOR (3 downto 0)     
        );
end topmodule;

architecture behaviour of topmodule is 

    
    -- 0000 register_rpn(3)
    -- 0000 register_rpn(2)
    -- 0000 register_rpn(1)
    -- 0000 register_rpn(0)
    
    signal reg : rpn_type_register := (others => ( others => '0'));
     
    signal add : std_logic;
    signal subtract : std_logic;  
    signal multiply : std_logic;    
    signal divide : std_logic;   
    signal enter : std_logic;

    signal output_string : string(3 downto 1) := "   ";
    signal s_ascii_out : std_logic ; 
    signal keypad_input : std_logic_vector(3 downto 0 );
    
    -- error signals
    signal error_out_of_bound : std_logic;
    signal error_division_by_zero : std_logic;
    

    component control_unit is
        port (
            clk : in std_logic;
            clear_rst : in std_logic;
            output_reg : out rpn_type_register;
            output_string_output : out string(3 downto 1);
            add_input : in std_logic;
            subtract_input : in std_logic;
            multiply_input : in std_logic;
            divide_input : in std_logic;
            enter_input : in std_logic;
            s_ascii_out_input : in std_logic;
            input_keypad_input : in std_logic_vector(3 downto 0 );
            test_led : out std_logic_vector(2 downto 0);
            error_out_of_bound : out std_logic;
            error_division_by_zero : out std_logic
        );
    end component control_unit;  

    component input_interface is
        generic (
            clk_freq : integer := 100_000_000;
            ps2_debounce_counter_size : integer);
        port (
            clk : in std_logic;
            ps2_clk  : in std_logic;
            ps2_data : in std_logic;
            push_btn : in std_logic_vector(5 - 1 downto 0);
            add : out std_logic;
            subtract : out std_logic;               
            multiply : out std_logic;
            divide : out std_logic;
            s_ascii_out : out std_logic;
            keypad_input : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component output_interface is
        port (
            clk : in std_logic;
            reg : in rpn_type_register;
            h_sync    : out STD_LOGIC;
            v_sync    : out STD_LOGIC;
            VGA_RED   : out STD_LOGIC_VECTOR (3 downto 0);
            VGA_BLUE  : out STD_LOGIC_VECTOR (3 downto 0);
            VGA_GREEN : out STD_LOGIC_VECTOR (3 downto 0);
            output_string : in string(3 downto 1);
            
            error_out_of_bound : in std_logic;
            error_division_by_zero : in std_logic
                        
        );  
    end component;
                 
begin 
        
    control_unit_uut : control_unit 
        port map (
            clk => clk,
            clear_rst => clear_rst,
            output_reg => reg,
            output_string_output => output_string,
            add_input => add,
            subtract_input => subtract,
            multiply_input => multiply,
            divide_input => divide,
            enter_input => enter,
            s_ascii_out_input => s_ascii_out,
            input_keypad_input => keypad_input,
            test_led => test_led,
            
            error_out_of_bound => error_out_of_bound,
            error_division_by_zero => error_division_by_zero
        );
        
    input_interface_uut : input_interface 
        generic map (
            clk_freq,
            ps2_debounce_counter_size
            )
        port map (
            clk => clk,
            ps2_clk  => ps2_clk,
            ps2_data => ps2_data,
            push_btn => push_btn,
            add => add,
            subtract => subtract,               
            multiply => multiply,
            divide => divide,
            s_ascii_out => s_ascii_out,
            keypad_input => keypad_input
        );   
        
    output_interface_uut : output_interface
        port map (
            clk => clk,
            reg => reg,
            h_sync => h_sync,
            v_sync => v_sync,
            VGA_RED => VGA_RED,
            VGA_BLUE => VGA_BLUE,
            VGA_GREEN => VGA_GREEN,
            output_string => output_string,
            
            error_out_of_bound => error_out_of_bound,
            error_division_by_zero => error_division_by_zero
        ); 
       
end behaviour;


















