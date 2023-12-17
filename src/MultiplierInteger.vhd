library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MultiplierInteger is
    Port ( 
        InMul1 : in STD_LOGIC_VECTOR(31 downto 0);
        InMul2 : in STD_LOGIC_VECTOR(31 downto 0);
        OutMul : out STD_LOGIC_VECTOR(31 downto 0);
        MulOverflowFlag : out STD_LOGIC;
        clk, rst : in STD_LOGIC
    );
end MultiplierInteger;

architecture Behavioral of MultiplierInteger is
    -- signal Result : STD_LOGIC_VECTOR(31 downto 0);
    -- signal InAddA : STD_LOGIC_VECTOR(31 downto 0);
    -- signal InAddB : STD_LOGIC_VECTOR(31 downto 0);
    -- signal OutSum : STD_LOGIC_VECTOR(31 downto 0);
    -- signal OutMultiplier : STD_LOGIC_VECTOR(31 downto 0);
    -- signal OutOverflow : STD_LOGIC := '0';
    -- signal resetAdder : STD_LOGIC := '0';
    -- signal doneMul : STD_LOGIC := '0';
    -- signal addRepitition : integer := 0;
    -- signal multiplicant : integer := 0;
    
begin
    -- multiplicant <= to_integer(unsigned(InMul2));

    -- decoderEnt : entity work.AdderInt 
    --     port map (
    --         InAddA => InAddA,
    --         InAddB => InAddB,
    --         OutSum => OutSum,
    --         OutOverflow => OutOverflow,
    --         clk => clk,
    --         rst => resetAdder
    --     );

    -- -- process(clk, rst)
    -- -- begin
    -- --     if rst = '1' then
    -- --         OutMul <= (others => '0');
    -- --         MulOverflowFlag <= '0';
    -- --         OutMultiplier <= (others => '0');
    -- --         addRepitition <= 0;
    -- --         doneMul <= '0';
    -- --     elsif rising_edge(clk) then
    -- --         if doneMul = '0' then
    -- --             if addRepitition < multiplicant then
    -- --                 InAddA <= InMul1;
    -- --                 InAddB <= OutMultiplier;
    -- --                 OutMultiplier <= OutSum; -- Accumulate the sum
    -- --                 addRepitition <= addRepitition + 1;
    -- --             else
    -- --                 doneMul <= '1';
    -- --                 OutMul <= std_logic_vector(resize(unsigned(InAddA) * unsigned(InAddB), 32)); -- Final product
    -- --             end if;
    -- --         end if;
    -- --     end if;
    -- -- end process;

    process(clk, rst)
        variable Temp : signed(63 downto 0);
    begin
        if rst = '1' then
            Temp := (others => '0');
            MulOverflowFlag <= '0';
        elsif rising_edge(clk) then
            Temp := signed(InMul1) * signed(InMul2);
        end if;
        OutMul <= std_logic_vector(Temp(31 downto 0));
    end process;


          
end Behavioral;