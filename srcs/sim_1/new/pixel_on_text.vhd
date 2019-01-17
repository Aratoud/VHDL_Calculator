library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

library work;

use work.commonPackage.all;

entity Pixel_On_Text is
	generic(
	   -- needed for init displayText, the default value 11 is just a random number
       textLength: integer := 11
	);
	port ( 
		clk: in std_logic;
		displayText: in string (1 to textLength) := (others => NUL);
		-- top left corner of the text
		position: in vector_2d := (0, 0);
		-- current pixel postion
		horzCoord: in integer;
		vertCoord: in integer;
		
		pixel: out std_logic := '0'
	);

end Pixel_On_Text;

architecture Behavioral of Pixel_On_Text is

	signal fontAddress: integer;
	-- A row of bit in a charactor, we check if our current (x,y) is 1 in char row
	signal charBitInRow: std_logic_vector(FONT_WIDTH-1 downto 0) := (others => '0');
	-- char in ASCII code
	signal charCode:integer := 0;
	-- the position(column) of a charactor in the given text
	signal charPosition:integer := 0;
	-- the bit position(column) in a charactor
	signal bitPosition:integer := 0;
	
	signal slower_clock : std_logic := '0';
    signal counter : std_logic_vector(0 to 6);
    
--    signal larger_width : integer := 64;
--    signal larger_height : integer := 128; 
	
begin
    -- (horzCoord - position.x): x positionin the top left of the whole text
    charPosition <= (horzCoord - position.x)/FONT_WIDTH + 1;
    bitPosition <= (horzCoord - position.x) mod FONT_WIDTH;
    charCode <= character'pos(displayText(charPosition));
    -- charCode*16: first row of the char
    fontAddress <= charCode*16+(vertCoord - position.y);


	fontRom: entity work.fontROM
	port map(
		clk => clk,
		address => fontAddress,
		fontRow => charBitInRow
	);
	
--	process(clk) 
--	begin
--	   if rising_edge(clk) then
--	       counter <= counter + "0000001"; 
--	       if counter = "1111111" then
--              counter <= "0000000";
--              slower_clock <= '1';
--           else 
--              slower_clock <= '0';
--           end if;
--       end if;
--    end process;

--    process(clk)
--    begin
--        if rising_edge(clk) then
--            slower_clock <= not slower_clock;
--        end if;
--    end process;
	
	pixelOn: process(clk)
		variable inXRange: boolean := false;
		variable inYRange: boolean := false;
	begin
        if rising_edge(clk) then
            
            -- reset
            inXRange := false;
            inYRange := false;
            pixel <= '0';
            -- If current pixel is in the horizontal range of text
            if horzCoord >= position.x and horzCoord < position.x + (FONT_WIDTH * textlength) then
                inXRange := true;
            end if;
            
            -- If current pixel is in the vertical range of text
            if vertCoord >= position.y and vertCoord < position.y + FONT_HEIGHT then
                inYRange := true;
            end if;
            
            -- need to check if the pixel is on for text
            if inXRange and inYRange then
                -- FONT_WIDTH-bitPosition: we are reverting the charactor
                if charBitInRow(FONT_WIDTH-bitPosition) = '1' then
                    pixel <= '1';
                end if;					
            end if;

		end if;
	end process;

end Behavioral;