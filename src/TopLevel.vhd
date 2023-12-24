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
    type StateType is (Idle, Decode, Execution, Output);
    signal state : StateType := Idle;
    signal next_state : StateType := Idle;

    signal FloatNumADecOut, FloatNumBDecOut : std_logic_vector(31 downto 0);
    signal FloatNumAFAIn, FloatNumBFAIn : std_logic_vector(31 downto 0);
    signal SignSelectDecOut     : std_logic;
    signal SignSelectFAIn     : std_logic;
    signal RstFAIn     : std_logic;

    signal FloatAdderOut        : std_logic_vector(31 downto 0);
    signal FloatAdderCarryFlag  : std_logic;
    signal FloatAdderDone       : std_logic;
    signal ControlWordDecIn : std_logic_vector (64 downto 0);

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

begin

    -- Instantiate the Decoder
    Decoder_inst : Decoder
        port map (
            ControlWord => ControlWordDecIn,
            FloatNumA   => FloatNumADecOut,
            FloatNumB   => FloatNumBDecOut,
            SignSelect  => SignSelectDecOut
        );

    -- Instantiate the FloatAdder
    FloatAdder_inst : FloatAdder
        port map (
            FloatNumA   => FloatNumAFAIn,
            FloatNumB   => FloatNumBFAIn,
            clk         => clk,
            rst         => RstFAIn,
            SignSelect  => SignSelectFAIn,
            FloatOut    => FloatAdderOut,
            CarryFlag   => FloatAdderCarryFlag,
            Done        => FloatAdderDone
        );

    process(clk, rst)
    begin
        if rst = '1' then
            state <= Idle;
        elsif rising_edge(clk) then
            case state is
                when Idle =>
                    -- reset signals    
                    -- FloatNumADecOut <= (others => '0');
                    -- FloatNumBDecOut <= (others => '0');
                    -- FloatNumAFAIn <= (others => '0');
                    -- FloatNumBFAIn <= (others => '0');
                    -- SignSelectDecOut <= '0';
                    -- SignSelectFAIn <= '0';
                    RstFAIn <= '1';
                    -- FloatAdderOut <= (others => '0');
                    -- FloatAdderCarryFlag <= '0';
                    -- FloatAdderDone <= '0';
                    -- ControlWordDecIn <= (others => '0');

                    next_state <= Decode;
                    
                when Decode =>
                    -- Input signals
                    ControlWordDecIn <= ControlWord;
                        
                    next_state <= Execution;

                when Execution =>
                    if FloatAdderDone = '1' then
                        -- Output signals
                        FloatNumAFAIn <= FloatNumADecOut;
                        FloatNumBFAIn <= FloatNumBDecOut;
                        SignSelectFAIn <= SignSelectDecOut;
                        RstFAIn <= '0';

                        next_state <= Output;
                    else
                        next_state <= Execution;
                    end if;

                when Output =>
                    -- Output signals
                    FloatOut <= FloatAdderOut;
                    CarryFlag <= FloatAdderCarryFlag;
                    Done <= FloatAdderDone;
                    
                    next_state <= Idle;
            end case;
        end if;
    end process;
end architecture rtl;