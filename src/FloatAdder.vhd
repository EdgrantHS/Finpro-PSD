library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FloatAdder is
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
end entity FloatAdder;

architecture rtl of FloatAdder is
    function getFraction(number : std_logic_vector) return std_logic_vector is
        variable result : std_logic_vector(31 downto 0);
    begin
      
        return result;
    end function;

    function getExponent(number : std_logic_vector) return std_logic_vector is
        variable result : std_logic_vector(7 downto 0);
    begin
       
        return result;
    end function;

    function ShiftRight(mantissa : std_logic_vector; shift : integer) return std_logic_vector is
        variable result : std_logic_vector(mantissa'length downto 0);
    begin
      
        return result;
    end function;

    function Assemble(sign : std_logic; exponent : std_logic_vector; mantissa : std_logic_vector) return std_logic_vector is
        variable result : std_logic_vector(31 downto 0);
    begin
     
        return result;
    end function;

    

    signal signA, signB : std_logic;
    signal exponentA, exponentB : std_logic_vector(7 downto 0);
    signal mantissaA, mantissaB : std_logic_vector(23 downto 0);
    signal exponent, mantissa : std_logic_vector(7 downto 0);

begin
    main: process (clk, rst)
    begin
        if rst = '1' then
            
        elsif rising_edge(clk) then
            -- Step 1: Decompose each number into sign, exponent, and mantissa
            signA     <= getFraction(FloatNumA)(31);
            exponentA <= getExponent(FloatNumA);
            mantissaA <= getFraction(FloatNumA)(22 downto 0);

            signB     <= getFraction(FloatNumB)(31);
            exponentB <= getExponent(FloatNumB);
            mantissaB <= getFraction(FloatNumB)(22 downto 0);

            -- handle zeros
            if (FloatNumA = "00000000000000000000000000000000") and (FloatNumB = "00000000000000000000000000000000") then
                FloatOut <= (others => '0');
                CarryFlag <= '0';
                Done <= '1';
            else
                -- Step 3: Align the mantissas
                if exponentA > exponentB then
                    mantissaB <= ShiftRight(mantissaB, to_integer(unsigned(exponentA) - unsigned(exponentB)));
                    exponent  <= exponentA;
                else
                    mantissaA <= ShiftRight(mantissaA, to_integer(unsigned(exponentB) - unsigned(exponentA)));
                    exponent  <= exponentB;
                end if;

                -- Step 4: Add or subtract the mantissas based on the signs
                if signA = signB then
                    mantissa <= std_logic_vector(unsigned(mantissaA) + unsigned(mantissaB));
                    sign <= signA;
                else
                    if mantissaA > mantissaB then
                        mantissa <= std_logic_vector(unsigned(mantissaA) - unsigned(mantissaB));
                        sign <= signA;
                    else
                        mantissa <= std_logic_vector(unsigned(mantissaB) - unsigned(mantissaA));
                        sign <= signB;
                    end if;
                end if;

                -- Step 5: Normalize the result
                
                FloatOut <= Assemble(sign, exponent, mantissa);
                CarryFlag <= '0';
                Done <= '1';     
            end if;
        end if;
    end process main;

end architecture rtl;



/*library IEEE;
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