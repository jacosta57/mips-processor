library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  
library std;
use std.env.all;
use std.textio.all;             
entity tb_extenders is

end tb_extenders;

architecture mixed of tb_extenders is

component extenders is
	port ( i_imm16 : in std_logic_vector(15 downto 0);
		zero_sign_s  : in std_logic;
		o_imm32 : out std_logic_vector(31 downto 0));
	
end component extenders;

signal s_i_imm16  : std_logic_vector(15 downto 0);
signal s_zero_sign_s: std_logic;
signal s_o_imm32: std_logic_vector(31 downto 0);

begin

   DUT: extenders
  port map(
            i_imm16     => s_i_imm16,
            zero_sign_s     => s_zero_sign_s,
		o_imm32   =>   s_o_imm32);
 
  P_TEST_CASES: process
  begin
	s_i_imm16 <= x"7FFF";
	s_zero_sign_s <= '0';
	wait for 50 ns;

	s_i_imm16 <= x"7FFF";
	s_zero_sign_s <= '1';
	wait for 50 ns;

	s_i_imm16 <= x"F888";
	s_zero_sign_s <= '1';
	wait for 50 ns;

	s_i_imm16 <= x"F888";
	s_zero_sign_s <= '0';
	wait for 50 ns;

	s_i_imm16 <= x"8FED";
	s_zero_sign_s <= '1';
	wait for 50 ns;

	s_i_imm16 <= x"8FED";
	s_zero_sign_s <= '0';
	wait for 50 ns;

     end process;

end mixed;