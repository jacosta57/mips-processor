-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- WB_Reg.vhd
-------------------------------------------------------------------------
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity WB_Reg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_RegWr          : in std_logic;     -- Data value input
       i_MemtoReg          : in std_logic;
      i_Halt          :in std_logic;
      i_Ovfl          :in std_logic;
      i_JAL : in std_logic;
      o_JAL :out std_logic;
      o_Ovfl          :out std_logic;
      o_Halt          :out std_logic;
       o_RegWr          : out std_logic;   -- Data value output
       o_MemtoReg          : out std_logic);

end WB_Reg;
architecture structural of WB_Reg is

  component  dffg is
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  end component;  

  signal s_we : std_logic;

begin
 
  s_we <= '1';

  reg_RegWR:dffg 
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => s_we,
      i_D => i_RegWr,
      o_Q => o_RegWr
  );

  reg_MemtoReg: dffg
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => s_we,
      i_D => i_MemtoReg,
      o_Q => o_MemtoReg
  );

  reg_halt: dffg
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => s_we,
      i_D => i_Halt,
      o_Q => o_Halt
  );

  reg_Ovfl: dffg
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => s_we,
      i_D => i_Ovfl,
      o_Q => o_Ovfl
  );
  reg_JAL: dffg
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_WE => s_we,
      i_D => i_JAL,
      o_Q => o_JAL
  );
end structural;
