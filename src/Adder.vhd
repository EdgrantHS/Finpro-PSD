library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Adder is
    port (
        AddNumA : in std_logic_vector(31 downto 0);
        AddNumB : in std_logic_vector(31 downto 0);
        Sum : out std_logic_vector(31 downto 0);
        CarryFlag : out std_logic
    );
end entity Adder;

architecture rtl of Adder is
    function FullAdderBit(A, B, Cin : std_logic) return std_logic_vector is
        variable SumBit : std_logic_vector(0 to 1);
    begin
        SumBit(0) := A xor B xor Cin;
        SumBit(1) := (A and B) or (B and Cin) or (A and Cin);
        return SumBit;
    end function FullAdderBit;

    signal Carry : std_logic := '0';

begin
    process (AddNumA, AddNumB)
        variable TempSum : std_logic_vector(31 downto 0) := (others => '0');
        variable TempCarry : std_logic := '0';
    begin
        for i in 0 to 31 loop
            TempSum(i) := FullAdderBit(AddNumA(i), AddNumB(i), TempCarry)(0);
            TempCarry := FullAdderBit(AddNumA(i), AddNumB(i), TempCarry)(1);
        end loop;

        Sum <= TempSum;
        CarryFlag <= TempCarry;
    end process;
end architecture rtl;