library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.std_logic_unsigned.all;

entity SyncModule is
	Port ( clk : in STD_LOGIC;
		y_control : out STD_LOGIC_VECTOR (11 downto 0);
		x_control : out STD_LOGIC_VECTOR (11 downto 0);
		h_sync    : out STD_LOGIC;
		v_sync    : out STD_LOGIC);
end SyncModule;

architecture Behavioral of SyncModule is
	
	constant FRAME_WIDTH  : natural := 1280;  -- resolution
	constant FRAME_HEIGHT : natural := 1024;
	
	-- numbers from http://tinyvga.com/vga-timing/1280x1024@60Hz
	constant H_FP  : natural := 48;   --H front porch width (pixels)
	constant H_PW  : natural := 112;  --H sync pulse width (pixels)
	constant H_MAX : natural := 1688; --H total period (pixels)  ( Horizontal back porch = 1688 - (1280 + 112 + 48) )
	
	constant V_FP  : natural := 1;    --V front porch width (lines)
	constant V_PW  : natural := 3;    --V sync pulse width (lines)
	constant V_MAX : natural := 1066; --V total period (lines)  ( Vertical back porch = 1066 - (1024 + 3 + 1) )
	
	constant H_POL : std_logic := '1';
	constant V_POL : std_logic := '1';
	
	-- Horizontal and Vertical counters
	signal x_cntr_reg : std_logic_vector(11 downto 0) := (others => '0');
	signal y_cntr_reg : std_logic_vector(11 downto 0) := (others => '0');
	
	-- Horizontal and Vertical Sync
	signal h_sync_reg : std_logic := not(H_POL);
	signal v_sync_reg : std_logic := not(V_POL);
	
begin
	-- Generate Horizontal, Vertical counters and the Sync signals
	-- Horizontal counter
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (x_cntr_reg = (H_MAX - 1)) then
				x_cntr_reg <= (others => '0');  -- reset the horizontal pixel counter if it has reached the end 
			else
				x_cntr_reg <= x_cntr_reg + 1;
			end if;
		end if;
	end process;
	-- Vertical counter
	process (clk)
	begin
		if (rising_edge(clk)) then
			if ((x_cntr_reg = (H_MAX - 1)) and (y_cntr_reg = (V_MAX - 1))) then  -- reset vertical counter if both have reached the end, or right below corner
				y_cntr_reg <= (others => '0');
			elsif (x_cntr_reg = (H_MAX - 1)) then  -- reset the vertical counter if the horizontal counter has reached the end of the line
				y_cntr_reg <= y_cntr_reg + 1;
			end if;
		end if;
	end process;
	
	-- Horizontal sync
	-- in this design first is horizontal front porch then visible frame width then pulse width  
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (x_cntr_reg >= (H_FP + FRAME_WIDTH - 1)) and (x_cntr_reg < (H_FP + FRAME_WIDTH + H_PW - 1)) then -- if x counter is between these numbers 
				h_sync_reg <= H_POL;
			else
				h_sync_reg <= not(H_POL);  -- inactive during backporch 
			end if;
		end if;
	end process;
	
	-- Vertical sync
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (y_cntr_reg >= (V_FP + FRAME_HEIGHT - 1)) and (y_cntr_reg < (V_FP + FRAME_HEIGHT + V_PW - 1)) then
				v_sync_reg <= V_POL;
			else
				v_sync_reg <= not(V_POL);  -- inactive during backporch
			end if;
		end if;
	end process; 

	y_control <= y_cntr_reg ;
	x_control <= x_cntr_reg ;

	h_sync    <= h_sync_reg ;
	v_sync    <= v_sync_reg ;
	
end Behavioral;