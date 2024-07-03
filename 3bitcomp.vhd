----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.06.2024 14:08:48
-- Design Name: 
-- Module Name: 3bitcomp - Behavioral
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

entity bit3comp is
    Port ( a : in std_logic_vector(2 downto 0);
           b : in std_logic_vector(2 downto 0);
           a_equalto_b : out STD_LOGIC;
           a_greaterthan_b : out STD_LOGIC;
           a_smallerthan_b : out STD_LOGIC);
end bit3comp;

architecture Behavioral of bit3comp is
signal st1, st2, st3, st4, st5,st6,st7, st8, st9 :std_logic;
begin
st1 <= not(a(2)XOR b(2)); --xnor
st2 <= not(a(1)XOR b(1));
st3 <= not(a(0)XOR b(0));
st4 <= not(a(0)) and b(0);
st5 <= not(a(1)) and b(1);
st6 <= not(a(2)) and b(2); --nota
st7 <= not(b(0)) and a(0);
st8 <= not(b(1)) and a(1);
st9 <= not(b(2)) and a(2);
a_equalto_b <= st1 and st2 and st3;
a_smallerthan_b <= (st1 and st5) or st6 or (st2 and st1 and st4);
a_greaterthan_b <= (st1 and st8) or st9 or (st7 and st1 and st2);


end Behavioral;
