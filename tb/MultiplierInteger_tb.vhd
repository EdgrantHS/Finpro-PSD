-- FILEPATH: /c:/Users/Edgrant/OneDrive - UNIVERSITAS INDONESIA/Desktop/UI/Pelajaran/Semester 3/PSD/Prak PSD/Finpro-PSD/tb/MultiplierInteger_tb.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity MultiplierInteger_tb is
end entity MultiplierInteger_tb;

architecture Behavioral of MultiplierInteger_tb is
    -- Signal declarations
    signal InMul1 : std_logic_vector(31 downto 0) := (others => '0');
    signal InMul2 : std_logic_vector(31 downto 0) := (others => '0');
    signal OutMul : std_logic_vector(31 downto 0) := (others => '0');
    signal MulOverflowFlag : std_logic := '0';
    signal clk, rst : std_logic := '0';
    
    -- Signal declarations
    signal doneMul : std_logic := '0';
    
begin
    -- Testbench process
          -- Instantiate the component
        DUT : entity work.MultiplierInteger
            port map (
                clk => clk,
                rst => rst,
                InMul1 => InMul1,
                InMul2 => InMul2,
                OutMul => OutMul,
                MulOverflowFlag => MulOverflowFlag
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

        -- Add more test cases here with different inputs and expected outputs
        InMul1 <= (others => '0');  -- Example value
        InMul2 <= (others => '0');  -- Example value
        wait for 20 ns;
        -- assert OutMul = "00000000000000000000000000000000" report "MultiplierInteger failed on test case 1!" severity failure;

        -- Test Case 2
        InMul1 <= "00000000000000000000000000000001";
        InMul2 <= "00000000000000000000000000000010";
        wait for 20 ns;
        -- assert OutMul = "00000000000000000000000000000010" report "MultiplierInteger failed on test case 2!" severity failure;

        -- Test Case 3
        InMul1 <= "00000000000000000000000000000100";
        InMul2 <= "00000000000000000000000000000010";
        wait for 20 ns;
        -- assert OutMul = "00000000000000000000000000001000" report "MultiplierInteger failed on test case 4!" severity failure;

        wait; -- Stop the simulation
    end process;
    
end Behavioral;