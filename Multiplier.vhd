library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;

entity Multiplier is
    Port ( InMul : in STD_LOGIC_VECTOR(63 downto 0);
           Operand : in STD_LOGIC_VECTOR(7 downto 0);
           OutMul : out STD_LOGIC_VECTOR(63 downto 0);
           MulOverflowFlag : out STD_LOGIC);
end Multiplier;

architecture Behavioral of Multiplier is
begin
    process
        variable A, B, Product : real;
    begin
        A := signed(InMul);
        B := signed(Operand);
        
        Product := A * B;
        
        OutMul <= std_logic_vector(to_signed(integer(trunc(Product)), 64));
        MulOverflowFlag <= '1' when Product > 2.0**63 or Product < -2.0**63 else '0';
    end process;
end Behavioral;