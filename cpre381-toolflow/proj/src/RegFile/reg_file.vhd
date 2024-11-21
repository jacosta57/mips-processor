-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- reg_file.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity reg_file is

  port(iCLK                         : in std_logic;
       read_A0 		            : in std_logic_vector(4 downto 0);
       read_A1 		            : in std_logic_vector(4 downto 0);
       write_A 		            : in std_logic_vector(4 downto 0);
       write_en                     : in std_logic;
       write_val		    : in std_logic_vector(31 downto 0);
       reset			    :in std_logic;
       read_out0 		    : out std_logic_vector(31 downto 0);
       read_out1 		    : out std_logic_vector(31 downto 0));

end reg_file;

architecture structure of reg_file is

  component n_reg
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic_vector(31 downto 0);     -- Data value input
         o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
  end component;

  component decoder_32
     port(i_S : in std_logic_vector(4 downto 0);
	  o_Q : out std_logic_vector(31 downto 0));
  end component;

  component mux_32
    port(D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16, D17, D18, D19, D20, D21, D22, D23,D24, D25, D26, D27, D28, D29, D30, D31  : in std_logic_vector(31 downto 0);
	     i_S 	: in std_logic_vector(4 downto 0);
	     o_Q 	: out std_logic_vector(31 downto 0));
  end component;

signal sCLK : std_logic;
signal decoder_o_Q: std_logic_vector(31 downto 0);
signal s_D0, s_D1, s_D2, s_D3, s_D4, s_D5, s_D6, s_D7, s_D8, s_D9, s_D10, s_D11, s_D12, s_D13, s_D14, s_D15, s_D16, s_D17, s_D18, s_D19, s_D20, s_D21, s_D22, s_D23,s_D24, s_D25, s_D26, s_D27, s_D28, s_D29, s_D30, s_D31  : std_logic_vector(31 downto 0);
signal w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31  : std_logic;

begin

w0 <= '0';
w1 <= write_en and decoder_o_Q(1);
w2 <= write_en and decoder_o_Q(2);
w3 <= write_en and decoder_o_Q(3);
w4 <= write_en and decoder_o_Q(4);
w5 <= write_en and decoder_o_Q(5);
w6 <= write_en and decoder_o_Q(6);
w7 <= write_en and decoder_o_Q(7);
w8 <= write_en and decoder_o_Q(8);
w9 <= write_en and decoder_o_Q(9);
w10 <= write_en and decoder_o_Q(10);
w11 <= write_en and decoder_o_Q(11);
w12 <= write_en and decoder_o_Q(12);
w13 <= write_en and decoder_o_Q(13);
w14 <= write_en and decoder_o_Q(14);
w15 <= write_en and decoder_o_Q(15);
w16 <= write_en and decoder_o_Q(16);
w17 <= write_en and decoder_o_Q(17);
w18 <= write_en and decoder_o_Q(18);
w19 <= write_en and decoder_o_Q(19);
w20 <= write_en and decoder_o_Q(20);
w21 <= write_en and decoder_o_Q(21);
w22 <= write_en and decoder_o_Q(22);
w23 <= write_en and decoder_o_Q(23);
w24 <= write_en and decoder_o_Q(24);
w25 <= write_en and decoder_o_Q(25);
w26 <= write_en and decoder_o_Q(26);
w27 <= write_en and decoder_o_Q(27);
w28 <= write_en and decoder_o_Q(28);
w29 <= write_en and decoder_o_Q(29);
w30 <= write_en and decoder_o_Q(30);
w31 <= write_en and decoder_o_Q(31);

process(iCLK)
begin
    sCLK <= NOT iCLK;
end process;

  Decoder: decoder_32
    port MAP(i_S             => write_A,
	     o_Q             => decoder_o_Q);

  Reg0: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w0,
        	 i_D        => write_val,
        	 o_Q	    =>s_D0);
  Reg1: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w1,
        	 i_D        => write_val,
        	 o_Q	    =>s_D1);
  Reg2: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w2,
        	 i_D        => write_val,
        	 o_Q	    =>s_D2);
  Reg3: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w3,
        	 i_D        => write_val,
        	 o_Q	    =>s_D3);
  Reg4: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w4,
        	 i_D        => write_val,
        	 o_Q	    =>s_D4);
  Reg5: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w5,
        	 i_D        => write_val,
        	 o_Q	    =>s_D5);
  Reg6: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w6,
        	 i_D        => write_val,
        	 o_Q	    =>s_D6);
  Reg7: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w7,
        	 i_D        => write_val,
        	 o_Q	    =>s_D7);
  Reg8: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w8,
        	 i_D        => write_val,
        	 o_Q	    =>s_D8);
  Reg9: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w9,
        	 i_D        => write_val,
        	 o_Q	    =>s_D9);
