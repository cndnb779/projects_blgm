----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.07.2024 10:26:21
-- Design Name: 
-- Module Name: top_uart_fifo_tb - Behavioral
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

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.07.2024 16:28:36
-- Design Name: 
-- Module Name: son_tb - Behavioral
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
-- Create Date: 12.07.2024 16:42:50
-- Design Name: 
-- Module Name: top_tb - Behavioral
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



use IEEE.STD_LOGIC_1164.ALL;

entity top_uart_fifo_tb is
end top_uart_fifo_tb;

architecture Behavioral of top_uart_fifo_tb is

    -- Constants for simulation
--    constant clk_period : time := 10 ns; -- Adjust as necessary based on your clock frequency
    constant data_wdth: integer := 8;
    -- Components declarations
    component debounced_button_forfifo is
    Port ( push_button : in STD_LOGIC;
           clk : in STD_LOGIC;
--           reset : in STD_LOGIC;
           debounced_out : out STD_LOGIC);
end component; 
    component uart_tx_1
        generic (
            clk_freq : integer := 100_000_000;  -- Example clock frequency
            baudrate : integer := 115_200;
            stop_bit : integer := 2
        );
        port (
            tx_start : in STD_LOGIC;
            tx_data_in : in STD_LOGIC_VECTOR(7 downto 0);
            tx : out STD_LOGIC;
            tx_done_tick : out STD_LOGIC;
            clk : in STD_LOGIC
        );
    end component;

    component uart_rx_debo
        generic (
            clk_freq : integer := 100_000_000;  -- Example clock frequency
            baudrate : integer := 115_200
        );
        port (
            rx_in : in STD_LOGIC;
            clk : in STD_LOGIC;
            rx_data_out : out STD_LOGIC_VECTOR(7 downto 0);
            rx_done_tick : out STD_LOGIC;
            parity_error : out STD_LOGIC
        );
    end component;
    
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
   
    signal tb_clk : STD_LOGIC := '0';  -- Clock signal for simulation
    signal tx_start : STD_LOGIC := '0';  -- Signal to start transmission
    signal tx_data_in : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');  -- Data to transmit
    signal tx : STD_LOGIC;  -- Transmitter output
    signal tx_done_tick : STD_LOGIC;  -- Transmitter done tick signal
    signal rx_in : STD_LOGIC := '0';  -- Receiver input signal
    signal rx_data_out : STD_LOGIC_VECTOR(7 downto 0);  -- Data received by the receiver
    signal rx_done_tick : STD_LOGIC:='0';  -- Receiver done tick signal
    signal parity_error : STD_LOGIC:='0';  -- Parity error signal
    signal rst1 : std_logic:='0';
    signal wr_en : std_logic:='1';
    signal rd_en : std_logic:='0';
    signal data_o :std_logic_vector(7 downto 0);
    signal full : std_logic;
    signal empty : std_logic;
    signal push_button: std_logic:='0';
    signal debounced_out : std_logic;
    signal tx_1: std_logic;
    signal tx_done_tick_1:std_logic;
    signal tx_data_in_1:std_logic_vector(7 downto 0);
    signal tx_start_1: std_logic;
    constant deneme :std_logic_vector(10 downto 0):="11101000000";--error
begin
    UUT_debounced_button_forfifo: debounced_button_forfifo
    port map(push_button => push_button,
           clk => tb_clk,
--           reset =>rst2,
           debounced_out => debounced_out);
    UUT_fifo : fifo
    generic map(data_wdth=> 8,
    fifo_dpth=> 16)
    Port map( clk => tb_clk,
           rst => rst1,
           wr_en => wr_en,
           rd_en => debounced_out,
           data_i => rx_data_out,
           data_o => data_o,
           full => full,
           empty => empty);

   --push button vs??

    UUT_tx : uart_tx_1
        generic map (
            clk_freq => 100_000_000,  -- Example clock frequency
            baudrate => 115_200,
            stop_bit => 2
        )
        port map (
            tx_start => tx_start,
            tx_data_in => tx_data_in,
            tx => tx,
            tx_done_tick => tx_done_tick,
            clk => tb_clk
        );
    UUT_tx_2 : uart_tx_1--diðer kaynaktan gelen
        generic map (
            clk_freq => 100_000_000,  -- Example clock frequency
            baudrate => 115_200,
            stop_bit => 2
        )
        port map (
            tx_start => tx_start_1,
            tx_data_in => tx_data_in_1,
            tx => tx_1,
            tx_done_tick => tx_done_tick_1,
            clk => tb_clk
        );
    -- Instantiate UART Receiver
    UUT_rx : uart_rx_debo
        generic map (
            clk_freq => 100_000_000,  -- Example clock frequency
            baudrate => 115_200
        )
        port map (
            rx_in => tx_1,
            clk => tb_clk,
            rx_data_out => rx_data_out,
            rx_done_tick => rx_done_tick,
            parity_error => parity_error
        );

    -- Clock Process for test bench
    tb_clk_process : process
    begin
            tb_clk <= '0';
            wait for 5 ns ;
            tb_clk <= '1';
            wait for 5 ns;
    end process tb_clk_process;
process(full,empty,tb_clk)
begin
if (rising_edge(tb_clk)) then
    if (full='1') then--empty syrekli
        if (empty='0') then
            tx_data_in<= x"46";
            tx_start<='1';
        else
            tx_start<='0';    
        end if;
    else
        if (empty='1') then
            tx_data_in <= x"45";
            tx_start<='1'; 
        else
            tx_start<='0';          
        end if;
    end if;    
end if;
end process;
   
    
    tb_uarttop_stimulus : process
    begin
        -- Example transmission sequence
        tx_start_1 <= '1';  -- Start transmission
        tx_data_in_1 <= "01010101";  -- Example data to transmit
        
        
        wait for 100 ns;  -- Wait for transmission to complete (adjust timing as needed)
        tx_start_1 <= '0';  -- End transmission
        wait for 110 us;
        tx_start <= '1';  -- Start transmission
        tx_data_in_1 <= "01010111";  -- Example data to transmit
        wait for 100 ns;  -- Wait for transmission to complete (adjust timing as needed)
        tx_start <= '0';
        wait for 110 us;
--        tx_start <= '1';  -- Start transmission
--        tx_data_in <= "01011111";  -- Example data to transmit
--        wait for 100 ns;  -- Wait for transmission to complete (adjust timing as needed)
--        tx_start <= '0';
--        wait for 110 us;
--        tx_start <= '1';  -- Start transmission
--        tx_data_in <= "01111111";  -- Example data to transmit
--        wait for 100 ns;  -- Wait for transmission to complete (adjust timing as needed)
--        tx_start <= '0';
        wait;
    end process tb_uarttop_stimulus;

    
    

end Behavioral;





