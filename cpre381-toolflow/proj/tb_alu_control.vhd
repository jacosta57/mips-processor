-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- tb_alu_control.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_alu_control is
  generic(gCLK_HPER   : time := 50 ns;
	  N : integer := 32);

end tb_alu_control;

architecture behavior of tb_alu_control is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component ALU_Control

  port(
        i_ALUOp     : in std_logic_vector(1 downto 0);    -- From main control
        i_Funct     : in std_logic_vector(5 downto 0);    -- Function field from instruction
        o_ALU_Operation : out std_logic_vector(3 downto 0) -- To ALU
  end component;


  signal s_ALU_Operation : std_logic;
  signal s_funct : std_logic_vector(5 downto 0);
  signal  s_ALUOp     : std_logic_vector(1 downto 0);

begin

  DUT: control_logic 
  port map(i_funct => s_funct,
        o_ALUOp=> s_ALUOp,
         o_ALU_Operation => s_ALU_Operation);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  
  -- Testbench process  
  P_TB: process
  begin
    
   s_ALUOp <= "00";
   s_funct <=  "000001";
	wait for 50 ns;        

   s_ALUOp <= "00";
   s_funct <=  "000001";
	wait for 50 ns;   

  end process;
  
end behavior;