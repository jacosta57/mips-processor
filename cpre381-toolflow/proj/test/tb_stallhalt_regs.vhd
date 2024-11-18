library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_stallhalt_regs is
generic(gCLK_HPER   : time := 50 ns);
end tb_stallhalt_regs;

architecture mixed of tb_stallhalt_regs is

constant cCLK_PER  : time := gCLK_HPER * 2;
signal s_CLK : STD_LOGIC;

component IF_ID_Reg is
  generic(N : integer := 32); 
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_PC          : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_Inst          : in std_logic_vector(N-1 downto 0);
      i_Flush         :in std_logic;
      i_Stall        :in std_logic;
       o_PC          : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_Inst          : out std_logic_vector(N-1 downto 0));
end component;

component ID_EX_Reg is
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
      i_Flush         :in std_logic;
      i_Stall        :in std_logic;
      o_JAL :out std_logic;
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
end component;

component EX_MEM_Reg is
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
end component;

component MEM_WB_Reg is
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
end component;

signal s_IFID_Stall : STD_LOGIC;
signal s_IFID_Flush  : STD_LOGIC;
signal s_IDEX_Stall : STD_LOGIC;
signal s_IDEX_Flush  : STD_LOGIC;
signal s_EXMEM_Stall : STD_LOGIC;
signal s_EXMEM_Flush  : STD_LOGIC;
signal s_MEMWB_Stall : STD_LOGIC;
signal s_MEMWB_Flush  : STD_LOGIC;

signal s_RegOut1 : std_logic_vector(31 downto 0);--Carry the first value read from the regfile
signal s_RegOut2 : std_logic_vector(31 downto 0);--Carry the second value read from the regfile
signal s_Mux_Reg_Mem : std_logic_vector(31 downto 0);
signal  s_WB_ALUOut : std_logic_vector(31 downto 0);
signal  s_DMemOut : std_logic_vector(31 downto 0);
signal s_RegWr : std_logic;
signal  s_RegWrAddr : std_logic_vector(4 downto 0);
--Signals for ALU input and outputs
signal s_Imm_SignExt : std_logic_vector(31 downto 0);
signal s_Mux_ALU : std_logic_vector(31 downto 0);
signal s_ALU_Result : std_logic_vector(31 downto 0);
signal s_ALU_Ovfl :std_logic;

--Signals For Control Module and ALU Control
signal s_RegDest : std_logic; --Signal to act as the control signal for the mux that decides which bits in the instruction are the address for the destination
signal s_Jump : std_logic;
signal s_Jump_Return: std_logic;
signal s_jal : std_logic;
signal s_zero_extend : std_logic;
signal s_Branch : std_logic;
signal s_MemRead : std_logic;
signal s_RegAddr_JalAddr: std_logic;
signal s_MemtoReg : std_logic;
signal s_ALUOp : std_logic_vector(1 downto 0);
signal s_ALUSrc : std_logic;
signal s_ALUOut : std_logic_vector(31 downto 0);
signal s_DMemWr : std_logic;

