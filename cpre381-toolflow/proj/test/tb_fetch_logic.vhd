-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- tb_fetch_logic.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_fetch_logic is
  generic(gCLK_HPER   : time := 50 ns;
	  N : integer := 32);

end tb_fetch_logic;

architecture behavior of tb_fetch_logic is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component fetch_logic

  port (
    i_clk           : in  std_logic;
    i_rst           : in  std_logic;
    i_branch_en     : in  std_logic;
    i_jump_en       : in  std_logic;
    i_jr_en         : in  std_logic;
    i_branch_addr   : in  std_logic_vector(31 downto 0);
    i_jump_addr     : in  std_logic_vector(25 downto 0);
    i_jr_addr       : in  std_logic_vector(31 downto 0);
    o_PC            : out std_logic_vector(31 downto 0);
    o_next_inst_addr: out std_logic_vector(31 downto 0));

  end component;


  signal s_clk, s_rst, s_branch_en, s_jump_en, s_jr_en : std_logic;
  signal s_branch_addr, s_PC, s_jr_addr, s_next_inst_addr : std_logic_vector(31 downto 0);
  signal  s_jump_addr     : std_logic_vector(25 downto 0);

begin

  DUT: fetch_logic 
  port map(i_clk => s_CLK, 
           i_rst => s_RST,
           i_branch_en => s_branch_en,
           i_jump_en  => s_jump_en,
           i_jr_en   => s_jr_en,
           i_branch_addr => s_branch_addr,
           i_jump_addr  => s_jump_addr,
           i_jr_addr => s_jr_addr,
           o_PC  => s_PC,
           o_next_inst_addr => s_next_inst_addr);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    
    s_rst <= '1';
    s_branch_en  <= '0';
    s_jump_en  <= '0';
    s_jr_en  <= '0';
    s_branch_addr   <= x"00000000";
    s_jr_addr   <= x"00000000";
    s_jump_addr   <= "00000000000000000000000000";
    wait for cCLK_PER;
    
    s_rst <= '0';
    s_branch_en  <= '0';
    s_jump_en  <= '0';
    s_jr_en  <= '0';
    s_branch_addr   <= x"00000000";
    s_jr_addr   <= x"00000000";
    s_jump_addr   <= "00000000000000000000000000";
    wait for cCLK_PER * 2;
        
    s_rst <= '0';
    s_branch_en  <= '1';
    s_jump_en  <= '0';
    s_jr_en  <= '0';
    s_branch_addr   <= x"00001000";
    s_jr_addr   <= x"00400008";
    s_jump_addr   <= "11111000000000000000000000";
    wait for cCLK_PER;
                
    s_rst <= '0';
    s_branch_en  <= '0';
    s_jump_en  <= '1';
    s_jr_en  <= '0';
    s_branch_addr   <= x"00001000";
    s_jr_addr   <= x"00400008";
    s_jump_addr   <= "11111000000000000000000000";
    wait for cCLK_PER;
                
    s_rst <= '0';
    s_branch_en  <= '0';
    s_jump_en  <= '0';
    s_jr_en  <= '1';
    s_branch_addr   <= x"00001000";
    s_jr_addr   <= x"00400008";
    s_jump_addr   <= "11111000000000000000000000";
    wait for cCLK_PER;
                
    s_rst <= '0';
    s_branch_en  <= '0';
    s_jump_en  <= '0';
    s_jr_en  <= '0';
    s_branch_addr   <= x"00001000";
    s_jr_addr   <= x"00400008";
    s_jump_addr   <= "11111000000000000000000000";
    wait for cCLK_PER;
        
  end process;
  
end behavior;