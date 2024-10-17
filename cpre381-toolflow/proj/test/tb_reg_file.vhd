library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_reg_file is
generic(gCLK_HPER   : time := 50 ns);
end tb_reg_file;

architecture mixed of tb_reg_file is

constant cCLK_PER  : time := gCLK_HPER * 2;

component reg_file is
	port(iCLK                         : in std_logic;
       read_A0 		            : in std_logic_vector(4 downto 0);
       read_A1 		            : in std_logic_vector(4 downto 0);
       write_A 		            : in std_logic_vector(4 downto 0);
       write_en                     : in std_logic;
       write_val		    : in std_logic_vector(31 downto 0);
       reset			    :in std_logic;
       read_out0 		    : out std_logic_vector(31 downto 0);
       read_out1 		    : out std_logic_vector(31 downto 0));
	end component reg_file;

	signal s_CLK                         : std_logic;
       signal s_read_A0 		            : std_logic_vector(4 downto 0);
       signal s_read_A1 		            :std_logic_vector(4 downto 0);
       signal s_write_A 		            :std_logic_vector(4 downto 0);
       signal s_write_en                     : std_logic;
       signal s_write_val		    : std_logic_vector(31 downto 0);
       signal s_reset			    :std_logic;
       signal s_read_out0 		    : std_logic_vector(31 downto 0);
       signal s_read_out1 		    : std_logic_vector(31 downto 0);

begin

   DUT0: reg_file
  port map(iCLk  => s_CLK,
	read_A0 => s_read_A0,
	read_A1  => s_read_A1,
	write_A  => s_write_A,
	write_en   => s_write_en,
	write_val  => s_write_val,
	reset   => s_reset,
	read_out0  => s_read_out0,
	read_out1  => s_read_out1);

P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  P_TEST_CASES: process
  begin
	s_read_A0 <= "00000";
       s_read_A1 	<= "00000";    
       s_write_A  <= "00000";        
       s_write_en <= '0';               
       s_write_val <= x"00000000";	 
       s_reset	 <= '1';	
    wait for cCLK_PER;

	s_read_A0 <= "00000";
       s_read_A1 	<= "00000";    
       s_write_A  <= "00000";        
       s_write_en <= '1';               
       s_write_val <= x"11111111";	 
       s_reset	 <= '0';	
    wait for cCLK_PER;

	s_read_A0 <= "00010";
       s_read_A1 	<= "00000";    
       s_write_A  <= "00010";        
       s_write_en <= '1';               
       s_write_val <= x"12345678";	 
       s_reset	 <= '0';	
    wait for cCLK_PER;

	s_read_A0 <= "00010";
       s_read_A1 	<= "00011";    
       s_write_A  <= "00011";        
       s_write_en <= '1';               
       s_write_val <= x"11111111";	 
       s_reset	 <= '0';	
    wait for cCLK_PER;

	s_read_A0 <= "00011";
       s_read_A1 	<= "00010";    
       s_write_A  <= "00010";        
       s_write_en <= '1';               
       s_write_val <= x"11111111";	 
       s_reset	 <= '0';	
    wait for cCLK_PER;

   
  end process;

end mixed;