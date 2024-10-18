-------------------------------------------------------------------------
-- Parnika Dasgupta
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_onescompl.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_onescomp is
end tb_onescomp;

architecture behavior of tb_onescomp is

  -- Generic parameter N from the original design
  constant N : integer := 32; 

  -- Signal declarations for inputs and outputs
  signal i_A : std_logic_vector(N-1 downto 0) := (others => '0'); -- Input signal
  signal o_F : std_logic_vector(N-1 downto 0); -- Output signal

  -- Component Declaration of Unit Under Test (UUT)
  component onescomp
    generic(N : integer);
    port(
      i_A : in std_logic_vector(N-1 downto 0);
      o_F : out std_logic_vector(N-1 downto 0)
    );
  end component;

begin

  -- Instantiate the Unit Under Test (UUT)
  UUT: onescomp 
    generic map(N => N) -- Map the generic value
    port map(
      i_A => i_A,
      o_F => o_F
    );

  -- Stimulus process to provide input vectors and monitor output
  stim_proc: process
  begin
    -- Test Case 1: All zeros
    i_A <= (others => '0');
    wait for 10 ns;
    
    -- Test Case 2: All ones
    i_A <= (others => '1');
    wait for 10 ns;

    -- Test Case 3: Alternating 1's and 0's
    i_A <= "10101010101010101010101010101010";
    wait for 10 ns;

    -- Test Case 4: Random pattern
    i_A <= "11001100110011001100110011001100";
    wait for 10 ns;

    -- Test Case 5: Another random pattern
    i_A <= "00110011001100110011001100110011";
    wait for 10 ns;

    -- End simulation
    wait;
  end process;

end behavior;


