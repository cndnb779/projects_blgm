----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.07.2024 09:25:23
-- Design Name: 
-- Module Name: rx_tb - Behavioral
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

entity rx_tb is
   
    generic(
    clk_freq : integer :=100_000_000;
    
    baudrate : integer := 115200
    );
--  Port ( );
end rx_tb;

architecture Behavioral of rx_tb is
component uart_rx is
    generic(
    clk_freq : integer :=100_000_000;
    
    baudrate : integer := 115200
    );
    Port ( rx_in : in STD_LOGIC;
           clk : in STD_LOGIC;
           rx_data_out : out  std_logic_vector(7 downto 0);
           rx_done_tick : out STD_LOGIC;
           parity_error: out std_logic);
end component;
signal rx_in: std_logic:='1';
signal clk : std_logic:='0';
signal rx_data_out : std_logic_vector(7 downto 0);
signal rx_done_tick : std_logic;
signal parity_error : std_logic:='0';
constant clk_per : time:= 10 ns;
constant cbaud :time := 868 ns;--clk freq/ baud rate
constant deneme :std_logic_vector(10 downto 0):="11101010000";--error
constant deneme2 :std_logic_vector(10 downto 0):="11111101010";--error prity
constant deneme3 :std_logic_vector(10 downto 0):="11001101010";--error parit
constant deneme4 :std_logic_vector(10 downto 0):="10000010010";--no error parity
begin
DUT: uart_rx
 generic map(
    clk_freq => clk_freq,
    
    baudrate => baudrate
    ) 
    Port map( rx_in =>rx_in,
           clk => clk,
           rx_data_out => rx_data_out,
           rx_done_tick => rx_done_tick,
           parity_error => parity_error);
clock_process:process
begin
clk <=  '0';
wait for clk_per/2 ;
clk <=  '1';
wait for clk_per/2 ; 
end process;
stim_process: process
begin --8.68 us
wait for 10 ns;
for i in 0 to 10 loop
    rx_in<=deneme(i);
    wait for 8680 ns; --8.68 us 

end loop;

wait for 10 ns;
for i in 0 to 10 loop
    rx_in<=deneme2(i);
    wait for 8680 ns;  

end loop;
wait for 10 ns;
for i in 0 to 10 loop
    rx_in<=deneme3(i);
    wait for 8680 ns;  

end loop;
wait for 10 ns;
for i in 0 to 10 loop
    rx_in<=deneme4(i);
    wait for 8680 ns;  

end loop;

--for i in 0 to 9 loop
--    rx_in<=deneme3(i);
--    wait for cbaud;  

--end loop;
assert false;
report "done"
severity failure;
end process;

end Behavioral;
