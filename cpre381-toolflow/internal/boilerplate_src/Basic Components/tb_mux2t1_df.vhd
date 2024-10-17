library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


entity tb_mux2t1 is
  generic(N   : integer := 32); 
end tb_mux2t1;

architecture mixed of tb_mux2t1 is


component mux2t1 is
  port(i_D0             : in std_logic;
       i_D1               : in std_logic;
	iC		:in std_logic;
       oQ               : out std_logic);

end component mux2t1;


signal s_i_D0: std_logic := '0';
signal s_i_D1: std_logic := '0';
signal s_iC: std_logic := '0';
signal s_oQ: std_logic;


begin


  DUT0: mux2t1
  port map(
            i_D0     => s_i_D0,
             i_D1      => s_i_D1,
            iC      => s_iC ,
            oQ     => s_oQ);


  P_TEST_CASES: process
  begin

    s_i_D0   <= '0';  
    s_i_D1   <= '0';
    s_iC <= '0';
	wait for 50 ns;

       s_i_D0   <= '1';  
    s_i_D1   <= '0';
    s_iC <= '0';
	wait for 50 ns;
       s_i_D0   <= '0';  
    s_i_D1   <= '1';
    s_iC <= '0';
	wait for 50 ns;
       s_i_D0   <= '1';  
    s_i_D1   <= '1';
    s_iC <= '0';
	wait for 50 ns;
       s_i_D0   <= '0';  
    s_i_D1   <= '0';
    s_iC <= '1';
	wait for 50 ns;
       s_i_D0   <= '1'; 
    s_i_D1   <= '0';
    s_iC <= '1';
	wait for 50 ns;
       s_i_D0   <= '0'; 
    s_i_D1   <= '1';
    s_iC <= '1';
	wait for 50 ns;
       s_i_D0   <= '1'; 
    s_i_D1   <= '1';
    s_iC <= '1';
	wait for 50 ns;
  end process;

end mixed;
