.data
.text
.globl main
main: 
    # Test arithmetic with proper spacing to avoid hazards
    addi $1, $0, 1           # $1 = 1
    addi $2, $0, 2           # No hazard with $1
    add  $3, $1, $2          # Use $1,$2 after they're ready
    nop                      # Avoid hazard with $3
    nop
    sub  $4, $3, $1          # Use $3 after NOPs
    
    # Test logical operations with scheduling
    ori  $5, $0, 0xFF        # $5 = 0xFF
    andi $6, $5, 0x0F        # Safe to use $5 immediately for andi
    or   $7, $5, $6          # Use both after they're ready
    nop
    xor  $8, $7, $5          # Add NOP before using $7
    
    # Test memory operations
    lui  $9, 0x1001          # Load base address
    nop                      # Avoid hazard with $9
    nop
    sw   $8, 0($9)           # Store after NOPs
    nop                      # Avoid hazard between sw and lw
    lw   $10, 0($9)          # Load after NOP
    
    # Test shifts with scheduling
    addi $11, $0, 0x4        # Set up value
    nop
    sll  $12, $11, 2         # Shift left after NOP
    nop
    srl  $13, $12, 1         # Shift right after NOP
    sra  $14, $13, 1         # Safe to do immediately
    
    # Test branches (properly spaced)
    beq  $0, $0, branch1     # Always taken
    nop                      # Branch delay slot
    nop                      # Never executed
branch1:
    addi $15, $0, 5          # After branch
    nop
    bne  $15, $0, branch2    # Always taken
    nop                      # Branch delay slot
branch2:
    
    # Test jumps with proper spacing
    j    jump1               # Direct jump
    nop                      # Jump delay slot
    
jump1:
    jal  jump2               # Link and jump
    nop                      # Jump delay slot
    
jump2:
    jr   $31                 # Jump register
    nop                      # Jump delay slot

    # End Test
    halt