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
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

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

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

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

component n_reg
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

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
	      o_ALU_Operation : out std_logic_vector(3 downto 0));

component shifter
	port ( i_D : in std_logic_vector(31 downto 0);
		i_Shamt : in std_logic_vector(4 downto 0);
		Right_Left  : in std_logic;
		Logic_Arith  : in std_logic;
		o_Q : out std_logic_vector(31 downto 0));

end component;

component n_adder
generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(N-1 downto 0);
	i_D1         : in std_logic_vector(N-1 downto 0);
	i_C         : in std_logic;
       o_C          : out std_logic;
       o_S          : out std_logic_vector(N-1 downto 0));
end component;

component fetch_logic
port (
       i_clk           : in  std_logic;
       i_rst           : in  std_logic;
       i_branch_en     : in  std_logic;
       i_jump_en       : in  std_logic;
       i_jr_en         : in  std_logic;
       i_branch_addr   : in  std_logic_vector(31 downto 0);
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
           o_RegDst    : out std_logic;
           o_Jump      : out std_logic;
           o_Branch    : out std_logic;
           o_MemRead   : out std_logic;
           o_MemtoReg  : out std_logic;
           o_ALUOp     : out std_logic_vector(1 downto 0);
           o_MemWrite  : out std_logic;
           o_ALUSrc    : out std_logic;
           o_RegWrite  : out std_logic;
           o_Halt      : out std_logic
       );
   end component;

--Signals for the data controlling the regFile and the data coming out of it
signal s_Mux_RegDest : std_logic_vector(4 downto 0);--Output of the mux that selects which address to write to
signal s_RegOut1 : std_logic_vector(31 downto 0);--Carry the first value read from the regfile
signal s_RegOut2 : std_logic_vector(31 downto 0);--Carry the second value read from the regfile

--Signals for ALU input and outputs
signal s_Imm_SignExt : std_logic_vector(31 downto 0);
signal s_Mux_ALU : std_logic_vector(31 downto 0);
signal s_ALU_Result : std_logic_vector(31 downto 0);

--Signals For Control Module and ALU Control
signal s_RegDest : std_logic; --Signal to act as the control signal for the mux that decides which bits in the instruction are the address for the destination
signal s_Jump : std_logic;
signal s_Jump_Return: std_logic;
signal s_Branch : std_logic;
signal s_MemRead : std_logic;
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
signal s_PC_Adder : std_logic_vector(31 downto 0);

--Constant signals for ground and high values
constant s_Ground : std_logic := '0';
constant s_High : std_logic := '1';
constant s_Const_Shamt : std_logic_vector(4 downto 0) := "00010";
constant s_Const_Add_4 : std_logic_vector(31 downto 0) := x"00000004";

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

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

mux_RegDest: mux2t1_N
port map(i_S => s_RegDest,
       i_D0 => s_Inst(20 downto 16),
       i_D1 => s_Inst(15 downto 11),
       o_O => s_RegWrAddr);

regFile: reg_file
port map(iCLK        => iCLK,                 
       read_A0 	  => s_Inst(25 downto 21),            
       read_A1 	 => s_Inst(20 downto 16),    
       write_A   => s_RegWrAddr,    
       write_en  => s_RegWr,                 
       write_val => s_RegWrData,
       reset	 => iRST,
       read_out0  => s_RegOut1,
       read_out1  => s_DMemData);

imm_SignExtend: extenders
port map(i_imm16 => s_Inst(15 downto 0),
	zero_sign_s => s_High,
	o_imm32 => s_Imm_SignExt);

mux_ALU_Reg_Imm: mux2t1_N
port map(i_S => s_ALUSrc,
       i_D0 => s_RegOut1,
       i_D1 => s_Imm_SignExt,
       o_O => s_Mux_ALU);

alu_ctrl: alu_control
    port map(
        i_ALUOp         => s_ALUOp,
        i_Funct         => s_Inst(5 downto 0),
        o_ALU_Operation => s_ALU_Operation
    );

alu_1: alu
    port map(
        i_A        => s_RegOut1,
        i_B        => s_Mux_ALU,
        i_ALUOp    => s_ALU_Operation,
        i_shamt    => s_Inst(10 downto 6),
        o_F        => s_ALU_Result,
        o_Zero     => s_ALU_Zero,
        o_Overflow => s_Ovfl
    );

    s_DMemAddr => s_ALU_Result;

fetch_component: fetch_logic
port map(
       i_clk => iCLK,
       i_rst => iRST,
       i_branch_en => s_Branch_En and s_ALU_Zero,
       i_jump_en => s_Jump,
       i_jr_en => s_Jump_Return,
       i_branch_addr => s_Imm_SignExt,
       i_jump_addr => s_Inst(25 downto 0),
       i_jr_addr => s_RegOut1,
       o_PC => s_Inst,
       o_next_inst_addr => s_NextInstAddr);

control_component: control_logic
    port map(
        i_opcode   => s_Inst(31 downto 26),
        i_funct    => s_Inst(5 downto 0),
        o_RegDst   => s_RegDest,
        o_Jump     => s_Jump,
        o_Branch   => s_Branch,
        o_MemRead  => s_MemRead,
        o_MemtoReg => s_MemtoReg,
        o_ALUOp    => s_ALUOp,
        o_MemWrite => s_DMemWr,
        o_ALUSrc   => s_ALUSrc,
        o_RegWrite => s_RegWr,
        o_Halt     => s_Halt);

        
mux_Mem_Reg: mux2t1_N
port map(i_S => s_MemtoReg,
       i_D0 => s_DMemAddr,
       i_D1 => s_DMemOut,
       o_O => s_RegWrData);

end structure;

