----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.08.2024 08:38:48
-- Design Name: 
-- Module Name: top_modulevgatext - Behavioral
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
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_modulevgatext is--hsync vsync rgb gerekli ve uarta girdi
  Port (clk_in_100: in std_logic;
        reset: in std_logic;
        hsync: out std_logic;
        vsync: out std_logic;
        rx_data_in_ascii: in std_logic;
        red: out std_logic_vector(3 downto 0);
        green: out std_logic_vector(3 downto 0);
        blue: out std_logic_vector(3 downto 0) );
end top_modulevgatext;

architecture Behavioral of top_modulevgatext is
component vga_driver is
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
        row_pixel: out std_logic_vector(12 downto 0);
        column_pixel: out std_logic_vector(11 downto 0));
     
end component;



component text_gen is
    Port ( reset: in std_logic;
           clk : in STD_LOGIC;
           active_video : in STD_LOGIC;
           pixel_x : in std_logic_vector(12 downto 0);--2200
           pixel_y : in std_logic_vector(11 downto 0);
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
signal row_pixel:std_logic_vector(12 downto 0);
signal column_pixel:std_logic_vector(11 downto 0);
constant baudrate: integer:= 115200;
constant clk_freq: integer:= 100_000_000;
signal x_coor: integer range 0 to 1920-1;
signal   y_coor :  integer range 0 to 1080-1;
signal active_area: std_logic;
signal rgb: std_logic_vector(11 downto 0);
signal data_char: std_logic_vector(7 downto 0);
signal char_address: std_logic_vector(6 downto 0);
signal rom_address: std_logic_vector(10 downto 0);
signal rx_temp: std_logic;

signal clk_o :std_logic:='0';
signal locked :std_logic:='0';

signal row_address: std_logic_vector(3 downto 0);
signal data_word : std_logic_vector(7 downto 0);--font
--signal rom_address: std_logic_vector(10 downto 0);
signal bit_addr: std_logic_vector(2 downto 0);
signal data_bit, text_bit: std_logic;

signal x_up: integer range 0 to 1920:= 208;
signal    x_down: integer range 0 to 1920:= 199;
signal   y_up: integer range 0 to 1080:= 80;
signal   y_down: integer range 0 to 1080:= 60;

type states_type is ( start, write_state);
signal states: states_type:=start;

component ascii_rom is--rom
  Port (clk_in: in std_logic;
        data_out: out std_logic_vector(7 downto 0);
        rom_address: in std_logic_vector(10 downto 0)--8*8 pixel(64 pixels)
        );
end component;


signal column: integer range 0 to 1920;    
signal data_mem: std_logic_vector(7 downto 0);   
--type states_type is(idle_state, write_state);
--signal state: states_type:=idle_state;  

signal wr_en: std_logic:='0';

begin
rx_temp<= not rx_data_in_ascii;
u1: uart_rx_debo generic map(
    clk_freq => clk_freq,--1000000/115200=8.68 
    baudrate => baudrate)
    Port map( rx_in => rx_temp ,
           clk => clk_in_100,
           rx_data_out => rx_data_out_char,
           rx_done_tick => rx_done_tick,
           parity_error => parity_error);
u4:  vga_driver 
  Port map(reset=> reset,
        h_sync=> hsync,
        clk_in_100=> clk_o,
        v_sync=> vsync,
        x_coor=> x_coor,--hcount
        y_coor=> y_coor,
        active=> active_area,
        row_pixel=>row_pixel,
        column_pixel=> column_pixel);
        
        
  c1: ascii_rom --rom
  Port map(clk_in=> clk_o,
        data_out=> data_word,
        rom_address=> rom_address);

--u3:  text_gen 
--    Port map( reset=> reset,
--            clk =>clk_in_100,
--           active_video => active_area,
--           pixel_x => row_pixel,
--           pixel_y => column_pixel,
--           text_rgb => rgb,
--           char_address=> char_address);
c2: clk_wiz_0  port map(clk_out1=>clk_o,reset=> reset,locked => locked, clk_in1=> clk_in_100);

row_address<= column_pixel(3 downto 0);--NP 16 tane 8 bitlik bit map
rom_address<= (char_address )& row_address;
bit_addr<= row_pixel(2 downto 0);--8 BÝTLÝK VERÝ

data_bit <= data_word(to_integer(unsigned( not bit_addr)));
--text_bit<=
--    data_bit when to_integer(unsigned(row_pixel))<x_up and to_integer(unsigned(row_pixel))> x_down and to_integer(unsigned(column_pixel))< y_up and  to_integer(unsigned(column_pixel))> y_down else '0'; --YUKARI ÇEKMELÝYÝM to_integer(unsigned(pixel_x))> 192 and

process(clk_in_100)
begin
   
if reset='1'then
    char_address<="0000000";  
elsif rising_edge(clk_in_100) then
    case states is 
    when start =>
        if wr_en = '1' then
            states <= write_state;  -- Correct assignment
        end if;    
    when write_state =>
        if rx_done_tick = '1' then
            x_up <= x_up + 8;   -- Correct assignment
            x_down <= x_down + 8;
            char_address <= rx_data_out_char(6 downto 0);
            states <= write_state;
            if to_integer(unsigned(row_pixel))<x_up and to_integer(unsigned(row_pixel))> x_down and to_integer(unsigned(column_pixel))< y_up and  to_integer(unsigned(column_pixel))> y_down then
            
                text_bit<=data_bit;
                
             end if;
                
            
        end if;
end case;

end if;  
end process;
red<= rgb(11 downto 8);
green<= rgb(7 downto 4);
blue<= rgb(3 downto 0);


        


end Behavioral;
