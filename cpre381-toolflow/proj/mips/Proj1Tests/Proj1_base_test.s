.data
.text
.globl main
main: 

    # Start Test
    addi $1, $0, 1
    add $1, $1, $1
    add $2, $1, $1
    add $3, $2, $2
    addiu $4, $0, -16
    addu $5, $4, $4
    and $6, $5, $4
    andi $7, $6, 256
    lui $8, 0xFFFF
    sw $8, 0($5)
    lw $9, 0($5)
    nor $10, $9, $7
    or $11, $10, $8
    ori $12, $11, 0x00FF
    sll $13, $12, 26
    sra $14, $13, 25
    srl $15, $13, 25
    slt $16, $2, $4
    slti $17, $3, 1
    sub $18, $13, $3
    subu $19, $12, $6
    xor $20, $13, $8
    xori $21, $16, 0x6789
    # End Test

    # Exit program
    halt
