library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divisor is
    Port ( Dividend : in  STD_LOGIC_VECTOR (21 downto 0); -- 22 bit
           Divis : in  STD_LOGIC_VECTOR (10 downto 0); -- 11 bit
           clk : in  STD_LOGIC;
           Start : in  STD_LOGIC;
           Remainder : out  STD_LOGIC_VECTOR (10 downto 0);
	       Quotient : out  STD_LOGIC_VECTOR (10 downto 0);
           Done : out  STD_LOGIC;
           Acc_out : out STD_LOGIC_VECTOR (21 downto 0));
end divisor;

architecture Behavioral of divisor is

signal DivBuf: STD_LOGIC_VECTOR (10 downto 0);
-- signal DivNeg: STD_LOGIC_VECTOR (3 downto 0);

signal ACC: STD_LOGIC_VECTOR (21 downto 0);
signal sum: STD_LOGIC_VECTOR (10 downto 0);
signal Remaind :  STD_LOGIC_VECTOR (3 downto 0);

type state is (S0, S1, S2, S3, S4);
signal FSM_cur_state, FSM_nx_state: state;
Signal Counter: STD_LOGIC_VECTOR (3 downto 0);
signal INC_CNT: STD_LOGIC;
signal LD_high: STD_LOGIC;
signal AccShift_left0: STD_LOGIC;
signal AccShift_left1: STD_LOGIC;
--signal addd: STD_LOGIC;
--signal subb: STD_LOGIC;
signal FSM_Done: STD_LOGIC;
--signal sum: STD_LOGIC_VECTOR(3 downto 0);

begin
Acc_out <= Acc;
DivisorReg: process (clk, start)
begin
   if clk'event and clk = '1' then 
	  if start = '1' then
	  DivBuf <= Divis;
	  end if;
	 end if;
end process;

ComboSum: process(DivBuf, ACC)
begin
    	 sum <= ACC(21 downto 11) + (not(DivBuf) + 1);
end process;

ACCReg: process (clk, start, Dividend, sum,
  AccShift_left0, AccShift_left1, LD_high)
begin
   if clk'event and clk = '1' then
	  if start = '1' then
	  ACC <= Dividend(20 downto 0)&'0';	
	  
	  elsif  LD_high = '1' then 
	     ACC(21 downto 11) <= sum;
	  elsif AccShift_left0 = '1' then
			ACC <= ACC(20 downto 0) & '0';
	     elsif AccShift_left1 = '1' then
	     ACC <= ACC(20 downto 0) & '1';
	 end if;
	 end if;	
end process;

-- output the results
Result: process(ACC)
begin  
	 Quotient  <= ACC(10 downto 0);	 
	 Remainder <= '0'&ACC(21 downto 12);	 
end process;

-- Combo Control Output
ComboFSMoutput: process(FSM_cur_State, start, sum, FSM_done)
begin
   INC_CNT <= '0';
   LD_high <= '0';
   AccShift_left0 <= '0';
   AccShift_left1 <= '0';
	case FSM_cur_State is 
	when S0 =>
	          if start = '1' then 
				 FSM_nx_State <= S0;
				 elsif sum(10) = '0' then 
				 FSM_nx_State <= S1;		 
				 else 
				 FSM_nx_State <= S2;
				 end if;
				 
	when S1 =>
				 LD_high <= '1';
				 FSM_nx_State <= S3;
	          	
	when S2 =>
	         AccShift_left0 <= '1';
				INC_CNT <= '1';
	         FSM_nx_State <= S4;
				
	when S3 => 
	         AccShift_left1 <= '1';
				INC_CNT <= '1';
				FSM_nx_State <= S4;
				
	when S4 =>
	         if FSM_done = '1' then 
				FSM_nx_State <= S4;
				else
				FSM_nx_State <= S0;
				end if;
	end case;	
end process;

-- FSM next state register	  
RegFSM_State: process (clk, FSM_nx_State, start)
begin
    if (clk'event and clk = '1') then 
	     if start ='1' then 
		  FSM_Cur_State <= S0;
		  else
		  FSM_Cur_State <= FSM_nx_State;
		  end if;
	 end if;
end process;

-- Counter to control the iteration
RegCounter: process(clk, start)
begin
    if clk'event and clk = '1' then 
	    if start = '1' then
		 Counter <= (others => '0');
		 elsif INC_CNT = '1' then
		 Counter <= Counter + 1;
		 end if;
	 end if;
end process;

-- update FSM_done
ComboFSMdone: process(Counter)
begin
--   FSM_done <= counter(2) and (not(counter(1)))  and (not(counter(0)));
    FSM_done <= counter(3) and (not(counter(2)))  and counter(1) and (not(counter(0)));
end process;

process(FSM_done)
begin 
		done <= FSM_done;
end process;

end Behavioral;
