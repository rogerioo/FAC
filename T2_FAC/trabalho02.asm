# FAC: TRABALHO 02
# Coded by: Pedro Igor (17/0062635) & Rogério Júnior (17/0021751)

	.text
main:
	li $v0, 5	# load appropriate system call code into register $v0;
			# code for reading integer is 5
	syscall		# call operating system to perform operation
	move $a0, $v0	# O PRIMEIRO VALOR LIDO DO TECLADO ESTA DISPONIVEL EM $A0
	li $v0, 5	# load appropriate system call code into register $v0;
			# code for reading integer is 5
	syscall		# call operating system to perform operation
	move $a1, $v0	# O SEGUNDO VALOR LIDO DO TECLADO ESTA DISPONIVEL EM $A1
      
# =================== IMPLEMENTE AQUI SUA SOLUCAO: INICIO

	slti $t1, $a0, 1    	#t1 = a0 < 1
	slti $t2, $a1, 1	#t2 = a1 < 1
	or $t3, $t1, $t2	#t3 = t1 || t2,
	beq $t3, 1, error	#if (t1 == 1) the program goes to the error procedure
	mul $t3, $a0, $a1 	#t3 = a0 x a0
	jal mdc			#goes to the mdc calculation
	div $t1, $t3, $t0	#a0 x a1 = mdc(a0,a1) x mmc(a0, a1) --> mmc = (a0 x a1)/mdc(a0, a1)
		
# =================== IMPLEMENTE AQUI SUA SOLUCAO: FIM      

      jal  print            # call print routine. 
      li   $v0, 10          # system call for exit
      syscall               # we are out of here.
		
#########  routine to print messages
      .data
space:		.asciiz  " "          # space
new_line:	.asciiz  "\n"         # newline
string_MDC:	.asciiz  "MDC: "
string_MMC:	.asciiz  "\nMMC: "
erro:		.asciiz "\n Entrada invalida.\n"

      .text
print:	la   $a0, string_MDC  
      	li   $v0, 4		# specify Print String service
      	syscall               	# print heading
      	move   $a0, $t0      	# 
	li   $v0, 1           	# specify Print Integer service
      	syscall               	# print $t0
	la   $a0, string_MMC   	# load address of print heading
      	li   $v0, 4           	# specify Print String service
      	syscall               	# print heading
      	move   $a0, $t1      	# 
	li   $v0, 1           	# specify Print Integer service
      	syscall               	# print $t1
	jr   $ra              	# return

				# This procudure follow the euclidian algorithm to find the mdc	
mdc:	div $a0, $a1		# Make the division (a0 / a1) that get's stored in $lo and the rest of the division get's stored in #hi
	mfhi $t0		# t0 = a0 % a1
	move $a0, $a1		# a0 = a1
	move $a1, $t0		# a1 = t0
	bgtz $a1, mdc		# While (a1) > 0 makes the procedure
	move $t0, $a0		# t0 = a0; To take de mdc result
	jr $ra			#Return to the normal procedure
	
error:	la   $a0, erro  	#load the error message
      	li   $v0, 4		# specify Print String service
      	syscall 
      	
      	li   $v0, 10          # system call for exit
      	syscall  
