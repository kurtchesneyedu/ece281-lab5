--+----------------------------------------------------------------------------
--| edit for github
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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
    port(
        clk : in std_logic;
        btnU : in std_logic;
        btnC : in std_logic;
        btnR : in std_logic;
        sw : in std_logic_vector (15 downto 0);
        
        led : out std_logic_vector(15 downto 0);
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0)
        );
        
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	component ALU is
        Port ( i_op : in STD_LOGIC_VECTOR (3 downto 0);
               i_A : in STD_LOGIC_VECTOR (7 downto 0);
               i_B : in STD_LOGIC_VECTOR (7 downto 0);
               
               o_result : out STD_LOGIC_VECTOR (7 downto 0);
               o_sign : out STD_LOGIC;
               o_cout : out STD_LOGIC;
               o_zero : out STD_LOGIC);
    end component ALU;
    
    component TDM4 is
        generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
        Port ( i_clk        : in  STD_LOGIC;
               i_reset        : in  STD_LOGIC; -- asynchronous
               i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
               o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
        );
    end component TDM4;
    
    component clock_divider is
        generic ( constant k_DIV : natural := 2    ); -- How many clk cycles until slow clock toggles
                                                   -- Effectively, you divide the clk double this 
                                                   -- number (e.g., k_DIV := 2 --> clock divider of 4)
        port (  i_clk    : in std_logic;
                i_reset  : in std_logic;           -- asynchronous
                o_clk    : out std_logic           -- divided (slow) clock
        );
    end component clock_divider;
    
    component controller_fsm is
        Port ( i_reset : in STD_LOGIC;
               i_adv : in STD_LOGIC;
               o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
    end component controller_fsm;
    
    component sevenSegDecoder is
        Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
               o_S : out STD_LOGIC_VECTOR (6 downto 0));
    end component sevenSegDecoder;
    
    component twoscomp_decimal is
        port (
            i_binary: in std_logic_vector(7 downto 0);
            o_negative: out std_logic;
            o_hundreds: out std_logic_vector(3 downto 0);
            o_tens: out std_logic_vector(3 downto 0);
            o_ones: out std_logic_vector(3 downto 0)
        );
    end component twoscomp_decimal;

    signal w_regA, w_regB, w_ALU, w_MUX, w_regANext, w_regBNext: std_logic_vector (7 downto 0);
    signal w_cycle, w_sign, w_hund, w_tens, w_ones, w_data : std_logic_vector (3 downto 0);
    signal w_clk_tdm, w_neg : std_logic;
    
begin
	-- PORT MAPS ----------------------------------------
    ALU_inst : ALU
        Port map(
               i_op => sw(3 downto 0),
               i_A => w_regA,
               i_B => w_regB,
               
               o_result => w_ALU,
               o_sign => led(15),
               o_cout => led(13),
               o_zero => led(14)
               );
    
    TDM4_inst : TDM4
        generic map ( k_WIDTH => 4)
        Port map ( 
               i_clk => w_clk_tdm,
               i_reset => btnR,
               i_D3 => w_sign,
               i_D2 => w_hund,
               i_D1 => w_tens,
               i_D0 => w_ones,
               o_data => w_data,
               o_sel => an
               );
    
    clock_divider_inst : clock_divider
        generic map ( k_DIV => 500000) -- 100 Hz clock
        port map (  
                i_clk => clk,
                i_reset => btnR,           -- asynchronous
                o_clk => w_clk_tdm         -- divided (slow) clock
        );
    
    controller_fsm_inst : controller_fsm
        port map ( 
               i_reset => btnU,
               i_adv => btnC,
               o_cycle => w_cycle
               );
    
    sevenSegDecoder_inst : sevenSegDecoder
        port map ( 
               i_D => w_data,
               o_S => seg
               );
    
    twoscomp_decimal_inst : twoscomp_decimal
        port map (
            i_binary => w_mux,
            o_negative => w_neg,
            o_hundreds => w_hund,
            o_tens => w_tens,
            o_ones=> w_ones
        );
	
	
	-- CONCURRENT STATEMENTS ----------------------------
	w_sign <= "1111" when w_neg = '1' else "1110";
	
	-- output mux implementation
	w_MUX <= w_ALU when w_cycle = "1000" else
	         w_regA when w_cycle = "0010" else
	         w_regB when w_cycle = "0100" else "00000000";
	         
    -- register implementation
    w_regANext <= "00000000" when btnR = '1' else sw(7 downto 0);
    w_regBNext <= "00000000" when btnR = '1' else sw(7 downto 0);
    
    w_regA <= "00000000" when btnR = '1' else w_regANext;
    w_regB <= "00000000" when btnR = '1' else w_regBNext;
	
end top_basys3_arch;
