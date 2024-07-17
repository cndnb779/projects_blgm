----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.07.2024 15:30:59
-- Design Name: 
-- Module Name: rx_debo - Behavioral
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
-- Create Date: 10.07.2024 13:45:11
-- Design Name: 
-- Module Name: uart_rx - Behavioral
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

entity uart_rx_debo is
    generic(
    clk_freq : integer :=100_000_000;--1000000/115200=8.68 
    
    baudrate : integer := 115200
    );
    Port ( rx_in : in STD_LOGIC;
           clk : in STD_LOGIC;
           rx_data_out : out  std_logic_vector(7 downto 0);
           rx_done_tick : out STD_LOGIC;
           parity_error: out std_logic);
end uart_rx_debo;

architecture Behavioral of uart_rx_debo is
constant lim: integer:= clk_freq/baudrate; --bittimer limit

type states is (idle_stat, start_stat, data_stat, parity_stat, stop_stat); --parity check???
signal state : states := idle_stat;
signal b : std_logic_vector(7 downto 0):=(others=>'0');--bits to be shifted --shift reg
signal n : integer range 0 to 7:=0;--number of data bits counter örneklenen bit say?s?
signal bittimer : integer range 0 to lim:=0; --number of s ticks --16 clk freq/ baudrate--t yi sayar
signal gelen_parity : std_logic:='0';--tx2ten gelen parity bit(rx_indeki parity biti)
signal control_parity : std_logic:='0';--gelen dataya bak?laeak rx uartta hesaplanan parity bit 
signal sample_timer : integer range 0 to (lim)/7:=0;
signal zero_num : integer range 0 to 6:=0;
signal one_num : integer range 0 to 6:=0;
signal rx_debounced: std_logic:='0';
begin
process(clk)
begin
if (rising_edge(clk)) then
    case state is 
        when idle_stat=>
            rx_done_tick<='0';
            bittimer<=0;
            parity_error<='0';
            if (rx_in= '0' ) then
                state <= start_stat;
                bittimer<=0;
               
            end if;    
        when start_stat=>
            if (bittimer = (lim) - 1) then --s=?7 --yarim byt suruyor
               bittimer<=0;
               n<=0;
               state<= data_stat;
               control_parity<=control_parity xor rx_in;
--               b <= rx_in & (b(7 downto 1));
             else
                bittimer<=bittimer+1; 
--                state<= start_stat;
             end if;     
             
        when data_stat =>--sor -- sadece data stateinde gelen datadaki 1ler say?lmal? ondan num 1 burda
            
            
                if (n=7) then
                    if (bittimer=(lim-1)) then
                        state<= parity_stat;
--                        gelen_parity<= rx_in;
                        n<=0;
                        sample_timer<=0;
                        zero_num<=0;
                        one_num<=0;
                        bittimer<= 0 ;
                        b <= rx_debounced & (b(7 downto 1));
--                        control_parity<=control_parity xor rx_in;
                        if one_num>zero_num then
                            rx_debounced<='1';
                        else
                            rx_debounced <='0';
                        end if;
                     else
                    
                        bittimer<=bittimer+1;
                         if (sample_timer=lim/7) then
                            if rx_in = '1' then
                                one_num <= one_num +1;
                            else
                                zero_num<=zero_num+1;
                            end if;
                            sample_timer<=0;
                        else
                            sample_timer<= sample_timer+1;
                        end if;
                        if one_num>zero_num then
                            rx_debounced<='1';
                        else
                            rx_debounced <='0';
                        end if;
                     end if;      
                else
                    if (bittimer=(lim-1)) then
                        control_parity<=control_parity xor rx_in;
                        b <= rx_debounced & (b(7 downto 1));
                        n<=n+1;
                        state<= data_stat;
                        bittimer<= 0 ;
                        zero_num<=0;
                        one_num<=0;
                        sample_timer<=0;
--                        if (sample_timer=lim/7) then
--                            if rx_in = '1' then
--                                one_num <= one_num +1;
--                            else
--                                zero_num<=zero_num+1;
--                            end if;
--                            sample_timer<=0;
--                        else
--                            sample_timer<= sample_timer+1;
--                        end if;                
                    else
                        bittimer<=bittimer+1;
                        if (sample_timer=lim/7) then
                            if rx_in = '1' then
                                one_num <= one_num +1;
                            else
                                zero_num<=zero_num+1;
                            end if;
                            sample_timer<=0;
                        else
                            sample_timer<= sample_timer+1;
                        end if;
                        if one_num>zero_num then
                            rx_debounced<='1';
                        else
                            rx_debounced <='0';
                        end if;                  
                end if;    
           
            
            end if;  
    when parity_stat=>
--        gelen_parity<= rx_in;
        if (bittimer = lim - 1) then --bittimer=15
            state<=stop_stat;
            bittimer <= 0;
            rx_data_out<= b;  
        else    
           bittimer<= bittimer + 1;
           gelen_parity<= rx_in;
        end if;
                      
                      
        when stop_stat=>
            if (bittimer=(lim*2)-1) then
                state<= idle_stat;
                control_parity<='0';
                bittimer<=0;
                rx_done_tick <='1'; --t kadr bekleyip 1
--                if (rx_in ='1') then --stop state ?????
--                    if (control_parity /=gelen_parity) then
--                       parity_error<='1';
--                    else
--                       parity_error <='0';       
--                    end if;     
                
--                    rx_data_out<= b;
--                 end if;
--                 state<= idle_stat;
--                 bittimer<=0;
                    
            else
                bittimer<= bittimer+1;
                if (control_parity /=gelen_parity) then
                       parity_error<='1';
                else
                       parity_error <='0';       
                end if;
                 
            end if;        
        
    end case;
end if;

end process;
--rx_data_out<= b;  --
end Behavioral;

