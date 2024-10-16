library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_decoder_32 is

end tb_decoder_32;

architecture mixed of tb_decoder_32 is

component decoder_32 is
	port(i_S		: in std_logic_vector(4 downto 0);
	     o_Q		: out std_logic_vector(31 downto 0));
end component decoder_32;

signal s_i_S: std_logic_vector(4 downto 0);
signal s_o_Q: std_logic_vector(31 downto 0);

begin

   DUT0: decoder_32
  port map(
            i_S     => s_i_S,
            o_Q     => s_o_Q);
 
  P_TEST_CASES: process
  begin
    s_i_S <= "00000";
	wait for 50 ns;

 s_i_S <= "00001";
	wait for 50 ns;

 s_i_S <= "00010";
	wait for 50 ns;

 s_i_S <= "00100";
	wait for 50 ns;

 s_i_S <= "01000";
	wait for 50 ns;

 s_i_S <= "11111";
	wait for 50 ns;

  end process;

end mixed;

