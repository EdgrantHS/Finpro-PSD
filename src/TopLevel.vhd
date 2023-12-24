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
    type StateType is (Idle, Decode, Execution);
    signal state : StateType := Idle;
    signal next_state : StateType := Idle;

    signal FloatNumA, FloatNumB : std_logic_vector(31 downto 0);
    signal SignSelect           : std_logic;

    signal FloatAdderOut        : std_logic_vector(31 downto 0);
    signal FloatAdderCarryFlag  : std_logic;
    signal FloatAdderDone       : std_logic;

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
    process(clk, rst)
    begin
        if rst = '1' then
            state <= Idle;
        elsif rising_edge(clk) then
            case state is
                when Idle =>
                    if rising_edge(clk) then
                        next_state <= Decode;
                    end if;
                    
                when Decode =>
                    if rising_edge(clk) then
                        next_state <= Execution;
                    end if;

                when Execution =>
                    if FloatAdderDone = '1' then
                        next_state <= Idle;
                    else
                        next_state <= Execution;
                    end if;
            end case;
        end if;
    end process;

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
end architecture rtl;