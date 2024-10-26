-------------------------------------------------------------------------
-- Jayson Acosta
--
--
-- control_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the control logic
-- for the MIPS single cycle processor
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_types.all;

entity control_logic is
    port (
        i_opcode    : in  std_logic_vector(5 downto 0);
        i_funct     : in  std_logic_vector(5 downto 0);
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
        o_Halt      : out std_logic);
end control_logic;

architecture behavioral of control_logic is
    type t_control_signals is record
        RegDst    : std_logic;
        Jump      : std_logic;
        JumpReturn      : std_logic;
        Jal     : std_logic;
        Branch    : std_logic;
        Zero_Extend : std_logic;
        MemRead   : std_logic;
        MemtoReg  : std_logic;
        ALUOp     : std_logic_vector(1 downto 0);
        MemWrite  : std_logic;
        ALUSrc    : std_logic;
        RegWrite  : std_logic;
	Halt      : std_logic;
    end record;

    signal r_control : t_control_signals;
begin
    process(i_opcode, i_funct, r_control)
    begin
        -- Default values
        r_control <= ('0', '0', '0', '0', '0', '0', '0', '0', "00", '0', '0', '0', '0');

        case to_integer(unsigned(i_opcode)) is
            when 0 =>  -- R-type instructions
                r_control.RegDst   <= '1';
                r_control.ALUOp    <= "10";
                r_control.RegWrite <= '1';
                
                -- Special case for jr
                if to_integer(unsigned(i_funct)) = 8 then
                    r_control.Jump <= '1';
                    r_control.JumpReturn <= '1';
                    r_control.RegWrite <= '0';
                end if;

            when 2 =>  -- j
                r_control.Jump     <= '1';

            when 3 =>  -- jal
                r_control.Jump     <= '1';
                r_control.Jal     <= '1';
                r_control.RegDst   <= '0';
                r_control.RegWrite <= '1';

            when 4 | 5 =>  -- beq, bne
                r_control.Branch   <= '1';
                r_control.ALUOp    <= "01";

            when 8 | 9 =>  -- addi, addiu
                r_control.ALUSrc   <= '1';
                r_control.RegWrite <= '1';
		
	    when 10 => --slti
		r_control.ALUSrc   <= '1';
                r_control.RegWrite <= '1';
                r_control.ALUOp    <= "11";

            when 12 =>  -- andi
                r_control.ALUSrc   <= '1';
                r_control.RegWrite <= '1';
                r_control.Zero_Extend <= '1';
                r_control.ALUOp    <= "11";

            when 13 =>  -- ori
                r_control.ALUSrc   <= '1';
                r_control.RegWrite <= '1';
                r_control.Zero_Extend <= '1';
                r_control.ALUOp    <= "11";
	    
	    when 14 => --xori
                r_control.ALUSrc   <= '1';
                r_control.RegWrite <= '1';
                r_control.Zero_Extend <= '1';
                r_control.ALUOp    <= "11";

            when 15 =>  -- lui
                r_control.ALUSrc   <= '1';
                r_control.RegWrite <= '1';
                r_control.MemWrite <= '0';
                r_control.ALUOp    <= "11";

	    when 20 => -- Halt
		r_control.Halt     <= '1';

            when 35 =>  -- lw
                r_control.ALUSrc   <= '1';
                r_control.MemRead  <= '1';
                r_control.MemtoReg <= '1';
                r_control.RegWrite <= '1';
		r_control.ALUOp    <= "00";

            when 43 =>  -- sw
                r_control.ALUSrc   <= '1';
                r_control.MemWrite <= '1';
		r_control.ALUOp    <= "00";

            when others => 
                null;
        end case;
    end process;

    -- Assign internal signals to output ports
    o_RegDst   <= r_control.RegDst;
    o_Jump     <= r_control.Jump;
    o_JumpReturn     <= r_control.JumpReturn;
    o_Jal     <= r_control.Jal;
    o_Zero_extend  <= r_control.Zero_Extend;
    o_Branch   <= r_control.Branch;
    o_MemRead  <= r_control.MemRead;
    o_MemtoReg <= r_control.MemtoReg;
    o_ALUOp    <= r_control.ALUOp;
    o_MemWrite <= r_control.MemWrite;
    o_ALUSrc   <= r_control.ALUSrc;
    o_RegWrite <= r_control.RegWrite;
    o_Halt     <= r_control.Halt;

end behavioral;
