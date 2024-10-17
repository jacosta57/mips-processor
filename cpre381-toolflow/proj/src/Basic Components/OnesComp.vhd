-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- onescomp.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onescomp is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A         : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));

end onescomp;

architecture structural of onescomp is

  component invg is
	port(i_A          : in std_logic;
             o_F          : out std_logic);
end component;

begin


  G_onesComp: for i in 0 to N-1 generate
    ONESCOMPI: invg port map(
              i_A     => i_A(i),  
              o_F      => o_F(i));  
  end generate G_onesComp;
  
end structural;
