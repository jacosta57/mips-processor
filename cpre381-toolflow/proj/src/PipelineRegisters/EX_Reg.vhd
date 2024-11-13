-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- EX_Reg.vhd
-------------------------------------------------------------------------
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity EX_Reg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_ALUSrc          : in std_logic;     -- Data value input
       i_ALUOp          : in std_logic_vector(1 downto 0);
       i_RegDst          : in std_logic;
       i_InstOp          : in std_logic_vector(5 downto 0);
       o_ALUSrc          : out std_logic;     -- Data value input
       o_ALUOp          : out std_logic_vector(1 downto 0);
       o_RegDst          : out std_logic;
       o_InstOp          : out std_logic_vector(5 downto 0));

end EX_Reg;
architecture structural of EX_Reg is

  component  n_reg is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
         o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;  

  component dffg is

  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output
  end component;
  signal s_we : std_logic;

begin
 
  s_we <= '1';

  reg_ALUSrc: dffg
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => s_we,
      i_D => i_ALUSrc,
      o_Q => o_ALUSrc
  );

  reg_ALUOp: n_reg
  generic map(
    N => 4
)
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => s_we,
      i_D => i_ALUOp,
      o_Q => o_ALUOp
  );

  reg_RegDst: dffg 
  port map(
     i_CLK => i_CLK,
     i_RST => i_RST,
     i_WE => s_we,
     i_D => i_RegDst,
     o_Q => o_RegDst
 );

 reg_InstOp: n_reg  
 generic map(
    N => 6
)
 port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => s_we,
    i_D => i_InstOp,
    o_Q => o_InstOp
);

end structural;
