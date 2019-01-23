.data


# First Example: Machine1: {{q0},{qf},{{q0,b,b,R,q0},{q0,1,1,R,q1},{q1,1,1,R,q1},{q1,b,1,R,qf}}}
# Input1: {b,b,1,1,1,b,b}

#Glossary:
# 1 corresponds to 1
# 2 corresponds to b
# 3 corresponds to q0
# 4 corresponds to qf or qa (first final state)
# 5 corresponds to q1
# 6 corresponds to q2
# 7 corresponds to Right
# 8 corresponds to Left
# 9 corresponds to qu (second final state)

# Save the machine as a word
Machine: .word 3 2 2 7 3 3 1 1 7 5 3 0 0 7 9 5 1 1 7 5 5 2 2 8 4 5 0 0 7 9

# Save the Input list as a word
Input: .word 2 2 1 1 1 2 2

message1: .asciiz "\n The final state is: \n"
message2: .asciiz "\n The final state is reached \n The result is: \n"
virgule: .asciiz ", "





.text


# Initialization

# $t0 is the position of the Machine
li $t0, 0

# $t1 is the position of the Input
li $t1, 0

# $t2 is the current state
li $t2, 3



# Main program

# Test if the current state is the final state
TestFinalState:
beq $t2, 4, Finish
beq $t2, 9, Finish

# Test if the current state is the right state
TestCurrentState:
lw $t3, Machine($t0)
beq $t2, $t3, TestInput

# Change the transition of the Machine
ChangeState:
add $t0, $t0, 20
j TestCurrentState






end:

# Syscall to end
li $v0, 10
syscall


TestInput:
add $t0, $t0, 4
lw $t3, Machine($t0)
lw $t4, Input($t1)
beq $t3, $t4, Replacement
sub $t0, $t0, 4
j ChangeState


Replacement:
add $t0, $t0, 4
lw $t3, Machine($t0)
la $t5, Input($t1)
sw $t3, ($t5)
add $t0, $t0, 4
lw $t3, Machine($t0)
beq $t3, 7, RightMovement
beq $t3, 8, LeftMovement


RightMovement:
add $t1, $t1, 4
add $t0, $t0, 4
lw $t2, Machine($t0)
li $t0, 0
j TestFinalState


LeftMovement:
sub $t1, $t1, 4
add $t0, $t0, 4
lw $t2, Machine($t0)
li $t0, 0
j TestFinalState


Finish:

li $v0, 4           # Print the message1
la $a0, message1
syscall
li $v0, 1           # Print the final state
move $a0, $t2
syscall

li $v0, 4           # Print the message2
la $a0, message2
syscall

la $a1, Input
li $t0, 1
move $t1, $a1
addi $t2, $a1, 28

loop:             # Start a loop to recover the elements of the output
lw $t0, ($t1)
li $v0, 1
move $a0, $t0
syscall

li $v0, 4         #  Print the virgule message
la $a0, virgule
syscall

addi $t1, $t1, 4
bne $t1, $t2, loop

li $v0, 10        # End the program
syscall
