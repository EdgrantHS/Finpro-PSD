### 1. Dataflow Style
Dataflow modeling in VHDL is used to describe the flow of data and the relationships between different parts of the circuit using concurrent statements. For a double adder, you'd use `assign` statements to define how the sum and carry are generated from the input bits.

Example:
```vhdl
entity DoubleAdder is
    Port ( A, B, C : in std_logic;
           Sum, Carry : out std_logic);
end DoubleAdder;

architecture Dataflow of DoubleAdder is
begin
    Sum <= A xor B xor C;
    Carry <= (A and B) or (B and C) or (C and A);
end Dataflow;
```

### 2. Behavioral Style
Behavioral modeling describes how the system behaves using sequential statements. This style is more about writing code that looks like a software program.

Example:
```vhdl
architecture Behavioral of DoubleAdder is
begin
    process(A, B, C)
    begin
        Sum <= A xor B xor C;
        Carry <= (A and B) or (B and C) or (C and A);
    end process;
end Behavioral;
```

### 3. Testbench
A testbench is used to simulate and verify the functionality of your VHDL design. It provides stimulus to your double adder and checks the outputs.

Example:
```vhdl
entity DoubleAdder_tb is
-- Testbench has no ports
end DoubleAdder_tb;

architecture test of DoubleAdder_tb is
    signal A, B, C, Sum, Carry: std_logic;
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.DoubleAdder
        port map ( A => A, B => B, C => C, Sum => Sum, Carry => Carry );

    -- Stimulus process
    stimulus: process
    begin
        -- Define test cases here
        wait;
    end process stimulus;
end test;
```

### 4. Structural Style
Structural modeling in VHDL describes a design in terms of its components and how they are connected together. You would define components like gates or other adders and connect them to create your double adder.

Example:
```vhdl
architecture Structural of DoubleAdder is
    component FullAdder
        Port ( A, B, Cin : in std_logic;
               Sum, Cout : out std_logic);
    end component;
    signal interm_sum, interm_carry: std_logic;
begin
    FA1: FullAdder port map(A, B, '0', interm_sum, interm_carry);
    FA2: FullAdder port map(interm_sum, C, '0', Sum, Carry);
end Structural;
```

### 5. Looping
In VHDL, loops can be used in the process block for repetitive operations. However, loops in hardware description usually don't imply "time-based" repetition but rather creating multiple instances of hardware structures.

Example:
```vhdl
process
begin
    for i in 0 to 3 loop
        -- Repetitive hardware operation
    end loop;
end process;
```

### 6. Function
Functions in VHDL are used to encapsulate reusable logic. You can write a function for a part of your double adder and then use it in your design.

Example:
```vhdl
function adder_function(A, B: std_logic) return std_logic is
begin
    return A xor B; -- Simple example
end function;
```

### 7. FSM (Finite State Machine)
Implementing an FSM in VHDL involves defining states, transitions, and outputs based on inputs and current state. This might be an advanced feature for a double adder, but you can integrate it for controlling parts of your design.

Example:
```vhdl
type state_type is (IDLE, ADD, DONE);
signal state: state_type;
-- FSM implementation goes here
```

### 8. Microcomputing
This is a broad term and can involve creating a small-scale processor or controller in VHDL. It's a complex task and might be beyond the scope of a double adder project unless your adder is a part of a larger microcomputing system.

### General Tips:
- Always begin with a clear plan of your circuit.
- Simulate each part separately before integrating them.
- Keep track of signal types and conversions.
- Ensure that your testbench thoroughly tests all possible input combinations.

Remember, the complexity of each part can vary greatly depending on the requirements of your project and the level of detail you wish to achieve.