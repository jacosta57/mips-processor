-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

component reg_file
	port(iCLK                         : in std_logic;
       read_A0 		            : in std_logic_vector(4 downto 0);
       read_A1 		            : in std_logic_vector(4 downto 0);
       write_A 		            : in std_logic_vector(4 downto 0);
       write_en                     : in std_logic;
       write_val		    : in std_logic_vector(31 downto 0);
       reset			    :in std_logic;
       read_out0 		    : out std_logic_vector(31 downto 0);
       read_out1 		    : out std_logic_vector(31 downto 0));
end component;


component extenders 
	port ( i_imm16 : in std_logic_vector(15 downto 0);
		zero_sign_s  : in std_logic;
		o_imm32 : out std_logic_vector(31 downto 0));
end component;

component mux2t1_N 
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

component mux2t1_5 
  generic(N : integer := 5); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;

component alu 
	port (
             i_A         : in std_logic_vector(31 downto 0);
             i_B         : in std_logic_vector(31 downto 0);
             i_ALUOp     : in std_logic_vector(3 downto 0);
             i_shamt     : in std_logic_vector(4 downto 0);
             o_F         : out std_logic_vector(31 downto 0);
             o_Zero      : out std_logic;
             o_Overflow  : out std_logic);
end component;

component alu_control is
	port (
	      i_ALUOp	 :in std_logic_vector(1 downto 0);
	      i_Funct    :in std_logic_vector(5 downto 0);
	      i_InstOp    : in std_logic_vector(5 downto 0);
	      o_ALU_Operation : out std_logic_vector(3 downto 0));
end component;

component fetch_logic
    port (
        i_clk           : in  std_logic;
        i_rst           : in  std_logic;
        i_branch_en     : in  std_logic;
        i_jump_en       : in  std_logic;
        i_jr_en         : in  std_logic;
        i_branch_addr   : in  std_logic_vector(31 downto 0);
        i_pipelined_PC   : in  std_logic_vector(31 downto 0);
        i_jump_addr     : in  std_logic_vector(25 downto 0);
        i_jr_addr       : in  std_logic_vector(31 downto 0);
        o_PC            : out std_logic_vector(31 downto 0);
        o_next_inst_addr: out std_logic_vector(31 downto 0)
   );
end component;

component control_logic is
       port (
           i_opcode    : in  std_logic_vector(5 downto 0);
           i_funct     : in  std_logic_vector(5 downto 0);
           i_reset    : in std_logic;
           o_RegDst    : out std_logic;
           o_Jump      : out std_logic;
           o_JumpReturn      : out std_logic;
           o_Jal       : out std_logic;
           o_Branch    : out std_logic;
           o_Zero_Extend : out std_logic;
           o_MemRead   : out std_logic;
           o_MemtoReg  : out std_logic;
           o_ALUOp     : out std_logic_vector(1 downto 0);
           o_MemWrite  : out std_logic;
           o_ALUSrc    : out std_logic;
           o_RegWrite  : out std_logic;
           o_Halt      : out std_logic
       );
   end component;

component forwarding_logic is
  port(i_MEM_RegWr  :   in std_logic;
    i_WB_RegWr  :in std_logic;
    i_MEM_RegDst    :   in std_logic_vector(4 downto 0);
    i_WB_RegDst    :   in std_logic_vector(4 downto 0);
    i_Rs            : in std_logic_vector(4 downto 0);
    i_Rt            : in std_logic_vector(4 downto 0);
    o_Mux0_s        : out std_logic_vector(1 downto 0);
    o_Mux1_s        : out std_logic_vector(1 downto 0));
end component;

component mux3t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic_vector(1 downto 0);
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       i_D2         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

component IF_ID_Reg is
  generic(N : integer := 32); 
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_PC          : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_Inst          : in std_logic_vector(N-1 downto 0);
      i_Flush         :in std_logic;
      i_Stall        :in std_logic;
       o_PC          : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_Inst          : out std_logic_vector(N-1 downto 0)
     );
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
       i_AddrRs          : in std_logic_vector(4 downto 0);
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
       o_AddrRs          : out std_logic_vector(4 downto 0);
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

