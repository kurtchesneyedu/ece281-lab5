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
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture Behavioral of controller_fsm is
    
    signal f_Q : std_logic_vector (3 downto 0) := "0001";
    signal f_Q_next : std_logic_vector (3 downto 0);
    
begin

    f_Q_next <= "0010" when f_Q = "0001" else
                "0100" when f_Q = "0010" else
                "1000" when f_Q = "0100" else
                "0001" when f_Q = "1000" else
                "0001";
                
    o_cycle <= "0010" when f_Q = "0010" else
               "0100" when f_Q = "0100" else
               "1000" when f_Q = "1000" else
               "0001" when f_Q = "0001" else
               "0001";
    
    register_proc : process (i_adv)
    begin
        
       if (i_reset = '1') then
            f_Q <= "0001";
       elsif rising_edge(i_adv) then
            f_Q <= f_Q_next;
       else
            f_Q <= f_Q;    -- next state becomes current state
       end if;         -- floor stays the same

    
    end process register_proc;
                    
end Behavioral;
