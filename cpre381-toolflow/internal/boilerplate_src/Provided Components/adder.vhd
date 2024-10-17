-------------------------------------------------------------------------
-- Nakota Clark
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a behavioral 
-- register that delays the input by one clock cycle. 
--
--
-- NOTES: Integer data type is not typically useful when doing hardware
-- design. We use it here for simplicity, but in future labs it will be
-- important to switch to std_logic_vector types and associated math
-- libraries (e.g. signed, unsigned). 


-- 1/14/18 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all; 

entity adder is

  port(i_D0             : in std_logic;
       i_D1               : in std_logic;
	i_C		:in std_logic;
	o_S               : out std_logic;
       o_C               : out std_logic);

end adder;

architecture structure of adder is


 component xorg2
	port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

   component andg2
	port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

  end component;

   component org2
	port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

  end component;

signal xor_o         : std_logic;
signal and_out_0         : std_logic;
signal and_out_1         : std_logic;

begin

xor_0: xorg2
    port MAP(i_A               => i_D0,
	     i_B     =>		i_D1,
		o_F		=> xor_o);

and_0: andg2
	port MAP(i_B               => i_D1,
             	i_A               => i_D0,
			o_F	=> and_out_0);
and_1: andg2
	port MAP(i_B               => i_C,
             	i_A               => xor_o,
		o_F 		=>and_out_1);

or_1:org2
	port MAP( i_A=> and_out_1,
		 i_B => and_out_0,
		o_F   => o_C);
xor_1: xorg2
    port MAP(i_A               => xor_o,
	     i_B     =>		i_C,
		o_F		=> o_S);



end structure;