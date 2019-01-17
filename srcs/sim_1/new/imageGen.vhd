library IEEE;
library work;
use work.commonPackage.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;


entity ImgGenModule is
	Port ( clk : in STD_LOGIC;
		x_counter : in  STD_LOGIC_VECTOR (11 downto 0);
		y_counter : in  STD_LOGIC_VECTOR (11 downto 0);
		VGA_RED   : out STD_LOGIC_VECTOR (3 downto 0);
		VGA_GREEN : out STD_LOGIC_VECTOR (3 downto 0);
		VGA_BLUE  : out STD_LOGIC_VECTOR ( 3 downto 0);
		
		reg       : in rpn_type_register;
		output_string : in string(3 downto 1) := "   ";
		
		error_out_of_bound : in std_logic;
        error_division_by_zero : in std_logic
--		error_out_of_bound_output : in std_logic
        );
		
--		operation : in STD_LOGIC_VECTOR(1 downto 0);
--		inputData : in STD_LOGIC_VECTOR(DATA_SIZE - 1 downto 0);
--		outputData: in STD_LOGIC_VECTOR(DATA_SIZE - 1 downto 0));
		
--		plus_btn : in STD_LOGIC;
--        minus_btn : in STD_LOGIC;
--        mul_btn : in STD_LOGIC;
--        div_btn : in STD_LOGIC;
--        eql_btn : in STD_LOGIC);
end ImgGenModule;

architecture Behavioral of ImgGenModule is
    constant BIG_OFFSET_W : INTEGER := 550;
    CONSTANT BIG_OFFSET_H : INTEGER := 450;
       
	signal x        : std_logic_vector(11 downto 0) ;
	signal y        : std_logic_vector(11 downto 0) ;
	signal v        : std_logic;

    -- will enable or disable RGB at certain times
	signal pixel_active  : std_logic; 
	
	-- dummy variables 
	signal vga_red_o   : std_logic_vector(3 downto 0);
	signal vga_green_o : std_logic_vector(3 downto 0);
	signal vga_blue_o  : std_logic_vector(3 downto 0);
	
	-- VGA R, G and B signals to connect output with the design
	signal vga_red_comb   : std_logic_vector(3 downto 0);
	signal vga_green_comb : std_logic_vector(3 downto 0);
	signal vga_blue_comb  : std_logic_vector(3 downto 0);
	signal wid            : std_logic;
	
--	signal op_signal : STD_LOGIC_VECTOR (1 downto 0);
--	signal test_led_signal  : STD_LOGIC_VECTOR (1 downto 0) := "00";
	
	signal horizontal_int_counter : integer := to_integer(signed(x_counter));
    signal vertical_int_counter : integer := to_integer(signed(y_counter));
        
    -- results
    signal d1 : std_logic := '0';
    signal d2 : std_logic := '0';
    signal d3 : std_logic := '0';
    signal d4 : std_logic := '0';
    signal d5 : std_logic := '0';
    signal d6 : std_logic := '0';
    signal d7 : std_logic := '0';
    signal d8 : std_logic := '0';
    signal d9 : std_logic := '0'; -- test 
    signal d10 : std_logic := '0';
    
    signal d_error_out_of_bound : std_logic := '0';
    signal d_error_division_by_zero : std_logic := '0';
    
--    signal d11 : std_logic := '0'; -- error Overflow!
	
--	signal lastButtonState    : std_logic := '0';
--	signal color : std_logic_vector(1 downto 0) := "00";
	
	-- button debounce code
--	signal flipflops   : STD_LOGIC_VECTOR(1 DOWNTO 0); --input flip flops
--    signal counter_set : STD_LOGIC;                    --sync reset to zero
--    signal counter_out : STD_LOGIC_VECTOR(20 DOWNTO 0) := (OTHERS => '0'); --counter output
--    signal debounce_result : std_logic;
    
    --signal test_led_signal : std_logic_vector(1 downto 0);
    
