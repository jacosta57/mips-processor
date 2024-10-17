library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_onescomp is
  generic(N   : integer := 32);   -- Generic for half of the clock cycle period
end tb_onescomp;

architecture mixed of tb_onescomp is


-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component onescomp is
    port(i_A                 : in std_logic_vector(N-1 downto 0);
         o_F                  : out std_logic_vector(N-1 downto 0));

  end component onescomp;


-- TODO: change input and output signals as needed.
signal s_i_A: std_logic_vector(N-1 downto 0) := x"00000000";
signal s_F: std_logic_vector(N-1 downto 0);


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: onescomp
  port map(
            i_A     => s_i_A,
            o_F     => s_F);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    -- Test case 1:
    -- Initialize weight value to 10.
    s_i_A   <= x"00000000";  -- Not strictly necessary, but this makes the testcases easier to read
	wait for 50 ns;
    -- Test case 2:
    -- Perform average example of an input activation of 3 and a partial sum of 25. The weight is still 10. 
       s_i_A   <= x"11111111";  -- Not strictly necessary, but this makes the testcases easier to read
	wait for 50 ns;
       s_i_A   <= x"FFFFFFFF";  -- Not strictly necessary, but this makes the testcases easier to read
	wait for 50 ns;
       s_i_A   <= x"77777777";  -- Not strictly necessary, but this makes the testcases easier to read
 	wait for 50 ns;
 end process;

end mixed;