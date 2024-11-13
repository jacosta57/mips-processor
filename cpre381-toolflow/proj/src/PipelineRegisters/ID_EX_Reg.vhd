-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- ID_EX_Reg.vhd
-------------------------------------------------------------------------
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ID_EX_Reg is
  generic(N : integer := 32); 
  port(i_CLK        : in std_logic; 
       i_RST        : in std_logic;   
       i_RegWr          : in std_logic;
       i_MemtoReg          : in std_logic;
       i_BranchEn          : in std_logic; 
       i_MemWr          : in std_logic;
       i_ALUSrc          : in std_logic;   
       i_ALUOp          : in std_logic_vector(1 downto 0);
       i_RegDst          : in std_logic;
       i_InstOp          : in std_logic_vector(5 downto 0);
       i_PC          : in std_logic_vector(N-1 downto 0);
       i_RegData0          : in std_logic_vector(N-1 downto 0);
       i_RegData1          : in std_logic_vector(N-1 downto 0);
       i_imm          : in std_logic_vector(N-1 downto 0);
       i_AddrRd          : in std_logic_vector(4 downto 0);
       i_AddrRt          : in std_logic_vector(4 downto 0);
       i_halt           : in std_logic;
      i_JAL : in std_logic;
      i_Ovfl          :in std_logic;
      o_JAL :out std_logic;
      o_Ovfl          :out std_logic;
      o_halt            :out std_logic;
       o_RegWr          : out std_logic;  
       o_MemtoReg          : out std_logic;
       o_BranchEn          : out std_logic;
       o_MemWr          : out std_logic;
       o_ALUSrc          : out std_logic;  
       o_PC          : out std_logic_vector(N-1 downto 0); 
       o_RegData0          : out std_logic_vector(N-1 downto 0); 
       o_RegData1          : out std_logic_vector(N-1 downto 0); 
       o_imm          : out std_logic_vector(N-1 downto 0);
       o_AddrRd          : out std_logic_vector(4 downto 0);
       o_AddrRt          : out std_logic_vector(4 downto 0);

       o_ALUOp          : out std_logic_vector(1 downto 0);
       o_RegDst          : out std_logic;
       o_InstOp          : out std_logic_vector(5 downto 0)
       );

end ID_EX_Reg;
architecture structural of ID_EX_Reg is

  component  n_reg is
    generic(N : integer := 32);
    port(i_CLK        : in std_logic;  
         i_RST        : in std_logic;  
         i_WE         : in std_logic;  
         i_D          : in std_logic_vector(N-1 downto 0);    
         o_Q          : out std_logic_vector(N-1 downto 0));  
  end component;  

  component WB_Reg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_RegWr          : in std_logic;     -- Data value input
       i_MemtoReg          : in std_logic;
      i_Halt          :in std_logic;
      i_Ovfl          :in std_logic;
      i_JAL : in std_logic;
      o_JAL :out std_logic;
      o_Ovfl          :out std_logic;
      o_Halt          :out std_logic;
       o_RegWr          : out std_logic;   -- Data value output
       o_MemtoReg          : out std_logic);

  end component;

  component MEM_Reg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_BranchEn          : in std_logic;     -- Data value input
       i_MemWr          : in std_logic;
       o_BranchEn          : out std_logic;
       o_MemWr          : out std_logic);

  
  end component;

  component EX_Reg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_ALUSrc          : in std_logic;     -- Data value input
       i_ALUOp          : in std_logic_vector(1 downto 0);
       i_RegDst          : in std_logic;
       i_InstOp          : in std_logic_vector(5 downto 0);
       o_ALUSrc          : out std_logic;     -- Data value input
       o_ALUOp          : out std_logic_vector(1 downto 0);
       o_RegDst          : out std_logic;
       o_InstOp          : out std_logic_vector(5 downto 0));
  
  end component;
signal s_we : STD_LOGIC;

begin
 
  s_we <= '1';

  WB_Reg_inst: WB_Reg
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_RegWr => i_RegWr,
      i_MemtoReg => i_MemtoReg,
      i_JAL => i_JAL,
      i_Ovfl => i_Ovfl,
      i_halt => i_halt,
      o_JAL => o_JAL,
      o_Ovfl => o_Ovfl,
      o_halt => o_halt,
      o_RegWr => o_RegWr,
      o_MemtoReg => o_MemtoReg
  );

  EX_Reg_inst: EX_Reg
   port map(
      i_CLK => i_CLK,
      i_RST => i_RST,
      i_ALUSrc => i_ALUSrc,
      i_ALUOp => i_ALUOp,
      i_RegDst => i_RegDst,
      i_InstOp => i_InstOp,
      o_ALUSrc => o_ALUSrc,
      o_ALUOp => o_ALUOp,
      o_RegDst => o_RegDst,
      o_InstOp => o_InstOp
  );

MEM_Reg_inst: MEM_Reg
 port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_BranchEn => i_BranchEn,
    i_MemWr => i_MemWr,
    o_BranchEn => o_BranchEn,
    o_MemWr => o_MemWr
);

PC_Reg: n_reg
 port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => s_we,
    i_D => i_PC,
    o_Q => o_PC
);

Read0_Reg: n_reg
 port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => s_we,
    i_D => i_RegData0,
    o_Q => o_RegData0
);

Read1_Reg: n_reg
 port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => s_we,
    i_D => i_RegData1,
    o_Q => o_RegData1
);

Imm_Reg: n_reg
 port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => s_we,
    i_D => i_imm,
    o_Q => o_imm
);

AddrRd_Reg: n_reg
generic map(
  N => 5
)
 port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => s_we,
    i_D => i_AddrRd,
    o_Q => o_AddrRd
);

AddrRt_Reg: n_reg
generic map(
  N => 5
)
 port map(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => s_we,
    i_D => i_AddrRt,
    o_Q => o_AddrRt
);
end structural;
