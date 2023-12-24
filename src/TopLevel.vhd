library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TopLevel is
    port (
        ControlWord : in std_logic_vector (64 downto 0);
        clk         : in std_logic;
        rst         : in std_logic;
        FloatOut    : out std_logic_vector (31 downto 0);
        CarryFlag   : out std_logic;
        Done        : out std_logic
    );
end entity TopLevel;

architecture rtl of TopLevel is
    signal FloatNumA, FloatNumB : std_logic_vector(31 downto 0);
    signal SignSelect           : std_logic;

    signal FloatAdderOut        : std_logic_vector(31 downto 0);
    signal FloatAdderCarryFlag  : std_logic;
    signal FloatAdderDone       : std_logic;

    -- Microprogramming Constants for FloatAdder
    constant FETCH_MICROOP      : std_logic_vector(2 downto 0) := "000";
    constant DECODE_MICROOP     : std_logic_vector(2 downto 0) := "001";
    constant SHIFT_MICROOP      : std_logic_vector(2 downto 0) := "010";
    constant ADD_MICROOP        : std_logic_vector(2 downto 0) := "011";
    constant NORMALIZE_MICROOP  : std_logic_vector(2 downto 0) := "100";
    constant OUTPUT_MICROOP     : std_logic_vector(2 downto 0) := "101";

    -- Microprogram Counter for FloatAdder
    signal floatAdderMicroCounter : std_logic_vector(2 downto 0) := (others => '0');

    -- Component Declarations
    component Decoder
        port (
            ControlWord : in std_logic_vector (64 downto 0);
            FloatNumA   : out std_logic_vector (31 downto 0);
            FloatNumB   : out std_logic_vector (31 downto 0);
            SignSelect  : out std_logic
        );
    end component;

    component FloatAdder
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
    end component;

    -- Variable declarations
    signal signA, signB : std_logic;
    signal exponentA, exponentB : integer;
    signal mantissaA, mantissaB : std_logic_vector(23 downto 0);
    signal signO : std_logic;
    signal exponent : integer;
    signal mantissa : std_logic_vector(23 downto 0);
    signal differnce : integer;

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

    -- Function Shift_Right(unsigned SLV, int shift):
    --     // Unsigned shift right for mantissa normalization
    function Shift_Right(value : unsigned; shift : integer) return unsigned is
        variable result : unsigned(23 downto 0);
    begin
        result := shift_right(value, shift);
        return result;
    end function;

    -- Function Assemble(SLV sign, int exponent, SLV mantissa) -> (SLV float32):
    --     // Assemble the 32-bit floating-point number from sign, exponent, and mantissa
    function Assemble(sign : std_logic; exponent : integer; mantissa : std_logic_vector) return std_logic_vector is
        variable result : std_logic_vector(31 downto 0);
    begin
        result := (others => '0');
        result(31) := sign;
        result(30 downto 23) := std_logic_vector(to_unsigned(exponent + 127, 8));
        result(22 downto 0) := mantissa(22 downto 0);
        return result;
    end function;

begin
    -- Instantiate the Decoder
    Decoder_inst : Decoder
        port map (
            ControlWord => ControlWord,
            FloatNumA   => FloatNumA,
            FloatNumB   => FloatNumB,
            SignSelect  => SignSelect
        );

    -- Instantiate the FloatAdder
    FloatAdder_inst : FloatAdder
        port map (
            FloatNumA   => FloatNumA,
            FloatNumB   => FloatNumB,
            clk         => clk,
            rst         => rst,
            SignSelect  => SignSelect,
            FloatOut    => FloatAdderOut,
            CarryFlag   => FloatAdderCarryFlag,
            Done        => FloatAdderDone
        );
        
    -- Output signals
    FloatOut <= FloatAdderOut;
    CarryFlag <= FloatAdderCarryFlag;
    Done <= FloatAdderDone;

    process(clk, rst)
    begin
        if rst = '1' then
            floatAdderMicroCounter <= (others => '0');
        elsif rising_edge(clk) then
            case floatAdderMicroCounter is
                when FETCH_MICROOP =>
                    FloatOut <= (others => '0');
                    CarryFlag <= '0';
                    Done <= '1';
                    floatAdderMicroCounter <= DECODE_MICROOP;

                when DECODE_MICROOP =>
                    if (FloatNumA = "00000000000000000000000000000000") and (FloatNumB = "00000000000000000000000000000000") then
                        FloatOut <= (others => '0');
                        CarryFlag <= '0';
                        Done <= '1';
                        floatAdderMicroCounter <= FETCH_MICROOP;
                    else 
                        floatAdderMicroCounter <= SHIFT_MICROOP;
                    end if;

                when SHIFT_MICROOP =>
                    -- Step 3: Align the mantissas
                    if exponentA > exponentB then
                        mantissaB <= ShiftRight(mantissaB, exponentA - exponentB);
                        exponent  <= exponentA;
                    else
                        mantissaA <= ShiftRight(mantissaA, exponentB - exponentA);
                        exponent  <= exponentB;
                    end if;

                    differnce <= exponentA - exponentB;
                    
                    floatAdderMicroCounter <= ADD_MICROOP;

                when ADD_MICROOP =>
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

                    floatAdderMicroCounter <= NORMALIZE_MICROOP;

                when NORMALIZE_MICROOP =>
                    -- Step 5: Normalize the result
                    exponent <= exponent + 127;
                    mantissa <= std_logic_vector(Shift_Right(unsigned(mantissa), 1));
                    if mantissa(23) = '1' then
                        exponent <= exponent + 1;
                        mantissa <= ShiftRight(mantissa, 1);
                    end if;

                    floatAdderMicroCounter <= OUTPUT_MICROOP;

                when OUTPUT_MICROOP =>
                    -- Step 6: Assemble the result
                    FloatOut <= Assemble(signO, exponent, mantissa);
                    CarryFlag <= '0';
                    Done <= '1';     
                    floatAdderMicroCounter <= FETCH_MICROOP;

                when others =>
                    floatAdderMicroCounter <= FETCH_MICROOP;
            end case;
        end if;
    end process;

end architecture rtl;