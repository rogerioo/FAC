# FAC: TRABALHO 04
# Coded by: Pedro Igor (17/0062635) & Rogério Júnior (17/0021751)

.data
entrada: .space	33        	# "array" of 32 bytes to contain entrada
bull:	 .space 3
saida:	 .space	260        	# "array" of 256 bytes to contain saida

.text
main:

	li $v0, 8       	# take in input

	la $a0, entrada  	# load byte space into address
	li $a1, 34      	# numero de caracteres a ser lido + 1 (NULL) --> Alterado para caber o enter do buffer | critério de parada
	syscall
      
# =================== IMPLEMENTE AQUI SUA SOLUCAO: INICIO

# O valor lido do teclado estah em entrada


.data
	table : .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	
.text

	la $t0, entrada		# Setting memorry base --> t0
	li $a1, -1		# Setting output offset pointer --> a1
	li $s7, 0		# Setting input offset pointer --> s7

core:
	sll $t8, $s7, 2		# Lining up the pointer to access input memory --> t8
	add $t8, $t8, $t0	# Adding the base memory with the offset pointer --> t8 + t0
	addiu $s7, $s7, 1	# Increasing the offset input pointer
	lw $t1, 0($t8)		# Getting the first block of words --> t1
	
	sll $t2, $t1, 8		# Eliminating the MSByte--> t2 = t1 % 1000
	srl $t2, $t2, 8		# Returning the 3 bytes to the correct position --> Block ready to encode
	srl $t3, $t1, 24	# Getting the MSBytes --> t3 = t1 / 100
	sll $t3, $t3, 8		# Moving LSBytes one byte forward
	
	move $a0, $t2		# Block to encode
	addiu $a1, $a1, 1	# Setting the offset of the output
	jal conversion		# Goes to code procedure
	
	sll $t8, $s7, 2		# Lining up the pointer to access input memory --> t8
	add $t8, $t8, $t0	# Adding the base memory with the offset pointer --> t8 + t0
	addiu $s7, $s7, 1	# Increasing the offset input pointer
	lw $t1, 0($t8)		# Getting the second block of words --> t1
	
	sll $t2, $t1, 16	# Getting the 2 LSBytes --> t2 = t1 % 100
	add $t3, $t3, $t2	# Adding the previous byte with the rest - t3 has the byte of the previous offset 
	srl $t3, $t3, 8		# Returning the 3 bytes to the correct position --> Block ready to encode
	srl $t2, $t1, 16	# Getting the 2 MSBytes - div by 100
	sll $t2, $t2, 8		# Returning the 2 bytes to the correct position
	
	move $a0, $t3		# Block to encode
	addiu $a1, $a1, 1	# Setting the offset of the output
	jal conversion		# Goes to code procedure
	
	sll $t8, $s7, 2		# Lining up the pointer to access input memory --> t8
	add $t8, $t8, $t0	# Adding the base memory with the offset pointer --> t8 + t0
	addiu $s7, $s7, 1	# Increasing the offset input pointer
	lw $t1, 0($t8)		# Getting the third block of words --> t1
	
	sll $t3, $t1, 24	# Getting the LSByte --> t3 = t1 % 10
	add $t2, $t2, $t3	# Adding the previous byte with the rest - t2 has the byte of the previous offset 
	srl $t2, $t2, 8		# Returning the 3 bytes to the correct position --> Block ready to encode
	srl $t3, $t1, 8		# Getting the 3 MSBytes --> t3 = t1 / 10 --> Block ready to encode
	
	move $a0, $t2		# Block to encode
	addiu $a1, $a1, 1	# Setting the offset of the output
	jal conversion		# Goes to code procedure
	
	move $a0, $t3		# Block to encode
	addiu $a1, $a1, 1	# Setting the offset of the output
	jal conversion		# Goes to code procedure
	
	j core			# The exit condition of this loop is done by the exception procedure
				# This procedure finds where's the end of the string ('\0')

exit:
# O valor do resultado da codificacao base64 devera ser escrito em saida
	
# =================== IMPLEMENTE AQUI SUA SOLUCAO: FIM      

      jal  print            	# call print routine. 
      li   $v0, 10          	# system call for exit
      syscall               	# we are out of here.
		
#########  routine to print messages

           .data
space:		.asciiz  " "          	# space
new_line:	.asciiz  "\n"         	# newline
string_cabecalho:	.asciiz  "Base64: "

      .text
print:	la   $a0, string_cabecalho  
      	li   $v0, 4			# specify Print String service
      	syscall               		# print heading
	la $a0, saida  			# reload byte space to primary address
	li $v0, 4       		# print string
	syscall
      	jr $ra
      	
      	
