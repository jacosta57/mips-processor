.data
array: .word 5, 2, 8, 1, 9, 3, 7, 4, 6, 0    # 10 elements to sort
size:  .word 10

.text
.globl main
main:
    # Register usage same as original:
    # $s0 = base address of array
    # $s1 = size of array
    # $t0 = i (outer loop counter)
    # $t1 = j (inner loop counter)
    # $t2 = size - i - 1 (inner loop limit)
    # $t3 = array index calculation
    # $t4 = array[j]
    # $t5 = array[j+1]

    lui $s0, 0x1001           # Load upper immediate for array address
    lw  $s1, size            # Load array size
    nop                      # Avoid hazard with $s1
    add $t0, $0, $0          # i = 0

outer_loop:
    add $t1, $0, $0          # j = 0
    sub $t2, $s1, $t0        # t2 = size - i
    nop                      # Avoid hazard with $t2
    addi $t2, $t2, -1        # t2 = size - i - 1

inner_loop:
    # Calculate array index - Example 1 of optimized scheduling:
    # No NOPs needed between these as sll uses $t1 and add uses $t3
    sll $t3, $t1, 2          # t3 = j * 4
    add $t3, $s0, $t3        # t3 = base + j*4
    
    # Load elements - Example 2 of optimized scheduling:
    # Only one NOP needed between loads as they use different addresses
    lw  $t4, 0($t3)          # t4 = array[j]
    nop                      # Single NOP sufficient
    lw  $t5, 4($t3)          # t5 = array[j+1]
    
    # Compare elements - Example 3 of optimized scheduling:
    # No NOPs needed between slt and beq as they're independent
    nop                      # Wait for $t4 and $t5
    slt $t6, $t5, $t4        # t6 = 1 if array[j+1] < array[j]
    beq $t6, $0, no_swap     # Skip swap if t6 = 0
    nop                      # Branch delay slot
    
    # Swap elements
    sw  $t5, 0($t3)          # array[j] = t5
    sw  $t4, 4($t3)          # array[j+1] = t4

no_swap:
    addi $t1, $t1, 1         # j++
    nop                      # Avoid hazard with next slt
    slt $t6, $t1, $t2        # t6 = 1 if j < size-i-1
    bne $t6, $0, inner_loop  # if j < size-i-1, continue inner loop
    nop                      # Branch delay slot

    addi $t0, $t0, 1         # i++
    nop                      # Avoid hazard with next slt
    slt $t6, $t0, $s1        # t6 = 1 if i < size
    bne $t6, $0, outer_loop  # if i < size, continue outer loop
    nop                      # Branch delay slot

    halt