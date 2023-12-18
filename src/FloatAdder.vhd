library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FloatAdder is
    port (
        FloatNumA : in std_logic_vector (31 downto 0);
        FloatNumB : in std_logic_vector (31 downto 0);
        clk : in std_logic;
        rst : in std_logic;
        SignSelect : in std_logic;
        FloatOut : out std_logic_vector (31 downto 0);
        CarryFlag : out std_logic;
        Done : out std_logic
        
    );
end entity FloatAdder;

architecture rtl of FloatAdder is
    
begin
    
-- // Helper Functions:
-- Function getFraction(float32 number) -> (SLV(sign + mantissa)):
--     // Extract sign and mantissa from the 32-bit floating-point number


-- Function getExponent(float32 number) -> (SLV exponent):
--     // Extract exponent from the 32-bit floating-point number

-- Function ShiftRight(SLV mantissa, int shift):
--     // Right shift/left the mantissa by 'shift' places, handling overflow/underflow
--     ...

-- Function Assemble(mantissa, exponent) -> float32:
--     // Assemble the 32-bit floating-point number from sign, exponent, and mantissa



-- main: process (clk, rst) 
--     // Step 1: Decompose each number into sign, exponent, and mantissa
--     signA, exponentA, mantissaA = Decompose(a)
--     signB, exponentB, mantissaB = Decompose(b)

--     // handle zeros
--     if a and b are zeros:
--         return zero

--     // Step 3: Align the mantissas
--     // This may involve shifting the mantissa of the number with the smaller exponent
--     if exponentA > exponentB:
--         ShiftRight(mantissaB, exponentA - exponentB)
--         exponent = exponentA
--     else:
--         ShiftRight(mantissaA, exponentB - exponentA)
--         exponent = exponentB

--     // Step 4: Add or subtract the mantissas based on the signs
--     if signA == signB:
--         mantissa = mantissaA + mantissaB
--         sign = signA
--     else:
--         if mantissaA > mantissaB:
--             mantissa = mantissaA - mantissaB
--             sign = signA
--         else:
--             mantissa = mantissaB - mantissaA
--             sign = signB

--     // Step 5: Normalize the result
--     // Shift the mantissa and adjust the exponent until the mantissa is normalized
--     while mantissa not in normalized range:
--         if mantissa too large:
--             ShiftRight(mantissa)
--             exponent += 1
--         else if mantissa too small:
--             ShiftLeft(mantissa)
--             exponent -= 1

--     return result    
    
end architecture rtl;