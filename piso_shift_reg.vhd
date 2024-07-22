----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.07.2024 08:39:58
-- Design Name: 
-- Module Name: piso_shift_reg - Behavioral
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

entity piso_shift_reg is
    Port ( serial_out : out STD_LOGIC;
           p_in : in std_logic_vector(7 downto 0);
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           clear : in std_logic);
end piso_shift_reg;

architecture Behavioral of piso_shift_reg is
signal shift_reg: std_logic_vector(7 downto 0);
begin
process (clk, clear )
begin
if (clear='1') then
    shift_reg<="00000000";
elsif rising_edge(clk) then
    if enable ='1' then
        shift_reg<=p_in;
    else
        shift_reg <= '0' & shift_reg(7 downto 1) ;    
    end if;
end if;
end process;
serial_out<= shift_reg(0);       
end Behavioral;