component branch_logic is
  port (
      i_Branch    : in std_logic;
      i_Opcode    : in std_logic_vector(5 downto 0);
      i_RegData1  : in std_logic_vector(31 downto 0);
      i_RegData2  : in std_logic_vector(31 downto 0);
      o_Branch_Take : out std_logic);
end component;

component hazard_detection is
  port(
      i_Branch      : in std_logic;
      i_Jump        : in std_logic;
      i_JumpReg     : in std_logic;
      i_Branch_Take : in std_logic;
      o_IF_Flush    : out std_logic;
      o_IF_ID_Flush : out std_logic);
end component;

--Signals for the data controlling the regFile and the data coming out of it
signal s_Mux_RegDest : std_logic_vector(4 downto 0);--Output of the mux that selects which address to write to
signal s_RegOut1 : std_logic_vector(31 downto 0);--Carry the first value read from the regfile
signal s_RegOut2 : std_logic_vector(31 downto 0);--Carry the second value read from the regfile
signal s_Mux_Reg_Mem : std_logic_vector(31 downto 0);
signal s_ALU_Mux_O_0 : std_logic_vector(31 downto 0);
signal s_ALU_Mux_O_1 : std_logic_vector(31 downto 0);


--Signals for ALU input and outputs
signal s_Imm_SignExt : std_logic_vector(31 downto 0);
signal s_Mux_ALU : std_logic_vector(31 downto 0);
signal s_ALU_Result : std_logic_vector(31 downto 0);
signal s_ALU_Ovfl :std_logic;
signal s_ALU_Mux_S_0 : std_logic_vector(1 downto 0);
signal s_ALU_Mux_S_1 : std_logic_vector(1 downto 0);

--Signals For Control Module and ALU Control
signal s_RegDest : std_logic; --Signal to act as the control signal for the mux that decides which bits in the instruction are the address for the destination
signal s_Jump : std_logic;
signal s_Jump_Return: std_logic;
signal s_jal : std_logic;
signal s_zero_extend : std_logic;
signal s_NOT_zero_extend : std_logic;
signal s_Branch : std_logic;
signal s_MemRead : std_logic;
signal s_RegAddr_JalAddr: std_logic;
signal s_MemtoReg : std_logic;
signal s_ALUOp : std_logic_vector(1 downto 0);
signal s_ALUSrc : std_logic;
signal s_ALU_Zero : std_logic;
signal s_ALU_Operation : std_logic_vector (3 downto 0);

--Signals for branch and jump instructions
signal s_Branch_Shift : std_logic_vector(31 downto 0);
signal s_Branch_Adder : std_logic_vector(31 downto 0);
signal s_Branch_Mux : std_logic_vector(31 downto 0);
signal s_Branch_en : std_logic;
signal s_Jump_Shift_In : std_logic_vector(31 downto 0);
signal s_Jump_Shift_Out : std_logic_vector(31 downto 0);
signal s_Jump_Addr : std_logic_vector(31 downto 0);
signal s_Jump_Mux : std_logic_vector(31 downto 0);


--Signals for the PC register
signal s_PC_In : std_logic_vector(31 downto 0);
signal s_PC_Out : std_logic_vector(31 downto 0);
signal s_PC_plus_4 : std_logic_vector(31 downto 0);
signal s_PC_Adder : std_logic_vector(31 downto 0);
signal s_IF_Flush  : std_logic;

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
signal s_EX_AddrRs : std_logic_vector(4 downto 0);
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
signal s_WB_Halt : std_logic;
signal s_WB_MemtoReg : std_logic;
signal s_WB_PC : std_logic_vector(31 downto 0);
signal s_WB_JAL : std_logic;
signal s_WB_Ovfl : std_logic;
signal s_WB_ALUResult : std_logic_vector(31 downto 0);
signal s_WB_MemData : std_logic_vector(31 downto 0);


