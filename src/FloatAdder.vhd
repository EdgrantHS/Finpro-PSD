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
    
    
    
end architecture rtl;