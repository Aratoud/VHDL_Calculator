library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_interface is
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
end input_interface;

architecture Behavioral of input_interface is

    component KeyboardInput is
    GENERIC(
        clk_freq : INTEGER := 100_000_000; --system clock frequency in Hz
        ps2_debounce_counter_size : INTEGER := 9); --set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)   
    Port (  
        clk : in STD_LOGIC; -- System Clock       
        ps2_clk : in STD_LOGIC; --Clock Signal from ps2 keyboard     
        ps2_data : in STD_LOGIC; --Data signal from ps2 keyboard      
        ascii_new_out : out STD_LOGIC;  
        Action : out STD_LOGIC_VECTOR (3 downto 0)); --Action to be taken when a certain key is pressed.       
    end component;
    
    COMPONENT debounce IS 
    GENERIC( 
      counter_size : INTEGER); --debounce period (in seconds) = 2^counter_size/(clk freq in Hz) 
    PORT( 
      clk    : IN  STD_LOGIC;  --input clock 
      button : IN  STD_LOGIC;  --input signal to be debounced 
      result : OUT STD_LOGIC); --debounced signal 
    END COMPONENT;
begin
    btn_add      : debounce --port map (clk => clk, btn_in => push_btn(0), btn_out => add);
        GENERIC MAP(counter_size => ps2_debounce_counter_size) 
        PORT MAP(clk => clk, button => push_btn(0), result => add); 
        
    btn_subtract : debounce --port map (clk => clk, btn_in => push_btn(1), btn_out => subtract);
        GENERIC MAP(counter_size => ps2_debounce_counter_size) 
        PORT MAP(clk => clk, button => push_btn(1), result => subtract); 
        
    btn_multiply : debounce --port map (clk => clk, btn_in => push_btn(2), btn_out => multiply);
        GENERIC MAP(counter_size => ps2_debounce_counter_size) 
        PORT MAP(clk => clk, button => push_btn(2), result => multiply); 
            
    btn_divide   : debounce --port map (clk => clk, btn_in => push_btn(3), btn_out => divide);
        GENERIC MAP(counter_size => ps2_debounce_counter_size) 
        PORT MAP(clk => clk, button => push_btn(3), result => divide); 
    
--    btn_enter    : debounce --port map (clk => clk, btn_in => push_btn(4), btn_out => enter);
--        GENERIC MAP(counter_size => ps2_debounce_counter_size) 
--        PORT MAP(clk => clk, button => push_btn(4), result => enter); 

     keyboard: KeyboardInput

    GENERIC MAP( clk_freq => clk_freq,
    
    ps2_debounce_counter_size => ps2_debounce_counter_size)
    
    PORT MAP( 
        clk => clk,
        ps2_clk => ps2_clk,
        ps2_data => ps2_data,
        ascii_new_out => s_ascii_out,
        Action => keypad_input);
        
        
end Behavioral;
