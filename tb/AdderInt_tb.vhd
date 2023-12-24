-- Testbench for AdderInt module
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity AdderInt_tb is
end AdderInt_tb;

architecture Behavioral of AdderInt_tb is
    signal InAddA : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal InAddB : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal OutSum : STD_LOGIC_VECTOR(31 downto 0);
    signal OutOverflow : STD_LOGIC;
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';

begin
    DUT : entity work.AdderInt
        port map (
            InAddA => InAddA,
            InAddB => InAddB,
            OutSum => OutSum,
            OutOverflow => OutOverflow,
            clk => clk,
            rst => rst
        );

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Reset the DUT
        rst <= '1';
        wait for 20 ns; -- Ensure reset is applied for enough time
        rst <= '0';

        -- Test Case 1
        InAddA <= (others => '0');  -- Example value
        InAddB <= (others => '0');  -- Example value
        wait for 20 ns;
        assert OutSum = "00000000000000000000000000000000" report "AdderInt failed on test case 1!" severity failure;

        -- Add more test cases here with different inputs and expected outputs
        InAddA <= (others => '0');  -- Example value
        InAddB <= (others => '0');  -- Example value
        wait for 20 ns;
        assert OutSum = "00000000000000000000000000000000" report "AdderInt failed on test case 1!" severity failure;

        -- Test Case 2
        InAddA <= "00000000000000000000000000000001";
        InAddB <= "00000000000000000000000000000010";
        wait for 20 ns;
        assert OutSum = "00000000000000000000000000000011" report "AdderInt failed on test case 2!" severity failure;

        -- Test Case 3
        InAddA <= "11111111111111111111111111111111";
        InAddB <= "00000000000000000000000000000001";
        wait for 20 ns;
        assert OutSum = "00000000000000000000000000000000" report "AdderInt failed on test case 3!" severity failure;

        wait; -- Stop the simulation
    end process;
end Behavioral;
