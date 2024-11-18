-------------------------------------------------------------------------
-- Jayson Acosta
--
--
-- tb_branch_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for branch_logic
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_branch_logic is
  generic(gCLK_HPER   : time := 50 ns;
          N : integer := 32);
end tb_branch_logic;

architecture behavior of tb_branch_logic is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component branch_logic
    port(
        i_Branch    : in std_logic;
        i_Opcode    : in std_logic_vector(5 downto 0);
        i_RegData1  : in std_logic_vector(31 downto 0);
        i_RegData2  : in std_logic_vector(31 downto 0);
        o_Branch_Take : out std_logic
    );
  end component;

  signal s_Branch       : std_logic;
  signal s_Opcode       : std_logic_vector(5 downto 0);
  signal s_RegData1     : std_logic_vector(31 downto 0);
  signal s_RegData2     : std_logic_vector(31 downto 0);
  signal s_Branch_Take  : std_logic;

begin

  DUT: branch_logic 
  port map(
    i_Branch     => s_Branch,
    i_Opcode     => s_Opcode,
    i_RegData1   => s_RegData1,
    i_RegData2   => s_RegData2,
    o_Branch_Take => s_Branch_Take
  );
  
  P_TB: process
  begin
    -- Test 1: BEQ with equal values (should branch)
    s_Branch <= '1';
    s_Opcode <= "000100";  -- beq
    s_RegData1 <= x"00000005";
    s_RegData2 <= x"00000005";
    wait for cCLK_PER;

    -- Test 2: BEQ with unequal values (should not branch)
    s_Branch <= '1';
    s_Opcode <= "000100";  -- beq
    s_RegData1 <= x"00000005";
    s_RegData2 <= x"00000006";
    wait for cCLK_PER;

    -- Test 3: BNE with unequal values (should branch)
    s_Branch <= '1';
    s_Opcode <= "000101";  -- bne
    s_RegData1 <= x"00000005";
    s_RegData2 <= x"00000006";
    wait for cCLK_PER;

    -- Test 4: BNE with equal values (should not branch)
    s_Branch <= '1';
    s_Opcode <= "000101";  -- bne
    s_RegData1 <= x"00000005";
    s_RegData2 <= x"00000005";
    wait for cCLK_PER;

    -- Test 5: Branch disabled
    s_Branch <= '0';
    s_Opcode <= "000100";  -- beq
    s_RegData1 <= x"00000005";
    s_RegData2 <= x"00000005";
    wait for cCLK_PER;
    
    wait;
  end process;
  
end behavior;