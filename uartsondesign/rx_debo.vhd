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
constant stop_bit : integer :=1;
constant stopbitlim : integer:= lim * stop_bit;
type states is (idle_stat, start_stat, data_stat, parity_stat, stop_stat); --parity check???
signal state : states := idle_stat;
signal b : std_logic_vector(7 downto 0):=(others=>'0');--bits to be shifted --shift reg
signal n : integer range 0 to 7:=0;--number of data bits counter örneklenen bit say?s?
signal bittimer : integer range 0 to lim:=0; --number of s ticks --16 clk freq/ baudrate--t yi sayar
signal gelen_parity : std_logic:='0';--tx2ten gelen parity bit(rx_indeki parity biti)
signal control_parity : std_logic:='0';--gelen dataya bak?laeak rx uartta hesaplanan parity bit 
signal sample_timer : integer range 0 to (lim/7) :=0;
signal zero_num : integer range 0 to 7:=0;
signal one_num : integer range 0 to 7:=0;
signal rx_sampled: std_logic:='0';
signal rx_done_tmp: std_logic;
signal temp_rx: std_logic;
signal error : std_logic;
component ila_0 is
Port (
	clk : in std_logic;
	 probe0 : in states;
	 probe1 : in std_logic;
	 probe2 : in std_logic;
	 probe3 : in std_logic_vector(7 downto 0);
     probe4 : in integer;
     probe5: in std_logic ;
     probe6: in integer;
     probe7: in integer

);

end component;
begin
u7: ila_0 port map(clk=> clk,probe0=> state, probe1 =>rx_in,probe2=> rx_done_tmp, probe3 =>b,probe4=> n, probe5=>rx_sampled, probe6=> bittimer,probe7=> one_num ); --parity_error,state,n,rx_sampled,bittimer,b);
rx_done_tick<= rx_done_tmp;

process(clk)
begin

if (rising_edge(clk)) then
    case state is 
        when idle_stat=>
            rx_done_tmp<='0';
            bittimer<=0;
            parity_error<='0';
            if (rx_in= '0' ) then--1ken start olamamalý?
                state <= start_stat;
                bittimer<=0;--
            else
                state<=idle_stat;   
            end if;    
        when start_stat=>
            if (bittimer = (lim) ) then 
               bittimer<=0;
               n<=0;
               state<= data_stat;
               control_parity<=control_parity xor rx_in;
               sample_timer<=0;
               zero_num<=0;
               one_num<=0;
               b <= rx_sampled & (b(7 downto 1));
               if one_num>zero_num then
                     rx_sampled<='1';
               else
                     rx_sampled <='0';
               end if;
             else
                bittimer<=bittimer+1;
                if (sample_timer=(lim/7)-1) then
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
                            rx_sampled<='1';
                        else
                            rx_sampled <='0';
                        end if; 
             end if;     
             
        when data_stat =>
                if (n=7) then
                    if (bittimer=(lim)) then
                        state<= parity_stat;
                        n<=0;
                        sample_timer<=0;
                        zero_num<=0;
                        one_num<=0;
                        bittimer<= 0 ;
                        b <= rx_sampled & (b(7 downto 1));
                        if one_num>zero_num then
                            rx_sampled<='1';
                        else
                            rx_sampled <='0';
                        end if;
                     else
                    
                        bittimer<=bittimer+1;
                        if (sample_timer=(lim/7) -1) then
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
                            rx_sampled<='1';
                        else
                            rx_sampled <='0';
                        end if;
                     end if;      
                else
                    if (bittimer=(lim)) then
                        control_parity<=control_parity xor rx_in;--sadece data gelirken control parit deðiþir
                        b <= rx_sampled & (b(7 downto 1));
                        n<=n+1;
                        state<= data_stat;
                        bittimer<= 0 ;
                        zero_num<=0;
                        one_num<=0;
                        sample_timer<=0;               
                    else
                        bittimer<=bittimer+1;
                        sample_timer<= sample_timer+1;
                        if (sample_timer=(lim/7) -1) then
                            if rx_in = '1' then
                                one_num <= one_num +1;
                            else
                                zero_num<=zero_num+1;
                            end if;
                            sample_timer<=0;
--                        else
--                            sample_timer<= sample_timer+1;
                        end if;
                        if one_num>zero_num then
                            rx_sampled<='1';
                        else
                            rx_sampled <='0';
                        end if;                  
                end if;    
            end if;  
    when parity_stat=>
        if (bittimer = lim ) then --bittimer=15
            state<=stop_stat;
            bittimer <= 0;
            zero_num<=0;
            one_num<=0;
            sample_timer<=0;  
        else    
           bittimer<= bittimer + 1;
           gelen_parity<= rx_sampled;
           if (sample_timer=(lim/7) -1) then
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
               rx_sampled<='1';
            else
               rx_sampled <='0';
            end if;
        end if;
        when stop_stat=>
            if (bittimer=(stopbitlim)) then
                rx_done_tmp <='1';
                state<= idle_stat;
                control_parity<='0';
                bittimer<=0;
                rx_data_out<= b;
                zero_num<=0;
                one_num<=0;
                sample_timer<=0;  
                    
            else
                bittimer<= bittimer+1;
                if (sample_timer=(lim/7) -1) then
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
               rx_sampled<='1';
               
            else
               rx_sampled <='0';
               error<='1';
            end if;
                if (control_parity /=gelen_parity) then
                       parity_error<='1';
                else
                       parity_error <='0';       
                end if;
            end if;        
        when others=> 
            state<=idle_stat;
    end case;
end if;

end process;
  
end Behavioral;

