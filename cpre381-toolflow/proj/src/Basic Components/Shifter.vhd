-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- shifter.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shifter is
	port ( i_D : in std_logic_vector(31 downto 0);
		i_Shamt : in std_logic_vector(4 downto 0);
		Right_Left  : in std_logic;
		Logic_Arith  : in std_logic;
		o_Q : out std_logic_vector(31 downto 0));
	end shifter;

architecture Behavioral of shifter is
signal s_Control : std_logic_vector(1 downto 0);
signal s_shamt : natural;

begin

process(Right_Left, Logic_Arith)
begin

s_Control <= Right_Left & Logic_Arith;

end process;

process(i_D, i_Shamt, s_Control)
begin

if (s_Control = "00") then 
	o_Q <= std_logic_vector(shift_right(unsigned(i_D), to_integer(unsigned(i_Shamt))));
elsif(s_Control = "01") then 
	o_Q <= std_logic_vector(shift_right(signed(i_D), to_integer(unsigned(i_Shamt))));
elsif (s_Control = "10") then 
	o_Q <= std_logic_vector(shift_left(unsigned(i_D), to_integer(unsigned(i_Shamt))));
else
	o_Q <= x"12345678";
end if;

end process;
end Behavioral;