----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.07.2024 15:53:55
-- Design Name: 
-- Module Name: full_adder_withdelay - Behavioral
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

entity full_adder_withdelay is
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           c_in : in STD_LOGIC;
           sum : out STD_LOGIC;
           c_out : out STD_LOGIC);
end full_adder_withdelay;

architecture Behavioral of full_adder_withdelay is
signal s1 : std_logic;
signal c1: std_logic;
signal c2: std_logic;

begin

c1 <= (a and b) after 5 ns;
s1<= a XOR b after 10 ns;
c2<= c_in and s1 after 5 ns;
c_out<= c1 or c2 after 5 ns;
sum<= s1 XOR c_in after 10 ns;




end Behavioral;
