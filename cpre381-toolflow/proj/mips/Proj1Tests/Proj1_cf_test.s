.data
.text
.globl main
main: 

    # Start Test
    addi $1, $0, 1
    addi $2, $1, 0
    add $3, $2, $2
    add $3, $0, $2

    beq $1, $2, label4

label1:
    jr $31


label2:
    j label1


label3:
    bne $2, $4, label2


label4:
    
    beq $1, $3, exit
    jal label3
    jal label6

label5:
    jal label6

exit:
    halt 

label6:
    beq $1, $2, label1