signal s_IFID_Stall : STD_LOGIC :='0';
signal s_IFID_Flush  : STD_LOGIC :='0';
signal s_IDEX_Stall : STD_LOGIC :='0';
signal s_IDEX_Flush  : STD_LOGIC :='0';
signal s_EXMEM_Stall : STD_LOGIC :='0';
signal s_EXMEM_Flush  : STD_LOGIC :='0';
signal s_MEMWB_Stall : STD_LOGIC :='0';
signal s_MEMWB_Flush  : STD_LOGIC :='0';
signal muxtemp : std_logic_vector(4 downto 0);

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Implement the rest of your processor below this comment! 


--IF Stage
fetch_component: fetch_logic
port map(
       i_clk 		=> iCLK,
       i_rst 		=> iRST,
       i_branch_en 	=> s_Fetch_Branch_En,
       i_jump_en	=> s_Jump,
       i_jr_en 		=> s_Jump_Return,
       i_branch_addr 	=> s_MEM_Imm,
       i_jump_addr 	=> s_Inst(25 downto 0),
       i_jr_addr 	=> s_RegOut1,
       i_pipelined_PC => s_MEM_PC,
       o_PC 		=> s_NextInstAddr,
       o_next_inst_addr => s_PC_plus_4);

    IF_ID_Reg_Inst: IF_ID_Reg
     generic map(
        N => N
    )
     port map(
        i_CLK => iCLK,
        i_RST => iRST,
        i_PC => s_PC_plus_4,
        i_Inst => s_Inst,
        i_Stall => s_IFID_Stall,
        i_Flush => s_IFID_Flush,
        o_PC => s_ID_PC,
        o_Inst => s_ID_Inst
    );
    
--ID Stage
regFile: reg_file
port map(iCLK        => iCLK,                 
       read_A0 	  => s_ID_Inst(25 downto 21),            
       read_A1 	 => s_ID_Inst(20 downto 16),    
       write_A   => s_RegWrAddr,    
       write_en  => s_RegWr,                 
       write_val => s_RegWrData,
       reset	 => iRST,
       read_out0  => s_RegOut1,
       read_out1  => s_RegOut2);
s_NOT_zero_extend <= NOT s_zero_extend;

imm_SignExtend: extenders
port map(i_imm16 => s_ID_Inst(15 downto 0),
	zero_sign_s => s_NOT_zero_extend,
	o_imm32 => s_Imm_SignExt);

control_component: control_logic
    port map(
        i_opcode   => s_ID_Inst(31 downto 26),
        i_funct    => s_ID_Inst(5 downto 0),
        i_reset   =>  iRST, 
        o_RegDst   => s_RegDest,
        o_Jump     => s_Jump,
        o_Jal      => s_jal,
        o_JumpReturn => s_Jump_Return,
        o_Zero_extend => s_zero_extend,
        o_Branch   => s_Branch,
        o_MemRead  => s_MemRead,
        o_MemtoReg => s_MemtoReg,
        o_ALUOp    => s_ALUOp,
        o_MemWrite => s_ID_DMemWr,
        o_ALUSrc   => s_ALUSrc,
        o_RegWrite => s_ID_RegWr,
        o_Halt     => s_ID_halt);

branch_logic_inst: branch_logic
    port map(
        i_Branch    => s_Branch,
        i_Opcode    => s_ID_Inst(31 downto 26),
        i_RegData1  => s_RegOut1,
        i_RegData2  => s_RegOut2,
        o_Branch_Take => s_Fetch_Branch_En);

hazard_detection_inst: hazard_detection
    port map(
        i_Branch      => s_Branch,
        i_Jump        => s_Jump,
        i_JumpReg     => s_Jump_Return,
        i_Branch_Take => s_Fetch_Branch_En,
        o_IF_Flush    => s_IF_Flush,
        o_IF_ID_Flush => s_IFID_Flush);        

