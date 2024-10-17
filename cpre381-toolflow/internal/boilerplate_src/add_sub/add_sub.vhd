-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------


-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all; 

entity add_sub is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(N-1 downto 0);
	i_D1         : in std_logic_vector(N-1 downto 0);
	i_imm         : in std_logic_vector(N-1 downto 0);
	nAdd_Sub         : in std_logic;
	ALUSrc         : in std_logic;
       o_S          : out std_logic_vector(N-1 downto 0));

end add_sub;

architecture structure of add_sub is


 component mux2t1_N
    port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

   component n_adder
    port(i_D0         : in std_logic_vector(N-1 downto 0);
	i_D1         : in std_logic_vector(N-1 downto 0);
	i_C         : in std_logic;
       o_C          : out std_logic;
       o_S          : out std_logic_vector(N-1 downto 0));
  end component;

   component onescomp
    port(i_A         : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));

  end component;

signal adder_0_o         : std_logic_vector(N-1 downto 0);
signal adder_1_o         : std_logic_vector(N-1 downto 0);
signal adder_2_o         : std_logic_vector(N-1 downto 0);
signal onescomp_0         : std_logic_vector(N-1 downto 0);
signal mux_1         : std_logic_vector(N-1 downto 0);


begin

adder_0: n_adder
    port MAP(i_D0               => i_D0,
		i_D1               => mux_1,
	     i_C     =>		'0',
		o_S		=> adder_0_o);

adder_1: n_adder
    port MAP(i_D0               => onescomp_0,
		i_D1               => x"00000000",
	     i_C     =>		'1',
		o_S		=> adder_1_o);

adder_2: n_adder
    port MAP(i_D0               => i_D0,
		i_D1               => adder_1_o,
	     i_C     =>		'0',
		o_S		=> adder_2_o);

onecomp:onescomp
	port MAP( i_A=> mux_1,
		o_F   => onescomp_0);

mux_op: mux2t1_N
    port MAP(i_S               => nAdd_Sub,
	     i_D0     =>		adder_0_o,
		i_D1     =>		adder_2_o,
		o_O		=> o_S);

mux_ALU: mux2t1_N
    port MAP(i_S               => ALUSrc,
	     i_D0     =>		i_D1,
		i_D1     =>		i_imm,
		o_O		=> mux_1);


end structure;
