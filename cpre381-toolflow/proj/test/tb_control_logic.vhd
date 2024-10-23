-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- tb_control_logic.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_control_logic is
  generic(gCLK_HPER   : time := 50 ns;
	  N : integer := 32);

end tb_control_logic;

architecture behavior of tb_control_logic is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component control_logic

  port (
        i_opcode    : in  std_logic_vector(5 downto 0);
        i_funct     : in  std_logic_vector(5 downto 0);
        o_RegDst    : out std_logic;
        o_Jump      : out std_logic;
        o_Branch    : out std_logic;
        o_MemRead   : out std_logic;
        o_MemtoReg  : out std_logic;
        o_ALUOp     : out std_logic_vector(1 downto 0);
        o_MemWrite  : out std_logic;
        o_ALUSrc    : out std_logic;
        o_RegWrite  : out std_logic;
        o_Halt      : out std_logic);

  end component;


  signal s_Jump, s_RegDst, s_branch, s_memRead, s_MemToReg, s_MemWrite, s_ALUSrc, s_RegWrite, s_Halt : std_logic;
  signal s_opcode, s_funct : std_logic_vector(5 downto 0);
  signal  s_ALUOp     : std_logic_vector(1 downto 0);

begin

  DUT: control_logic 
  port map(i_opcode => s_opcode,
        i_funct => s_funct,
        o_RegDst => s_RegDst,
        o_Jump => s_Jump,
        o_Branch => s_branch,
        o_MemRead => s_memRead,
        o_MemtoReg  => s_MemtoReg,     
        o_ALUOp=> s_ALUOp,
        o_MemWrite => s_MemWrite,
        o_ALUSrc => s_ALUSrc,
        o_RegWrite => s_RegWrite,
        o_Halt => s_halt);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  
  -- Testbench process  
  P_TB: process
  begin
    
   s_opcode <= "000000";
   s_funct <=  "000001";
	wait for 50 ns;        

   s_opcode <= "000000";
   s_funct <=  "001000";
	wait for 50 ns; 

   s_opcode <= "000010";
   s_funct <=  "000001";
	wait for 50 ns;    

   s_opcode <= "000011";
   s_funct <=  "000001";
	wait for 50 ns;  

   s_opcode <= "000100";
   s_funct <=  "000001";
	wait for 50 ns;  

   s_opcode <= "000101";
   s_funct <=  "000001";
	wait for 50 ns;  

   s_opcode <= "001000";
   s_funct <=  "000001";
	wait for 50 ns;  

   s_opcode <= "001001";
   s_funct <=  "000001";
	wait for 50 ns;  

   s_opcode <= "001100";
   s_funct <=  "000001";
	wait for 50 ns;  

   s_opcode <= "001101";
   s_funct <=  "000001";
	wait for 50 ns;  

   s_opcode <= "001111";
   s_funct <=  "000001";
	wait for 50 ns;  

   s_opcode <= "010100";
   s_funct <=  "000001";
	wait for 50 ns;  

   s_opcode <= "100011";
   s_funct <=  "000001";
	wait for 50 ns;  

   s_opcode <= "101011";
   s_funct <=  "000001";
	wait for 50 ns; 

  end process;
  
end behavior;