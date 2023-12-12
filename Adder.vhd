library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Adder is
    Port ( InAddA : in STD_LOGIC_VECTOR(63 downto 0);
           InAddB : in STD_LOGIC_VECTOR(63 downto 0);
           OutSum : out STD_LOGIC_VECTOR(63 downto 0);
           AddCarryFlag : out STD_LOGIC;
           SubtractFlag : in STD_LOGIC := '0';
           CLK : in STD_LOGIC );
end Adder;

architecture Behavioral of Adder is
    signal tempB : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal tempSum : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal tempCarry : STD_LOGIC := '0';

begin
    process(InAddA, InAddB, SubtractFlag)
    begin
        if SubtractFlag = '1' then
            tempB <= (others => '0');
            for i in 0 to 63 loop
                tempB(i) <= not InAddB(i);
            end loop;
            tempB <= tempB + "1";
        else
            tempB <= InAddB;
        end if;

        tempSum <= (others => '0');
        if (InAddA(63) <= '1' and tempB(63) <= '1') then
        tempCarry <= '1';
        else 
        tempCarry <= '0';
        end if;
        tempSum(63 downto 0) <= InAddA(63 downto 0) + tempB(63 downto 0);      

    -- Debugging statement
    if tempSum /= InAddA + tempB then
        report "Error: tempSum and InAddA + tempB mismatch" severity warning;
    end if;
    end process;

    process (CLK)
    begin
        if (rising_edge(CLK)) then 
            OutSum <= tempSum;
            AddCarryFlag <= tempCarry;
        end if;
    end process;
end Behavioral;