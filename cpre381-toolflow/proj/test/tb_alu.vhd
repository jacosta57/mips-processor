-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- tb_alu.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_alu is
  generic(gCLK_HPER   : time := 50 ns;
	  N : integer := 32);

end tb_alu;

architecture behavior of tb_alu is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component alu

  port(
        i_A         : in std_logic_vector(31 downto 0);    -- First operand
        i_B         : in std_logic_vector(31 downto 0);    -- Second operand
        i_ALUOp     : in std_logic_vector(3 downto 0);     -- Operation select
        i_shamt     : in std_logic_vector(4 downto 0);     -- Shift amount
        o_F         : out std_logic_vector(31 downto 0);   -- Result
        o_Zero      : out std_logic;                       -- Zero flag for branching
        o_Overflow  : out std_logic                        -- Overflow flag
    );
    
  end component;

  signal s_i_A, s_i_B, s_o_F : std_logic_vector(31 downto 0);
  signal s_ALUOp : std_logic_vector(3 downto 0);
   signal s_i_shamt : std_logic_vector(4 downto 0); 
  signal  s_o_Zero, o_Overflow : std_logic;

begin

  DUT: alu 
  port map(i_A => s_i_A, 
           i_B  => s_i_B, 
           o_F => s_o_F,
           i_ALUOp => s_ALUOp,
           i_shamt  => s_i_shamt,
           o_Zero => s_o_Zero, 
           o_Overflow => o_Overflow);


  
  P_TB: process
  begin
    
    s_i_A <= x"11111111";
    s_i_B <= x"11112222";
    s_ALUOp <=  "0000";
    s_i_shamt <= "00100";
	wait for 50 ns;   
  
  s_i_A <= x"11111111";
  s_i_B <= x"11112222";
  s_ALUOp <=  "0001";
  s_i_shamt <= "00100";
wait for 50 ns;    

s_i_A <= x"11111111";
s_i_B <= x"11112222";
s_ALUOp <=  "0010";
s_i_shamt <= "00100";
wait for 50 ns;    

s_i_A <= x"11111111";
s_i_B <= x"11112222";
s_ALUOp <=  "0011";
s_i_shamt <= "00100";
wait for 50 ns;    

s_i_A <= x"11111111";
s_i_B <= x"11112222";
s_ALUOp <=  "0100";
s_i_shamt <= "00100";
wait for 50 ns;    

s_i_A <= x"11111111";
s_i_B <= x"11112222";
s_ALUOp <=  "0110";
s_i_shamt <= "00100";
wait for 50 ns;    

s_i_A <= x"11111111";
s_i_B <= x"11112222";
s_ALUOp <=  "0111";
s_i_shamt <= "00100";
wait for 50 ns;  

s_i_A <= x"11111111";
s_i_B <= x"11111110";
s_ALUOp <=  "0111";
s_i_shamt <= "00100";
wait for 50 ns; 

s_i_A <= x"11111111";
s_i_B <= x"11112222";
s_ALUOp <=  "1000";
s_i_shamt <= "00100";
wait for 50 ns;  

s_i_A <= x"11111111";
s_i_B <= x"11112222";
s_ALUOp <=  "1010";
s_i_shamt <= "00100";
wait for 50 ns;  
  
s_i_A <= x"11111111";
s_i_B <= x"11112222";
s_ALUOp <=  "1100";
s_i_shamt <= "00100";
wait for 50 ns; 
 
  end process;
end behavior;