--    constant clk_period : time := 20 ns;	-- clock period
--    constant debounce_time : time := 20 ms;    -- time after which the signal is considered stable
--    constant on_state : std_logic := '0';    -- pushed state (vs rest state)
    
--    constant deb_cycles : integer := debounce_time / clk_period;	-- number of clock cycles in the debounce time
--    signal count : integer range 0 to (deb_cycles + 1) := 0;
--    signal state : std_logic := '0';
--    signal output : std_logic := '1';

    -- last states
--    signal lastPlusBtnState    : std_logic := '0';
--    signal lastMinusBtnState    : std_logic := '0';
--    signal lastMulBtnState    : std_logic := '0';
--    signal lastDivBtnState    : std_logic := '0';
--    signal lastEqlBtnState    : std_logic := '0';
    
--    signal led_signal : std_logic_vector(1 downto 0) := "00";
--    signal operation_char : string := " ";
    signal reg0_string : string(1 to STRING_DATA_SIZE) := DATA_SIZED_NULL_STRING;
    signal reg1_string : string(1 to STRING_DATA_SIZE) := DATA_SIZED_NULL_STRING;
    signal reg2_string : string(1 to STRING_DATA_SIZE) := DATA_SIZED_NULL_STRING;
    signal reg3_string : string(1 to STRING_DATA_SIZE) := DATA_SIZED_NULL_STRING;
    signal temp_string : string(1 to 3) := "   "; 
    
    signal reg0_int : integer;
    signal reg1_int : integer;
    signal reg2_int : integer;
    signal reg3_int : integer; 
    
--    signal error_out_of_bound_signal : std_logic;
    
    component stringROM is
      Port 
      (
        reg0_int : in integer;
        reg1_int : in integer;
        reg2_int : in integer;
        reg3_int : in integer;
        
        reg0_string : out string(1 to 4);
        reg1_string : out string(1 to 4); 
        reg2_string : out string(1 to 4);
        reg3_string : out string(1 to 4) 
      );
    end component;
    
--    signal test_string : string(1 to STRING_DATA_SIZE) := "    ";
    
begin
    
    textElement1: entity work.Pixel_On_Text
	generic map (
		textLength => 7
	)
	port map(
		clk => clk,
		displayText => "1 2 3 +",
		position => (BIG_OFFSET_W + 50 , 50 + BIG_OFFSET_H),
		horzCoord => horizontal_int_counter,
		vertCoord => vertical_int_counter,
		pixel => d1
	);
	
	textElement2: entity work.Pixel_On_Text
	generic map (
		textLength => 7
	)
	port map(
		clk => clk,
		displayText => "4 5 6 -",
		position => (BIG_OFFSET_W + 50, 66 + BIG_OFFSET_H),
		horzCoord => horizontal_int_counter,
		vertCoord => vertical_int_counter,
		pixel => d2
	);
	
	textElement3: entity work.Pixel_On_Text
	generic map (
		textLength => 7
	)
	port map(
		clk => clk,
		displayText => "7 8 9 =",
		position => (BIG_OFFSET_W + 50, 82 + BIG_OFFSET_H),
		horzCoord => horizontal_int_counter,
		vertCoord => vertical_int_counter,
		pixel => d3
	);
	
	textElement4: entity work.Pixel_On_Text
    generic map (
        textLength => 1
    )
    port map(
        clk => clk,
        displayText => "0",
        position => (BIG_OFFSET_W + 50, 98 + BIG_OFFSET_H),
        horzCoord => horizontal_int_counter,
        vertCoord => vertical_int_counter,
        pixel => d4
    );
    
--    reg3Text: entity work.Pixel_On_Text
--    generic map (
--        textLength => STRING_DATA_SIZE
--    )
--    port map(
--        clk => clk,
--        displayText => reg3_string,
--        position => (50, 114),
--        horzCoord => horizontal_int_counter,
--        vertCoord => vertical_int_counter,
--        pixel => d5
--    );
    
