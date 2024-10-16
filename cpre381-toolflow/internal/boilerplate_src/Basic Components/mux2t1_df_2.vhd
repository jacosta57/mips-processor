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

entity mux2t1_df_2 is

  port(i_D0             : in std_logic;
       i_D1               : in std_logic;
	i_S		:in std_logic;
       o_O               : out std_logic);

end mux2t1_df_2;

architecture mux2t1_df of mux2t1_df_2 is
begin
o_O <= i_D0 when (i_S = '0') else
	i_D1 when (i_S = '1') else
	'0';


end mux2t1_df;