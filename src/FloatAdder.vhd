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
    --State Machine (idle -> fetch -> decode -> shift -> add -> shift -> output)
    type StateType is (idle, fetch, decode, shift, add, normalize, output);

    signal state : StateType := idle;
    signal next_state : StateType := idle;

    -- Variable declarations
    signal signO : std_logic;
    signal exponent : integer;
    signal mantissa : std_logic_vector(23 downto 0);

    signal signA, signB : std_logic;
    signal exponentA, exponentB : integer;
    signal mantissaA, mantissaB : std_logic_vector(23 downto 0);

    signal differnce : integer;
begin
    -- main process
    main: process (clk, rst)     
        -- Function getFraction(float32 number) -> (SLV(sign + mantissa)):
        --     // Extract sign and mantissa from the 32-bit floating-point number    
        function getFraction(number : std_logic_vector) return std_logic_vector is
            variable result : std_logic_vector(23 downto 0);
        begin
            result := '1' & number(22 downto 0);
            return result;
        end function;

        -- Function getExponent(float32 number) -> (SLV exponent):
        --     // Extract exponent from the 32-bit floating-point number
        function getExponent(number : std_logic_vector) return integer is
            variable result : integer;
        begin
            result := to_integer(unsigned(number(30 downto 23))) - 127;
            return result;
        end function;

        -- Function getSign(float32 number) -> (SLV sign):
        --     // Extract sign from the 32-bit floating-point number
        function getSign(number : std_logic_vector) return std_logic is
            variable result : std_logic;
        begin
            result := number(31);
            return result;
        end function;
        -- Function ShiftRight(SLV mantissa, int shift):
        --     // Right shift/left the mantissa by 'shift' places, handling overflow/underflow
        function ShiftRight(mantissa : std_logic_vector; shift : integer) return std_logic_vector is
            variable result : std_logic_vector(23 downto 0);
        begin
            -- shift right by 'shift' places, also can handle negative
            -- shift values (shift left)
            if shift >= 0 then
                result := std_logic_vector(shift_right(unsigned(mantissa), shift));
            else
                result := std_logic_vector(shift_left(unsigned(mantissa), -shift));
            end if;

            return result;
        end function;

        -- Function Assemble(mantissa, exponent) -> float32:
        --     // Assemble the 32-bit floating-point number from sign, exponent, and mantissa
        function Assemble(signO : std_logic; exponent : integer; mantissa : std_logic_vector) return std_logic_vector is
            variable result : std_logic_vector(31 downto 0);
        begin
            result := signO & std_logic_vector(to_signed(exponent, 8)) & mantissa (22 downto 0);
            return result;
        end function;
    begin

        if rst = '1' then
            FloatOut <= (others => '0');
            CarryFlag <= '0';
            Done <= '0';
        elsif rising_edge(clk) then
            case state is
                when idle =>
                    Done <= '0';
                    next_state <= fetch;

                when fetch =>
                    -- Step 2: handle zeros
                    if (FloatNumA = "00000000000000000000000000000000") and (FloatNumB = "00000000000000000000000000000000") then
                        FloatOut <= (others => '0');
                        CarryFlag <= '0';
                        Done <= '1';
                        next_state <= idle;
                    else 
                        next_state <= decode;
                    end if;
                when decode =>
                    -- Step 1: Decompose each number into sign, exponent, and mantissa
                    signA     <= getSign(FloatNumA);
                    exponentA <= getExponent(FloatNumA);
                    mantissaA <= getFraction(FloatNumA);
            
                    signB     <= getSign(FloatNumB);
                    exponentB <= getExponent(FloatNumB);
                    mantissaB <= getFraction(FloatNumB);
                    Done <= '0';
                    next_state <= shift;

                when shift =>
                    -- Step 3: Align the mantissas
                    if exponentA > exponentB then
                        mantissaB <= ShiftRight(mantissaB, exponentA - exponentB);
                        exponent  <= exponentA;
                    else
                        mantissaA <= ShiftRight(mantissaA, exponentB - exponentA);
                        exponent  <= exponentB;
                    end if;

                    differnce <= exponentA - exponentB;
                    
                    next_state <= add;

                when add =>
                    -- Step 4: Add or subtract the mantissas based on the signs
                    if signA = signB then
                        mantissa <= std_logic_vector(unsigned(mantissaA) + unsigned(mantissaB));
                        signO <= signA;
                    else
                        if mantissaA > mantissaB then
                            mantissa <= std_logic_vector(unsigned(mantissaA) - unsigned(mantissaB));
                            signO <= signA;
                        else
                            mantissa <= std_logic_vector(unsigned(mantissaB) - unsigned(mantissaA));
                            signO <= signB;
                        end if;
                    end if;
                    next_state <= normalize;

                when normalize =>
                    -- Step 5: Normalize the result
                    exponent <= exponent + 127;
                    mantissa <= std_logic_vector(Shift_Right(unsigned(mantissa), 1));
                    if mantissa(23) = '1' then
                        exponent <= exponent + 1;
                        mantissa <= ShiftRight(mantissa, 1);
                    end if;
                    next_state <= output;
                    
                when output =>
                    -- Step 6: Assemble the result
                    FloatOut <= Assemble(signO, exponent, mantissa);
                    CarryFlag <= '0';
                    Done <= '1';     
                    next_state <= idle;
                    
                when others =>
                    next_state <= idle;
            end case;
        end if;
    end process main;

    -- handle the state machine
    state_machine: process (clk, rst)
    begin
        if rst = '1' then
            state <= idle;
        elsif falling_edge(clk) then
            state <= next_state;
        end if;
    end process state_machine;

end architecture rtl;