----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.08.2024 09:16:14
-- Design Name: 
-- Module Name: vga_controller_with_coordinates - Behavioral
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



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_controller_with_coordinates is
  Port (reset: in std_logic;
        h_sync: out std_logic;
        clk_in_100: in std_logic;
        v_sync: out std_logic;
--        x_coor: out std_logic_vector(11 downto 0);
--        y_coor : out std_logic_vector(10 downto 0);
--        active: out std_logic;
        red: out std_logic_vector(3 downto 0);
        green: out std_logic_vector(3 downto 0);
        blue: out std_logic_vector(3 downto 0));
     
end vga_controller_with_coordinates;


architecture Behavioral of vga_controller_with_coordinates is
constant h_front_porch: integer:=88;
constant h_back_porch: integer:=148;
constant hva: integer:=1920;
constant h_syncpulse: integer:=44;

constant v_front_porch: integer:=4;
constant v_back_porch: integer:=36;
constant v_syncpulse: integer:=5;
constant vva: integer:=1080;--??
constant horiz_line:integer:= hva+h_back_porch+h_front_porch+h_syncpulse;--800
constant ver_line: integer :=vva+v_back_porch+v_front_porch+ v_syncpulse;--
signal clk_o :std_logic:='0';

--component frequency_divider_100to25 is
--    Port ( clk_in : in STD_LOGIC;
--           divided_clk_out : out STD_LOGIC;
--           reset: in std_logic);
--end component;
component clk_wiz_0  is port(
    clk_out1 : out std_logic;
    reset : in std_logic;
    locked :out std_logic;
    clk_in1: in std_logic );
    end component;
signal h_sync_temp: std_logic:='0';
signal v_sync_temp : std_logic:='0';
signal locked : std_logic:='0';
signal h_count: integer range 0 to hva+h_back_porch+h_front_porch+h_syncpulse:=0;
signal v_count: integer range 0 to vva+v_back_porch+v_front_porch+ v_syncpulse:=0;


signal active_temp : std_logic;
begin
u3: clk_wiz_0  port map(clk_out1=>clk_o,reset=> reset,locked => locked, clk_in1=> clk_in_100);
--u1:frequency_divider_100to25 port map(clk_in=>clk_in_100,divided_clk_out=> clk_25, reset=> reset);
--u2: color_generator_8bitcounter port map(clk=> clk_in_100,rst=> reset,enable => clk_25,red_o => red,green_o => green, blue_o => blue );

process(clk_o,reset)

begin
if reset='1' then
    h_count<=0;
    v_count<=0;
elsif rising_edge(clk_o) then
     if (h_count < h_syncpulse )then --95  en son(rising edge yüzünden bir sonraki rising edgei beklediðinden 94te deðil de 95te else'e geçer)
        h_sync_temp<='0';
     elsif(h_count<=hva+ h_back_porch + h_front_porch-1) then
        h_sync_temp<='1';     
     end if;
     if (v_count < v_syncpulse  )then--0,1 sayýp deðiþmeli ?????? 
        v_sync_temp<='0';
     elsif(v_count<=vva+ v_back_porch + v_front_porch-1) then
        v_sync_temp<='1';
     end if;   
     if (h_count< horiz_line-1)then--vsync, hsync tamamen saydýðýnda (799) saymaya baþlar
        h_count<=h_count+1;
     else
        h_count<= 0;
        if (v_count< ver_line-1)then  --her bir h_countta v_count sayacak
            v_count<=v_count +1; 
        else
            v_count<=0;
        end if;
      end if;       
end if;                
end process;


process(h_count, v_count)
begin
if h_count>= (h_syncpulse +h_back_porch) and (h_count< h_syncpulse+ hva+ h_front_porch + h_back_porch) and (v_count>=(v_syncpulse+ v_back_porch))
                              and (v_count< v_syncpulse+ vva+ v_back_porch) then
   active_temp<='1';
else
    active_temp<='0';   
end if;
end process;



--x_coor<=std_logic_vector( to_unsigned(h_count, 12));
--y_coor<=std_logic_vector( to_unsigned(v_count, 11));


--active<=active_temp;
h_sync<= h_sync_temp;
v_sync<= v_sync_temp;



process(h_count,v_count,active_temp)
begin
if (active_temp='1') then
    if ((h_count))< ((hva/2)+ h_back_porch+ h_syncpulse) then
        red<="1100";
        green<="0000";
        blue<="0110";
    else
        red<="0000";
        green<="0000";
        blue<="1111";
    end if;
else
    red<="0000";
    green<="0000";
    blue<="0000";        
end if;        

end process;

end Behavioral;
