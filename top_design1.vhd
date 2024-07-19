----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.07.2024 15:57:10
-- Design Name: 
-- Module Name: top_design1 - Behavioral
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

entity top_design1 is
 Port ( rx_in : in std_logic;
         push_button:in std_logic;
           tx_out : out STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           --parity_error : out std_logic;
           data_o : out STD_LOGIC_VECTOR(7 downto 0));--lede bagli fifodan 
end top_design1;

architecture Behavioral of top_design1 is

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
    Port ( 
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
--           reset : in STD_LOGIC;
           debounced_out : out STD_LOGIC);
end component; 
--signal rx_in : STD_LOGIC ;  -- Receiver input signal
signal rx_dout : STD_LOGIC_VECTOR(7 downto 0);  -- Data received by the receiver
signal rx_done_tick : STD_LOGIC;  -- Receiver done tick signalsignal rx_dout: std_logic_vector(7 downto 0);
signal tx_data_in: std_logic_vector(7 downto 0); --fifodan f veya e ascii kodu fifodan cýkan full ve empty ye gore
signal rx_donetick: std_logic;
signal tx_donetick: std_logic;
signal tx_start:std_logic;
signal debounced_out: std_logic;
signal full : std_logic;
signal empty: std_logic;
signal parity_error:std_logic;--??
 

constant fifo_dpth: integer:= 16;
constant  clk_freq : integer :=100_000_000;
constant data_wdth: integer := 8;    
constant    baudrate : integer := 115_200;
constant   stop_bit : integer := 2;

begin
u1: uart_rx_debo generic map(clk_freq,baudrate) 
    port map(rx_in,clk,rx_dout,rx_donetick,parity_error);
    
u2: uart_tx_1 generic map(clk_freq,baudrate,stop_bit )
    port map(tx_start,tx_data_in,tx_out,tx_donetick,clk);
    
u3: fifo generic map(data_wdth,fifo_dpth)
port map(clk,rst,rx_donetick,debounced_out, rx_dout, data_o, full, empty);

u4: debounced_button_forfifo port map(push_button,clk,debounced_out);
t_process:process (clk)
begin
 
    if (empty='1') then
             tx_data_in<=x"45";
             tx_start<='1';
    elsif(full='1') then
             tx_data_in<= x"46";
             tx_start<='1';
    else 
        tx_start<='0';         
   end if;

 end process;


end Behavioral;
