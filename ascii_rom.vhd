----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.08.2024 08:35:01
-- Design Name: 
-- Module Name: ascii_rom - Behavioral
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
--use ieee.std_logic_arith.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ascii_rom is--rom
  Port (clk_in: in std_logic;
        data_out: out std_logic_vector(7 downto 0);
        rom_address: in std_logic_vector(10 downto 0)--8*8 pixel(64 pixels)
        );
end ascii_rom;

architecture Behavioral of ascii_rom is--uses rom or look up table lut, here it uses rom called datas_array

signal reg: std_logic_vector(10 downto 0);
type datas_array is array( 0 to 431) of std_logic_vector(7 downto 0);--26 elemanl� her bir eleman 8 bitlik- her bir row
constant char_datas: datas_array:=(
    --0
   "00000000",--A yaz�nca B, B yaz�nca C g�r�nd��� i�in eklendi
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   "00000000",
   -- code x41
   "00000000", -- 0
   "00000000", -- 1
   "00010000", -- 2    *
   "00111000", -- 3   ***
   "01101100", -- 4  ** **
   "11000110", -- 5 **   **
   "11000110", -- 6 **   **
   "11111110", -- 7 *******
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "11000110", -- b **   **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x42
   "00000000", -- 0
   "00000000", -- 1
   "11111100", -- 2 ******
   "01100110", -- 3  **  **
   "01100110", -- 4  **  **
   "01100110", -- 5  **  **
   "01111100", -- 6  *****
   "01100110", -- 7  **  **
   "01100110", -- 8  **  **
   "01100110", -- 9  **  **
   "01100110", -- a  **  **
   "11111100", -- b ******
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x43
   "00000000", -- 0
   "00000000", -- 1
   "00111100", -- 2   ****
   "01100110", -- 3  **  **
   "11000010", -- 4 **    *
   "11000000", -- 5 **
   "11000000", -- 6 **
   "11000000", -- 7 **
   "11000000", -- 8 **
   "11000010", -- 9 **    *
   "01100110", -- a  **  **
   "00111100", -- b   ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x44
   "00000000", -- 0
   "00000000", -- 1
   "11111000", -- 2 *****
   "01101100", -- 3  ** **
   "01100110", -- 4  **  **
   "01100110", -- 5  **  **
   "01100110", -- 6  **  **
   "01100110", -- 7  **  **
   "01100110", -- 8  **  **
   "01100110", -- 9  **  **
   "01101100", -- a  ** **
   "11111000", -- b *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x45
   "00000000", -- 0
   "00000000", -- 1
   "11111110", -- 2 *******
   "01100110", -- 3  **  **
   "01100010", -- 4  **   *
   "01101000", -- 5  ** *
   "01111000", -- 6  ****
   "01101000", -- 7  ** *
   "01100000", -- 8  **
   "01100010", -- 9  **   *
   "01100110", -- a  **  **
   "11111110", -- b *******
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x46
   "00000000", -- 0
   "00000000", -- 1
   "11111110", -- 2 *******
   "01100110", -- 3  **  **
   "01100010", -- 4  **   *
   "01101000", -- 5  ** *
   "01111000", -- 6  ****
   "01101000", -- 7  ** *
   "01100000", -- 8  **
   "01100000", -- 9  **
   "01100000", -- a  **
   "11110000", -- b ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x47
   "00000000", -- 0
   "00000000", -- 1
   "00111100", -- 2   ****
   "01100110", -- 3  **  **
   "11000010", -- 4 **    *
   "11000000", -- 5 **
   "11000000", -- 6 **
   "11011110", -- 7 ** ****
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "01100110", -- a  **  **
   "00111010", -- b   *** *
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x48
   "00000000", -- 0
   "00000000", -- 1
   "11000110", -- 2 **   **
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11000110", -- 5 **   **
   "11111110", -- 6 *******
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "11000110", -- b **   **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x49
   "00000000", -- 0
   "00000000", -- 1
   "00111100", -- 2   ****
   "00011000", -- 3    **
   "00011000", -- 4    **
   "00011000", -- 5    **
   "00011000", -- 6    **
   "00011000", -- 7    **
   "00011000", -- 8    **
   "00011000", -- 9    **
   "00011000", -- a    **
   "00111100", -- b   ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x4a
   "00000000", -- 0
   "00000000", -- 1
   "00011110", -- 2    ****
   "00001100", -- 3     **
   "00001100", -- 4     **
   "00001100", -- 5     **
   "00001100", -- 6     **
   "00001100", -- 7     **
   "11001100", -- 8 **  **
   "11001100", -- 9 **  **
   "11001100", -- a **  **
   "01111000", -- b  ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x4b
   "00000000", -- 0
   "00000000", -- 1
   "11100110", -- 2 ***  **
   "01100110", -- 3  **  **
   "01100110", -- 4  **  **
   "01101100", -- 5  ** **
   "01111000", -- 6  ****
   "01111000", -- 7  ****
   "01101100", -- 8  ** **
   "01100110", -- 9  **  **
   "01100110", -- a  **  **
   "11100110", -- b ***  **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x4c
   "00000000", -- 0
   "00000000", -- 1
   "11110000", -- 2 ****
   "01100000", -- 3  **
   "01100000", -- 4  **
   "01100000", -- 5  **
   "01100000", -- 6  **
   "01100000", -- 7  **
   "01100000", -- 8  **
   "01100010", -- 9  **   *
   "01100110", -- a  **  **
   "11111110", -- b *******
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x4d
   "00000000", -- 0
   "00000000", -- 1
   "11000011", -- 2 **    **
   "11100111", -- 3 ***  ***
   "11111111", -- 4 ********
   "11111111", -- 5 ********
   "11011011", -- 6 ** ** **
   "11000011", -- 7 **    **
   "11000011", -- 8 **    **
   "11000011", -- 9 **    **
   "11000011", -- a **    **
   "11000011", -- b **    **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x4e
   "00000000", -- 0
   "00000000", -- 1
   "11000110", -- 2 **   **
   "11100110", -- 3 ***  **
   "11110110", -- 4 **** **
   "11111110", -- 5 *******
   "11011110", -- 6 ** ****
   "11001110", -- 7 **  ***
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "11000110", -- b **   **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x4f
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11000110", -- 5 **   **
   "11000110", -- 6 **   **
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x50
   "00000000", -- 0
   "00000000", -- 1
   "11111100", -- 2 ******
   "01100110", -- 3  **  **
   "01100110", -- 4  **  **
   "01100110", -- 5  **  **
   "01111100", -- 6  *****
   "01100000", -- 7  **
   "01100000", -- 8  **
   "01100000", -- 9  **
   "01100000", -- a  **
   "11110000", -- b ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x510
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11000110", -- 5 **   **
   "11000110", -- 6 **   **
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11010110", -- 9 ** * **
   "11011110", -- a ** ****
   "01111100", -- b  *****
   "00001100", -- c     **
   "00001110", -- d     ***
   "00000000", -- e
   "00000000", -- f
   -- code x52
   "00000000", -- 0
   "00000000", -- 1
   "11111100", -- 2 ******
   "01100110", -- 3  **  **
   "01100110", -- 4  **  **
   "01100110", -- 5  **  **
   "01111100", -- 6  *****
   "01101100", -- 7  ** **
   "01100110", -- 8  **  **
   "01100110", -- 9  **  **
   "01100110", -- a  **  **
   "11100110", -- b ***  **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x53
   "00000000", -- 0
   "00000000", -- 1
   "01111100", -- 2  *****
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "01100000", -- 5  **
   "00111000", -- 6   ***
   "00001100", -- 7     **
   "00000110", -- 8      **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x54
   "00000000", -- 0
   "00000000", -- 1
   "11111111", -- 2 ********
   "11011011", -- 3 ** ** **
   "10011001", -- 4 *  **  *
   "00011000", -- 5    **
   "00011000", -- 6    **
   "00011000", -- 7    **
   "00011000", -- 8    **
   "00011000", -- 9    **
   "00011000", -- a    **
   "00111100", -- b   ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x55
   "00000000", -- 0
   "00000000", -- 1
   "11000110", -- 2 **   **
   "11000110", -- 3 **   **
   "11000110", -- 4 **   **
   "11000110", -- 5 **   **
   "11000110", -- 6 **   **
   "11000110", -- 7 **   **
   "11000110", -- 8 **   **
   "11000110", -- 9 **   **
   "11000110", -- a **   **
   "01111100", -- b  *****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x56
   "00000000", -- 0
   "00000000", -- 1
   "11000011", -- 2 **    **
   "11000011", -- 3 **    **
   "11000011", -- 4 **    **
   "11000011", -- 5 **    **
   "11000011", -- 6 **    **
   "11000011", -- 7 **    **
   "11000011", -- 8 **    **
   "01100110", -- 9  **  **
   "00111100", -- a   ****
   "00011000", -- b    **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x57
   "00000000", -- 0
   "00000000", -- 1
   "11000011", -- 2 **    **
   "11000011", -- 3 **    **
   "11000011", -- 4 **    **
   "11000011", -- 5 **    **
   "11000011", -- 6 **    **
   "11011011", -- 7 ** ** **
   "11011011", -- 8 ** ** **
   "11111111", -- 9 ********
   "01100110", -- a  **  **
   "01100110", -- b  **  **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f

   -- code x58
   "00000000", -- 0
   "00000000", -- 1
   "11000011", -- 2 **    **
   "11000011", -- 3 **    **
   "01100110", -- 4  **  **
   "00111100", -- 5   ****
   "00011000", -- 6    **
   "00011000", -- 7    **
   "00111100", -- 8   ****
   "01100110", -- 9  **  **
   "11000011", -- a **    **
   "11000011", -- b **    **
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x59
   "00000000", -- 0
   "00000000", -- 1
   "11000011", -- 2 **    **
   "11000011", -- 3 **    **
   "11000011", -- 4 **    **
   "01100110", -- 5  **  **
   "00111100", -- 6   ****
   "00011000", -- 7    **
   "00011000", -- 8    **
   "00011000", -- 9    **
   "00011000", -- a    **
   "00111100", -- b   ****
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000", -- f
   -- code x5a
   "00000000", -- 0
   "00000000", -- 1
   "11111111", -- 2 ********
   "11000011", -- 3 **    **
   "10000110", -- 4 *    **
   "00001100", -- 5     **
   "00011000", -- 6    **
   "00110000", -- 7   **
   "01100000", -- 8  **
   "11000001", -- 9 **     *
   "11000011", -- a **    **
   "11111111", -- b ********
   "00000000", -- c
   "00000000", -- d
   "00000000", -- e
   "00000000"); -- f

begin
process(clk_in)
begin
if (rising_edge(clk_in)) then
    reg<= rom_address;--meaning:select the std logic vector of the bitmap                                                                   --row column... 2 boyutlu row ve columnlar� 64 bitlik datan�n  tek bitine d�n��t�r�r
end if;
end process;
data_out<= char_datas(to_integer(unsigned(reg))); --A ascii =65 ancak byrda char_datas(0)a denk gelio(to integer decimale �evirir)
end Behavioral;