Reg10: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w10,
        	 i_D        => write_val,
        	 o_Q	    =>s_D10);    
Reg11: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w11,
        	 i_D        => write_val,
        	 o_Q	    =>s_D11);
Reg12: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w12,
        	 i_D        => write_val,
        	 o_Q	    =>s_D12);
Reg13: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w13,
        	 i_D        => write_val,
        	 o_Q	    =>s_D13);
Reg14: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w14,
        	 i_D        => write_val,
        	 o_Q	    =>s_D14);
Reg15: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w15,
        	 i_D        => write_val,
        	 o_Q	    =>s_D15);
Reg16: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w16,
        	 i_D        => write_val,
        	 o_Q	    =>s_D16);
Reg17: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w17,
        	 i_D        => write_val,
        	 o_Q	    =>s_D17);
Reg18: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w18,
        	 i_D        => write_val,
        	 o_Q	    =>s_D18);
Reg19: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w19,
        	 i_D        => write_val,
        	 o_Q	    =>s_D19);
Reg20: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w20,
        	 i_D        => write_val,
        	 o_Q	    =>s_D20);
Reg21: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w21,
        	 i_D        => write_val,
        	 o_Q	    =>s_D21);
Reg22: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w22,
        	 i_D        => write_val,
        	 o_Q	    =>s_D22);
Reg23: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w23,
        	 i_D        => write_val,
        	 o_Q	    =>s_D23);
Reg24: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w24,
        	 i_D        => write_val,
        	 o_Q	    =>s_D24);
Reg25: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w25,
        	 i_D        => write_val,
        	 o_Q	    =>s_D25);
Reg26: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w26,
        	 i_D        => write_val,
        	 o_Q	    =>s_D26);
Reg27: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w27,
        	 i_D        => write_val,
        	 o_Q	    =>s_D27);
Reg28: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w28,
        	 i_D        => write_val,
        	 o_Q	    =>s_D28);
Reg29: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w29,
        	 i_D        => write_val,
        	 o_Q	    =>s_D29);
Reg30: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w30,
        	 i_D        => write_val,
        	 o_Q	    =>s_D30);
Reg31: n_reg
	port MAP(i_CLK     => sClk,
         	i_RST     =>reset,
         	i_WE       => w31,
        	 i_D        => write_val,
        	 o_Q	    =>s_D31);

Mux1: mux_32
	port MAP(D0    =>   s_D0, 
	D1    =>   s_D1, 
	D2    =>   s_D2, 
	D3    =>   s_D3, 
	D4    =>   s_D4, 
	D5    =>   s_D5, 
	D6    =>   s_D6, 
	D7    =>   s_D7, 
	D8    =>   s_D8, 
	D9    =>   s_D9, 
	D10    =>   s_D10, 
	D11    =>   s_D11, 
	D12    =>   s_D12, 
	D13    =>   s_D13, 
	D14    =>   s_D14, 
	D15    =>   s_D15, 
	D16    =>   s_D16, 
	D17    =>   s_D17, 
	D18    =>   s_D18, 
	D19    =>   s_D19, 
	D20    =>   s_D20, 
	D21    =>   s_D21, 
	D22    =>   s_D22, 
	D23    =>   s_D23,
	D24    =>   s_D24, 
	D25    =>   s_D25, 
	D26    =>   s_D26, 
	D27    =>   s_D27, 
	D28    =>   s_D28, 
	D29    =>   s_D29, 
	D30    =>   s_D30, 
	D31    =>   s_D31,
	     i_S 	=> read_A0,
	     o_Q 	=> read_out0);

Mux2: mux_32
	port MAP(D0    =>   s_D0, 
	D1    =>   s_D1, 
	D2    =>   s_D2, 
	D3    =>   s_D3, 
	D4    =>   s_D4, 
	D5    =>   s_D5, 
	D6    =>   s_D6, 
	D7    =>   s_D7, 
	D8    =>   s_D8, 
	D9    =>   s_D9, 
	D10    =>   s_D10, 
	D11    =>   s_D11, 
	D12    =>   s_D12, 
	D13    =>   s_D13, 
	D14    =>   s_D14, 
	D15    =>   s_D15, 
	D16    =>   s_D16, 
	D17    =>   s_D17, 
	D18    =>   s_D18, 
	D19    =>   s_D19, 
	D20    =>   s_D20, 
	D21    =>   s_D21, 
	D22    =>   s_D22, 
	D23    =>   s_D23,
	D24    =>   s_D24, 
	D25    =>   s_D25, 
	D26    =>   s_D26, 
	D27    =>   s_D27, 
	D28    =>   s_D28, 
	D29    =>   s_D29, 
	D30    =>   s_D30, 
	D31    =>   s_D31,
	     i_S 	=> read_A1,
	     o_Q 	=> read_out1);
  end structure;
