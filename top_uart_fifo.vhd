----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2024 08:59:41
-- Design Name: 
-- Module Name: top_uart_fifo - Behavioral
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

entity top_uart_fifo is
    Port ( push_button:in std_logic;
           rx_in : in STD_LOGIC;
           tx_out : out STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           read_en : in STD_LOGIC;
           write_en : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(7 downto 0));--lede bagli
end top_uart_fifo;

architecture Behavioral of top_uart_fifo is

component fifo is
    generic(data_wdth: integer := 8;
    fifo_dpth: integer:= 16);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           wr_en : in STD_LOGIC;
           rd_en : in STD_LOGIC;
           data_i : in std_logic_vector(data_wdth -1 downto 0);
           data_o : out std_logic_vector(data_wdth -1 downto 0);
           full : out STD_LOGIC;
           empty : out STD_LOGIC);
end component;
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

component debounced_button_forfifo is
    Port ( push_button : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           debounced_out : out STD_LOGIC);
end component; 

signal rx_dout: std_logic_vector(7 downto 0);
signal tx_din: std_logic_vector(7 downto 0); --fifodan f veya e ascii kodu fifodan cýkan full ve empty ye gore
signal rx_donetick: std_logic;
signal tx_donetick: std_logic;
signal parity_error: std_logic;
signal tx_start:std_logic;
signal debounced_out: std_logic;
signal full : std_logic;
signal empty: std_logic;

constant  clk_freq : integer :=100_000_000;
constant data_wdth: integer := 8;    
constant    baudrate : integer := 115_200;
constant   stop_bit : integer := 2;
--begin
--process(clk)
begin

u1: uart_rx_debo generic map(clk_freq,baudrate) 
    port map(rx_in,clk,rx_dout,rx_donetick,parity_error);
    
u2: uart_tx_1 generic map(clk_freq,baudrate,stop_bit )
    port map(tx_start,tx_din,tx_out,tx_donetick,clk);
    
u3: fifo generic map(data_wdth)
port map(clk,rst,rx_donetick,debounced_out, rx_dout, data_out, full, empty);

u4: debounced_button_forfifo port map(push_button,clk, rst,debounced_out);
process(full,empty)
begin
if (full='1') then
    if (empty='0') then
        tx_din<= x"46";
    end if;
else
    if (empty='1') then
        tx_din <= x"45";       
    end if;
end if;
end process;
end Behavioral;
