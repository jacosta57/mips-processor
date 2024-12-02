

-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- forwarding_logic.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity forwarding_logic is
  port(i_MEM_RegWr  :   in std_logic;
    i_WB_RegWr  :in std_logic;
    i_MEM_RegDst    :   in std_logic_vector(4 downto 0);
    i_WB_RegDst    :   in std_logic_vector(4 downto 0);
    i_Rs            : in std_logic_vector(4 downto 0);
    i_Rt            : in std_logic_vector(4 downto 0);
    i_ALUOp         : in std_logic_vector(1 downto 0);
    o_Mux0_s        : out std_logic_vector(1 downto 0);
    o_Mux1_s        : out std_logic_vector(1 downto 0));

end forwarding_logic;


architecture Behavioral of forwarding_logic is
begin
    process(i_MEM_RegWr, i_WB_RegWr, i_MEM_RegDst, i_WB_RegDst, i_Rs, i_Rt, i_ALUOp)
    begin
        o_Mux0_s <= "00";
        o_Mux1_s <= "00";
        if (i_ALUOp = "10") then
            if ((i_Rs = i_MEM_RegDst) AND (i_MEM_RegWr = '1') AND (i_MEM_RegDst /= "00000")) then
                o_Mux0_s <= "10";
            elsif ((i_Rs = i_WB_RegDst) AND (i_WB_RegWr = '1') AND (i_WB_RegDst /= "00000")) then
                o_Mux0_s <= "01";
            end if;

            if ((i_Rt = i_MEM_RegDst) AND (i_MEM_RegWr = '1') AND (i_MEM_RegDst /= "00000")) then
                o_Mux1_s <= "10";
            elsif ((i_Rt = i_WB_RegDst) AND (i_WB_RegWr = '1') AND (i_WB_RegDst /= "00000")) then
                o_Mux1_s <= "01";
            end if;
        elsif (i_ALUOp = "11") then
            if ((i_Rs = i_MEM_RegDst) AND (i_MEM_RegWr = '1') AND (i_MEM_RegDst /= "00000")) then
                o_Mux0_s <= "10";
            elsif ((i_Rs = i_WB_RegDst) AND (i_WB_RegWr = '1') AND (i_WB_RegDst /= "00000")) then
                o_Mux0_s <= "01";
            end if;
        elsif (i_ALUOp = "00") then
            if ((i_Rs = i_MEM_RegDst) AND (i_MEM_RegWr = '1') AND (i_MEM_RegDst /= "00000")) then
                o_Mux0_s <= "10";
            elsif ((i_Rs = i_WB_RegDst) AND (i_WB_RegWr = '1') AND (i_WB_RegDst /= "00000")) then
                o_Mux0_s <= "01";
            end if;

        end if;
    end process;	
end Behavioral;
