LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all ;
use IEEE.numeric_std.ALL;

USE work.commonPackage.all ;


ENTITY multiply_CIR IS
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
END multiply_CIR ;

ARCHITECTURE Behavior OF multiply_CIR IS
    
    -- states 
    type state_type is (s1, s2, s3);
    signal current_state : state_type;
    
    -- dummy signals 
    signal Zero : std_logic;
    signal N_Zeros : std_logic_vector(N - 1 downto 0);
    
    -- while right shifting B if it reaches "000...00" then B_reached_zero = '1' otherwise B_reached_zero = '0'
    signal B_reached_zero : std_logic;
    -- Enable signal for Shift register B
    signal Enable_register_B : std_logic;
    -- B shift Register
    signal B : std_logic_vector(N - 1 downto 0);
    
    -- Enable signal for shift register A  
    signal Enable_register_A : std_logic; 
    -- A shfit Register
    signal A : std_logic_vector(NN - 1 downto 0);
    -- dummy variable to construct a bus of size 2 * N for the shift Register A
    signal Ain : std_logic_vector(NN - 1 downto 0);
    
    -- Sum output of the 2 * N bit adder 
    signal Sum : std_logic_vector(NN - 1 downto 0);
    
    -- signal that controls Shift register P 
    signal Enable_register_P : std_logic;
    -- signal that controls load to register P (load either from Sum or 0)
    signal Load_control_register_P : std_logic; 
    -- shift register for P (product)
    signal DataP : std_logic_vector(NN - 1 downto 0);
    
    -- signal output p
    signal output_P : STD_LOGIC_VECTOR(NN-1 DOWNTO 0);
    
    
    component left_shift_register is
        generic (N : integer);
        port ( 
            Ain : in std_logic_vector(N - 1 downto 0);
            LoadA : IN STD_LOGIC;
            Enable_register_A : in std_logic;  
            Zero : in std_logic;
            Clock : in std_logic;
            A : inout std_logic_vector(N - 1 downto 0)
            );
    end component;
    
    component right_shift_register is
        generic (N : integer);
        port (
            DataB : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
            LoadB : IN STD_LOGIC;
            Enable_register_B : in std_logic;
            Zero : in std_logic;
            Clock : in std_logic;
            B : inout std_logic_vector(N - 1 downto 0)
            );
    end component;
    
    component mux2to1 is
        PORT ( 
            Zero : in std_logic;
            Sum_i : in std_logic;
            Psel : in std_logic; 
            DataP_i : out std_logic
            );
    end component;
    
    component register_with_enable_reset
        generic (N : integer);
        port (
            DataP : in std_logic_vector(N - 1 downto 0); 
            ResetN : in std_logic;
            Enable_register_P : in std_logic;
            Clock : in std_logic;
            P : out STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    end component;
    
    
begin 
--    state_out <= current_state;
--    A_out <= A;
--    B_out <= B;
    P_out <= output_P; 
    
    FSM_transitions : process( resetn, clock)
    begin
        if resetn = '0' then
            current_state <= s1;
        elsif rising_edge(clock) then
            case current_state is 
                when s1 => 
                    if s = '0' then 
                        current_state <= s1;
                    else 
                        current_state <= s2;
                    end if;
                when s2 =>
                    if B_reached_zero = '0' then -- B is not "00..000" yet so continue the caluculation 
                        current_state <= s2;
                    else 
                        current_state <= s3;     -- B has reached the "00..000" so stop the calculation and go to S3
                    end if;
                when s3 =>
                    if s = '1' then 
                        current_state <= s3;
                    else 
                        current_state <= s1;
                    end if;
            end case;
        end if;               
    end process;
    
    FSM_outputs : process(current_state, s, B(0)) 
    begin 
        Enable_register_P <= '0'; Enable_register_A <= '0'; Enable_register_B <= '0'; Done <= '0'; Load_control_register_P <= '0';
        case current_state is
            when s1 => 
                Enable_register_P <= '1';
            when s2 => 
                Enable_register_A <= '1'; Enable_register_B <= '1'; Load_control_register_P <= '1';
                if B(0) = '1' then 
                    Enable_register_P <= '1'; 
                else 
                    Enable_register_P <= '0'; -- disable writing to register since we won't add only Shift 
                end if;
            when s3 =>
                Done <= '1';
        end case;
    end process;
    
    Zero <= '0';
    N_Zeros <= (others => '0');
    Ain <= N_Zeros & DataA;
    
    shiftA : left_shift_register  -- for shift register A
        generic map (N => NN)
        port map    ( Ain => Ain, LoadA => Load_A, Enable_register_A => Enable_register_A, Zero => Zero, Clock => Clock, A => A);
    
    shiftB : right_shift_register -- for shit register B
        generic map (N => N)
        port map    (DataB => DataB, LoadB => Load_B, Enable_register_B => Enable_register_B, Zero => Zero, Clock => Clock, B => B);
    
    B_reached_zero <= '1' when B = N_Zeros else '0';
    
    
    Sum <= A + output_P;
    
    -- Define the 2n 2-to-1 multiplexers for DataP
    GenMUX: FOR i IN 0 TO NN-1 GENERATE
        Muxi: mux2to1 PORT MAP ( Zero => Zero, Sum_i => Sum(i), Psel => Load_control_register_P, DataP_i => DataP(i) ) ;
    END GENERATE;
    
    RegP : register_with_enable_reset 
        generic map (N => NN)
        port map (DataP => DataP, ResetN => ResetN, Enable_register_P => Enable_register_P, Clock => Clock, P => output_P);
        
END Behavior ;