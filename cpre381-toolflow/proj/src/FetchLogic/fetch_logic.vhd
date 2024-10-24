-------------------------------------------------------------------------
-- Jayson Acosta
--
--
-- fetch_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the fetch logic
-- for the MIPS single cycle processor
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fetch_logic is
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
end fetch_logic;

architecture behavioral of fetch_logic is
    signal s_PC, s_next_PC : std_logic_vector(31 downto 0);
    signal s_PC_plus_4 : std_logic_vector(31 downto 0);
    signal s_shifted_branch :   std_logic_vector(31 downto 0);

begin
    -- PC update process
    process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            s_PC <= x"00400000";  -- Initial PC value for MIPS
        elsif rising_edge(i_clk) then
            s_PC <= s_next_PC;
        end if;
    end process;

    -- PC + 4 calculation
    s_PC_plus_4 <= std_logic_vector(unsigned(s_PC) + 4);

    -- Next PC selection
    process(s_PC, s_PC_plus_4, i_branch_en, i_jump_en, i_jr_en, i_branch_addr, i_jump_addr, i_jr_addr)
    begin
        if i_jr_en = '1' then
            s_next_PC <= i_jr_addr;
        elsif i_jump_en = '1' then
            -- Combine upper 4 bits of PC+4 with jump address and 00
            s_next_PC <= s_PC_plus_4(31 downto 28) & i_jump_addr & "00";
        elsif i_branch_en = '1' then
		s_shifted_branch <= std_logic_vector(shift_left(unsigned(i_branch_addr), 2));
            s_next_PC <= std_logic_vector(unsigned(s_PC_plus_4) + unsigned(s_shifted_branch));
        else
            s_next_PC <= s_PC_plus_4;
        end if;
    end process;

    -- Output assignments
    o_PC <= s_PC;
    o_next_inst_addr <= s_next_PC;

end behavioral;
