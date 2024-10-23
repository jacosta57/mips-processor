-------------------------------------------------------------------------
-- Parnika Dasgupta
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_mux2t1_N.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux2t1_N is
end tb_mux2t1_N;

architecture behavior of tb_mux2t1_N is

  -- Constant for the bit-width of the input/output
  constant N : integer := 32; 

  -- Signal declarations for inputs and outputs
  signal i_S : std_logic := '0';  -- Select signal
  signal i_D0 : std_logic_vector(N-1 downto 0) := (others => '0');  -- Input data 0
  signal i_D1 : std_logic_vector(N-1 downto 0) := (others => '1');  -- Input data 1
  signal o_O : std_logic_vector(N-1 downto 0);  -- Output signal

  -- Component Declaration for Unit Under Test (UUT)
  component mux2t1_N
    generic(N : integer);
    port(
      i_S : in std_logic;
      i_D0 : in std_logic_vector(N-1 downto 0);
      i_D1 : in std_logic_vector(N-1 downto 0);
      o_O : out std_logic_vector(N-1 downto 0)
    );
  end component;

begin

  -- Instantiate the Unit Under Test (UUT)
  UUT: mux2t1_N 
    generic map(N => N)  -- Map the generic parameter
    port map(
      i_S => i_S,        -- Connect the select signal
      i_D0 => i_D0,      -- Connect input data 0
      i_D1 => i_D1,      -- Connect input data 1
      o_O => o_O         -- Connect the output
    );

  -- Stimulus process to provide test vectors and observe the output
  stim_proc: process
  begin
    -- Test Case 1: i_S = '0', expect o_O = i_D0
    i_S <= '0';
    i_D0 <= "00000000000000000000000000000000";
    i_D1 <= "11111111111111111111111111111111";
    wait for 10 ns;

    -- Test Case 2: i_S = '1', expect o_O = i_D1
    i_S <= '1';
    wait for 10 ns;

    -- Test Case 3: i_S = '0', with different data on i_D0 and i_D1
    i_S <= '0';
    i_D0 <= "10101010101010101010101010101010";
    i_D1 <= "01010101010101010101010101010101";
    wait for 10 ns;

    -- Test Case 4: i_S = '1', again switching to i_D1
    i_S <= '1';
    wait for 10 ns;

    -- End simulation
    wait;
  end process;

end behavior;


