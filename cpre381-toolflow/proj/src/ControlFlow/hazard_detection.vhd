-------------------------------------------------------------------------
-- Jayson Acosta
--
--
-- hazard_detection.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of hazard detection
-- It detects when control flow instructions (branches/jumps)
-- are in the ID stage and generates control signals.
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity hazard_detection is
    port(
        i_Branch       : in std_logic;
        i_Jump        : in std_logic;
        i_JumpReg     : in std_logic;
        i_Branch_Take : in std_logic;
        o_IF_Flush    : out std_logic;
        o_IF_ID_Flush : out std_logic);
end hazard_detection;

architecture behavioral of hazard_detection is
begin
    process(i_Branch, i_Jump, i_JumpReg, i_Branch_Take)
    begin
        -- Default: no flush needed
        o_IF_Flush <= '0';
        o_IF_ID_Flush <= '0';
        
        -- Branch taken: need to flush IF and IF/ID
        if (i_Branch = '1' AND i_Branch_Take = '1') then
            o_IF_Flush <= '1';
            o_IF_ID_Flush <= '1';
        
        -- Jump instruction: need to flush IF and IF/ID
        elsif (i_Jump = '1') then
            o_IF_Flush <= '1';
            o_IF_ID_Flush <= '1';
            
        -- Jump register: need to flush IF and IF/ID
        elsif (i_JumpReg = '1') then
            o_IF_Flush <= '1';
            o_IF_ID_Flush <= '1';
        end if;
    end process;
end behavioral;