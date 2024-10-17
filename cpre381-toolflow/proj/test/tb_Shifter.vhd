library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  
library std;
use std.env.all;               
use std.textio.all;            

entity tb_shifter is

end tb_shifter;

architecture mixed of tb_shifter is

component shifter is
	port ( i_D : in std_logic_vector(31 downto 0);
		i_Shamt : in std_logic_vector(4 downto 0);
		Right_Left  : in std_logic;
		Logic_Arith  : in std_logic;
		o_Q : out std_logic_vector(31 downto 0));

end component shifter;

signal s_Shamt: std_logic_vector(4 downto 0);
signal s_i_D, s_o_Q: std_logic_vector(31 downto 0);
signal s_Right_Left, s_Logic_Arith  : std_logic;

begin

   DUT0: shifter
  port map(
            i_D     => s_i_D,
            i_Shamt     => s_Shamt,
            Right_Left     => s_Right_Left,
            Logic_Arith     => s_Logic_Arith,
	    o_Q     => s_o_Q);
 
  P_TEST_CASES: process
  begin
	s_Shamt <= "00000";	

	s_i_D <= x"0000000F";
	s_Shamt <= "00001";
	s_Right_Left <= '0';
	s_Logic_Arith <= '0';
	wait for 50 ns;

	s_i_D <= x"0000000F";
	s_Shamt <= "00011";
	s_Right_Left <= '0';
	s_Logic_Arith <= '1';
	wait for 50 ns;

	s_i_D <= x"0000000F";
	s_Shamt <= "00010";
	s_Right_Left <= '1';
	s_Logic_Arith <= '0';
	wait for 50 ns;

	s_i_D <= x"0000000F";
	s_Shamt <= "11111";
	s_Right_Left <= '1';
	s_Logic_Arith <= '0';
	wait for 50 ns;

	s_i_D <= x"F0000000";
	s_Shamt <= "00100";
	s_Right_Left <= '0';
	s_Logic_Arith <= '1';
	wait for 50 ns;

	s_i_D <= x"F0000000";
	s_Shamt <= "11111";
	s_Right_Left <= '0';
	s_Logic_Arith <= '1';
	wait for 50 ns;
  end process;

end mixed;
