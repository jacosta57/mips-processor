-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- EX_MEM_Reg.vhd
-------------------------------------------------------------------------
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity EX_MEM_Reg is
  generic(N : integer := 32); 
  port(i_CLK        : in std_logic; 
       i_RST        : in std_logic;   
       i_RegWr          : in std_logic;
       i_MemtoReg          : in std_logic;
       i_BranchEn          : in std_logic; 
       i_MemWr          : in std_logic;
       i_WrAddr          : in std_logic_vector(4 downto 0);
       i_PC          : in std_logic_vector(N-1 downto 0);
      i_Halt          :in std_logic;
      i_Ovfl          :in std_logic;
       i_MEMData          : in std_logic_vector(N-1 downto 0);
      i_ALUZero          :in std_logic;
      i_Flush         :in std_logic;
      i_Stall        :in std_logic;

       i_ALUOut          : in std_logic_vector(N-1 downto 0);
      i_JAL : in std_logic;
      o_JAL :out std_logic;
       o_PC          : out std_logic_vector(N-1 downto 0); 

       o_ALUOut          : out std_logic_vector(N-1 downto 0);
       o_RegWr          : out std_logic;  
       o_MemtoReg          : out std_logic;
       o_BranchEn          : out std_logic;
       o_MemWr          : out std_logic;
       o_WrAddr          : out std_logic_vector(4 downto 0);
      o_Ovfl          :out std_logic;
      o_Halt          :out std_logic;
       o_MEMData          : out std_logic_vector(N-1 downto 0);
      o_ALUZero          :out std_logic
       );

end EX_MEM_Reg;
architecture structural of EX_MEM_Reg is

  component  n_reg is
    generic(N : integer := 32);
    port(i_CLK        : in std_logic;  
         i_RST        : in std_logic;  
         i_WE         : in std_logic;  
         i_D          : in std_logic_vector(N-1 downto 0);    
         o_Q          : out std_logic_vector(N-1 downto 0));  
  end component;  
  
  component  dffg is
    port(i_CLK        : in std_logic;  
         i_RST        : in std_logic;  
         i_WE         : in std_logic;  
         i_D          : in std_logic;    
         o_Q          : out std_logic);  
  end component;  

  component WB_Reg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_RegWr          : in std_logic;     -- Data value input
       i_MemtoReg          : in std_logic;
      i_Halt          :in std_logic;
      i_Ovfl          :in std_logic;
      i_JAL : in std_logic;
      i_we : in std_logic;
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
      i_we          : in std_logic;
       o_BranchEn          : out std_logic;
       o_MemWr          : out std_logic);
  
  end component;

signal s_we : STD_LOGIC;
signal s_RST : STD_Logic;
begin
  process(i_Stall, i_Flush)
  begin
  s_we <= '1' XOR i_Stall;
  s_RST <= i_RST OR i_Flush;
end process;
  WB_Reg_inst: WB_Reg
   port map(
      i_CLK => i_CLK,
      i_RST => s_RST,
      i_RegWr => i_RegWr,
      i_Ovfl => i_Ovfl,
      i_Halt => i_Halt,
      i_MemtoReg => i_MemtoReg,
      i_JAL => i_JAL,
      i_we => s_we,
      o_JAL => o_JAL,
      o_RegWr => o_RegWr,
      o_Ovfl => o_Ovfl,
      o_Halt => o_Halt,
      o_MemtoReg => o_MemtoReg
  );

MEM_Reg_inst: MEM_Reg
 port map(
    i_CLK => i_CLK,
    i_RST => s_RST,
    i_BranchEn => i_BranchEn,
    i_MemWr => i_MemWr,
    i_we => s_we,
    o_BranchEn => o_BranchEn,
    o_MemWr => o_MemWr
);


MemWrData_Reg: n_reg
 port map(
    i_CLK => i_CLK,
    i_RST => s_RST,
    i_WE => s_we,
    i_D => i_MemData,
    o_Q => o_MemData
);

ALUZero_Reg: dffg
 port map(
    i_CLK => i_CLK,
    i_RST => s_RST,
    i_WE => s_we,
    i_D => i_ALUZero,
    o_Q => o_ALUZero
);

WrAddr_Reg: n_reg
generic map(
  N => 5
)
 port map(
    i_CLK => i_CLK,
    i_RST => s_RST,
    i_WE => s_we,
    i_D => i_WrAddr,
    o_Q => o_WrAddr
);
PC_Reg: n_reg
 port map(
    i_CLK => i_CLK,
    i_RST => s_RST,
    i_WE => s_we,
    i_D => i_PC,
    o_Q => o_PC
);

ALUOut_Reg: n_reg
 generic map(
    N => N
)
 port map(
    i_CLK => i_CLK,
    i_RST => s_RST,
    i_WE => s_we,
    i_D => i_ALUOut,
    o_Q => o_ALUOut
);
end structural;
