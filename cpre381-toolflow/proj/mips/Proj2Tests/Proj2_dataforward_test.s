# This test verifies the processor's data forwarding unit by testing various forwarding paths
# including MEM to EX, WB to EX, load-use, multiple dependencies, and back-to-back dependencies.

.data
.text
.globl main
main:
    # Test 1: MEM to EX Forwarding
    addi $1, $0, 5         # Set initial value
    add  $2, $1, $0        # Forward from MEM stage
    nop
    
    # Test 2: WB to EX Forwarding
    addi $3, $0, 10        # Set initial value
    nop
    nop
    add  $4, $3, $0        # Forward from WB stage
    
    # Test 3: Load Use Forwarding
    addi $5, $0, 100       # Address setup
    sw   $1, 0($5)         # Store a value
    lw   $6, 0($5)         # Load the value
    nop
    add  $7, $6, $0        # Use loaded value
    
    # Test 4: Multiple Dependencies
    addi $8, $0, 15        # Set first value
    addi $9, $0, 20        # Set second value
    add  $10, $8, $9       # Forward both operands
    
    # Test 5: Back to Back Dependencies
    addi $11, $0, 25       # Set initial value
    add  $12, $11, $0      # First forward
    add  $13, $12, $0      # Second forward
    
    halt