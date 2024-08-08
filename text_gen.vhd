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
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity text_gen is
    Port ( reset: in std_logic;
           clk : in STD_LOGIC;
           active_video : in STD_LOGIC;
           pixel_x : in std_logic_vector(12 downto 0);--1920 ve 1080 için
           pixel_y : in std_logic_vector(11 downto 0);
           text_rgb : out std_logic_vector(11 downto 0);
           char_address: in std_logic_vector(6 downto 0));
end text_gen;

architecture Behavioral of text_gen is
--signal char_address: std_logic_vector(6 downto 0);
signal row_address: std_logic_vector(3 downto 0);
signal data_word : std_logic_vector(7 downto 0);--font
signal rom_address: std_logic_vector(10 downto 0);
signal bit_addr: std_logic_vector(2 downto 0);
signal data_bit, text_bit: std_logic;





component ascii_rom is--rom
  Port (clk_in: in std_logic;
        data_out: out std_logic_vector(7 downto 0);
        rom_address: in std_logic_vector(10 downto 0)--8*8 pixel(64 pixels)
        );
end component;


signal column: integer range 0 to 1920;    
signal data_mem: std_logic_vector(7 downto 0);   
type states_type is(idle_state, write_state);
signal state: states_type:=idle_state;    
begin



c1: ascii_rom --rom
  Port map(clk_in=> clk,
        data_out=> data_word,
        rom_address=> rom_address);--8*8 pixel(64 pixels)
        
        
--row_address<= pixel_y(3 downto 0);
--rom_address<= (char_address )& row_address;
--bit_addr<= pixel_x(2 downto 0);
--data_bit<=data_mem(to_integer(unsigned( not bit_addr)));
--text_bit<=
--    data_bit when pixel_x(12 downto 11)="00" and pixel_y(11 downto 8)="0000" and reset='0' else '0';
--column<=to_integer(unsigned(pixel_x));
process(clk)
begin
if rising_edge(clk) then
    case state  is
        when idle_state =>
            
           state<= write_state;
        when write_state=> 
           data_mem<= data_word; 
           column<= column + 8;
           row_address<= pixel_y(3 downto 0);
           rom_address<= (char_address )& row_address;
           bit_addr<= pixel_x(2 downto 0);
           data_bit<=data_mem(to_integer(unsigned( not bit_addr)));
           text_bit<=data_bit;

end case;
end if;
end process;
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
