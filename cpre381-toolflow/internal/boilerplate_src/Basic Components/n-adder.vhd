-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- n-adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity n_adder is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(N-1 downto 0);
	i_D1         : in std_logic_vector(N-1 downto 0);
	i_C         : in std_logic;
       o_C          : out std_logic;
       o_S          : out std_logic_vector(N-1 downto 0));

end n_adder;

architecture structural of n_adder is

  component adder is
	port(i_D0             : in std_logic;
       i_D1               : in std_logic;
	i_C		:in std_logic;
	o_S               : out std_logic;
       o_C               : out std_logic);
end component;
signal Carry: std_logic_vector(N downto 0);

begin
Carry(0) <= i_C;
  -- Instantiate N mux instances.
  G_adder: for i in 0 to N-1 generate
    ADDERI: adder port map(
              i_D0     => i_D0(i),  -- ith instance's data input hooked up to ith data 0 input.
		i_D1     => i_D1(i),
		i_C =>  Carry(i),
		o_S     => o_S(i),              
		o_C      => Carry(i+1));  -- ith instance's data output hooked up to ith data output.
  end generate G_adder;
  o_C <= Carry(32);
end structural;