signal s_ALU_Zero : std_logic;
signal s_ALU_Operation : std_logic_vector (3 downto 0);
signal s_RST : std_logic;
signal s_PC_plus_4 : std_logic_vector(31 downto 0);
signal s_Inst : std_logic_vector(31 downto 0);
--Signals to carry data through ID stage
signal s_ID_PC : std_logic_vector(31 downto 0);
signal s_ID_Inst : std_logic_vector(31 downto 0);
signal s_ID_Halt : std_logic;
signal s_ID_DMemWr : std_logic;
signal s_ID_RegWr : std_logic;
--Signals to carry data through EX Stage
signal s_EX_Imm : std_logic_vector(31 downto 0);
signal s_EX_Halt : std_logic;
signal s_EX_RegWr : std_logic;
signal s_EX_MemtoReg : std_logic;
signal s_EX_BranchEn : std_logic;
signal s_EX_MemWr : std_logic;
signal s_EX_ALUSrc : std_logic;
signal s_EX_PC : std_logic_vector(31 downto 0);
signal s_EX_RegData0 : std_logic_vector(31 downto 0);
signal s_EX_RegData1 : std_logic_vector(31 downto 0);
signal s_EX_AddrRd : std_logic_vector(4 downto 0);
signal s_EX_AddrRt : std_logic_vector(4 downto 0);
signal s_EX_ALUOp : std_logic_vector(1 downto 0);
signal s_EX_RegDst : std_logic;
signal s_EX_InstOp : std_logic_vector(5 downto 0);
signal s_EX_JAL : std_logic;
signal s_EX_Ovfl : std_logic;
signal s_EX_RegWrAddr : std_logic_vector(4 downto 0);
--Signals to carry data through MEM Stage
signal s_MEM_Branch_En, s_MEM_ALU_Zero, s_Fetch_Branch_En : std_logic;
signal s_MEM_Imm : std_logic_vector(31 downto 0);
signal s_MEM_Halt : std_logic;
signal s_MEM_RegWr : std_logic;
signal s_MEM_MemtoReg : std_logic;
signal s_MEM_BranchEn : std_logic;
signal s_MEM_WrAddr : std_logic_vector(4 downto 0);
signal s_MEM_PC : std_logic_vector(31 downto 0);
signal s_MEM_JAL : std_logic;
signal s_MEM_Ovfl : std_logic;
signal s_MEM_ALUOut : std_logic_vector(31 downto 0);
signal s_MEM_RegData1 : std_logic_vector(31 downto 0);
signal s_MEM_ALUZero : std_logic;
--Signals to carry data through WB Stage
signal s_WB_RegWr : std_logic;
signal  s_WB_RegWrData: std_logic_vector(31 downto 0);
signal s_WB_RegWrAddr : std_logic_vector(4 downto 0);
signal s_WB_Halt : std_logic;
signal s_WB_MemtoReg : std_logic;
signal s_WB_Regdst : std_logic_vector(4 downto 0);
signal s_WB_PC : std_logic_vector(31 downto 0);
signal s_WB_JAL : std_logic;
signal s_WB_Ovfl : std_logic;
signal s_WB_ALUResult : std_logic_vector(31 downto 0);
signal s_WB_MemData : std_logic_vector(31 downto 0);

begin
P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

    IF_ID_Reg_Inst: IF_ID_Reg
     port map(
        i_CLK => s_CLK,
        i_RST => s_RST,
        i_PC => s_PC_plus_4,
        i_Inst => s_Inst,
        i_Stall => s_IFID_Stall,
        i_Flush => s_IFID_Flush,
        o_PC => s_ID_PC,
        o_Inst => s_ID_Inst
    );
