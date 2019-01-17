library IEEE;
library work;
use work.commonPackage.all;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ALU is
  Port (
        clk    : in std_logic;
        Reset  : in std_logic; -- active high
        input1 : in signed(DATA_SIZE - 1 DOWNTO 0);
        input2 : in signed(DATA_SIZE - 1 DOWNTO 0);
        output : out signed(DATA_SIZE - 1 DOWNTO 0);
        operation : in std_logic_vector(4 - 1 downto 0)
        );
end ALU;

architecture Behavioral of ALU is
--    signal input1_signal : signed(DATA_SIZE - 1 DOWNTO 0);
--    signal input2_signal : signed(DATA_SIZE - 1 DOWNTO 0);
--    signal output_signal  : signed(DATA_SIZE - 1 DOWNTO 0);
--    signal operation_signal  : std_logic_vector(4 - 1 downto 0);
    
--    signal mul_temp : signed(2 * DATA_SIZE - 1 downto 0);
--    signal div_temp : signed(2 * DATA_SIZE - 1 downto 0);
    
    -- state var
--    signal done_signal : std_logic;
--    signal output_std_logic : std_logic_vector(DATA_SIZE - 1 DOWNTO 0);    
--    signal multiplication_output : std_logic_vector(2 * DATA_SIZE - 1 DOWNTO 0);
--    signal s_for_multiplication : std_logic;
--    signal loadAB_signal : std_logic;
    
--    component multiply IS
--        GENERIC 
--        ( 
--            N : integer;
--            NN : integer  -- stands for 2 * N
--        );
--        PORT ( 
--            Clock : IN STD_LOGIC ;
--            Resetn : IN STD_LOGIC ;
--            Load_A, Load_B, s : IN STD_LOGIC ;
--            DataA : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
--            DataB : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
--            P : inout STD_LOGIC_VECTOR(NN-1 DOWNTO 0);
--            Done : OUT STD_LOGIC 
--        );
--    END component ;
    
begin
    
    process (operation) 
    begin
        case operation is 
            when "0001" => output <= input2 + input1;
            when "0010" => output <= input2 - input1;
            when "0100" => output <= input2 + input1;
            when "1000" => output <= input2 - input1;
            when others => output <= REGISTER_ZERO;
        end case;
    end process;
    
--    output <= REGISTER_ZERO;
--    loadAB_signal <= not s_for_multiplication;
--    multiplication_module : multiply 
--        generic map 
--        ( 
--            N => DATA_SIZE,
--            NN => 2 * DATA_SIZE
--        )
--        port map 
--        (
--            clock => clk,
--            ResetN => Reset, 
--            Load_A => '1',
--            Load_B => '1',
--            s => s_for_multiplication,
--            DataA => std_logic_vector(input1),
--            DataB => std_logic_vector(input2),
--            P => multiplication_output,
--            done => done_signal
--        );
    
--    process ( operation_signal ) 
--    begin 
--        if operation_signal = "0001" then -- +
--            output_signal <= input2 + input1;
----            s_for_multiplication <= '0'; -- we load
--        elsif operation_signal = "0010" then -- -
--            output_signal <= input2 - input1;
----            s_for_multiplication <= '0'; -- we load
--        elsif operation_signal = "0100" then -- *
----            mul_temp <= input1 * input2;
----            output <= mul_temp(10 downto 0);
----            s_for_multiplication <= '1'; -- we calculate
----            output <= signed(multiplication_output(DATA_SIZE - 1 DOWNTO 0));
----            output <= input2 * input1;
            
--        elsif operation_signal = "1000" then -- /
----            output <= input2 / input1;
----            s_for_multiplication <= '0'; -- we load
--            --output <= div_temp(3 downto 0);
--        else 
--            output_signal <= REGISTER_ZERO;
--        end if;
--    end process;

--    input1_signal <= input1;
--    input2_signal <= input2;
----    output <= output_signal;
--    operation_signal <= operation;
--    output <= output_signal;
    
end Behavioral;
