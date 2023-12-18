library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Adder_tb is
-- Testbench doesn't have ports
end entity Adder_tb;

architecture behavior of Adder_tb is 

    -- input
    signal ControlWord : std_logic_vector (64 downto 0);

    -- outputs
    signal FloatNumA : std_logic_vector (31 downto 0);
    signal FloatNumB : std_logic_vector (31 downto 0);
    signal SignSelect : std_logic;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.Decoder 
    port map (
        ControlWord => ControlWord,
        FloatNumA => FloatNumA,
        FloatNumB => FloatNumB,
        SignSelect => SignSelect
    );

    
    -- Stimulus process
    stim_proc: process
        variable AddNumA : std_logic_vector (31 downto 0);
        variable AddNumB : std_logic_vector (31 downto 0);
        variable SignSelectVar : std_logic;
    begin        
        -- Case 1
        AddNumA := std_logic_vector(to_unsigned(15, 32));
        AddNumB := std_logic_vector(to_unsigned(10, 32));
        SignSelectVar := '0';
        ControlWord <= SignSelectVar & AddNumA & AddNumB;
        wait for 100 ps;
        assert FloatNumA = AddNumA report "Test failed for case 1 - FloatNumA" severity error;
        assert FloatNumB = AddNumB report "Test failed for case 1 - FloatNumB" severity error;
        assert SignSelect = SignSelectVar report "Test failed for case 1 - SignSelectVar" severity error;

        -- Case 2
        AddNumA := std_logic_vector(to_unsigned(165, 32));
        AddNumB := std_logic_vector(to_unsigned(410, 32));
        SignSelectVar := '0';
        ControlWord <= SignSelectVar & AddNumA & AddNumB;
        wait for 100 ps;
        assert FloatNumA = AddNumA report "Test failed for case 1 - FloatNumA" severity error;
        assert FloatNumB = AddNumB report "Test failed for case 1 - FloatNumB" severity error;
        assert SignSelect = SignSelectVar report "Test failed for case 1 - SignSelectVar" severity error;

        
        -- Case 3
        AddNumA := std_logic_vector(to_unsigned(65, 32));
        AddNumB := std_logic_vector(to_unsigned(10, 32));
        SignSelectVar := '1';
        ControlWord <= SignSelectVar & AddNumA & AddNumB;
        wait for 100 ps;
        assert FloatNumA = AddNumA report "Test failed for case 1 - FloatNumA" severity error;
        assert FloatNumB = AddNumB report "Test failed for case 1 - FloatNumB" severity error;
        assert SignSelect = SignSelectVar report "Test failed for case 1 - SignSelectVar" severity error;
        wait;
    end process;

end architecture;
