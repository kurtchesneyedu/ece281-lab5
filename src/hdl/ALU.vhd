--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
--|
--| ALU OPCODES:
--|
--|     ADD      1000
--|     SUBTRACT 1001
--|     AND      0100
--|     OR       0101
--|     SHIFT L  0010
--|     SHIFT R  0011
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
    Port ( i_op : in STD_LOGIC_VECTOR (3 downto 0);
           i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_sign : out STD_LOGIC;
           o_cout : out STD_LOGIC;
           o_zero : out STD_LOGIC);
end ALU;

architecture behavioral of ALU is 

	signal w_arithout : STD_LOGIC_VECTOR (7 downto 0);
	signal w_logicout : STD_LOGIC_VECTOR (7 downto 0);
	signal w_shiftout : STD_LOGIC_VECTOR (7 downto 0);
	signal w_result : STD_LOGIC_VECTOR (7 downto 0);
	signal w_b_in : STD_LOGIC_VECTOR (7 downto 0);
  
begin
	-- PORT MAPS, CONCURRENT STATEMENTS ----------------------------------------
    w_result <= w_arithout when i_op (3 downto 1) = "100" else
                w_logicout when i_op (3 downto 1) = "010" else
                w_shiftout;
    o_result <= w_result;
    
    o_sign <= w_result(7);
    o_cout <= '1' when (i_op(3) = '1' and i_A(7) = i_B(7) and i_A(7) /= w_result(7)) else '0';                        
    o_zero <= '1' when w_result = "00000000" else '0';
    
    w_b_in <= i_B when i_op(0) = '0' else
              std_logic_vector(0 - signed(i_B));
    w_arithout <= std_logic_vector(signed(i_A) + signed(w_b_in));
    
    w_logicout <= (i_A and i_B) when i_op(0) = '0' else (i_A or i_B);
    
    w_shiftout <= std_logic_vector(shift_left(unsigned(i_A), to_integer(unsigned(i_B(2 downto 0))))) when i_op(0) = '0' else
                  std_logic_vector(shift_right(unsigned(i_A), to_integer(unsigned(i_B(2 downto 0)))));
	
end behavioral;