--    reg2Text: entity work.Pixel_On_Text
--    generic map (
--        textLength => STRING_DATA_SIZE
--    )
--    port map(
--        clk => clk,
--        displayText => reg2_string,
--        position => (50, 130),
--        horzCoord => horizontal_int_counter,
--        vertCoord => vertical_int_counter,
--        pixel => d6
--    );
    
--    reg1Text: entity work.Pixel_On_Text
--    generic map (
--        textLength => STRING_DATA_SIZE
--    )
--    port map(
--        clk => clk, 
--        displayText => reg1_string, 
--        position => (50, 146),
--        horzCoord => horizontal_int_counter,
--        vertCoord => vertical_int_counter,
--        pixel => d7
--    );
    
    reg0Text: entity work.Pixel_On_Text
    generic map (
        textLength => STRING_DATA_SIZE
    )
    port map(
        clk => clk, 
        displayText => reg0_string, 
        position => (BIG_OFFSET_W + 50, 162 + BIG_OFFSET_H), 
        horzCoord => horizontal_int_counter,
        vertCoord => vertical_int_counter, 
        pixel => d8
    );
    
    temp_string <= output_string;
    
    temp_Text: entity work.Pixel_On_Text
    generic map (
        3
    )
    port map(
        clk => clk, 
        displayText => temp_string,
        position => (BIG_OFFSET_W + 50, 178 + BIG_OFFSET_H),
        horzCoord => horizontal_int_counter,
        vertCoord => vertical_int_counter, 
        pixel => d10
    );
    

--    d_error_out_of_bound <= error_out_of_bound;
--    d_error_division_by_zero <= error_division_by_zero;
--    d_error_out_of_bound <= '1';
--    d_error_division_by_zero <= '1';
    
    
    error_bound_txt: entity work.Pixel_On_Text
        generic map (
            9
        )
        port map(
            clk => clk, 
            displayText => "Overflow!",
            position => (BIG_OFFSET_W + 50, 194 + BIG_OFFSET_H),
            horzCoord => horizontal_int_counter,
            vertCoord => vertical_int_counter, 
            pixel => d_error_out_of_bound
        );
        
    
    error_div_txt: entity work.Pixel_On_Text
        generic map (
            17
        )
        port map(
            clk => clk, 
            displayText => "Division by Zero!",
            position => (BIG_OFFSET_W + 50, 210 + BIG_OFFSET_H),
            horzCoord => horizontal_int_counter,
            vertCoord => vertical_int_counter, 
            pixel => d_error_division_by_zero
        );
        
--    process(d_error_out_of_bound, d_error_division_by_zero, error_out_of_bound, error_division_by_zero) 
--    begin 
--        if 
--    end process;
    
--    test_string <=  integer'image(to_integer(reg(0)));
    
--    testText: entity work.Pixel_On_Text
--    generic map (
--        textLength => 4
--    )
--    port map(
--        clk => clk, 
--        displayText => test_string, 
--        position => (50, 200), 
--        horzCoord => horizontal_int_counter,
--        vertCoord => vertical_int_counter, 
--        pixel => d9
--    );



--    operationText: entity work.Pixel_On_Text
--    generic map (
--        textLength => 1
--    )
--    port map(
--        clk => clk,
--        displayText => operation_char,
--        position => (130, 114),
--        horzCoord => horizontal_int_counter,
--        vertCoord => vertical_int_counter,
--        pixel => d5
--    );

--    reg0_string <= to_string(reg(0));
--    reg1_string <= to_string(reg(1));
--    reg2_string <= to_string(reg(2));
--    reg3_string <= to_string(reg(3));


    
    reg0_int <= to_integer(reg(0));
    reg1_int <= to_integer(reg(1));
    reg2_int <= to_integer(reg(2));
    reg3_int <= to_integer(reg(3));
    
    string_rom_uut : stringROM port map 
    (
        reg0_int => reg0_int,
        reg1_int => reg1_int,
        reg2_int => reg2_int,
        reg3_int => reg3_int,
        
        reg0_string => reg0_string,
        reg1_string => reg1_string,
        reg2_string => reg2_string, 
        reg3_string => reg3_string
    );
    
