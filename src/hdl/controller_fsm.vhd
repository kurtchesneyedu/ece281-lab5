----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2024 08:33:08 PM
-- Design Name: 
-- Module Name: controller_fsm - Behavioral
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

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           i_clk : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture Behavioral of controller_fsm is
    
    signal f_Q : std_logic_vector (2 downto 0) := "000";
    signal f_Q_next : std_logic_vector (2 downto 0);
    
begin

    f_Q_next <= "001" when f_Q = "000" and i_adv = '1' else
                "010" when f_Q = "001" and i_adv = '0' else
                "011" when f_Q = "010" and i_adv = '1' else
                "100" when f_Q = "011" and i_adv = '0' else
                "101" when f_Q = "100" and i_adv = '1' else
                "110" when f_Q = "101" and i_adv = '0' else
                "111" when f_Q = "110" and i_adv = '1' else
                "000" when f_Q = "111" and i_adv = '0' else
                f_Q;
                
    o_cycle <= "0001" when f_Q = "000" else
               "0010" when f_Q = "010" else
               "0100" when f_Q = "100" else
               "1000" when f_Q = "110" else
               "0001";
    
    register_proc : process (i_clk)
    begin
        
       if (i_reset = '1') then
            f_Q <= "000";
       elsif rising_edge(i_clk) then
            f_Q <= f_Q_next;
       else
            f_Q <= f_Q;    -- next state becomes current state
       end if;         -- floor stays the same

    
    end process register_proc;
                    
end Behavioral;
