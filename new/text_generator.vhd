----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.08.2024 11:05:29
-- Design Name: 
-- Module Name: text_generator - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity text_generator is
   
    Port ( reset: in std_logic;
           clk_in : in STD_LOGIC;
           active_video : in STD_LOGIC;
           pixel_x : in std_logic_vector(12 downto 0);--1920 ve 1080 için
           pixel_y : in std_logic_vector(11 downto 0);
           text_rgb : out std_logic_vector(11 downto 0);
           char_address: in std_logic_vector(6 downto 0));
end text_generator;

architecture Behavioral of text_generator is
--signal char_address: std_logic_vector(6 downto 0);
signal row_address: std_logic_vector(3 downto 0);
signal data_word : std_logic_vector(7 downto 0);--font
signal rom_address: std_logic_vector(10 downto 0);
signal bit_addr: std_logic_vector(2 downto 0);
signal data_bit, text_bit: std_logic;

constant x_up: integer range 0 to 1920:= 208;
constant    x_down: integer range 0 to 1920:= 199;
 constant   y_up: integer range 0 to 1080:= 80;
 constant   y_down: integer range 0 to 1080:= 60;


component ascii_to_pixel_converter is--rom
  Port (clk_in: in std_logic;
        data_out: out std_logic_vector(7 downto 0);
        rom_address: in std_logic_vector(10 downto 0)--8*8 pixel(64 pixels)
        );
end component;
    
    
begin

c1: ascii_to_pixel_converter --rom
  Port map(clk_in=> clk_in,
        data_out=> data_word,
        rom_address=> rom_address);--8*8 pixel(64 pixels)
        

    
row_address<= pixel_y(3 downto 0);--NP 16 tane 8 bitlik bit map
rom_address<= (char_address )& row_address;
bit_addr<= pixel_x(2 downto 0);--8 BÝTLÝK VERÝ

data_bit <= data_word(to_integer(unsigned( not bit_addr)));
text_bit<=
    data_bit when to_integer(unsigned(pixel_x))<x_up and to_integer(unsigned(pixel_x))> x_down and to_integer(unsigned(pixel_y))< y_up and  to_integer(unsigned(pixel_y))> y_down else '0'; --YUKARI ÇEKMELÝYÝM to_integer(unsigned(pixel_x))> 192 and

--    text_bit <= data_bit when active_video = '1' else '0';

process(active_video,text_bit)
begin

    if (active_video='0') then
        text_rgb<="000000000000";--siyah
    elsif text_bit='1' then
        text_rgb<="111111111111";
    else        
        text_rgb<="000000000000";
        
    end if;

end process;        
end Behavioral;
