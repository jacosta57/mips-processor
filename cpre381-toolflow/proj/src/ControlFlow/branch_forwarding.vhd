



-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- branch_frowarding.vhd
-------------------------------------------------------------------------

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity branch_forwarding is
  port(i_MEM_RegWr  :   in std_logic;
    i_WB_RegWr  :in std_logic;
    i_EX_RegWr  :in std_logic;
    i_MEM_RegDst    :   in std_logic_vector(4 downto 0);
    i_WB_RegDst    :   in std_logic_vector(4 downto 0);
    i_EX_RegDst    :   in std_logic_vector(4 downto 0);
    i_Rs            : in std_logic_vector(4 downto 0);
    i_Rt            : in std_logic_vector(4 downto 0);
    i_ALUOp         : in std_logic_vector(1 downto 0);
    o_Mux0_s        : out std_logic_vector(1 downto 0);
    o_Mux1_s        : out std_logic_vector(1 downto 0));

end branch_forwarding;


architecture Behavioral of branch_forwarding is
begin
    process(i_EX_RegWr, i_MEM_RegWr, i_WB_RegWr, i_EX_RegDst, i_MEM_RegDst, i_WB_RegDst, i_Rs, i_Rt, i_ALUOp)
    begin
        o_Mux0_s <= "00";
        o_Mux1_s <= "00";
        if (i_ALUOp = "01") then
            if ((i_Rs = i_EX_RegDst) AND (i_EX_RegWr = '1') AND (i_EX_RegDst /= "00000")) then
                o_Mux0_s <= "11";
            elsif ((i_Rs = i_MEM_RegDst) AND (i_MEM_RegWr = '1') AND (i_MEM_RegDst /= "00000")) then
                o_Mux0_s <= "10";
            elsif ((i_Rs = i_WB_RegDst) AND (i_WB_RegWr = '1') AND (i_WB_RegDst /= "00000")) then
                o_Mux0_s <= "01";
            end if;

            if ((i_Rt = i_EX_RegDst) AND (i_EX_RegWr = '1') AND (i_EX_RegDst /= "00000")) then
                o_Mux1_s <= "11";
            elsif ((i_Rt = i_MEM_RegDst) AND (i_MEM_RegWr = '1') AND (i_MEM_RegDst /= "00000")) then
                o_Mux1_s <= "10";
            elsif ((i_Rt = i_WB_RegDst) AND (i_WB_RegWr = '1') AND (i_WB_RegDst /= "00000")) then
                o_Mux1_s <= "01";
            end if;
        end if;
    end process;
end Behavioral;
