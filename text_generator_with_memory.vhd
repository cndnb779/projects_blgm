----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.08.2024 10:15:27
-- Design Name: 
-- Module Name: text_generator_with_memory - Behavioral
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
USE IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity text_generator_with_memory is
  Port (clk: in std_logic;
        reset: in std_logic;
        wr_en:in std_logic;
        data_o : out std_logic_vector(6 downto 0));
end text_generator_with_memory;

architecture Behavioral of text_generator_with_memory is
type states is(idle_state, write_state);
signal state: states:=idle_state;

begin

--process(clk,reset)
--begin
--if reset='1'then
--    data_o<="0000000";
  
--elsif rising_edge (clk) then
--    if wr_en='1' then


    
end Behavioral;
