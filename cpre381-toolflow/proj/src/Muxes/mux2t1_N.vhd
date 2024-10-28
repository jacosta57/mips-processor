-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- mux2t1_N.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end mux2t1_N;


architecture Behavioral of mux2t1_N is
	begin
	o_O <= i_D0 when (i_S = '0') else
		i_D1 when (i_S = '1') else
		x"00000000";

  
	end Behavioral;
