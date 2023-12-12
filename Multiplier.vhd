library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Multiplier is
    Port ( InMul : in STD_LOGIC_VECTOR(63 downto 0);
           Exponent : in STD_LOGIC_VECTOR(7 downto 0);
           OutMul : out STD_LOGIC_VECTOR(63 downto 0);
           MulOverflowFlag : out STD_LOGIC;
           FatorialDone : out STD_LOGIC);
end Multiplier;

architecture Behavioral of Multiplier is
    signal Result : STD_LOGIC_VECTOR(63 downto 0) := (others => '1');
    signal Num : integer range 0 to 255;
    signal Exp : integer range 0 to 255;
begin
    process(InMul, Exponent)
        variable ExpVar : integer range 0 to 255;
        variable TempMul : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    begin
        ExpVar := conv_integer(Exponent);
        Exp <= ExpVar;

        Result <= (others => '1');  -- Initial value

        for i in 1 to ExpVar loop
            TempMul(63 downto 0) := TempMul(62 downto 0) & '0';
            TempMul(0) := '0';
        end loop;        

        Result <= TempMul;

        -- Overflow detection (adjust as needed)
        if Result(Result'left) = '1' then
            MulOverflowFlag <= '1';  -- Overflow
        else
            MulOverflowFlag <= '0';  -- No overflow
        end if;

        -- Set FatorialDone to '1' when done (adjust as needed)
        if Num = 0 then
            FatorialDone <= '1';
        else
            FatorialDone <= '0';
        end if;

        OutMul <= Result;
    end process;
end Behavioral;