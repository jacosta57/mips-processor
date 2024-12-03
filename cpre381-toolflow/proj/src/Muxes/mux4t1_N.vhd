

-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- mux4t1_N.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux4t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic_vector(1 downto 0);
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       i_D2         : in std_logic_vector(N-1 downto 0);
       i_D3         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end mux4t1_N;


architecture Behavioral of mux4t1_N is
	begin
	process(i_S, i_D0, i_D1, i_D2, i_D3)
	begin
        	case to_integer(unsigned(i_S)) is
            	when 0 => 
               	 	o_O <= i_D0;
            	when 1 =>
               	 	o_O <= i_D1;
           	 when 2 =>
                	o_O <= i_D2;
           	 when 3 =>
                	o_O <= i_D3;
            	when others =>
                	null;
		end case;
	end process;	
end Behavioral;
