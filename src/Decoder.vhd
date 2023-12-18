library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decoder is
    port (
        ControlWord : in std_logic_vector (64 downto 0);
        FloatNumA : out std_logic_vector (31 downto 0);
        FloatNumB : out std_logic_vector (31 downto 0);
        SignSelect : out std_logic        
    );
end entity Decoder;

architecture rtl of Decoder is
    
begin
    FloatNumA <= ControlWord(31 downto 0);
    FloatNumB <= ControlWord(63 downto 32);
    SignSelect <= ControlWord(64);
end architecture rtl;