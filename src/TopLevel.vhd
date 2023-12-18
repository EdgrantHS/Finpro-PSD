library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TopLevel is
    port (
        ControlWord : in std_logic_vector (64 downto 0);
        FloatSum : out std_logic_vector (31 downto 0);
        CarryFlag : out std_logic;    
    );
end entity TopLevel;

architecture rtl of TopLevel is
    
begin
    
    
    
end architecture rtl;