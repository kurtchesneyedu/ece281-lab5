----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/19/2024 11:43:04 AM
-- Design Name: 
-- Module Name: sevenSegDecoder - Behavioral
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

entity sevenSegDecoder is
    Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
           o_S : out STD_LOGIC_VECTOR (6 downto 0));
end sevenSegDecoder;

architecture Behavioral of sevenSegDecoder is

begin      
    o_s <= "0111111" when i_D = "1111" else -- negative sign
           
           -- "gfedcba"
           "1000000" when i_D = "0000" else
           "1111001" when i_D = "0001" else
           "0100100" when i_D = "0010" else
           "0110000" when i_D = "0011" else
           "0011001" when i_D = "0100" else
           "0010010" when i_D = "0101" else
           "0000010" when i_D = "0110" else
           "1111000" when i_D = "0111" else
           "0000000" when i_D = "1000" else
           "0011000" when i_D = "1001" else
           "1111111";
    
end Behavioral;
