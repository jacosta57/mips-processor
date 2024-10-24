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
        o_ALU_Operation : out std_logic_vector(3 downto 0)); -- To ALU
  end component;


  signal s_ALU_Operation : std_logic_vector(3 downto 0);
  signal s_funct : std_logic_vector(5 downto 0);
  signal  s_ALUOp     : std_logic_vector(1 downto 0);

begin

  DUT: ALU_Control 
  port map(i_funct       => s_funct,
        i_ALUOp          => s_ALUOp,
         o_ALU_Operation => s_ALU_Operation);


  
  P_TB: process
  begin
    
   s_ALUOp <= "00";
   s_funct <=  "000001";
	wait for 50 ns;        

   s_ALUOp <= "01";
   s_funct <=  "000100";
	wait for 50 ns;   

  s_ALUOp <= "10";
  s_funct <=  "100000";
 wait for 50 ns;   

 s_ALUOp <= "10";
 s_funct <=  "100001";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "100100";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "100101";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "100110";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "100110";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "100111";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "101010";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "000000";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "000010";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "000011";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "100010";
wait for 50 ns;  

s_ALUOp <= "10";
s_funct <=  "100011";
wait for 50 ns;  

s_ALUOp <= "11";
s_funct <=  "000010";
wait for 50 ns;  
  end process;
  
end behavior;