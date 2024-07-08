----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.07.2024 08:18:00
-- Design Name: 
-- Module Name: top_ripplecarryadder - Behavioral
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

entity top_ripplecarryadder is
    Port ( c_in : in STD_LOGIC;
           SUM : out std_logic_vector(15 downto 0);
           a : in std_logic_vector(15 downto 0);
           b : in std_logic_vector(15 downto 0);
           c_out : out STD_LOGIC);
end top_ripplecarryadder;

architecture Behavioral of top_ripplecarryadder is

component full_adder_withdelay is
    Port ( a : in std_logic;
           b : in STD_LOGIC;
           c_in : in STD_LOGIC;
           sum : out STD_LOGIC;
           c_out : out STD_LOGIC);
end component;
signal c_inout: std_logic_vector(16 downto 0);
begin
c_inout(0)<=c_in ;
g_GENERATE_FOR: for i in 0 to 15 generate --width 15
    u1: full_adder_withdelay port map(a(i),b(i),c_inout(i),SUM(i),c_inout(i + 1));
  end generate g_GENERATE_FOR;
  
c_out<=c_inout(16);
end Behavioral;
