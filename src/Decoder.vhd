library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decoder is
    port (
        ControlWord : in std_logic_vector (64 downto 0);
        FloatNumA : out std_logic_vector (31 downto 0);
        FloatNumB : out std_logic_vector (31 downto 0);
        SignSelect : out logic_vector        
    );
end entity Decoder;

architecture rtl of Decoder is
    
begin
    
    
    
end architecture rtl;