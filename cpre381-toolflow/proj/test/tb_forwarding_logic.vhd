-------------------------------------------------------------------------
-- Jayson Acosta
--
--
-- tb_forwarding_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for forwarding_logic
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_forwarding_logic is
  generic(gCLK_HPER   : time := 50 ns;
          N : integer := 32);
end tb_forwarding_logic;

architecture behavior of tb_forwarding_logic is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component forwarding_logic
    port(i_MEM_RegWr     : in std_logic;
         i_WB_RegWr      : in std_logic;
         i_MEM_RegDst    : in std_logic_vector(4 downto 0);
         i_WB_RegDst     : in std_logic_vector(4 downto 0);
         i_Rs            : in std_logic_vector(4 downto 0);
         i_Rt            : in std_logic_vector(4 downto 0);
         o_Mux0_s        : out std_logic_vector(1 downto 0);
         o_Mux1_s        : out std_logic_vector(1 downto 0));
  end component;

  signal s_MEM_RegWr   : std_logic;
  signal s_WB_RegWr    : std_logic;
  signal s_MEM_RegDst  : std_logic_vector(4 downto 0);
  signal s_WB_RegDst   : std_logic_vector(4 downto 0);
  signal s_Rs          : std_logic_vector(4 downto 0);
  signal s_Rt          : std_logic_vector(4 downto 0);
  signal s_Mux0_s      : std_logic_vector(1 downto 0);
  signal s_Mux1_s      : std_logic_vector(1 downto 0);

begin

  DUT: forwarding_logic 
  port map(i_MEM_RegWr   => s_MEM_RegWr,
           i_WB_RegWr    => s_WB_RegWr,
           i_MEM_RegDst  => s_MEM_RegDst,
           i_WB_RegDst   => s_WB_RegDst,
           i_Rs          => s_Rs,
           i_Rt          => s_Rt,
           o_Mux0_s      => s_Mux0_s,
           o_Mux1_s      => s_Mux1_s);
  
  P_TB: process
  begin
    -- Test 1: No forwarding needed
    s_MEM_RegWr  <= '0';
    s_WB_RegWr   <= '0';
    s_MEM_RegDst <= "00000";
    s_WB_RegDst  <= "00000";
    s_Rs         <= "00001";
    s_Rt         <= "00010";
    wait for cCLK_PER;

    -- Test 2: Forward from MEM to Rs
    s_MEM_RegWr  <= '1';
    s_WB_RegWr   <= '0';
    s_MEM_RegDst <= "00001";
    s_WB_RegDst  <= "00000";
    s_Rs         <= "00001";
    s_Rt         <= "00010";
    wait for cCLK_PER;

    -- Test 3: Forward from MEM to Rt
    s_MEM_RegWr  <= '1';
    s_WB_RegWr   <= '0';
    s_MEM_RegDst <= "00010";
    s_WB_RegDst  <= "00000";
    s_Rs         <= "00001";
    s_Rt         <= "00010";
    wait for cCLK_PER;

    -- Test 4: Forward from WB to Rs
    s_MEM_RegWr  <= '0';
    s_WB_RegWr   <= '1';
    s_MEM_RegDst <= "00000";
    s_WB_RegDst  <= "00001";
    s_Rs         <= "00001";
    s_Rt         <= "00010";
    wait for cCLK_PER;

    -- Test 5: Forward from WB to Rt
    s_MEM_RegWr  <= '0';
    s_WB_RegWr   <= '1';
    s_MEM_RegDst <= "00000";
    s_WB_RegDst  <= "00010";
    s_Rs         <= "00001";
    s_Rt         <= "00010";
    wait for cCLK_PER;

    -- Test 6: MEM priority over WB for Rs
    s_MEM_RegWr  <= '1';
    s_WB_RegWr   <= '1';
    s_MEM_RegDst <= "00001";
    s_WB_RegDst  <= "00001";
    s_Rs         <= "00001";
    s_Rt         <= "00010";
    wait for cCLK_PER;

    -- Test 7: No forward from register 0
    s_MEM_RegWr  <= '1';
    s_WB_RegWr   <= '1';
    s_MEM_RegDst <= "00000";
    s_WB_RegDst  <= "00000";
    s_Rs         <= "00000";
    s_Rt         <= "00000";
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;