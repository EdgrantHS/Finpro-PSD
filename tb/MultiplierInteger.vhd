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
    signal Result : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal InAddA : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal InAddB : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal OutSum : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal OutOverflow : STD_LOGIC := '0';
    signal resetAdder : STD_LOGIC := '0';
    signal doneMul : STD_LOGIC := '0';
    signal addRepitition : integer := 0;
    signal OutMultiplier : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal multiplicant : integer := 0;
    
begin
    multiplicant <= to_integer(unsigned(InMul2));

    decoderEnt : entity work.AdderFloat 
        port map (
            InAddA => InAddA,
            InAddB => InAddB,
            OutSum => OutSum,
            OutOverflow => OutOverflow,
            clk => clk,
            rst => resetAdder
        );

    process(clk, rst)
    begin
        if rst = '1' then
            OutMul <= (others => '0');
            MulOverflowFlag <= '0';
        elsif rising_edge(clk) then
            if addRepitition = multiplicant then
                doneMul <= '1';
            else
                doneMul <= '0';
                InAddA <= InMul1;
                InAddB <= OutMultiplier;
                OutSum <= OutMultiplier;
                addRepitition <= addRepitition + 1;
            end if;
        end if;
    end process;
      
end Behavioral;