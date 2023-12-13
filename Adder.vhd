library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder is
    Port ( InAddA : in STD_LOGIC_VECTOR(63 downto 0);
           InAddB : in STD_LOGIC_VECTOR(63 downto 0);
           OutSum : out STD_LOGIC_VECTOR(63 downto 0);
           AddCarryFlag : out STD_LOGIC);
end Adder;

architecture Behavioral of Adder is
    function signed(signal : STD_LOGIC_VECTOR) return integer is
    begin
        if signal(0) = '1' then
            return -to_integer(unsigned(signal(1 to signal'high))) - 1;
        else
            return to_integer(unsigned(signal));
        end if;
    end function;

    signal A, B, IntSum : integer;
    signal Carry : integer := 0;
begin
    process
    begin
        A <= signed(InAddA);
        B <= signed(InAddB);
        
        for i in 63 downto 0 loop
            if Carry = 1 then
                IntSum := A(i) and B(i) + 1;
            else
                IntSum := A(i) and B(i);
            end if;

            Carry <= IntSum / 2;
            OutSum(i) <= '0' when (IntSum mod 2) = 0 else '1';
        end loop;

        if IntSum > 0 or Carry = 1 then
            AddCarryFlag <= '1';
        else
            AddCarryFlag <= '0';
        end if;
    end process;
end Behavioral;