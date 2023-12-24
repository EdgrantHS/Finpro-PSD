library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ExponentFu is
    Port ( 
        Nilai : in STD_LOGIC_VECTOR(31 downto 0);
        Exponent : in STD_LOGIC_VECTOR(31 downto 0);
        OutMul : out STD_LOGIC_VECTOR(31 downto 0);
        MulSelect : out STD_LOGIC_VECTOR(1 downto 0);
        MulOverflowFlag : out STD_LOGIC;
        clk, rst : in STD_LOGIC
    );
end ExponentFu;

architecture Behavioral of ExponentFu is
    
begin
    -- membuat exponen dengan satuan Fu 16 bit

    -- memangil multiplier integer dan mengalikan sebanyak Nilai sebanyak Exponent
    
    -- membagi hasil sebanyak exponent kali 10436 (angka ini liat figmanya utk tau dpt dari mana) 
    -- contohnya jika nilai = 1056 dan exponent = 3, maka 1056**3 / (10436)**3 = 0.001036 rad

    -- hasil dikali dengan 10436
    -- contohnya jika nilai = 1056 dan exponent = 3, maka 0.001036 * 10436 = 10.8

    -- hasil dibulatkan
    --10.8 -> 11
    
    -- output hasil

          
end Behavioral;
