--Kode Float Adder
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Testbench_FloatAdder is
end entity Testbench_FloatAdder;

architecture rtl of Testbench_FloatAdder is
    component FloatAdder is
        port (
            FloatNumA   : in std_logic_vector (31 downto 0);
            FloatNumB   : in std_logic_vector (31 downto 0);
            clk         : in std_logic;
            rst         : in std_logic;
            SignSelect  : in std_logic;
            FloatOut    : out std_logic_vector (31 downto 0);
            CarryFlag   : out std_logic;
            Done        : out std_logic
        );
    end component FloatAdder;

    signal        input1        : std_logic_vector(31 downto 0);
    signal        input2        : std_logic_vector(31 downto 0);
    signal clk, rst, SignSelect : std_logic;
    signal    expected_output   : std_logic_vector(31 downto 0);
    signal    CarryFlag, Done   : std_logic;

begin
    UUT: entity work.FloatAdder port map (FloatNumA  => input1,
                                          FloatNumB  => input2,
                                          clk        => clk,
                                          rst        => rst,
                                          SignSelect => SignSelect,
                                          FloatOut   => expected_output,
                                          CarryFlag  => CarryFlag,
                                          Done       => Done
                                    );

    clk_process: process
    begin
        clk <= '1';
        wait for 50 ps;
        clk <= '0';
        wait for 50 ps;
    end process;

    test_bench: process
    begin
        -- Test case 1
	    wait for 100 ps;
        input1 <= "01000000111010000000000000000000"; --7.25
        input2 <= "01000000111010000000000000000000"; --7.25
        assert expected_output = "00000001111010000000000000000000" --14.5
        report "Float Adder failed" severity error;
	    wait for 700 ps;
        
        -- Test case 2
        input1 <= "11000001011010000000000000000000"; -- -14.5
        input2 <= "01000000011100000000000000000000"; -- 3.75
        assert expected_output = "10000010010101100000000000000000" -- -10.75
        report "Float Adder failed" severity error;
	    wait for 700 ps;
            
        -- Test case 3
        input1 <= "11000010010110011000000000000000"; -- -54.375
        input2 <= (others => '0'); -- 0
        assert expected_output = "11000010010110011000000000000000" -- -54.375
        report "Float Adder failed" severity error;
	    wait for 700 ps;
            
        -- Test case 4
        input1 <= (others => '0'); -- 0
        input2 <= "01000010010110011000000000000000"; -- 54.375
        assert expected_output = "01000010010110011000000000000000" -- 54.375
        report "Float Adder failed" severity error;
	    wait for 700 ps;
        
        -- Test case 5
        input1 <= "01010010000011111011001101110111"; -- 154297810944
        input2 <= "11000000000000000000000000000000"; -- -2
        assert expected_output = "10010010000011111011001101110111" -- -154297810944
        report "Float Adder failed" severity error;

        wait;
    end process;
end rtl;
