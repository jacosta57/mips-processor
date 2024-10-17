library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


entity tb_n_adder is
  generic(N   : integer := 32);   -- Generic for half of the clock cycle period
end tb_n_adder;

architecture mixed of tb_n_adder is



component n_adder is
    port(i_C                  : in std_logic;
         i_D0                 : in std_logic_vector(N-1 downto 0);
         i_D1                 : in std_logic_vector(N-1 downto 0);
         o_S                  : out std_logic_vector(N-1 downto 0);
	 o_C                  : out std_logic);

  end component n_adder;


-- TODO: change input and output signals as needed.
signal s_i_D0: std_logic_vector(N-1 downto 0) := x"00000000";
signal s_i_D1: std_logic_vector(N-1 downto 0) := x"00000000";
signal s_C_O: std_logic := '0';
signal s_C_i: std_logic := '0';
signal s_S: std_logic_vector(N-1 downto 0);


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: n_adder
  port map(
            i_D0     => s_i_D0,
             i_D1      => s_i_D1,
            i_C      => s_C_i ,
            o_C     => s_C_O,
		o_S     => s_S);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    -- Test case 1:
    s_i_D0   <= x"00000000"; 
    s_i_D1   <= x"00000000";
    s_C_i    <= '0';
	wait for 50 ns;
       s_i_D0   <= x"11111111"; 
    s_i_D1   <= x"00000000";
    s_C_i    <= '0';
	wait for 50 ns;
           s_i_D0   <= x"FFFFFFFE"; 
    s_i_D1   <= x"00000001";
    s_C_i    <= '0';
	wait for 50 ns;
          s_i_D0   <= x"EEEEEEED"; 
    s_i_D1   <= x"11111111";
    s_C_i    <= '1';
	wait for 50 ns;
          s_i_D0   <= x"11111111"; 
    s_i_D1   <= x"22222222";
    s_C_i    <= '1';
	wait for 50 ns;
  end process;

end mixed;