ID_EX_Reg_inst: ID_EX_Reg
 port map(
    i_CLK => s_CLK,
    i_RST => s_RST,
    i_RegWr => s_ID_RegWr,
    i_MemtoReg => s_MemtoReg,
    i_BranchEn => s_Branch,
    i_MemWr => s_ID_DMemWr,
    i_ALUSrc => s_ALUSrc,
    i_ALUOp => s_ALUOp,
    i_RegDst => s_RegDest,
    i_InstOp => s_ID_Inst(31 downto 26),
    i_PC => s_ID_PC,
    i_RegData0 => s_RegOut1,
    i_RegData1 => s_RegOut2,
    i_imm => s_Imm_SignExt,
    i_AddrRd => s_ID_Inst(15 downto 11),
    i_AddrRt => s_ID_Inst(20 downto 16),
    i_JAL => s_jal,
    i_halt => s_ID_Halt,
        i_Stall => s_IDEX_Stall,
        i_Flush => s_IDEX_Flush,
    o_JAL => s_EX_JAL,
    o_halt => s_EX_halt,
    o_RegWr => s_EX_RegWr,
    o_MemtoReg => s_EX_MemtoReg,
    o_BranchEn => s_EX_BranchEn,
    o_MemWr => s_EX_MemWr,
    o_ALUSrc => s_EX_ALUSrc,
    o_PC => s_EX_PC,
    o_RegData0 => s_EX_RegData0,
    o_RegData1 => s_EX_RegData1,
    o_imm => s_EX_imm,
    o_AddrRd => s_EX_AddrRd,
    o_AddrRt => s_EX_AddrRt,
    o_ALUOp => s_EX_ALUOp,
    o_RegDst => s_EX_RegDst,
    o_InstOp => s_EX_InstOp
);
EX_MEM_Reg_inst: EX_MEM_Reg
 port map(
    i_CLK => s_CLK,
    i_RST => s_RST,
    i_RegWr => s_EX_RegWr,
    i_MemtoReg => s_EX_MemtoReg,
    i_BranchEn =>s_EX_BranchEn,
    i_MemWr => s_EX_MemWr,
    i_WrAddr => s_EX_RegWrAddr,
    i_PC => s_EX_PC,
    i_Halt => s_EX_Halt,
    i_Ovfl => s_ALU_Ovfl,
    i_JAL => s_EX_JAL,
    i_ALUZero => s_ALU_Zero,
    i_MemData => s_EX_RegData1,
    i_ALUOut => s_ALUOut,
        i_Stall => s_EXMEM_Stall,
        i_Flush => s_EXMEM_Flush,
    o_ALUOut => s_MEM_ALUOut,
    o_MemData => s_MEM_RegData1,
    o_ALUZero => s_MEM_ALUZero,
    o_JAL => s_MEM_JAL,
    o_PC => s_MEM_PC,
    o_RegWr => s_MEM_RegWr,
    o_MemtoReg => s_MEM_MemtoReg,
    o_BranchEn => s_MEM_BranchEn,
    o_MemWr => s_DMemWr,
    o_WrAddr => s_MEM_WrAddr,
    o_Ovfl => s_MEM_Ovfl,
    o_Halt => s_MEM_Halt
);
MEM_WB_Reg_inst: MEM_WB_Reg
 port map(
    i_CLK => s_CLK,
    i_RST => s_RST,
    i_RegWr => s_MEM_RegWr,
    i_MemtoReg => s_MEM_MemtoReg,
    i_ALUResult => s_MEM_ALUOut,
    i_MemData => s_DMemOut,
    i_RegDst => s_MEM_WrAddr,
    i_PC => s_MEM_PC,
    i_Halt => s_MEM_Halt,
    i_Ovfl => s_MEM_Ovfl,
    i_JAL => s_MEM_JAL,
        i_Stall => s_MEMWB_Stall,
        i_Flush => s_MEMWB_Flush,
    o_JAL => s_WB_JAL,
    o_Ovfl => s_WB_Ovfl,
    o_Halt => s_WB_Halt,
    o_PC => s_WB_PC,
    o_RegWr => s_RegWr,
    o_MemtoReg => s_WB_MemtoReg,
    o_ALUResult => s_WB_ALUResult,
    o_MemData => s_WB_MemData,
    o_RegDst => s_RegWrAddr
);
  P_TEST_CASES: process
  begin
    s_RST <= '1';
    wait for cCLK_PER;

    s_RST <= '0';
    s_PC_plus_4 <= x"00000001";
    s_Inst <= x"00000001";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;

    s_RST <= '0';
    s_PC_plus_4 <= x"00000002";
    s_Inst <= x"00000002";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"00000003";
    s_Inst <= x"00000003";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"00000004";
    s_Inst <= x"00000004";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"00000005";
    s_Inst <= x"00000005";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '1';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"00000006";
    s_Inst <= x"00000006";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '1';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"00000007";
    s_Inst <= x"00000007";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '1';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"00000008";
    s_Inst <= x"00000008";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '1';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"00000009";
    s_Inst <= x"00000009";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '1';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"0000000a";
    s_Inst <= x"0000000a";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '1';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"0000000b";
    s_Inst <= x"0000000b";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '1';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"0000000c";
    s_Inst <= x"0000000c";
s_IFID_Stall <= '1';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
    
    s_RST <= '0';
    s_PC_plus_4 <= x"0000000d";
    s_Inst <= x"0000000d";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '1';
    wait for cCLK_PER;

    s_RST <= '0';
    s_PC_plus_4 <= x"0000000e";
    s_Inst <= x"0000000e";
s_IFID_Stall <= '0';
s_IFID_Flush  <= '0';
s_IDEX_Stall <= '0';
s_IDEX_Flush  <= '0';
s_EXMEM_Stall <= '0';
s_EXMEM_Flush  <= '0';
s_MEMWB_Stall <= '0';
s_MEMWB_Flush  <= '0';
    wait for cCLK_PER;
  end process;

end mixed;
