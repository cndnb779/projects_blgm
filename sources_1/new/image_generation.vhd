----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.08.2024 10:57:03
-- Design Name: 
-- Module Name: image_generation - Behavioral
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

entity image_generation is
  Port (clk_in_100: in std_logic;
        reset: in std_logic;
        active: in std_logic;x_coor: in std_logic_vector;
        y_coor: in std_logic_vector;
        red: out std_logic_vector(3 downto 0);
        green: out std_logic_vector(3 downto 0);
        blue: out std_logic_vector(3 downto 0) );
end image_generation;

architecture Behavioral of image_generation is
component vga_controller_with_coordinates is
  Port (reset: in std_logic;
        h_sync: out std_logic;
        clk_in_100: in std_logic;
        v_sync: out std_logic;
        x_coor: out std_logic_vector(11 downto 0);
        y_coor : out std_logic_vector(10 downto 0);
        active: out std_logic
         );
end component;

constant h_front_porch: integer:=88;
constant h_back_porch: integer:=148;
constant hva: integer:=1920;
constant h_syncpulse: integer:=44;

constant v_front_porch: integer:=4;
constant v_back_porch: integer:=36;
constant v_syncpulse: integer:=5;
constant vva: integer:=1080;--??
constant horiz_line:integer:= hva+h_back_porch+h_front_porch+h_syncpulse;--800
constant ver_line: integer :=vva+v_back_porch+v_front_porch+ v_syncpulse;--

signal active_signal: std_logic;
signal x_coor_temp: std_logic_vector;
signal y_coor_temp : std_logic_vector;
signal v_sync: std_logic;
signal h_sync: std_logic;

begin
u1: vga_controller_with_coordinates 
  Port map (reset=> reset,
        h_sync=> h_sync,
        clk_in_100=>clk_in_100,
        v_sync=> v_sync,
        x_coor=> x_coor_temp,
        y_coor => y_coor_temp,
        active => active_signal
         );


process(x_coor_temp,y_coor_temp,active_signal)
begin
if (active_signal='1') then
    if to_integer(unsigned(x_coor_temp)) < (hva/2) then
        red<="1100";
        green<="0000";
        blue<="0110";
    else
        red<="0000";
        green<="0000";
        blue<="1111";
    end if;
else
    red<="0000";
    green<="0000";
    blue<="0000";        
end if;        

end process;

end Behavioral;
