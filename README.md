32-bit arithmetic and logic unit (ALU) VHDL design. 
The design of the architecture for the circuit for the ual.vhd file was done via Quartus.

The ALU supports multiple operation types (ADD, SUB, AND, OR, SLT) and compares ALU outputs (result, zero, cout) against expected values to determine success or failure by reading input vectors from ual_entrees.txt and writing simulation results to ual_sorties.txt.

The testbench (UAL_tb.vhd) can be used with different vector generation strategies such as counters (compteurs), force, random (aléatoire), and text file (fichiersTexte). 

To simulate with a custom bit width (e.g., 16 bits), pass -gN=16 as a generic during simulation with ModelSim, e.g., vsim -gui work.UAL_tb -gN=16.
