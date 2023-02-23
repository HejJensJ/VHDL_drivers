LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

entity clockdivider is 
    port (
        clk_in: in std_logic;
        reset: in std_logic;
        clk_out: out std_logic);
end clockdivider;
    
architecture Behavioral of clockdivider is
    signal divider: std_logic_vector(23 downto 0);
    signal count: std_logic_vector(23 downto 0);
begin
    process (clk_in,reset)
    begin
        if reset='1' then
            divider<="000000000000000000000000";
            
        elsif rising_edge(clk_in) then
            divider <= divider + '1';
        end if;
    end process;
    clk_out<=divider(23);
    process (divider(23))
    begin
        if reset = '1' OR count <= "111111111111111111111111" then
            count <= "000000000000000000000000";
        elsif rising_edge(divider(23)) then
            count<=count + '1'; 
        end if;
    end process;
end Behavioral;
