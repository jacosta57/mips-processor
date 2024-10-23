-------------------------------------------------------------------------
-- Jayson Acosta
--
--
-- alu.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the ALU for the 
-- MIPS single cycle processor. It handles specific implementation of
-- operations, organization of control signals and overflow detection.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port(
        i_A         : in std_logic_vector(31 downto 0);    -- First operand
        i_B         : in std_logic_vector(31 downto 0);    -- Second operand
        i_ALUOp     : in std_logic_vector(3 downto 0);     -- Operation select
        i_shamt     : in std_logic_vector(4 downto 0);     -- Shift amount
        o_F         : out std_logic_vector(31 downto 0);   -- Result
        o_Zero      : out std_logic;                       -- Zero flag for branching
        o_Overflow  : out std_logic                        -- Overflow flag
    );
end alu;

architecture mixed of alu is
    signal s_addResult, s_subResult : std_logic_vector(32 downto 0);
    signal s_sltResult : std_logic_vector(31 downto 0);
    signal s_shiftResult : std_logic_vector(31 downto 0);

begin
    process(i_A, i_B, i_ALUOp, i_shamt, s_addResult, s_subResult)
    begin


        case i_ALUOp is
            when "0000" =>  -- AND
                o_F <= i_A and i_B;
            
            when "0001" =>  -- OR
                o_F <= i_A or i_B;
            
            when "0010" =>  -- ADD
                s_addResult <= std_logic_vector(('0' & signed(i_A)) + ('0' & signed(i_B)));
                o_F <= s_addResult(31 downto 0);
                o_Overflow <= s_addResult(32) xor s_addResult(31);
            
            when "0011" =>  -- XOR
                o_F <= i_A xor i_B;
            
            when "0100" =>  -- NOR
                o_F <= i_A nor i_B;
            
            when "0110" =>  -- SUB
                s_subResult <= std_logic_vector(('0' & signed(i_A)) - ('0' & signed(i_B)));
                o_F <= s_subResult(31 downto 0);
                o_Overflow <= s_subResult(32) xor s_subResult(31);
            
            when "0111" =>  -- SLT
                if signed(i_A) < signed(i_B) then
                    o_F <= x"00000001";
                else
                    o_F <= x"00000000";
                end if;
            
            when "1000" =>  -- Shift Left Logical
                o_F <= std_logic_vector(shift_left(unsigned(i_B), to_integer(unsigned(i_shamt))));
            
            when "1001" =>  -- Shift Right Logical
                o_F <= std_logic_vector(shift_right(unsigned(i_B), to_integer(unsigned(i_shamt))));
            
            when "1010" =>  -- Shift Right Arithmetic
                o_F <= std_logic_vector(shift_right(signed(i_B), to_integer(unsigned(i_shamt))));
            
            when "1100" =>  -- Load Upper Immediate
                o_F <= i_B(15 downto 0) & x"0000";
            
            when others =>
                        s_addResult <= (others => '0');
       			 s_subResult <= (others => '0');
      		 o_F <= (others => '0');
       		o_Overflow <= '0';
        end case;
    end process;

    -- Zero flag generation for branches
    o_Zero <= '1' when o_F = x"00000000" else '0';

end mixed;