--    d11 <= error_out_of_bound_output;

--    error_outofbound_text : 
--    entity work.Pixel_On_Text
--    generic map (
--        17
--    )
--    port map(
--        clk => clk, 
--        displayText => "Error : Overflow!",
--        position => (60, 162),
--        horzCoord => horizontal_int_counter,
--        vertCoord => vertical_int_counter, 
--        pixel => d11
--    );
    
    
--    process(reg) --, outputData
--    begin 
----        reg0_string <= integer'image(reg0_int);
----        reg1_string <= integer'image(reg1_int);
----        reg2_string <= integer'image(reg2_int);
----        reg3_string <= integer'image(reg3_int);
--        case(reg0_int) is
--            when 999 => reg0_string <= " 999";
--            when 998 => reg0_string <= " 998";
--        case reg(0) is
--            when "0000" => reg0_string <= "0000";
--            when "0001" => reg0_string <= "0001";
--            when "0010" => reg0_string <= "0010";
--            when "0011" => reg0_string <= "0011";
--            when "0100" => reg0_string <= "0100";
--            when "0101" => reg0_string <= "0101";
--            when "0110" => reg0_string <= "0110";
--            when "0111" => reg0_string <= "0111";
--            when "1000" => reg0_string <= "1000";
--            when "1001" => reg0_string <= "1001";
--            when "1010" => reg0_string <= "1010";
--            when "1011" => reg0_string <= "1011";
--            when "1100" => reg0_string <= "1100";
--            when "1101" => reg0_string <= "1101";
--            when "1110" => reg0_string <= "1110";
--            when "1111" => reg0_string <= "1111";
--            when others => reg0_string <= "xxxx";
--        end case;
        
--        case reg(1) is
--            when "0000" => reg1_string <= "0000";
--            when "0001" => reg1_string <= "0001";
--            when "0010" => reg1_string <= "0010";
--            when "0011" => reg1_string <= "0011";
--            when "0100" => reg1_string <= "0100";
--            when "0101" => reg1_string <= "0101";
--            when "0110" => reg1_string <= "0110";
--            when "0111" => reg1_string <= "0111";
--            when "1000" => reg1_string <= "1000";
--            when "1001" => reg1_string <= "1001";
--            when "1010" => reg1_string <= "1010";
--            when "1011" => reg1_string <= "1011";
--            when "1100" => reg1_string <= "1100";
--            when "1101" => reg1_string <= "1101";
--            when "1110" => reg1_string <= "1110";
--            when "1111" => reg1_string <= "1111";
--            when others => reg1_string <= "xxxx";
--        end case;
        
--        case reg(2) is
--            when "0000" => reg2_string <= "0000";
--            when "0001" => reg2_string <= "0001";
--            when "0010" => reg2_string <= "0010";
--            when "0011" => reg2_string <= "0011";
--            when "0100" => reg2_string <= "0100";
--            when "0101" => reg2_string <= "0101";
--            when "0110" => reg2_string <= "0110";
--            when "0111" => reg2_string <= "0111";
--            when "1000" => reg2_string <= "1000";
--            when "1001" => reg2_string <= "1001";
--            when "1010" => reg2_string <= "1010";
--            when "1011" => reg2_string <= "1011";
--            when "1100" => reg2_string <= "1100";
--            when "1101" => reg2_string <= "1101";
--            when "1110" => reg2_string <= "1110";
--            when "1111" => reg2_string <= "1111";
--            when others => reg2_string <= "xxxx";
--        end case;
                
