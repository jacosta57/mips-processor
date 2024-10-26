-------------------------------------------------------------------------
-- Jayson Acosta
--
--
-- alu_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the ALU control
-- for the MIPS single cycle processor. it takes in 2 bits to determine
-- the operation type, then translates it to the 4 bit ALU Operation
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_types.all;

entity ALU_Control is
    port(
        i_ALUOp     : in std_logic_vector(1 downto 0);    -- From main control
        i_Funct     : in std_logic_vector(5 downto 0);    -- Function field from instruction
	i_InstOp    : in std_logic_vector(5 downto 0);
        o_ALU_Operation : out std_logic_vector(3 downto 0) -- To ALU
    );
end ALU_Control;

architecture behavioral of ALU_Control is
begin
    process(i_ALUOp, i_Funct, i_InstOp)
    begin
        case i_ALUOp is
            when "00" =>  -- Memory reference or immediate
                o_ALU_Operation <= "0010";  -- ADD
                
            when "01" =>  -- Branch
            case to_integer(unsigned(i_InstOp)) is
                when 4 => o_ALU_Operation <= "0110"; --beq
                when 5 => o_ALU_Operation <= "1110"; --bne
                when others => o_ALU_Operation <= "0000";
		end case;
                
            when "10" =>  -- R-type
                case i_Funct is
                    when "100000" => o_ALU_Operation <= "0010"; -- add
                    when "100001" => o_ALU_Operation <= "0010"; -- addu
                    when "100100" => o_ALU_Operation <= "0000"; -- and
                    when "100101" => o_ALU_Operation <= "0001"; -- or
                    when "100110" => o_ALU_Operation <= "0011"; -- xor
                    when "100111" => o_ALU_Operation <= "0100"; -- nor
                    when "101010" => o_ALU_Operation <= "0111"; -- slt
                    when "000000" => o_ALU_Operation <= "1000"; -- sll
                    when "000010" => o_ALU_Operation <= "1001"; -- srl
                    when "000011" => o_ALU_Operation <= "1010"; -- sra
                    when "100010" => o_ALU_Operation <= "0110"; -- sub
                    when "100011" => o_ALU_Operation <= "0110"; -- subu
                    when others   => o_ALU_Operation <= "0000";
                end case;
                
            when "11" =>  -- Immediate operations
               -- o_ALU_Operation <= "0010";  -- Default to ADD for immediate
                case to_integer(unsigned(i_InstOp)) is
                    when 8 => o_ALU_Operation <= "0010"; -- addi
                    when 9 => o_ALU_Operation <= "0010"; -- addui
                    when 10 => o_ALU_Operation <= "0111"; -- slti
                    when 12 => o_ALU_Operation <= "0000"; -- andi
                    when 13 => o_ALU_Operation <= "0001"; -- ori
                    when 14 => o_ALU_Operation <= "0011"; -- xori
		            when 15 => o_ALU_Operation <= "1100"; -- lui
                    when others   => o_ALU_Operation <= "0010";
                end case;

            when others =>
                o_ALU_Operation <= "0000";
        end case;
    end process;
end behavioral;
