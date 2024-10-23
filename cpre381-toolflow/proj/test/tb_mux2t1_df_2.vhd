-------------------------------------------------------------------------
-- Parnika Dasgupta
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_mux2t1_df_2.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux2t1_df_2 is
end tb_mux2t1_df_2;

architecture behavior of tb_mux2t1_df_2 is

  -- Signal declarations for inputs and outputs
  signal i_D0 : std_logic := '0';  -- Input data 0
  signal i_D1 : std_logic := '1';  -- Input data 1
  signal i_S : std_logic := '0';   -- Select signal
  signal o_O : std_logic;          -- Output signal

  -- Component Declaration for Unit Under Test (UUT)
  component mux2t1_df_2
    port(
      i_D0 : in std_logic;
      i_D1 : in std_logic;
      i_S : in std_logic;
      o_O : out std_logic
    );
  end component;

begin

  -- Instantiate the Unit Under Test (UUT)
  UUT: mux2t1_df_2
    port map(
      i_D0 => i_D0,
      i_D1 => i_D1,
      i_S => i_S,
      o_O => o_O
    );

  -- Stimulus process to provide test vectors and observe the output
  stim_proc: process
  begin
    -- Test Case 1: i_S = '0', expect o_O = i_D0
    i_D0 <= '0';
    i_D1 <= '1';
    i_S <= '0';
    wait for 10 ns;
    
    -- Test Case 2: i_S = '1', expect o_O = i_D1
    i_S <= '1';
    wait for 10 ns;
    
    -- Test Case 3: i_S = '0', change inputs, expect o_O = i_D0
    i_D0 <= '1';
    i_D1 <= '0';
    i_S <= '0';
    wait for 10 ns;
    
    -- Test Case 4: i_S = '1', expect o_O = i_D1
    i_S <= '1';
    wait for 10 ns;

    -- End simulation
    wait;
  end process;

end behavior;

