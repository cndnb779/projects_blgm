----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.07.2024 10:55:50
-- Design Name: 
-- Module Name: uart_tx_1 - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx_1 is
    generic(
    clk_freq : integer :=100_000_000;
    
    baudrate : integer := 115_200;
    stop_bit : integer := 1);
    Port ( --s_tick : in STD_LOGIC;
    
           tx_start : in STD_LOGIC;
           tx_data_in : in std_logic_vector(7 downto 0);
           tx : out STD_LOGIC;
           tx_done_tick : out STD_LOGIC;
           clk : in STD_LOGIC);
end uart_tx_1;

architecture Behavioral of uart_tx_1 is
constant lim: integer:= clk_freq/baudrate;

constant stopbitlim : integer:= (clk_freq/baudrate)* stop_bit;
type states is (idle_stat, start_stat, data_stat, parity_stat, stop_stat);
signal state : states := idle_stat;
signal b : std_logic_vector(7 downto 0);--bits to be shifted
signal n : integer range 0 to 7:=0;--number of data bits counter
signal bittimer : integer range 0 to stopbitlim:=0; --number of s ticks
signal num_of_ones :integer range 0 to 8:=0;--num of ones for even parity
begin
process(clk)
begin
if (rising_edge(clk)) then
case state is
    when idle_stat =>
        tx<= '1';
        tx_done_tick <='0';
        n <= 0;
        if (tx_start = '1') then
            state<= start_stat;
            tx <='0';
            b <= tx_data_in;
        else
            state <= idle_stat;    
        end if;    
            
    when start_stat =>
        tx <='0';
        if (bittimer = (lim )) then
            state <= data_stat;
            tx <= b(0);
            b(6 downto 0)<= b(7 downto 1); --  shifted
            b(7) <= b(0);
            bittimer <= 0;
        else
            bittimer <= bittimer+1;    
        end if;
           
                
    when data_stat =>  --tx <= b(0); 
        
        if ( n = 7) then --tum data geldi
            if (bittimer = lim) then
                bittimer <= 0;
                n<=0; --parity geçmeden sıfırlandı
                state <= parity_stat;
                if (b(0) = '1') then
                    num_of_ones <= num_of_ones + 1;
                end if;
                --tx <='1'; stop statee geçince 1
            else
                bittimer<= bittimer + 1;  
                --tx <= b(0);  
            end if;
        else --sorun olablir   
            if (bittimer = lim ) then
                b(6 downto 0)<= b(7 downto 1); --  shifted
                b(7) <= b(0);
                n <= n+ 1;
                bittimer <= 0;
                tx <= b(0);
                if (b(0) = '1') then
                    num_of_ones <= num_of_ones + 1;
                end if;
                    
            else
                bittimer <= bittimer + 1;
                   
            end if;    
        end if; 
    when parity_stat=>
    
        if (bittimer = lim ) then
            state<=stop_stat;
            bittimer <= 0;  
            tx <='1';
            num_of_ones<=0;

        else    
           bittimer<= bittimer + 1;--bittimer artarken sadece toplam 1 sayısı alıncak 
           if (num_of_ones mod 2 =0) then --even
                tx<='0';
            else
                tx<='1';
            end if; 
        end if;
                  
              
    when stop_stat=> 
        tx <='1';
         
        if (bittimer = stopbitlim ) then
            state<= idle_stat;
            tx_done_tick <='1';
            bittimer <= 0;
           
        else
            bittimer<= bittimer + 1; 
        end if;         
end case;
end if;
end process;
end Behavioral;
