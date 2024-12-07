# This test ensures compatibility between our pipelined processor and Project 1's single-cycle design.
# It systematically tests arithmetic, logical, memory, shift, and control flow instructions.

.data
.text
.globl main
main:
    # Basic Arithmetic
    addi $1, $0, 10        # Immediate add
    addi $2, $0, 20
    add  $3, $1, $2        # Register add
    sub  $4, $2, $1        # Subtraction
    
    # Logical Operations
    andi $5, $1, 15        # Immediate AND
    or   $6, $1, $2        # Register OR
    xor  $7, $1, $2        # XOR
    
    # Memory Operations
    lui  $11 0x1001	    # Set up base address
    sw   $11, 0($11)         # Store
    lw   $8, 0($11)         # Load
    
    # Shifts
    sll  $9, $1, 2         # Shift left
    srl  $10, $2, 1        # Shift right
    
    # Branches and Jumps
    beq  $1, $1, target1   # Branch taken
    j    error             # Should skip
target1:
    bne  $1, $2, target2   # Branch taken
    j    error             # Should skip
target2:
    j    end               # Direct jump
error:
    addi $11, $0, 255      # Should not execute
end:
    halt
