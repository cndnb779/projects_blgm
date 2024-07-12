----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.07.2024 16:22:32
-- Design Name: 
-- Module Name: uart_tx_tb - Behavioral
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

entity uart_tx_tb is
--  Port ( );
generic(
    clk_freq : integer :=100_000_000;
    
    baudrate : integer := 115_200;
    stop_bit : integer := 2);
end uart_tx_tb;

architecture Behavioral of uart_tx_tb is
component uart_tx_1 is
    generic(
    clk_freq : integer :=100_000_000;
    
    baudrate : integer := 115_200;
    stop_bit : integer := 2);
    Port ( --s_tick : in STD_LOGIC;
   
           tx_start : in STD_LOGIC;
           tx_data_in : in std_logic_vector(7 downto 0);
           tx : out STD_LOGIC;
           tx_done_tick : out STD_LOGIC;
           clk : in STD_LOGIC);
end component;

signal clk : std_logic:='0';
signal tx_start : std_logic:='0';
signal tx_data_in : std_logic_vector(7 downto 0):=(others=>'0');
signal tx : std_logic;
signal tx_done_tick : std_logic;
constant clk_per : time:= 10 ns;
begin
DUT : uart_tx_1
generic map(
    clk_freq => clk_freq,
    
    baudrate => baudrate,
    stop_bit => stop_bit)
    
Port map( --s_tick : in STD_LOGIC;
            
           tx_start => tx_start,
           tx_data_in => tx_data_in,
           tx => tx ,
           tx_done_tick => tx_done_tick,
           clk => clk);
clock_process:process
begin
clk <=  '0';
wait for clk_per/2 ;
clk <=  '1';
wait for clk_per/2 ; 
end process;
 
stim_process: process
begin
tx_data_in <= x"00"; --hexadecimal
tx_start <='0' ;
wait for clk_per;

tx_data_in <= x"21"; --33 in decimal
tx_start <='1';
wait for clk_per;
tx_start <='0';--basla

wait for 8.7 us;


tx_data_in <= x"2F"; --47 in decimal
tx_start <='1';
wait for clk_per;
tx_start <='0';
wait until (rising_edge(tx_done_tick));
wait ;
end process;
end Behavioral;
