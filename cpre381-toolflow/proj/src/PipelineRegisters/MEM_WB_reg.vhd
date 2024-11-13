-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- MEM_WB_Reg.vhd
-------------------------------------------------------------------------
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity MEM_WB_Reg is
  generic(N : integer := 32); 
  port(i_CLK        : in std_logic; 
       i_RST        : in std_logic;   
       i_RegWr          : in std_logic; 
       i_MemtoReg          : in std_logic;
       i_ALUResult          : in std_logic_vector(N-1 downto 0);
       i_MemData          : in std_logic_vector(N-1 downto 0);
       i_RegDst          : in std_logic_vector(4 downto 0);
       i_PC          : in std_logic_vector(N-1 downto 0);

      i_Flush         :in std_logic;
      i_Stall        :in std_logic;
      i_Halt          :in std_logic;
      i_Ovfl          :in std_logic;
      i_JAL : in std_logic;
      o_JAL :out std_logic;
      o_Ovfl          :out std_logic;
      o_Halt          :out std_logic;
       o_PC          : out std_logic_vector(N-1 downto 0); 
       o_RegWr          : out std_logic;  
       o_MemtoReg          : out std_logic;
       o_ALUResult          : out std_logic_vector(N-1 downto 0); 
       o_MemData          : out std_logic_vector(N-1 downto 0);
       o_RegDst          : out std_logic_vector(4 downto 0)

       );

end MEM_WB_Reg;
architecture structural of MEM_WB_Reg is

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
      i_we : in std_logic;
      o_JAL :out std_logic;
      o_Ovfl          :out std_logic;
      o_Halt          :out std_logic;
       o_RegWr          : out std_logic;   -- Data value output
       o_MemtoReg          : out std_logic);
  end component;

  signal s_we : STD_LOGIC;
  signal s_RST : STD_LOGIC;
begin
  process(i_Stall, i_Flush, i_RST)
  begin
  s_we <= '1' XOR i_Stall;
  s_RST <= i_RST OR i_Flush;
end process;

  WB_Reg_inst: WB_Reg
   port map(
      i_CLK => i_CLK,
      i_RST => s_RST,
      i_RegWr => i_RegWr,
      i_MemtoReg => i_MemtoReg,
      i_JAL => i_JAL,
      i_Ovfl => i_Ovfl,
      i_halt => i_halt,
      i_we => s_we,
      o_JAL => o_JAL,
      o_Ovfl => o_Ovfl,
      o_halt => o_halt,
      o_RegWr => o_RegWr,
      o_MemtoReg => o_MemtoReg
  );

ALUResult_Reg: n_reg
 port map(
    i_CLK => i_CLK,
    i_RST => s_RST,
    i_WE => s_we,
    i_D => i_ALUResult,
    o_Q => o_ALUResult
);

RegDst_Reg: n_reg
generic map(
  N => 5
)
 port map(
    i_CLK => i_CLK,
    i_RST => s_RST,
    i_WE => s_we,
    i_D => i_RegDst,
    o_Q => o_RegDst
);

MemData_Reg: n_reg
generic map(
  N => 32
)
 port map(
    i_CLK => i_CLK,
    i_RST => s_RST,
    i_WE => s_we,
    i_D => i_MemData,
    o_Q => o_MemData
);
PC_Reg: n_reg
 port map(
    i_CLK => i_CLK,
    i_RST => s_RST,
    i_WE => s_we,
    i_D => i_PC,
    o_Q => o_PC
);
end structural;
