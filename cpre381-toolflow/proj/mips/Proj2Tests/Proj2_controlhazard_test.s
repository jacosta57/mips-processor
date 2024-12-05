# This test validates the processor's handling of control flow instructions and hazards.
# It tests branches (taken/not taken), jumps (j/jal), and jump register (jr) operations.

.data
.text
.globl main
main:
    # Test 1: Basic Branch Taken
    addi $1, $0, 5
    addi $2, $0, 5
    beq  $1, $2, branch1   # Should take branch
    addi $3, $0, 1         # Should be skipped
branch1:
    addi $4, $0, 2         # Should execute after branch

    # Test 2: Branch Not Taken
    addi $5, $0, 10
    addi $6, $0, 15
    beq  $5, $6, branch2   # Should not take branch
    addi $7, $0, 3         # Should execute
branch2:
    
    # Test 3: Jump
    addi $8, $0, 4
    j jump1                # Test direct jump
    addi $9, $0, 5         # Should be skipped
jump1:
    addi $10, $0, 6        # Should execute after jump

    # Test 4: Jump and Link
    addi $11, $0, 7
    jal function1          # Test jal
    j end                  # Skip function body

function1:
    addi $12, $0, 8
    jr $31                 # Test jump register

end:
    halt