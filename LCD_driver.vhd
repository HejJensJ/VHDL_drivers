
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY LCD_driver IS
  PORT(
    clk: IN STD_LOGIC;  --system clock
    reset_n: IN STD_LOGIC;  --active low reinitializes lcd
    rw, rs, e: OUT STD_LOGIC;  --read/write, setup/data, and enable for lcd
    lcd_data: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --data signals for lcd
	line1_string: IN String(15 downto 0);
	line2_string: IN String(15 downto 0));
END LCD_driver;

ARCHITECTURE controller OF LCD_driver IS
  TYPE CONTROL IS(power_up, initialize, RESETLINE, line1, line2, send);
  SIGNAL state: CONTROL;
  CONSTANT freq: integer := 12; --system clock frequency in MHz
  SIGNAL ptr: natural range 0 to 16 := 15; -- To keep track of what character we are up to
  SIGNAL line: STD_LOGIC := '1';
  
  
begin
    process(clk)
    variable clk_count : INTEGER := 0; --event counter for timing
    begin
    if(clk'event and clk = '1') then
        case state is
            --wait 50 ms to ensure Vdd has risen and required LCD wait is met
            when power_up =>
                if(clk_count < (50000  * freq)) then    --wait 50 ms
                    clk_count:= clk_count + 1;
                    state <= power_up;
                else                                   --power-up complete
                    clk_count := 0;
                    rs <= '0';
                    rw <= '0';
                    lcd_data <= "00110000";
                    state <= initialize;
                end if;
        
            --cycle through initialization sequence  
            when initialize =>
                clk_count := clk_count + 1;
                if(clk_count < (10  * freq)) THEN       --function set
                    lcd_data <= "00111100";      --2-line mode, display on
                    --lcd_data <= "00110100";      --1-line mode, display on
                    --lcd_data <= "00110000";    --1-line mdoe, display off
                    --lcd_data <= "00111000";    --2-line mode, display off
                    e <= '1';
                    state <= initialize;
                elsif(clk_count < (60 * freq)) then    --wait 50 us
                    lcd_data <= "00000000";
                    e <= '0';
                    state <= initialize;
                elsif(clk_count < (70 * freq)) then    --display on/off control
                    lcd_data <= "00001100";      --display on, cursor off, blink off
                    --lcd_data <= "00001101";    --display on, cursor off, blink on
                    --lcd_data <= "00001110";    --display on, cursor on, blink off
                    --lcd_data <= "00001111";    --display on, cursor on, blink on
                    --lcd_data <= "00001000";    --display off, cursor off, blink off
                    --lcd_data <= "00001001";    --display off, cursor off, blink on
                    --lcd_data <= "00001010";    --display off, cursor on, blink off
                    --lcd_data <= "00001011";    --display off, cursor on, blink on            
                    e <= '1';
                    state <= initialize;
                elsif(clk_count < (120 * freq)) then   --wait 50 us
                    lcd_data <= "00000000";
                    e <= '0';
                    state <= initialize;
                elsif(clk_count < (130 * freq)) then   --display clear
                    lcd_data <= "00000001";
                    e <= '1';
                    state <= initialize;
                elsif(clk_count < (2130 * freq)) then  --wait 2 ms
                    lcd_data <= "00000000";
                    e <= '0';
                    state <= initialize;
                elsif(clk_count < (2140 * freq)) then  --entry mode set
                    lcd_data <= "00000110";      --increment mode, entire shift off
                    --lcd_data <= "00000111";    --increment mode, entire shift on
                    --lcd_data <= "00000100";    --decrement mode, entire shift off
                    --lcd_data <= "00000101";    --decrement mode, entire shift on
                    e <= '1';
                    state <= initialize;
                elsif(clk_count < (2200 * freq)) then  --wait 60 us
                    lcd_data <= "00000000";
                    e <= '0';
                    state <= initialize;
                else                                   --initialization complete
                    clk_count := 0;
                    state <= RESETLINE;
                end if;    
		      
            when resetline =>
                ptr <= 16;
			    if line = '1' then
                    lcd_data <= "10000000";
                    rs <= '0';
                    rw <= '0';
                    clk_count := 0; 
                    state <= send;
			    else
			        lcd_data <= "11000000";
                    rs <= '0';
                    rw <= '0';
                    clk_count := 0; 
                    state <= send;
	            end if;
            when line1 =>
			    line <= '1';
			    case line1_string(ptr) is
			        when ' ' => lcd_data <= x"20";
			        when '!' => lcd_data <= x"21";
			        when '"' => lcd_data <= x"22";
			        when '#' => lcd_data <= x"23";
			        when '$' => lcd_data <= x"24";
			        when '%' => lcd_data <= x"25";
			        when '&' => lcd_data <= x"26";
			        when '´' => lcd_data <= x"27";
			        when '(' => lcd_data <= x"28";
			        when ')' => lcd_data <= x"29";
			        when '*' => lcd_data <= x"2A";
			        when '+' => lcd_data <= x"2B";
			        when ',' => lcd_data <= x"2C";
			        when '-' => lcd_data <= x"2D";
			        when '.' => lcd_data <= x"2E";
			        when '/' => lcd_data <= x"2F";
			        when '0' => lcd_data <= x"30";
			        when '1' => lcd_data <= x"31";
			        when '2' => lcd_data <= x"32";
			        when '3' => lcd_data <= x"33";
			        when '4' => lcd_data <= x"34";
			        when '5' => lcd_data <= x"35";
			        when '6' => lcd_data <= x"36";
			        when '7' => lcd_data <= x"37";
			        when '8' => lcd_data <= x"38";
			        when '9' => lcd_data <= x"39";
			        when ':' => lcd_data <= x"3A";
			        when ';' => lcd_data <= x"3B";
			        when '<' => lcd_data <= x"3C";
			        when '=' => lcd_data <= x"3D";
			        when '>' => lcd_data <= x"3E";
			        when '?' => lcd_data <= x"3F";
			        --when ' ' => lcd_data <= x"40";
			        when 'A' => lcd_data <= x"41";
			        when 'B' => lcd_data <= x"42";
			        when 'C' => lcd_data <= x"43";
			        when 'D' => lcd_data <= x"44";
			        when 'E' => lcd_data <= x"45";
			        when 'F' => lcd_data <= x"46";
			        when 'G' => lcd_data <= x"47";
			        when 'H' => lcd_data <= x"48";
			        when 'I' => lcd_data <= x"49";
			        when 'J' => lcd_data <= x"4A";
			        when 'K' => lcd_data <= x"4B";
			        when 'L' => lcd_data <= x"4C";
			        when 'M' => lcd_data <= x"4D";
			        when 'N' => lcd_data <= x"4E";
			        when 'O' => lcd_data <= x"4F";
			        when 'P' => lcd_data <= x"50";
			        when 'Q' => lcd_data <= x"51";
			        when 'R' => lcd_data <= x"52";
			        when 'S' => lcd_data <= x"53";
			        when 'T' => lcd_data <= x"54";
			        when 'U' => lcd_data <= x"55";
			        when 'V' => lcd_data <= x"56";
			        when 'W' => lcd_data <= x"57";
			        when 'X' => lcd_data <= x"58";
			        when 'Y' => lcd_data <= x"59";
			        when 'Z' => lcd_data <= x"5A";
			        when '[' => lcd_data <= x"5B";
			        --when '' => lcd_data <= x"5C";
			        when ']' => lcd_data <= x"5D";
			        when '^' => lcd_data <= x"5E";
			        when '_' => lcd_data <= x"5F";
			        --when ' ' => lcd_data <= x"60";
			        when 'a' => lcd_data <= x"61";
			        when 'b' => lcd_data <= x"62";
			        when 'c' => lcd_data <= x"63";
			        when 'd' => lcd_data <= x"64";
			        when 'e' => lcd_data <= x"65";
			        when 'f' => lcd_data <= x"66";
			        when 'g' => lcd_data <= x"67";
			        when 'h' => lcd_data <= x"68";
			        when 'i' => lcd_data <= x"69";
			        when 'j' => lcd_data <= x"6A";
			        when 'k' => lcd_data <= x"6B";
			        when 'l' => lcd_data <= x"6C";
			        when 'm' => lcd_data <= x"6D";
			        when 'n' => lcd_data <= x"6E";
			        when 'o' => lcd_data <= x"6F";
			        when 'p' => lcd_data <= x"70";
			        when 'q' => lcd_data <= x"71";
			        when 'r' => lcd_data <= x"72";
			        when 's' => lcd_data <= x"73";
			        when 't' => lcd_data <= x"74";
			        when 'u' => lcd_data <= x"75";
			        when 'v' => lcd_data <= x"76";
			        when 'w' => lcd_data <= x"77";
			        when 'x' => lcd_data <= x"78";
			        when 'y' => lcd_data <= x"79";
			        when 'z' => lcd_data <= x"7A";
			        when '{' => lcd_data <= x"7B";
			        when '|' => lcd_data <= x"7C";
			        when '}' => lcd_data <= x"7D";
			        --when '?' => lcd_data <= x"7E";
			        --when '?' => lcd_data <= x"7F";
			        when others => lcd_data <= "00100000";
			    end case;
                rs <= '1';
                rw <= '0';
                clk_count := 0; 
				line <= '1';
                state <= send;
            when line2 =>
				line <= '0';
				case line2_string(ptr) is
			        when ' ' => lcd_data <= x"20";
			        when '!' => lcd_data <= x"21";
			        when '"' => lcd_data <= x"22";
			        when '#' => lcd_data <= x"23";
			        when '$' => lcd_data <= x"24";
			        when '%' => lcd_data <= x"25";
			        when '&' => lcd_data <= x"26";
			        when '´' => lcd_data <= x"27";
			        when '(' => lcd_data <= x"28";
			        when ')' => lcd_data <= x"29";
			        when '*' => lcd_data <= x"2A";
			        when '+' => lcd_data <= x"2B";
			        when ',' => lcd_data <= x"2C";
			        when '-' => lcd_data <= x"2D";
			        when '.' => lcd_data <= x"2E";
			        when '/' => lcd_data <= x"2F";
			        when '1' => lcd_data <= x"31";
			        when '2' => lcd_data <= x"32";
			        when '3' => lcd_data <= x"33";
			        when '4' => lcd_data <= x"34";
			        when '5' => lcd_data <= x"35";
			        when '6' => lcd_data <= x"36";
			        when '7' => lcd_data <= x"37";
			        when '8' => lcd_data <= x"38";
			        when '9' => lcd_data <= x"39";
			        when ':' => lcd_data <= x"3A";
			        when ';' => lcd_data <= x"3B";
			        when '<' => lcd_data <= x"3C";
			        when '=' => lcd_data <= x"3D";
			        when '>' => lcd_data <= x"3E";
			        when '?' => lcd_data <= x"3F";
			        --when ' ' => lcd_data <= x"40";
			        when 'A' => lcd_data <= x"41";
			        when 'B' => lcd_data <= x"42";
			        when 'C' => lcd_data <= x"43";
			        when 'D' => lcd_data <= x"44";
			        when 'E' => lcd_data <= x"45";
			        when 'F' => lcd_data <= x"46";
			        when 'G' => lcd_data <= x"47";
			        when 'H' => lcd_data <= x"48";
			        when 'I' => lcd_data <= x"49";
			        when 'J' => lcd_data <= x"4A";
			        when 'K' => lcd_data <= x"4B";
			        when 'L' => lcd_data <= x"4C";
			        when 'M' => lcd_data <= x"4D";
			        when 'N' => lcd_data <= x"4E";
			        when 'O' => lcd_data <= x"4F";
			        when 'P' => lcd_data <= x"51";
			        when 'Q' => lcd_data <= x"52";
			        when 'R' => lcd_data <= x"53";
			        when 'S' => lcd_data <= x"54";
			        when 'T' => lcd_data <= x"55";
			        when 'U' => lcd_data <= x"56";
			        when 'V' => lcd_data <= x"57";
			        when 'X' => lcd_data <= x"58";
			        when 'Y' => lcd_data <= x"59";
			        when 'Z' => lcd_data <= x"5A";
			        when '[' => lcd_data <= x"5B";
			        --when '<' => lcd_data <= x"5C";
			        when ']' => lcd_data <= x"5D";
			        when '^' => lcd_data <= x"5E";
			        when '_' => lcd_data <= x"5F";
			        --when ' ' => lcd_data <= x"60";
			        when 'a' => lcd_data <= x"61";
			        when 'b' => lcd_data <= x"62";
			        when 'c' => lcd_data <= x"63";
			        when 'd' => lcd_data <= x"64";
			        when 'e' => lcd_data <= x"65";
			        when 'f' => lcd_data <= x"66";
			        when 'g' => lcd_data <= x"67";
			        when 'h' => lcd_data <= x"68";
			        when 'i' => lcd_data <= x"69";
			        when 'j' => lcd_data <= x"6A";
			        when 'k' => lcd_data <= x"6B";
			        when 'l' => lcd_data <= x"6C";
			        when 'm' => lcd_data <= x"6D";
			        when 'n' => lcd_data <= x"6E";
			        when 'o' => lcd_data <= x"6F";
			        when 'p' => lcd_data <= x"70";
			        when 'q' => lcd_data <= x"71";
			        when 'r' => lcd_data <= x"72";
			        when 's' => lcd_data <= x"73";
			        when 't' => lcd_data <= x"74";
			        when 'u' => lcd_data <= x"75";
			        when 'v' => lcd_data <= x"76";
			        when 'w' => lcd_data <= x"77";
			        when 'x' => lcd_data <= x"78";
			        when 'y' => lcd_data <= x"79";
			        when 'z' => lcd_data <= x"7A";
			        when '{' => lcd_data <= x"7B";
			        when '|' => lcd_data <= x"7C";
			        when '}' => lcd_data <= x"7D";
			        --when '?' => lcd_data <= x"7E";
			        --when '?' => lcd_data <= x"7F";
			        when others => lcd_data <= "00100000";
			    end case;
                rs <= '1';
                rw <= '0';
                clk_count := 0;            
                state <= send;
        --send instruction to lcd        
            when send =>
			    if(clk_count < (50  * freq)) then  --do not exit for 50us
				    if(clk_count < freq) then      --negative enable
					    e <= '0';
				    elsif(clk_count < (14 * freq)) then  --positive enable half-cycle
					    e <= '1';
				    elsif(clk_count < (27 * freq)) then  --negative enable half-cycle
					e <= '0';
				    end if;
				    clk_count := clk_count + 1;
				    state <= send;
			    else
			  	    clk_count := 0;
				    if line = '1' then
                        if ptr = 0 then
                            line <= '0';
							state <= resetline;
						else
							ptr <= ptr - 1;
							state <= line1;
						end if;
				else
				    if ptr = 0 then
					    line <= '1';
					    state <= resetline;
				    else
                        ptr <= ptr - 1;
                        state <= line2;
				    end if;
				end if;
			  end if;
      end case;    
      --reset
      if(reset_n = '0') then
          state <= power_up;
      end if;
    end if;
  end process;
end controller;
