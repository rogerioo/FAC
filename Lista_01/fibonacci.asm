.data
	Enter: .asciiz "Enter with the desired number of Fibonacci's arguments : " #Define the message to be print
	Result: .asciiz "The sequence is: "
	Space: .asciiz " "
.text
	li $v0, 4 #Load the immediate that referes to print a string
	la $a0, Enter #Load the message
		syscall #Call the system
	
	li $v0, 5 #Load the immediate that refers to read an interger in v0
		syscall #Call the system
	
	move $t0, $v0 #Save the user's input in t0
	
	li $v0, 4 #Load the immediate that referes to print a string
	la $a0, Result #Load the message
		syscall #Call the system
		
	li $v0, 1 #Load the immediate that referes to print an integer
	li $a0, 1 #Load the message
		syscall #Call the system
		
	li $v0, 4 #Load the immediate that referes to print a string
	la $a0, Space #Load the message
		syscall #Call the system
	
	li $v0, 1 #Load the immediate that referes to print an integer
	li $a0, 1 #Load the message
		syscall #Call the system
		
	li $v0, 4 #Load the immediate that referes to print a string
	la $a0, Space #Load the message
		syscall #Call the system
	
	li $t1, 3 #Load the number of terms that are already calculated
	li $t2, 1 #load the first term
	li $t3, 1 #load the second term
	
	jal Loop #Start the loop
	li  $v0,10 #Exit the program
    		syscall
	
.text
	Loop:
		seq $t4, $t0, $t1 #if t0 == t1, t4 = 1 | t4 = 0
		
		add $t5, $t2, $t3 # Calculate the next term
		move $t3, $t2 # Change the second term to the first
		move $t2, $t5 # Change the first term to the new one
		
		li $v0, 1 #Load the immediate that referes to print an integer
		move $a0, $t5 #Load the message
			syscall #Call the system
			
		li $v0, 4 #Load the immediate that referes to print a string
		la $a0, Space #Load the message
			syscall #Call the system
		
		addiu $t1, $t1, 1 #i++
		beqz $t4, Loop #if t4 = 0 return to Loop
		jr $ra #return to normal execution
