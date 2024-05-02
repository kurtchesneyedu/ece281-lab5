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
    
    signal f_Q, f_Q_next : std_logic_vector (3 downto 0);
    
begin

    f_Q_next <= "0010" when f_Q = "0001" else
                "0100" when f_Q = "0010" else
                "1000" when f_Q = "0100" else
                "0001" when f_Q = "1000" else
                f_Q;
                
    o_cycle <= f_Q;
    
    register_proc : process (i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_reset = '1') then
                f_Q <= "0001";    -- reset on rising edge
            elsif (i_adv = '1') then
                f_Q <= f_Q_next;    -- next state becomes current state
            end if;         -- floor stays the same
        end if;
        
        -- if elevator is enabled, advance floors
        -- if not enabled, stay at current floor
    
    end process register_proc;
                    
end Behavioral;
