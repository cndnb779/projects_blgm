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

entity top_module is--vga controller pixel converter kullan
  Port (reset: in std_logic;
        clk_in_100: in std_logic;
        h_sync: out std_logic;
        v_sync: out std_logic; --doðrudan vga display kodundan gelene eþit olucak
        x_coor: in std_logic_vector(11 downto 0);
        y_coor : in std_logic_vector(10 downto 0);
        active: in std_logic;
        red: out std_logic_vector(3 downto 0);
        green: out std_logic_vector(3 downto 0);
        blue: out std_logic_vector(3 downto 0));
     
end top_module;