conversion:
	la $t8, little_to_big_endian 	# Load the adress of te procedure in t8
	jalr $t9, $t8			# Calls conversion from little to big_endian --> rearrange the bytes order | t9 = ra
	move $a3, $a0			# Keep the block in a3
	
	# Getting 6 bytes each, from MSB to LSB to convert
	srl $s0, $a0, 18		# Getting the 6 MSB --> s0
	sll $a0, $a0, 14		# Removing the 6 MSB
	srl $a0, $a0, 14		# Returning bytes to the correct position
	
	srl $s1, $a0, 12		# Getting the 6 MSB --> s1
	sll $a0, $a0, 20		# Removing the 6 MSB
	srl $a0, $a0, 20		# Returning bytes to the correct position

	srl $s2, $a0, 6			# Getting the 6 MSB --> s2
	sll $a0, $a0, 26		# Removing the 6 MSB
	srl $a0, $a0, 26		# Returning bytes to the correct position

	move $s3, $a0			# Getting the 6 MSB --> s3
	
	
	la $s5, saida			# Setup the 'saida' to write the results
	li $s6, 0x000000		# Initializate the output register
	sll $t6, $a1, 2			# Lining up the offset pointer to access output memory --> t6
	addu $s5, $s5, $t6		# Adding the base memory with the offset pointer --> s5 + t6
	
	move $s0, $s0			# Get the first bits and goes to find this character in base64 table
	la $t8, find_on_table		# Load the adress of te procedure in t8
	jalr $t9, $t8			# Calls procedure | t9 = ra
	sll $s6, $s6, 0			# Lining up the previous bytes
	add $s6, $s6, $s0		# Adding with the new one
	
	move $s0, $s1			# Get the second bits and goes to find this character in base64 table
	la $t8, find_on_table		# Load the adress of te procedure in t8	
	jalr $t9, $t8			# Calls procedure | t9 = ra
	sll $s0, $s0, 8			# Lining up the previous bytes
	add $s6, $s6, $s0		# Adding with the new one
	
	move $s0, $s2			# Get the third bits and goes to find this character in base64 table
	la $t8, find_on_table		# Load the adress of te procedure in t8			
	jalr $t9, $t8			# Calls procedure | t9 = ra
	sll $s0, $s0, 16		# Lining up the previous bytes
	add $s6, $s6, $s0		# Adding with the new one
	
	move $s0, $s3			# Get the fourth bits and goes to find this character in base64 table
	la $t8, find_on_table		# Load the adress of te procedure in t8			
	jalr $t9, $t8			# Calls procedure | t9 = ra
	sll $s0, $s0, 24		# Lining up the previous bytes
	add $s6, $s6, $s0		# Adding with the new one
	
	la $t8, exception		# Load the adress of te procedure in t8	
	jalr $t9, $t8			# Goes to process all exceptions --> Find '\0'
	
	sw $s6, 0($s5)			# Save the output register in 'saida'
	
		
	jr $ra				# Return to core
	
little_to_big_endian:

	# This procedure consists on invert the MSByte with the LSByte
	# The input 'and', in memory, commes 'a' as the LSByte and the 'd' as the as the MSByte --> 'dna'
	# Here the procedure rearrange the byte so in memory it remains 'and'

	sll $s1, $a0, 24		# Getting the LSB --> a0 % 10
	srl $s1, $s1, 8			# Returning byte to the correct position
	
	srl $s0, $a0, 16		# Getting the MSB --> a0 / 100
	
	sll $a0, $a0, 16		# Removing the MSB from a0
	srl $a0, $a0, 24		# Removing the LSB from a0
	sll $a0, $a0, 8			# Returning the left byte to the middle
	
	or $a0, $a0, $s0		# Putting the MSB as LSB
	or $a0, $s1, $a0		# Putting the LSB as MSB
	
	jr $t9				# Return to conversion
	
find_on_table:

	# This procedure apply a mask to get character by character to compare with the base64 table

	la $s4, table			# Load table adrees in s4 --> memory base
	li $t7, 4			# Set the constante that refers to the amount os character per block | t7 = 4
	li $t8, 0xff			# Set the mask to extract the character from the table
	
	divu $s0, $t7			# Find the block where is the offset from the input bits | offset / 4
	mflo $s0			# Get the quotient from the division --> the block where's the character
	sll $s0, $s0, 2			# Lining up the block to find
	add $s0, $s0, $s4		# Adding the base memory with the offset pointer
	lw $s4, 0($s0)			# Getting the corresponding block
	
	mfhi $s0			# Get the rest from the division --> this tells which character from te block is needed
	mulu $s0, $s0, 8		# Lining up the character's position as byte
	sllv $t8, $t8, $s0		# Set the mask to the exact place of the character
	and $s4, $s4, $t8		# Aplying the mask
	srlv $s4, $s4, $s0		# Return the character to the LSB
	
	move $s0, $s4			# Set the output parameter
	jr $t9				# Return to conversion
	
exception:

	# This procedure verify if there is a terminator character in the characters
	# If the terminator character is found, save the text and exit
					
	srl $t4, $a3, 16		# Getting the MSByte
	
	sll $t5, $a3, 16		# Getting the middle Byte
	srl $t5, $t5, 24
	
	sll $t6, $a3, 24		# Getting the LSByte
	srl $t6, $t6, 24
	
	li $a2, 0			# Innitialize the register		
	seq $a2, $t4, 10
	beqz $a2, second		# Verify if the first character is '\n', if it is, exit, else, goes to the second character
	andi $s6, $s6, 0x00000000	# Applying the mask null character, none character was converted
	sw $s6, 0($s5)			# Save the output
	j exit				# Goes to print procedure
	
	second:
	li $a2, 0			# Innitialize the register	
	seq $a2, $t5, 10		
	beqz $a2, third			# Verify if the second character is '\n', if it is, exit, else, goes to the third character
	andi $s6, $s6, 0x0000FFFF	# Applying the mask null character where there was any byte to convert
	ori $s6, $s6, 0x3d3d0000	# Applying the mask '=' character where there was any bytes to convert
	sw $s6, 0($s5)			# Save the output
	j exit				# Goes to print procedure
	
	third:
	li $a2, 0			# Innitialize the register	
	seq $a2, $t6, 10		# Verify if the third character is '\n', if it is, ends because the string has ended
	beqz $a2, end			# Else return to conversion
	andi $s6, $s6, 0x00FFFFFF	# Applying the mask null character where there was any byte to convert
	ori $s6, $s6, 0x3d000000	# Applying the mask '=' character where there was any byte to convert
	sw $s6, 0($s5)			# Save the output
	j exit				# Goes to print procedure
	
	end:
		jr $t9			# If there's no exception return to conversion

