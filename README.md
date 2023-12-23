# Project Overview
The project aims to develop a high-performance FLoating Point Adder on a Field-Programmable Gate Array (FPGA). Floating point arithmetic is crucial for a variety of applications that demand high precision. The implementation on an FPGA provides flexibility, parallelism, and optimization possibilities, making it an ideal platform for intensive numerical computations.

# Component
## Adder (Async)
This component is responsible for performing asynchronous addition operations on floating point numbers. Using an asynchronous design allows for faster and more efficient computing processes. This design involves forming appropriate mantissa pairs and handling exponents to produce accurate addition results.
## Float Adder (Sync)
Float Adder is the core of the floating point addition operation on the FPGA. By using a synchronous design, these components can be seamlessly integrated into existing FPGA architectures. A synchronous implementation allows synchronization of floating point operations with the FPGA system clock, improving coordination and reliability of operations.
## Decoder (Async)
The decoder functions as a control and address signal decoder, guiding the input to the appropriate component. By using an asynchronous design, the decoder can respond to state changes more quickly, ensuring good coordination between the components involved.
## Top-Level
Top-Level Design is an aggregation of previous components, forming the main architecture of a floating point adder on an FPGA. Communication between components is regulated using control signals managed by the decoder. This design also takes into account the selection of the FPGA type that supports the desired speed and performance.
