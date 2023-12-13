-- Ini adalah adder floating point dengan spesifikasi double dengan IEE 754
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Adder is
    Port (
        InAddA : in STD_LOGIC_VECTOR(63 downto 0);
        InAddB : in STD_LOGIC_VECTOR(63 downto 0);
        OutSum : out STD_LOGIC_VECTOR(63 downto 0);
        OutOverflow : out STD_LOGIC;
        clk, rst : in STD_LOGIC
    );
end Adder;

architecture Behavioral of Adder is
    signal A_Mantissa, B_Mantissa, Sum_Mantissa : STD_LOGIC_VECTOR(52 downto 0); -- Extended for carry
    signal A_Exponent, B_Exponent, Sum_Exponent : STD_LOGIC_VECTOR(10 downto 0);
    signal A_Sign, B_Sign, Sum_Sign : STD_LOGIC;
    signal Carry : STD_LOGIC;
    signal Exponent_Difference : integer;
    signal AddResult : STD_LOGIC_VECTOR(53 downto 0);


    -- Function to add mantissas with carry
    function AddMantissas(A, B: STD_LOGIC_VECTOR(52 downto 0)) return STD_LOGIC_VECTOR is
        variable Result : STD_LOGIC_VECTOR(53 downto 0); -- Extended to include carry
        variable carry_var : STD_LOGIC := '0';
    begin
        for i in 0 to 52 loop
            Result(i) := A(i) xor B(i) xor carry_var;
            carry_var := (A(i) and B(i)) or (carry_var and (A(i) xor B(i)));
        end loop;
        Result(53) := carry_var; -- Store the carry in the 53rd bit
        return Result;
    end AddMantissas;

    function ShiftMantissaRight(Mantissa: STD_LOGIC_VECTOR(52 downto 0); ShiftAmount: integer) return STD_LOGIC_VECTOR is
        variable carry_var : STD_LOGIC_VECTOR(ShiftAmount downto 1);
    begin
        if ShiftAmount > 0 and ShiftAmount <= 52 then
            carry_var := (others => '0');
            return  Mantissa(52 downto ShiftAmount) & carry_var;
        else
            return Mantissa;
        end if;
    end ShiftMantissaRight;
    

begin
    add: process(clk, rst)
    begin
        if rst = '1' then
            OutOverflow <= '0';
            OutSum <= (others => '0');
        elsif rising_edge(clk) then
            -- Decompose inputs into sign, exponent, and mantissa
            A_Sign <= InAddA(63);
            A_Exponent <= InAddA(62 downto 52);
            A_Mantissa <= '1' & InAddA(51 downto 0); -- Implicit leading bit

            B_Sign <= InAddB(63);
            B_Exponent <= InAddB(62 downto 52);
            B_Mantissa <= '1' & InAddB(51 downto 0); -- Implicit leading bit

            -- Align mantissas based on exponent difference
            Exponent_Difference <= to_integer(unsigned(A_Exponent)) - to_integer(unsigned(B_Exponent));
            if Exponent_Difference > 0 then
                B_Mantissa <= ShiftMantissaRight(B_Mantissa, Exponent_Difference);
                Sum_Exponent <= A_Exponent;
            else
                A_Mantissa <= ShiftMantissaRight(A_Mantissa, -Exponent_Difference);
                Sum_Exponent <= B_Exponent;
            end if;

            --add result to temp var, the 53rd bit is the carry
            AddResult <= AddMantissas(A_Mantissa, B_Mantissa);

            -- Add or subtract mantissas based on sign
            if A_Sign = B_Sign then
                Sum_Mantissa <= AddResult(52 downto 0);
                Sum_Sign <= A_Sign;
            else
                -- Subtraction logic would be needed here
            end if;

            -- Normalize the result
            if Sum_Mantissa(52) = '1' then
                -- Right shift and increase exponent
                Sum_Mantissa <= '1' & Sum_Mantissa(52 downto 1);
                Sum_Exponent <= std_logic_vector(unsigned(Sum_Exponent) + 1);
            end if;

            -- Output the result
            OutSum <= Sum_Sign & Sum_Exponent & Sum_Mantissa(51 downto 0);
            OutOverflow <= AddResult(53); -- Simple overflow indication
        end if;
    end process add;
end Behavioral;