ID_EX_Reg_inst: ID_EX_Reg
 port map(
    i_CLK => iCLK,
    i_RST => iRST,
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
    i_AddrRs => s_ID_Inst(25 downto 21),
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
    o_AddrRs => s_EX_AddrRs,
    o_ALUOp => s_EX_ALUOp,
    o_RegDst => s_EX_RegDst,
    o_InstOp => s_EX_InstOp
);
--EX Stage
forwarding_unit: forwarding_logic
 port map(
    i_MEM_RegWr => s_MEM_RegWr,
    i_WB_RegWr => s_RegWr,
    i_MEM_RegDst => s_MEM_WrAddr,
    i_WB_RegDst => s_RegWrAddr,
    i_Rs => s_EX_AddrRs,
    i_Rt => s_EX_AddrRt,
    o_Mux0_s => s_ALU_Mux_S_0,
    o_Mux1_s => s_ALU_Mux_S_1
);

mux_ALU_Reg_Imm: mux2t1_N
port map(i_S => s_EX_ALUSrc,
       i_D0 => s_EX_RegData1,
       i_D1 => s_EX_imm,
       o_O => s_Mux_ALU);

ALU_Mux_0: mux3t1_N
 port map(
    i_S => s_ALU_Mux_S_0,
    i_D0 => s_EX_RegData0,
    i_D1 => s_RegWrData,
    i_D2 => s_MEM_ALUOut,
    o_O => s_ALU_Mux_O_0
);

ALU_Mux_1: mux3t1_N
 port map(
    i_S => s_ALU_Mux_S_1,
    i_D0 => s_Mux_ALU,
    i_D1 => s_RegWrData,
    i_D2 => s_MEM_ALUOut,
    o_O => s_ALU_Mux_O_1
);

alu_1: alu
    port map(
        i_A        => s_ALU_Mux_O_0,
        i_B        => s_ALU_Mux_O_1,
        i_ALUOp    => s_ALU_Operation,
        i_shamt    => s_EX_imm(10 downto 6),
        o_F        => oALUOut,
        o_Zero     => s_ALU_Zero,
        o_Overflow => s_ALU_Ovfl
    );
   
    s_EX_Ovfl <= s_ALU_Ovfl AND NOT(s_Branch);
    s_ALU_Result    <= oALUOut;

    alu_ctrl: alu_control
    port map(
        i_ALUOp         => s_EX_ALUOp,
        i_Funct         => s_EX_imm(5 downto 0),
	      i_InstOp        => s_EX_InstOp,
        o_ALU_Operation => s_ALU_Operation
    );

mux_RegAddr_JalAddr: mux2t1_5
port map(i_S => s_EX_JAL,
       i_D0 => s_EX_AddrRt,
       i_D1 => "11111",
       o_O => muxtemp);

mux_RegDest: mux2t1_5
port map(i_S => s_EX_RegDst,
       i_D0 => muxtemp,
       i_D1 => s_EX_AddrRd,
       o_O => s_EX_RegWrAddr);

EX_MEM_Reg_inst: EX_MEM_Reg
 port map(
    i_CLK => iCLK,
    i_RST => iRST,
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
    i_ALUOut => s_ALU_Result,
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
--MEM Stage

--process (s_MEM_Branch_En, s_MEM_ALU_Zero) begin
--s_Fetch_Branch_En <= (s_MEM_Branch_En AND s_MEM_ALU_Zero);
--end process;

         s_DMemAddr <= s_MEM_ALUOut;
         s_DMemData <= s_MEM_RegData1;            
          
MEM_WB_Reg_inst: MEM_WB_Reg
 port map(
    i_CLK => iCLK,
    i_RST => iRST,
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
--WB Stage

s_Halt <= s_WB_Halt;
s_Ovfl <= s_WB_Ovfl;

mux_Mem_Reg: mux2t1_N
port map(i_S => s_WB_MemtoReg,
       i_D0 => s_WB_ALUResult,
       i_D1 => s_WB_MemData,
       o_O => s_Mux_Reg_Mem);

mux_Op_Jal: mux2t1_N
port map(i_S => s_WB_jal,
       i_D0 => s_Mux_Reg_Mem,
       i_D1 => s_WB_PC,
       o_O => s_RegWrData);

end structure;

