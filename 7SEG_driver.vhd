
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SEVENSEG_driver is
  Port (NUM_IN: in integer range 0 to 9;
        NUM_OUT: out std_logic_vector(7 downto 0)
         );
end SEVENSEG_driver;

architecture Behavioral of SEVENSEG_driver is begin
    process(NUM_IN) begin
            case NUM_IN is 
                when 0 => NUM_OUT <= "11101110"; -- "0"
                when 1 => NUM_OUT <= "10000010"; -- "1" 
                when 2 => NUM_OUT <= "11001101"; -- "2" 
                when 3 => NUM_OUT <= "01101101"; -- "3" 
                when 4 => NUM_OUT <= "00101011"; -- "4" 
                when 5 => NUM_OUT <= "01100111"; -- "5" 
                when 6 => NUM_OUT <= "11100111"; -- "6" 
                when 7 => NUM_OUT <= "00101100"; -- "7" 
                when 8 => NUM_OUT <= "11101111"; -- "8"   
                when 9 => NUM_OUT <= "00101111"; -- "9" 
                when others => NUM_OUT <= "00000000"; -- BLANK
            end case;
        end process;
end Behavioral;
