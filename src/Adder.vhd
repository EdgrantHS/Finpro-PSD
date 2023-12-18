library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Adder is
    port (
        AddNumA : in std_logic_vector (31 downto 0);
        AddNumB : in std_logic_vector (31 downto 0);
        Sum : out std_logic_vector (31 downto 0);
        CarryFlag : out std_logic
    );
end entity Adder;

architecture rtl of Adder is
    
begin
    -- process (AddNumA, AddNumB) is
    --     --function full adder (in: A, B, Cin | out: S, Cout), pake dataflow 
    -- begin
    --     --for loop untuk seluruh 32 bit lalu tiap bit call function full addernya
               
    -- end process;

    --cara sementara, nanti didelete kalau proses udah kelar cara dataflow
    Sum <= std_logic_vector(unsigned(AddNumA) + unsigned(AddNumB));
    CarryFlag <= '1' when ((unsigned('0' & AddNumA) + unsigned('0' & AddNumB)) > to_unsigned(2147483647, 32)) else '0';

    end architecture rtl;