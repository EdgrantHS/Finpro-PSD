library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Adder_tb is
-- Testbench doesn't have ports
end entity Adder_tb;

architecture behavior of Adder_tb is 
    -- Inputs
    signal AddNumA : std_logic_vector(31 downto 0) := (others => '0');
    signal AddNumB : std_logic_vector(31 downto 0) := (others => '0');

    -- Outputs
    signal Sum : std_logic_vector(31 downto 0);
    signal CarryFlag : std_logic;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.Adder 
    port map (
          AddNumA => AddNumA,
          AddNumB => AddNumB,
          Sum => Sum,
          CarryFlag => CarryFlag
    );

    
    -- Stimulus process
    stim_proc: process
    begin        
        -- Case 1
        AddNumA <= std_logic_vector(to_unsigned(15, 32));
        AddNumB <= std_logic_vector(to_unsigned(10, 32));
        wait for 100 ps;
        assert Sum = std_logic_vector(to_unsigned(25, 32)) report "Test failed for case 1" severity error;

        -- Case 2
        AddNumA <= std_logic_vector(to_unsigned(123, 32));
        AddNumB <= std_logic_vector(to_unsigned(456, 32));
        wait for 100 ps;
        assert Sum = std_logic_vector(to_unsigned(579, 32)) report "Test failed for case 2" severity error;

        -- Case 3
        AddNumA <= std_logic_vector(to_unsigned(1223, 32));
        AddNumB <= std_logic_vector(to_unsigned(4546, 32));
        wait for 100 ps;
        assert Sum = std_logic_vector(to_unsigned(5769, 32)) report "Test failed for case 3" severity error;

        -- Case 4
        AddNumA <= std_logic_vector(to_unsigned(1, 32));
        AddNumB <= "11111111111111111111111111111111";
        wait for 100 ps;
        assert CarryFlag = '1' report "Test failed for case 4" severity error;
        


        

        -- Finish simulation
        wait;
    end process;

end architecture;
