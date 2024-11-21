-------------------------------------------------------------------------
-- Jayson Acosta
--
--
-- bracnh_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Implementation of the branch logic, compares register 
-- values in the ID stage to determine when to take a branch.
--
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity branch_logic is
    port (
        i_Branch    : in std_logic;
        i_Opcode    : in std_logic_vector(5 downto 0);  
        i_RegData1  : in std_logic_vector(31 downto 0);
        i_RegData2  : in std_logic_vector(31 downto 0); 
        o_Branch_Take : out std_logic
    );
end branch_logic;

architecture behavioral of branch_logic is
begin
    process(i_Branch, i_Opcode, i_RegData1, i_RegData2)
    begin
        -- Default to not taking branch
        o_Branch_Take <= '0';
        
        -- Only evaluate if branch is enabled by control unit
        if i_Branch = '1' then
            case i_Opcode is
                when "000100" =>  -- beq
                    if i_RegData1 = i_RegData2 then
                        o_Branch_Take <= '1';
                    end if;
                    
                when "000101" =>  -- bne
                    if i_RegData1 /= i_RegData2 then
                        o_Branch_Take <= '1';
                    end if;
                    
                when others =>
                    o_Branch_Take <= '0';
            end case;
        end if;
    end process;
end behavioral;