-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- IF_ID_Reg.vhd
-------------------------------------------------------------------------
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity IF_ID_Reg is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_PC          : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_Inst          : in std_logic_vector(N-1 downto 0);
       o_PC          : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_Inst          : out std_logic_vector(N-1 downto 0));

end IF_ID_Reg;
architecture structural of IF_ID_Reg is

  component  n_reg is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
         o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;  

  signal s_we : std_logic;

begin
 
  s_we <= '1';
  reg_PC: n_reg  
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => s_we,
      i_D => i_PC,
      o_Q => o_PC
  );

  reg_Inst: n_reg

   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => s_we,
      i_D => i_Inst,
      o_Q => o_Inst
  );
end structural;