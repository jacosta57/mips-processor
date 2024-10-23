-------------------------------------------------------------------------
-- Parnika Dasgupta
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_n_adder.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_n_adder is
end tb_n_adder;

architecture behavior of tb_n_adder is

  -- Generic parameter N for the width of the adder
  constant N : integer := 32; 

  -- Signal declarations for inputs and outputs
  signal i_D0 : std_logic_vector(N-1 downto 0) := (others => '0');  -- Input data 0
  signal i_D1 : std_logic_vector(N-1 downto 0) := (others => '0');  -- Input data 1
  signal i_C  : std_logic := '0';                                    -- Carry-in signal
  signal o_S  : std_logic_vector(N-1 downto 0);                      -- Sum output
  signal o_C  : std_logic;                                           -- Carry-out signal

  -- Component Declaration of Unit Under Test (UUT)
  component n_adder
    generic(N : integer);
    port(
      i_D0 : in std_logic_vector(N-1 downto 0);
      i_D1 : in std_logic_vector(N-1 downto 0);
      i_C  : in std_logic;
      o_C  : out std_logic;
      o_S  : out std_logic_vector(N-1 downto 0)
    );
  end component;

begin

  -- Instantiate the Unit Under Test (UUT)
  UUT: n_adder
    generic map(N => N)  -- Map the generic value
    port map(
      i_D0 => i_D0,
      i_D1 => i_D1,
      i_C  => i_C,
      o_C  => o_C,
      o_S  => o_S
    );

  -- Stimulus process to apply test vectors and observe output
  stim_proc: process
  begin
    -- Test Case 1: Add two 32-bit zeros with carry-in '0', expect sum = 0 and carry-out = 0
    i_D0 <= (others => '0');
    i_D1 <= (others => '0');
    i_C <= '0';
    wait for 10 ns;

    -- Test Case 2: Add two 32-bit ones with carry-in '0', expect sum = "11111111111111111111111111111110" and carry-out = 1
    i_D0 <= (others => '1');
    i_D1 <= (others => '1');
    i_C <= '0';
    wait for 10 ns;

    -- Test Case 3: Add 32-bit alternating pattern with carry-in '1'
    i_D0 <= "10101010101010101010101010101010";
    i_D1 <= "01010101010101010101010101010101";
    i_C <= '1';
    wait for 10 ns;

    -- Test Case 4: Random 32-bit patterns with carry-in '0'
    i_D0 <= "11001100110011001100110011001100";
    i_D1 <= "00110011001100110011001100110011";
    i_C <= '0';
    wait for 10 ns;

    -- End simulation
    wait;
  end process;

end behavior;

