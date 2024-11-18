# There are many other comments to make reading and debugging easier (MIPS is hard)

.data
array: .word 5, 2, 8, 1, 9, 3, 7, 4, 6, 0    # 10 elements to sort
size:  .word 10

.text
.globl main
main:
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
    add $t0, $0, $0          # i = 0

outer_loop:
    add $t1, $0, $0          # j = 0
    sub $t2, $s1, $t0        # t2 = size - i
    addi $t2, $t2, -1        # t2 = size - i - 1

inner_loop:
    # Calculate array index
    sll $t3, $t1, 2          # t3 = j * 4, 4 because it is a word offset
    add $t3, $s0, $t3        # t3 = base + j*4
    
    # Load elements to compare
    lw  $t4, 0($t3)          # t4 = array[j]
    lw  $t5, 4($t3)          # t5 = array[j+1]
    
    # Compare elements
    slt $t6, $t5, $t4        # t6 = 1 if array[j+1] < array[j]
    beq $t6, $0, no_swap     # Skip swap if t6 = 0
    
    # Swap elements
    sw  $t5, 0($t3)          # array[j] = t5
    sw  $t4, 4($t3)          # array[j+1] = t4

no_swap:
    addi $t1, $t1, 1         # j++
    slt $t6, $t1, $t2        # t6 = 1 if j < size-i-1
    bne $t6, $0, inner_loop  # if j < size-i-1, continue inner loop

    addi $t0, $t0, 1         # i++
    slt $t6, $t0, $s1        # t6 = 1 if i < size
    bne $t6, $0, outer_loop  # if i < size, continue outer loop

    halt
