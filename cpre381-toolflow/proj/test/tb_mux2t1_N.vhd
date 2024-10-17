library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O


entity tb_mux2t1_N is
  generic(N   : integer := 16);   
end tb_mux2t1_N;

architecture mixed of tb_mux2t1_N is



component mux2t1_N is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic_vector(N-1 downto 0);
         i_D1                 : in std_logic_vector(N-1 downto 0);
         o_O                  : out std_logic_vector(N-1 downto 0));

  end component mux2t1_N;



signal s_i_D0: std_logic_vector(N-1 downto 0) := x"0000";
signal s_i_D1: std_logic_vector(N-1 downto 0) := x"0000";
signal s_S: std_logic := '0';
signal s_O: std_logic_vector(N-1 downto 0);


begin

 
  DUT0: mux2t1_N
  port map(
            i_D0     => s_i_D0,
             i_D1      => s_i_D1,
            i_S      => s_S ,
            o_O     => s_O);
 
  P_TEST_CASES: process
  begin
  
    s_i_D0   <= x"0000"; 
    s_i_D1   <= x"0000";
    s_S <= '0';
	wait for 50 ns;
       s_i_D0   <= x"1111"; 
    s_i_D1   <= x"0000";
    s_S <= '0';
	wait for 50 ns;
       s_i_D0   <= x"0000"; 
    s_i_D1   <= x"1111";
    s_S <= '0';
	wait for 50 ns;
       s_i_D0   <= x"0000"; 
    s_i_D1   <= x"1111";
    s_S <= '1';
	wait for 50 ns;
       s_i_D0   <= x"1111"; 
    s_i_D1   <= x"0000";
    s_S <= '1';
  end process;

end mixed;