--        case reg(3) is
--            when "0000" => reg3_string <= "0000";
--            when "0001" => reg3_string <= "0001";
--            when "0010" => reg3_string <= "0010";
--            when "0011" => reg3_string <= "0011";
--            when "0100" => reg3_string <= "0100";
--            when "0101" => reg3_string <= "0101";
--            when "0110" => reg3_string <= "0110";
--            when "0111" => reg3_string <= "0111";
--            when "1000" => reg3_string <= "1000";
--            when "1001" => reg3_string <= "1001";
--            when "1010" => reg3_string <= "1010";
--            when "1011" => reg3_string <= "1011";
--            when "1100" => reg3_string <= "1100";
--            when "1101" => reg3_string <= "1101";
--            when "1110" => reg3_string <= "1110";
--            when "1111" => reg3_string <= "1111";
--            when others => reg3_string <= "xxxx";
--        end case;
--    end process;
	
--	process(x, op_signal)
--	begin
	   
--	end process;
		
		
--        if (op_signal = "00" and (((x > 200 and x < 230) and(( y > 0 and y < 420))) or ((x > 0 and x < 420) and (y > 220 and y < (1080-830)))))
--        then  
--                pixel_active <= '1';
--        elsif (op_signal = "01" and (x > 0 and x < 420) and (y > 220 and y < (1080-830)))  then
--                pixel_active <= '1';
--        elsif (op_signal = "10" and (((x > 0    and x < 70 ) and (y > 0   and y < 70 )) -- main diogonal
--                                  or ((x > 70   and x < 140) and (y > 70  and y < 140))
--                                  or ((x > 140  and x < 210) and (y > 140 and y < 210))
--                                  or ((x > 210  and x < 280) and (y > 210 and y < 280)) 
--                                  or ((x > 280  and x < 350) and (y > 280 and y < 350))
--                                  or ((x > 350  and x < 420) and (y > 350 and y < 420))
--                                  or ((x > 350  and x < 420) and (y > 0   and y < 70 )) -- secondary diogonal
--                                  or ((x > 280  and x < 350) and (y > 70  and y < 140))
--                                  or ((x > 210  and x < 280) and (y > 140 and y < 210))
--                                  or ((x > 140  and x < 210) and (y > 210 and y < 280)) 
--                                  or ((x > 70   and x < 140) and (y > 280 and y < 350))
--                                  or ((x > 0    and x < 70 ) and (y > 350 and y < 420)) ))  then
--                pixel_active <= '1';
--        elsif (op_signal = "11"  and (  ((x > 0 and x < 420  ) and (y > 220 and y < (1080-830))) 
--                                    or  ((x > 170 and x < 240) and (y > 120 and y < 190       ))
--                                    or  ((x > 170 and x < 240) and (y > 280 and y < 350       )) ))  then
--                pixel_active <= '1';
--        else
--            pixel_active <= '0';
            
--        end if ; 
--	end process ;
	
	-- debounce code
--	counter_set <= flipflops(0) xor flipflops(1);   --determine when to start/reset counter
	
