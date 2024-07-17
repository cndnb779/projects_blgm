----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2024 08:56:15
-- Design Name: 
-- Module Name: button_debounced_forfifo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity debounced_button_forfifo is
    Port ( push_button : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           debounced_out : out STD_LOGIC);
end debounced_button_forfifo;

architecture Behavioral of debounced_button_forfifo is
constant delay : integer := 1_000_000;
signal count : integer range 0 to delay:=0;
signal debounced: std_logic:='0';
signal stable: std_logic:='0';
signal passing : std_logic:='0';
signal prev_debounced : std_logic:='0';
--signal prev_stable: std_logic:='0';
begin
process(clk,reset, push_button)

begin
if reset = '1' then
    count <= 0;
    debounced <='0';
    stable<='0';
    passing <= '0';
    prev_debounced <='0';
elsif rising_edge(clk) then
    stable <= push_button;
    if push_button = stable then
        if count < delay then
            count <= count+1; --10 ms
        else
            debounced <=  stable;--deb 0 --deb1
        end if;
     else --push 1
        count <=0;           
        stable <= push_button; --stable 1 st 0
        
     end if;
     if (debounced = '1' and prev_debounced='0') then
        passing <= not passing;
     end if;
     prev_debounced <= debounced; --0  
end if;
end process;       
debounced_out<=passing;    
end Behavioral;


