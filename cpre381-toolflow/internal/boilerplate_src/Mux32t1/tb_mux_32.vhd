library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_mux_32 is

end tb_mux_32;

architecture mixed of tb_mux_32 is

component mux_32 is
	port(D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22, D23,D24, D25, D26, D27, D28, D29, D30, D31  : in std_logic_vector(31 downto 0);
	     i_S 	: in std_logic_vector(4 downto 0);
	     o_Q 	: out std_logic_vector(31 downto 0));
	end component mux_32;
signal s_D0, s_D1, s_D2, s_D3, s_D4, s_D5, s_D6, s_D7, s_D8, s_D9, s_D10, s_D11, s_D12, s_D13, s_D14, s_D15, s_D16, s_D17, s_D18, s_D19, s_D20, s_D21, s_D22, s_D23,s_D24, s_D25, s_D26, s_D27, s_D28, s_D29, s_D30, s_D31  : std_logic_vector(31 downto 0);
signal s_i_S: std_logic_vector(4 downto 0);
signal s_o_Q: std_logic_vector(31 downto 0);

begin

   DUT0: mux_32
  port map(
            i_S     => s_i_S,
            o_Q     => s_o_Q,
	    D0 => s_D0,
	    D1 => s_D1,
	    D2 => s_D2,
	    D3 => s_D3,
	    D4 => s_D4,
	    D5 => s_D5,
	    D6 => s_D6,
	    D7 => s_D7,
	    D8 => s_D8,
	    D9 => s_D9,
	    D10 => s_D10,
	    D11 => s_D11,
	    D12 => s_D12,
	    D13 => s_D13,
	    D14 => s_D14,
	    D15 => s_D15,

	    D16 => s_D16,
	    D17 => s_D17,
	    D18 => s_D18,
	    D19 => s_D19,
	    D20 => s_D20,
	    D21 => s_D21,
	    D22 => s_D22,
	    D23 => s_D23,
	    D24 => s_D24,
	    D25 => s_D25,
	    D26 => s_D26,
	    D27 => s_D27,
	    D28 => s_D28,
	    D29 => s_D29,
	    D30 => s_D30,
	    D31 => s_D31);
 
  P_TEST_CASES: process
  begin
    s_D0 <= x"11111111";
    s_D1 <= x"00001111";
    s_D2 <= x"11110000";
    s_D3 <= x"00000000";
    s_i_S <= "00000";
	wait for 50 ns;

    s_D4 <= x"11111111";
    s_D5 <= x"00001111";
    s_D6 <= x"11110000";
    s_D7 <= x"00000000";
    s_i_S <= "00111";
	wait for 50 ns;

s_D8 <= x"11111111";
    s_D9 <= x"00001111";
    s_D10 <= x"11110000";
    s_D11 <= x"00000000";
    s_i_S <= "01001";
	wait for 50 ns;

s_D20 <= x"11111111";
    s_D21 <= x"00001111";
    s_D22 <= x"11110000";
    s_D23 <= x"00000000";
    s_i_S <= "10101";
	wait for 50 ns;

s_D28 <= x"11111111";
    s_D29 <= x"00001111";
    s_D30 <= x"11110000";
    s_D31 <= x"00000000";
    s_i_S <= "11100";
	wait for 50 ns;


  end process;

end mixed;
