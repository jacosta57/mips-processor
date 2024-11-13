-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- MEM_Reg.vhd
-------------------------------------------------------------------------
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MEM_Reg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_BranchEn          : in std_logic;     -- Data value input
      i_MemWr          : in std_logic;
      i_we          : in std_logic;
       o_BranchEn          : out std_logic;
       o_MemWr          : out std_logic);

end MEM_Reg;
architecture structural of MEM_Reg is

  component  dffg is
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  end component;  


begin

  reg_Branch: dffg
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => i_we,
      i_D => i_BranchEn,
      o_Q => o_BranchEn
  );

  reg_MemWr: dffg
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => i_we,
      i_D => i_MemWr,
      o_Q => o_MemWr
  );

end structural;
