----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.07.2024 08:15:17
-- Design Name: 
-- Module Name: fifo - Behavioral
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

entity fifo is
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
end fifo;
    
architecture Behavioral of fifo is
    type fifo_array is array(0 to fifo_dpth - 1) of std_logic_vector(data_wdth-1 downto 0);
    signal wr_pointer : integer range 0 to fifo_dpth -1 :=0;
    signal rd_pointer : integer range 0 to fifo_dpth -1 :=0;
    signal fifo_count : integer range 0 to fifo_dpth  :=0;
    signal fifo_mem : fifo_array := (others =>(others=>'0'));
begin
    process(clk,rst)
    begin
    if (rst = '1') then 
        wr_pointer<=0;
        rd_pointer <= 0;
        fifo_count <=0;
        data_o <= (others=>'0');
    elsif (rising_edge(clk)) then  --data yazma
        if (wr_en = '1' and fifo_count < fifo_dpth) then
            fifo_mem(wr_pointer) <= data_i; --data yazma
            wr_pointer <= (wr_pointer+1) mod fifo_dpth; 
            fifo_count <= fifo_count + 1;
        end if;
        if (rd_en = '1' and fifo_count > 0) then
            data_o <= fifo_mem(rd_pointer); --data okuma
            rd_pointer <=(rd_pointer+1) mod fifo_dpth;
            fifo_count <= fifo_count + 1;
        end if;    
                  
    end if;
    end process;
    full <='1' when fifo_count = fifo_dpth else '0';
    empty <='1' when fifo_count = 0 else '0';
    end Behavioral;
