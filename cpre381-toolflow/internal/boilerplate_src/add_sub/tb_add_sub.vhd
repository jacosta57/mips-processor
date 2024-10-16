library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_add_sub is
  generic(N   : integer := 32);   -- Generic for half of the clock cycle period
end tb_add_sub;

architecture mixed of tb_add_sub is


-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component add_sub is
 port(i_D0         : in std_logic_vector(N-1 downto 0);
	i_D1         : in std_logic_vector(N-1 downto 0);
	i_imm         : in std_logic_vector(N-1 downto 0);
	nAdd_Sub         : in std_logic;
	ALUSrc         : in std_logic;
       o_S          : out std_logic_vector(N-1 downto 0));  

  end component add_sub;


-- TODO: change input and output signals as needed.
signal s_i_D0: std_logic_vector(N-1 downto 0) := x"00000000";
signal s_i_D1: std_logic_vector(N-1 downto 0) := x"00000000";
signal s_nadd_sub: std_logic := '0';
signal s_ALUSrc : std_logic:= '0';
signal s_S: std_logic_vector(N-1 downto 0):= x"00000000";
signal s_i_imm  : std_logic_vector(N-1 downto 0) := x"00000000";


begin


  DUT0: add_sub
  port map(
            i_D0     => s_i_D0,
             i_D1      => s_i_D1,
            nAdd_Sub      => s_nadd_sub ,
		ALUSrc => s_ALUSrc,
		i_imm => s_i_imm,  
		o_S     => s_S);

  P_TEST_CASES: process
  begin

    s_i_D0   <= x"11111111"; 
    s_i_D1   <= x"00000000";
    s_i_imm  <= x"22222222";
    s_ALUSrc <= '0';
    s_nadd_sub    <= '0';
	wait for 50 ns;

    s_i_D0   <= x"11111111"; 
    s_i_D1   <= x"00000000";
    s_i_imm  <= x"22222222";
    s_ALUSrc <= '1';
    s_nadd_sub    <= '0';
	wait for 50 ns;

    s_i_D0   <= x"FFFFFFFF"; 
    s_i_D1   <= x"11111111";
    s_i_imm  <= x"22222222";
    s_ALUSrc <= '0';
    s_nadd_sub    <= '1';
	wait for 50 ns;

    s_i_D0   <= x"FFFFFFFF"; 
    s_i_D1   <= x"11111111";
    s_i_imm  <= x"22222222";
    s_ALUSrc <= '1';
    s_nadd_sub    <= '1';
	wait for 50 ns;

    s_i_D0   <= x"88888888"; 
    s_i_D1   <= x"11111111";
    s_i_imm  <= x"77777777";
    s_ALUSrc <= '1';
    s_nadd_sub    <= '0';
	wait for 50 ns;

  end process;

end mixed;