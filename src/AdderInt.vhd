-- Ini adalah adder floating point dengan spesifikasi double dengan IEE 754
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity AdderInt is
    Port (
        InAddA : in STD_LOGIC_VECTOR(31 downto 0);
        InAddB : in STD_LOGIC_VECTOR(31 downto 0);
        OutSum : out STD_LOGIC_VECTOR(31 downto 0);
        OutOverflow : out STD_LOGIC;
        clk, rst : in STD_LOGIC
    );
end AdderInt;

architecture Behavioral of AdderInt is
    signal Sum : unsigned(32 downto 0); -- Intermediate signal for sum, 33 bits to capture overflow
begin
    -- Dataflow style implementation
    -- The output is directly defined as a function of the inputs
    Sum <= ('0' & unsigned(InAddA)) + ('0' & unsigned(InAddB)); -- Extend inputs to 33 bits for overflow detection
    OutSum <= std_logic_vector(Sum(31 downto 0)); -- Assign the lower 32 bits to OutSum
    OutOverflow <= Sum(32); -- The 33rd bit indicates overflow

end Behavioral;
