----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.07.2024 14:36:36
-- Design Name: 
-- Module Name: sequence_det - Behavioral
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

entity sequence_det is
    Port ( parallel_in : in std_logic_vector(19 downto 0);--parallel in
           clk : in STD_LOGIC;
           detection_out : out STD_LOGIC;
           enable : in std_logic;
           reset : in STD_LOGIC);
end sequence_det;

architecture Behavioral of sequence_det is
signal shift_reg: std_logic_vector(19 downto 0);
begin
process(clk,reset)
begin
    if reset ='1' then
        shift_reg <=(others=>'0');
        detection_out <= '0';
    
    elsif rising_edge(clk) then
        if enable ='1' then
            shift_reg<=parallel_in;
        else
            shift_reg <=  shift_reg(18 downto 0)&'0'  ; --serial out    
        end if;    
        if shift_reg(19 downto 17) <="010" then
            detection_out<= '1'  ;
        else
            detection_out<='0';
        end if;   
     
    end if;         
    
end process;
--detection_out <='1' when shift_reg = "010";    


end Behavioral;
