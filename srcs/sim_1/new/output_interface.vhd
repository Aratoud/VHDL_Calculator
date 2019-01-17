library IEEE;
library work;
use work.commonPackage.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity output_interface is
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
end output_interface;
    
architecture Behavioral of output_interface is

    -- vga signals
    signal x_count  : STD_LOGIC_VECTOR (11 downto 0);
    signal Y_count  : STD_LOGIC_VECTOR (11 downto 0);
    
--    -- error signals
    signal error_out_of_bound_signal : std_logic;
    signal error_division_by_zero_signal : std_logic;
    
    component ImgGenModule is
        Port ( clk : in STD_LOGIC;
                x_counter : in  STD_LOGIC_VECTOR (11 downto 0);
                y_counter : in  STD_LOGIC_VECTOR (11 downto 0);
                VGA_RED   : out STD_LOGIC_VECTOR (3 downto 0);
                VGA_GREEN : out STD_LOGIC_VECTOR (3 downto 0);
                VGA_BLUE  : out STD_LOGIC_VECTOR ( 3 downto 0);
                reg       : in rpn_type_register;
                output_string :  in string(3 downto 1);
                
                error_out_of_bound : in std_logic;
                error_division_by_zero : in std_logic
        );
    end component;
    
    component SyncModule is
        Port ( clk : in STD_LOGIC;
            y_control : out STD_LOGIC_VECTOR (11 downto 0);
            x_control : out STD_LOGIC_VECTOR (11 downto 0);
            h_sync    : out STD_LOGIC;
            v_sync    : out STD_LOGIC);
    end component;
begin
    error_out_of_bound_signal <= error_out_of_bound;
    error_division_by_zero_signal <= error_division_by_zero;
    
    -- VGA 
    syncMod      : syncModule port map (
        clk => clk, 
        y_control => y_count, 
        x_control => x_count, 
        h_sync => h_sync, 
        v_sync => v_sync);
    imageGenMod  : ImgGenModule port map (
        clk => clk, 
        VGA_RED => VGA_RED, 
        VGA_GREEN => VGA_GREEN, 
        VGA_BLUE => VGA_BLUE, 
        y_counter => y_count,   
        x_counter => x_count, 
        reg => reg, 
        output_string => output_string,
        
        error_out_of_bound => error_out_of_bound_signal,
        error_division_by_zero => error_division_by_zero_signal
    ); 

end Behavioral;
