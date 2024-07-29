----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.07.2024 14:27:19
-- Design Name: 
-- Module Name: to_dtb2 - Behavioral
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

entity to_dtb2 is
--  Port ( );
end to_dtb2;

architecture Behavioral of to_dtb2 is
component top_design1 is
 Port ( rx_in : in std_logic;
         push_button:in std_logic;
           tx_out : out STD_LOGIC;
           wclk : in STD_LOGIC;
           rst : in STD_LOGIC;
           --parity_error : out std_logic;
           data_o : out STD_LOGIC_VECTOR(7 downto 0));--lede bagli fifodan 
end component;
constant deneme5 :std_logic_vector(11 downto 0):="111100100100";--no error parity
signal rx_in: std_logic;
signal wclk : std_logic:='0';
--signal rx_data_out : std_logic_vector(7 downto 0);
--signal rx_done_tick1 : std_logic:='0';
--signal parity_error : std_logic:='0';
signal push_button: std_logic:='0';
  signal rst: std_logic:='0';
  signal data_o : std_logic_vector(7 downto 0);
  signal tx_out : std_logic;
constant deneme :std_logic_vector(11 downto 0):="111110100000";--error
constant deneme2 :std_logic_vector(11 downto 0):="111111100000";
constant deneme3 :std_logic_vector(11 downto 0):="111110110000";
constant deneme4 :std_logic_vector(11 downto 0):="111110000000";
constant deneme6 :std_logic_vector(11 downto 0):="111110000000";
constant deneme7 :std_logic_vector(11 downto 0):="111110000000";
constant deneme8 :std_logic_vector(11 downto 0):="111110001000";
constant deneme9 :std_logic_vector(11 downto 0):="111110000000";
constant deneme10 :std_logic_vector(11 downto 0):="111110001000";
constant deneme11 :std_logic_vector(11 downto 0):="111110000000";
constant deneme12 :std_logic_vector(11 downto 0):="111110000000";
constant deneme13 :std_logic_vector(11 downto 0):="111110000000";
constant deneme14 :std_logic_vector(11 downto 0):="111110000000";
constant deneme15 :std_logic_vector(11 downto 0):="111110001000";
constant deneme16 :std_logic_vector(11 downto 0):="111110111000";
begin
UUT_top_design1: top_design1 
 Port map( rx_in => rx_in,
         push_button=> push_button,
           tx_out =>tx_out,
           wclk => wclk,
           rst => rst,
           --parity_error : out std_logic;
           data_o => data_o);
           
tb_clk_process : process
begin
            wclk <= '0';
            wait for 5 ns ;
            wclk <= '1';
            wait for 5 ns;
end process tb_clk_process;
stim_process: process
begin --8.68 us
wait for 10 ns;
for i in 0 to 11 loop
    rx_in<=deneme(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme2(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme3(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme4(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme5(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme5(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme6(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme7(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme8(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme9(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme10(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme11(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme12(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme13(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme14(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme15(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme16(i);
    wait for 8680 ns; --8.68 us 
end loop;
for i in 0 to 11 loop
    rx_in<=deneme16(i);
    wait for 8680 ns; --8.68 us 
end loop;
push_button<='1';

wait for 10 ms;
wait;
end process;
end Behavioral;
