-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- extenders.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity extenders is
	port ( i_imm16 : in std_logic_vector(15 downto 0);
		zero_sign_s  : in std_logic;
		o_imm32 : out std_logic_vector(31 downto 0));
	end extenders;

architecture Behavioral of extenders is
begin
process(zero_sign_s, i_imm16)
begin
if (zero_sign_s='0') then 
o_imm32<= std_logic_vector(resize(unsigned(i_imm16), 32)); 
else 
o_imm32<= std_logic_vector(resize(signed(i_imm16), 32));
end if;
end process;
end Behavioral;