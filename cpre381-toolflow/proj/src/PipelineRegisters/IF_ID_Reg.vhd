-------------------------------------------------------------------------
-- Nakota Clark
-------------------------------------------------------------------------


-- IF_ID_Reg.vhd
-------------------------------------------------------------------------
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity IF_ID_Reg is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_PC          : in std_logic_vector(N-1 downto 0);     -- Data value input
       i_Inst          : in std_logic_vector(N-1 downto 0);
      i_Flush         :in std_logic;
      i_Stall        :in std_logic;
       o_PC          : out std_logic_vector(N-1 downto 0);   -- Data value output
       o_Inst          : out std_logic_vector(N-1 downto 0));

end IF_ID_Reg;
architecture structural of IF_ID_Reg is

  component  n_reg is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
         o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output
  end component;  

  signal s_we, s_RST, count : STD_LOGIC := '0';
  signal s_PC, s_Inst : std_logic_vector(31 downto 0);
begin
    process(i_Stall, i_RST, i_CLK)
    begin
        if((i_RST = '1')  )
        then
            if (count = '0')
            then
                s_RST <= '1';
                count <= '1';
            else
                s_we <= '1' XOR i_Stall;
                s_RST <= '0';
            end if;
        else
            s_we <= '1' XOR i_Stall;
        end if;
end process;
 
process(i_Flush, i_CLK, i_PC, i_Inst)
begin
    if(i_Flush = '1')
    then
        s_PC <= x"00000000";
        s_Inst <= x"00000000";
    else
        s_PC <= i_PC;
        s_Inst <= i_Inst;
    end if;
end process;

  reg_PC: n_reg  
   port map(
      i_CLK => i_CLK,
      i_RST => s_RST,
      i_WE => s_we,
      i_D => s_PC,
      o_Q => o_PC
  );

  reg_Inst: n_reg

   port map(
      i_CLK => i_CLK,
      i_RST => s_RST,
      i_WE => s_we,
      i_D => s_Inst,
      o_Q => o_Inst
  );
end structural;