--	PROCESS(clk)
--      BEGIN
--        IF(clk'EVENT and clk = '1') THEN
--          flipflops(0) <= test_pushbutton;
--          flipflops(1) <= flipflops(0);
--          If(counter_set = '1') THEN                  --reset counter because input is changing
--            counter_out <= (OTHERS => '0');
--          ELSIF(counter_out(20) = '0') THEN --stable input time is not yet met
--            counter_out <= counter_out + 1;
--          ELSE                                        --stable input time is met
--            debounce_result <= flipflops(1);
            
--          END IF;    
--        END IF;
--      END PROCESS;
	-- end debounce code
	

--    process(clk)
--    begin
--      if(rising_edge(clk)) then
        
--        if(test_pushbutton = '1') then
--            color <= color + "01";
--        else 
--            color <= "00";
--        end if;
--      end if;
--    end process;
    

        
--    process(color) 
--    begin 
--        if color = "00" then
--            vga_red_o      <= "1111";
--            vga_green_o    <= "0000";
--            vga_blue_o     <= "0000";
--        elsif color = "01" then
--            vga_red_o      <= "0000";
--            vga_green_o    <= "1111";
--            vga_blue_o     <= "0000";
--        elsif color = "10" then
--            vga_red_o      <= "0000";
--            vga_green_o    <= "0000";
--            vga_blue_o     <= "1111";
--        else
--            vga_red_o      <= "1111";
--            vga_green_o    <= "1111";
--            vga_blue_o     <= "0000";
--        end if;
--     end process;

--    process(clk)
--    begin
--      if(rising_edge(clk)) then
--        if(debounce_result = '1' and lastButtonState = '0') then      --assuming active-high
--          test_led_signal(1) <= not test_led_signal(1);
--        end if;
--        lastButtonState <= debounce_result;
--      end if;
--    end process;

--   process(test_pushbutton, clk)
--	begin
--		if(rising_edge(clk)) then
--			if (test_pushbutton /= state) then	-- if the state changed reset the counter
--				count <= 0;
--				output <= not on_state;
--			elsif (count < deb_cycles) then	-- if the change isn't changed and 20 ms aren't passed increase the counter
--				count <= count + 1;
--				output <= not on_state;
--			elsif (count = deb_cycles and test_pushbutton = on_state) then	-- 20 ms of stability! 
--										--> output the "on state"
--				count <= count + 1;
--				output <= on_state;
--			else				-- If the button is not pressed or the 20 ms 
--				output <= not on_state;	-- are passed and the button is still pressed  
--							-- keep it in off state.
--			end if;	
--		state <= test_pushbutton;
--	end if;
--	end process;

--    with output select  test_led_signal <= "01" when '0', "10" when '1';
--    test_led <= test_led_signal;
--    process(clk)
--    begin
--      if(rising_edge(clk)) then
--        if(plus_btn = '1' and lastPlusBtnState = '0') then      --assuming active-high
--          operation_char <= "+";
--        end if;
--        if(minus_btn = '1' and lastMinusBtnState = '0') then      --assuming active-high
--          operation_char <= "-";
--        end if;
--        if(mul_btn = '1' and lastMulBtnState = '0') then      --assuming active-high
--          operation_char <= "*";
--        end if;
--        if(div_btn = '1' and lastDivBtnState = '0') then      --assuming active-high
--          operation_char <= "/";
--        end if;
--        if(eql_btn = '1' and lastEqlBtnState = '0') then      --assuming active-high
--          operation_char <= "=";
--        end if;
        
--        lastPlusBtnState <= plus_btn;
--        lastMinusBtnState <= minus_btn;
--        lastMulBtnState <= mul_btn;
--        lastDivBtnState <= div_btn;
--        lastEqlBtnState <= eql_btn;
--      end if;
--    end process;
    
    vga_red_o      <= "1111";
    vga_green_o    <= "1111";
    vga_blue_o     <= "0000";
    
	
	x              <= x_counter;
	y              <= y_counter;
	v              <= pixel_active or d1 or d2 or d3 or d4 or d5 or d6 or d7 or d8 or d10 
	                           or (d_error_division_by_zero and error_division_by_zero) 
	                           or (d_error_out_of_bound and error_out_of_bound);
	
	
	vga_red_comb   <= (v & v & v & v) and vga_red_o ;
	vga_green_comb <= (v & v & v & v) and vga_green_o;
	vga_blue_comb  <= (v & v & v & v) and vga_blue_o;
	
--	op_signal <= op_input;
	

	process (clk)
	begin
		if (rising_edge(clk)) then
			VGA_RED   <= vga_red_comb;
			VGA_GREEN <= vga_green_comb;
			VGA_BLUE  <= vga_blue_comb;
		end if;
	end process;
end Behavioral;