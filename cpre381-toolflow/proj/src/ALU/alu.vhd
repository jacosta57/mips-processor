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
    signal s_addResult, s_subResult : std_logic_vector(31 downto 0);
    signal s_sltResult : std_logic_vector(31 downto 0);
    signal s_shiftResult : std_logic_vector(31 downto 0);
    signal s_o_F : std_logic_vector(31 downto 0);
    signal s_overflow_detect :  std_logic_vector(2 downto 0);

begin
    process(i_A, i_B, i_ALUOp, i_shamt, s_addResult, s_subResult, s_overflow_detect, s_o_F)
    begin

        o_Overflow <= '0';

        case i_ALUOp is
            when "0000" =>  -- AND
                s_o_F <= i_A and i_B;
            
            when "0001" =>  -- OR
                s_o_F <= i_A or i_B;
            
            when "0010" =>  -- ADD
                s_addResult <= std_logic_vector((signed(i_A)) + (signed(i_B)));
                s_o_F <= s_addResult(31 downto 0);
                s_overflow_detect <= i_A(31) & i_B(31) & s_o_F(31);

		    case s_overflow_detect is
                when "001" => o_Overflow <= '1';
                when "110" => o_Overflow <= '1';
                when others => o_Overflow <= '0';
                end case;
            
            when "0011" =>  -- XOR
               s_o_F <= i_A xor i_B;
            
            when "0100" =>  -- NOR
                s_o_F <= i_A nor i_B;
            
            when "0110" | "1110" =>  -- SUB
                s_subResult <= std_logic_vector((signed(i_A)) - (signed(i_B)));
                s_o_F <= s_subResult(31 downto 0);
                s_overflow_detect <= i_A(31) & i_B(31) & s_o_F(31);

            case (s_overflow_detect) is
                when "011" => o_Overflow <= '1';
                when "100" => o_Overflow <= '1';
                when others => o_Overflow <= '0';
                end case;
            
            when "0111" =>  -- SLT
                if signed(i_A) < signed(i_B) then
                    s_o_F <= x"00000001";
                else
                    s_o_F <= x"00000000";
                end if;
            
            when "1000" =>  -- Shift Left Logical
                s_o_F <= std_logic_vector(shift_left(unsigned(i_B), to_integer(unsigned(i_shamt))));
            
            when "1001" =>  -- Shift Right Logical
                s_o_F <= std_logic_vector(shift_right(unsigned(i_B), to_integer(unsigned(i_shamt))));
            
            when "1010" =>  -- Shift Right Arithmetic
                s_o_F <= std_logic_vector(shift_right(signed(i_B), to_integer(unsigned(i_shamt))));
            
            when "1100" =>  -- Load Upper Immediate
                s_o_F <= i_B(15 downto 0) & x"0000";
            
            when others =>
                        s_addResult <= (others => '0');
       			 s_subResult <= (others => '0');
      		 s_o_F <= (others => '0');
       		o_Overflow <= '0';
        end case;
	
    end process;

process(s_o_F, i_ALUOp)
	begin

	o_F <= s_o_F;

    if (s_o_F = x"00000000") then 
    case (i_ALUOp) is
        when "0110" => o_Zero <= '1';
        when others => o_Zero <= '0';
        end case;
    elsif (s_o_F /= x"00000000")then
        case (i_ALUOp) is
            when "1110" => o_Zero <= '1';
            when others => o_Zero <= '0';
            end case;
    else
	o_Zero <= '0';

    -- Zero flag generation for branches
    --o_Zero <= '1' when s_o_F = x"00000000" else '0';
end if;
end process;

end mixed;
