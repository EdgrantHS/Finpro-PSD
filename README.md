# Implementasi Penjumlahan Angka Floating Point FPGA
The project aims to develop a high-performance FLoating Point Adder on a Field-Programmable Gate Array (FPGA). Floating point arithmetic is crucial for a variety of applications that demand high precision. The implementation on an FPGA provides flexibility, parallelism, and optimization possibilities, making it an ideal platform for intensive numerical computations.

# COMPONENT
## 1. Adder (Async)
This component is responsible for performing asynchronous addition operations on floating point numbers. Using an asynchronous design allows for faster and more efficient computing processes. This design involves forming appropriate mantissa pairs and handling exponents to produce accurate addition results.
## 2. Float Adder (Sync)
Float Adder is the core of the floating point addition operation on the FPGA. By using a synchronous design, these components can be seamlessly integrated into existing FPGA architectures. A synchronous implementation allows synchronization of floating point operations with the FPGA system clock, improving coordination and reliability of operations.
## 3. Decoder (Async)
The decoder functions as a control and address signal decoder, guiding the input to the appropriate component. By using an asynchronous design, the decoder can respond to state changes more quickly, ensuring good coordination between the components involved.
## 4. Top-Level
Top-Level Design is an aggregation of previous components, forming the main architecture of a floating point adder on an FPGA. Communication between components is regulated using control signals managed by the decoder. This design also takes into account the selection of the FPGA type that supports the desired speed and performance.

# IMPLEMENTATION IN EACH MODULE
## Dataflow Style
The Sync Float Adder component is designed using the dataflow style. In dataflow architecture, operations are executed whenever their input data becomes available. For the full integer adder implementation:
### Objective
Implement a full integer adder for efficient floating-point addition.
### Implementation Explanation
Utilizing the dataflow style, the full integer adder can be designed to take advantage of parallelism and optimize resource utilization. The dataflow architecture allows for continuous computation as soon as the required inputs are available.

## Behavioral Style
The Async Decoder component, responsible for directing inputs, and Testbench is implemented using the behavioral style:
### Objective
Implement a signal and address decoder using the behavioral style and implement testbenches for all modules using the behavioral style.
### Implementation Explanation
Behavioral style focuses on describing functionality rather than internal structure. The decoder is designed to respond to changes in input signals asynchronously, providing flexibility and simplicity in its operation.
Behavioral style in testbenches involves specifying the expected behavior and responses of the modules under various conditions. Testbenches aim to validate correct functionality and identify potential issues through simulation.

## Structural Style
The Structural Style Component involves implementing a full integer adder:
### Objective
Implement a full integer adder using structural style.
### Implementation Explanation
Structural style focuses on describing the components and their interconnections. This approach enhances modularity and maintainability by explicitly defining the structure of the adder.

## Looping 
The Looping Component implements shifting using a loop:
### Objective
Implement shifting using a loop for flexibility and readability.
### Implementation Explanation
The loop structure allows for concise and flexible shifting operations. Looping simplifies repetitive tasks and enhances the readability of the code.

## Function
The Function Component implements shifting using a function:
### Objective
Implement shifting using a function for modularity and code reusability.
### Implementation Explanation
Functions encapsulate specific functionalities, promoting code reuse and modularity. This approach enhances maintainability and readability by isolating the shifting operation into a separate function.

## FSM (Finite State Machine)
The FSM Component implements the top-level state machine with states (idle -> fetch -> decode -> shift -> add -> shift -> output -> idle):
### Objective
Implement a Finite State Machine (FSM) representing the top-level control flow.
### Implementation Explanation
The FSM guides the overall operation by transitioning between different states. Each state represents a specific stage in the floating-point addition process, providing control and coordination.

## Microcomputing
The Microcomputing Component implements microcomputing with a control word format (signed/unsigned + angka 1 + angka 2):
### Objective
Implement microcomputing with a control word format for arithmetic computations.
### Implementation Explanation
Microcomputing involves using a compact control word format to specify the operation and operands. The control word guides the microcomputing unit to perform signed or unsigned addition with the specified operands.

# TESTING
## Synthesize: 
<img width="1121" alt="image" src="https://github.com/EdgrantHS/Finpro-PSD/assets/63389410/61a9b900-59fc-4bb6-bbdd-048b38b442da">

## Waveform:
<img width="1511" alt="image" src="https://github.com/EdgrantHS/Finpro-PSD/assets/63389410/5fcf766e-9f19-4363-8257-487acbeba572">


For more information, see [our report](https://docs.google.com/presentation/d/1HWBhs-hcO2FmkW1dZNwbxAaB9UCuj2YSHrkPxbCVEP4/edit?usp=sharing) in this project.
