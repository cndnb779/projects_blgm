----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.08.2024 08:22:55
-- Design Name: 
-- Module Name: top_module_vga - Behavioral
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module_vga is--hsync vsync rgb gerekli ve uarta girdi
  Port (clk_in_100: in std_logic;
        reset: in std_logic;
        hsync: out std_logic;
        vsync: out std_logic;
        rx_data_in_ascii: in std_logic;
        red: out std_logic_vector(3 downto 0);
        green: out std_logic_vector(3 downto 0);
        blue: out std_logic_vector(3 downto 0) );
end top_module_vga;

architecture Behavioral of top_module_vga is
component vga_controller_with_coordinates is
  Port (reset: in std_logic;
        h_sync: out std_logic;
        clk_in_100: in std_logic;
        v_sync: out std_logic;
        x_coor: out integer range 0 to 1920-1;
        y_coor : out integer range 0 to 1080-1;
        active: out std_logic;
--        red: out std_logic_vector(3 downto 0);
--        green: out std_logic_vector(3 downto 0);
--        blue: out std_logic_vector(3 downto 0);
        row_pixel: out std_logic_vector(9 downto 0);
        column_pixel: out std_logic_vector(9 downto 0));
     
end component;



component text_generator is
    Port ( clk : in STD_LOGIC;
           active_video : in STD_LOGIC;
           pixel_x : in std_logic_vector(9 downto 0);
           pixel_y : in std_logic_vector(9 downto 0);
           text_rgb : out std_logic_vector(11 downto 0);
           char_address: in std_logic_vector(6 downto 0));
end component;

component uart_rx_debo is
    generic(
    clk_freq : integer :=100_000_000;--1000000/115200=8.68 
    baudrate : integer := 115200
    );
    Port ( rx_in : in STD_LOGIC;
           clk : in STD_LOGIC;
           rx_data_out : out  std_logic_vector(7 downto 0);
           rx_done_tick : out STD_LOGIC;
           parity_error: out std_logic);
end component;
component clk_wiz_0  is port(
    clk_out1 : out std_logic;
    reset : in std_logic;
    locked :out std_logic;
    clk_in1: in std_logic );
    end component;
    
signal rx_done_tick: std_logic;
signal rx_data_out_char: std_logic_vector(7 downto 0);
signal parity_error: std_logic;
signal pixel_on: std_logic;
signal row_pixel:std_logic_vector(9 downto 0);
signal column_pixel:std_logic_vector(9 downto 0);
constant baudrate: integer:= 115200;
constant clk_freq: integer:= 100_000_000;
signal x_coor: integer range 0 to 1920-1;
signal   y_coor :  integer range 0 to 1080-1;
signal active_area: std_logic;
signal rgb: std_logic_vector(11 downto 0);
signal data_char: std_logic_vector(7 downto 0);
signal clk_pixel: std_logic;
signal locked : std_logic;
signal char_address: std_logic_vector(6 downto 0);
signal rom_address: std_logic_vector(10 downto 0);
begin
u1: uart_rx_debo generic map(
    clk_freq => clk_freq,--1000000/115200=8.68 
    baudrate => baudrate)
    Port map( rx_in => rx_data_in_ascii ,
           clk => clk_in_100,
           rx_data_out => rx_data_out_char,
           rx_done_tick => rx_done_tick,
           parity_error => parity_error);
u4:  vga_controller_with_coordinates 
  Port map(reset=> reset,
        h_sync=> hsync,
        clk_in_100=> clk_in_100,
        v_sync=> vsync,
        x_coor=> x_coor,--hcount
        y_coor=> y_coor,
        active=> active_area,
--        red=> red,
--        green=> green,
--        blue=> blue,
        row_pixel=>row_pixel,
        column_pixel=> column_pixel);

u3:  text_generator 
    Port map( clk =>clk_in_100,
           active_video => active_area,
           pixel_x => row_pixel,
           pixel_y => column_pixel,
           text_rgb => rgb,
           char_address=> rx_data_out_char(6 downto 0));



--rgb<=(others=>'1') when (active_area='1') and (pixel_on='1') else (others=>'0');
red<= rgb(11 downto 8);
green<= rgb(7 downto 4);
blue<= rgb(3 downto 0);


        


end Behavioral;
