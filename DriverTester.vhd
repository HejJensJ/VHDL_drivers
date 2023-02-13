library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity DriverTester is
    Port(LED_out : out STD_LOGIC_vector(7 downto 0);
        clk: in std_logic;
        LCD_BUS: out std_logic_vector (7 downto 0);
        LCD_RS: out std_logic;
        LCD_RW: out std_logic;
        LCD_E: out std_logic;
        LCD_RST: in std_logic);
    signal NUMBER: integer range 0 to 9;
    signal clkDISP: std_logic;
end DriverTester;

architecture Behavioral of DriverTester is

--------------------------COMPONENTS--------------------------
    --CLOCKDIVIDER
    component clockdivider
        Port ( clk_in: in std_logic;
               reset: in std_logic;
               clk_out: out std_logic);
    end component;
    
    --LCD_DRIVER
    component  LCD_driver
        Port ( clk: IN STD_LOGIC;  --system clock
               reset_n: IN STD_LOGIC;  --active low reinitializes lcd
               rw, rs, e: OUT STD_LOGIC;  --read/write, setup/data, and enable for lcd
               lcd_data: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --data signals for lcd
	           line1_string: IN String(15 downto 0);
	           line2_string: IN String(15 downto 0));
    end component;
    -- SEVEN SEGMENT DISPLAY DRIVER
    component  SEVENSEG_driver
        Port ( NUM_IN: in integer range 0 to 9;
               NUM_OUT: out std_logic_vector(7 downto 0));
    end component;
    
--------------------------VARIABLES--------------------------    
    signal divider: std_logic_vector(23 downto 0);    
    signal count: std_logic_vector(23 downto 0);
    signal LCD_STRING1: string(15 downto 0):= "Du skylder JJ en";
    signal LCD_STRING2: string(15 downto 0):= "tuborg classic  ";
    signal LCD_WRITE: std_logic := '1';
    
--------------------------PORT MAPS--------------------------       
    begin
    clkDiv: clockdivider port map(
        clk_in => clk, 
        reset =>'0', 
        clk_out =>clkDISP);
    LCD: LCD_driver port map(
        clk => clk,
        reset_n => LCD_WRITE, 
        rw => LCD_RW,
        rs => LCD_RS,
        e => LCD_E,
        lcd_data => LCD_BUS,
        line1_string =>LCD_STRING1,
        line2_string =>LCD_STRING2);
    disp: SEVENSEG_driver port map(
        NUM_IN => NUMBER,
        NUM_OUT => LED_out);
    
----------------------------MAIN-----------------------------      
    process(clkDISP, NUMBER) begin
        if rising_edge(clkDISP) then
            LCD_WRITE <= '0';
            if NUMBER <9 then
                NUMBER <= NUMBER + 1;
            else 
                NUMBER <= 0;
            end if;
        end if;
    end process;
end ;
