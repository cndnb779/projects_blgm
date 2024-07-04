----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.07.2024 14:16:07
-- Design Name: 
-- Module Name: debouncer - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
    Port ( clk : in STD_LOGIC;
           --new_out : out std_logic;
           d_in: in std_logic;
           debounced_out : out STD_LOGIC;
           reset: in std_logic);
end debouncer;

architecture Behavioral of debouncer is
constant n : integer :=16;
signal shift_reg: std_logic_vector(n-1 downto 0);
signal debouncing : std_logic;
begin
process(clk, reset)
begin
if reset = '1' then
    shift_reg <=(others=>'0');
    debouncing<='0';
elsif rising_edge(clk) then
    shift_reg<=shift_reg(n-2 downto 0) & d_in; --using shift rgister    
    if shift_reg = "111111111111111" then
        debouncing <= not debouncing;
        --new_out <= debouncing;
    --elsif shift_reg = "000000000000000" then
        
    end if;
end if; 
end process;   
debounced_out<=debouncing;    
end Behavioral;
