# FAC: TRABALHO 03
# Coded by: Pedro Igor (17/0062635) & Rogério Júnior (17/0021751)

	.text
main:
	li $v0, 7	# load appropriate system call code into register $v0;
			# code for reading double is 7
	syscall		# call operating system to perform operation
      
# =================== IMPLEMENTE AQUI SUA SOLUCAO: INICIO

# O valor lido do teclado estah em $f0

.data
	const1: .double 1.0
	const2: .double 2.0
	const4: .double 4.0
	const0: .double 0.0
	const1n: .double -1.0
	relative_error: .double 0.000000000001
	pi: .double 3.141592653580
	meio: .double 0.5
	
.text
	#Setting constants to the registers to operate
	
	l.d $f10, const1
	l.d $f14, const2
	l.d $f24, const0
	l.d $f26, relative_error	# f26 = 10⁻¹² Sum stop constant 
	
	li $t0, 0			# t0 = 0 --> Sum controler "k"
	li $t1, -2			# t1 = -2 --> Constant of input exponential - More than one
	li $t3, -1			# t3 = -1 --> Constant of input exponential - More than one
	li $t4, 2			# t4 = 2 --> Constant of input exponential - Less than one
	li $t5, 1			# t5 = 1 --> Constant of input exponential - Less than one

	li $t9, 1			# t9 = 1 --> Assuming that input is different of one
	abs.d $f2, $f0			# Taking the absolute value of the input
	c.eq.d $f2, $f10		# f2 == 1 ? --> If the absolute input is equal to one condition flag 0 is true
	movt $t9, $zero			# If the condition flag is true --> t9 = 0
	beqz $t9, arccot_equal_one	# If t9 == 0 --> goes to equal_one procedure
	
	li $t9, 1			# t9 = 1 --> Assuming that input is less than one
	c.le.d  $f2, $f10		# f2 < 1 ? --> If the absolute input is less than one condition flag 0 is true
	movt $t9, $zero			# If the condition flag is true --> t9 = 0
	beqz $t9, arccot_less_than_one	# If t9 == 0 --> goes to less than_one procedure

		
arccot_more_than_one:
	# Calculating the upper part of the sum's division	
	move $a0, $t0			# Setting the controler exponecial parameter (a0)
	l.d $f20, const1n		# Setting the value to exponetiate parameter (f20)
	jal exponencial			# (-1)^k --> calling the exponential procedure to execute this calculation
	mov.d $f2, $f20			# f2 = (-10)^k --> keeping the result in f2

	mul $a0, $t0, $t1		# a0 = (-2) * k
	add $a0, $a0, $t3		# a0 = (-2) * k - 1 --> Setting the controler exponecial parameter (a0)
	mov.d $f20, $f0			# f20 = x --> Setting the value to exponetiate parameter (f20)
	jal exponencial			# x^(-1-2k)
	mov.d $f4, $f20			# f4 = x^(-1-2k) --> keeping the result in f2
	
	mul.d $f2, $f2, $f4		# f2 = (-1)^k * x^(-1-2k) --> Setting the calculation of the upper part of division
	
	
	#Calculating the lower part of the sum's division
	mtc1.d $t0, $f4			# f4 = k --> Setting sum's counter to double register
	cvt.d.w $f4, $f4		# Converting word to double format
	mul.d $f4, $f14, $f4		# f4 = 2*k
	add.d $f4, $f4, $f10		# f4 = 2*k + 1 --> Setting the calculation of the lower part of division
	
	
	div.d $f4, $f2, $f4		# f4 = f2/f4 --> Calculatinng the new element
	add.d $f16, $f4, $f16		# f12 = f12 + f4 --> Incresing the sum with the new 
	
	sub.d $f28, $f16, $f24		# f28 = f12 - f24 --> Calculate relative error
	abs.d $f28, $f28		# Taking the absolute value of stopping criterion
	c.lt.d $f28, $f26		# f28 < relative_error ? --> The absolute stopping criterion is less than the precision?

	mov.d $f24, $f16		# Setting f24 as the previous term
	addiu $t0, $t0, 1		# k = k+1 --> Incrementing series' counter
	bc1f arccot_more_than_one	# If stopping criterion is bigger than the precision goes again to the procedure
	mov.d $f12, $f16		# Moving series' result to the print register
	j print				# Goes to print procedure

arccot_less_than_one:
	# Calculating the upper part of the sum's division
	move $a0, $t0			# Setting the controler exponecial parameter (a0)
	l.d $f20, const1n		# Setting the value to exponetiate parameter (f20)
	jal exponencial			# (-1)^k --> calling the exponential procedure to execute this calculation
	mov.d $f2, $f20			# f2 = (-10)^k --> keeping the result in f2

	mul $a0, $t0, $t4		# a0 = (2) * k
	add $a0, $a0, $t5		# a0 = (2) * k + 1 --> Setting the controler exponecial parameter (a0)
	mov.d $f20, $f0			# f20 = x --> Setting the value to exponetiate parameter (f20)
	jal exponencial			# x^(1+2k) --> Setting the value to exponetiate parameter (f20)
	mov.d $f4, $f20			# f4 = x^(1+2k) --> keeping the result in f2
	
	mul.d $f2, $f2, $f4		# f2 = (-1)^k * x^(1+2k) --> Setting the calculation of the upper part of division
	
	#Calculating the lower part of the sum's division
	mtc1.d $t0, $f4			# f4 = k --> Setting sum's counter to double register
	cvt.d.w $f4, $f4		# Converting word to double format
	mul.d $f4, $f14, $f4		# f4 = 2*k
	add.d $f4, $f4, $f10		# f4 = 2*k + 1 --> Setting the calculation of the lower part of division
	
	
	div.d $f4, $f2, $f4		# f4 = f2/f4 --> Calculatinng the new element
	add.d $f16, $f4, $f16		# f12 = f12 + f4 --> Incresing the sum with the new 
	
	sub.d $f28, $f16, $f24		# f28 = f12 - f24 --> Calculate relative error
      	abs.d $f28, $f28		# Taking the absolute value of stopping criterion
	c.lt.d $f28, $f26		# f28 < relative_error ? --> The absolute stopping criterion is less than the precision?
	mov.d $f24, $f16		# Setting f24 as the previous term
	addiu $t0, $t0, 1		# k = k+1 --> Incrementing series' counter
	bc1f arccot_less_than_one	# If stopping criterion is bigger than the precision goes again to the procedure
	
	mov.d $f12, $f16		# Moving series' result to the print register
	jal raiz			# Goes to the procedure to calculate first part of the formulation
	sub.d $f12, $f24, $f12		# First part minus serie
	j print				# Goes to print procedure
	
arccot_equal_one:			#If the input is equals 1 we need a diferent operation (by series will not converge)
	l.d $f30, pi
	l.d $f28, const4		#the answer is (pi/4) for input equals 1
	div.d $f12, $f30, $f28
	mul.d $f12, $f12, $f0

# O valor do resultado do arccot devera ser escrito em $f12
	
# ===============		==== IMPLEMENTE AQUI SUA SOLUCAO: FIM      

      jal  print            # call print routine. 
      li   $v0, 10          # system call for exit
      syscall               # we are out of here.
		
#########  routine to print messages
      .data
space:		.asciiz  " "          # space
new_line:	.asciiz  "\n"         # newline
string_ARCCOT:	.asciiz  "arccot= "
      .text
print:	la   $a0, string_ARCCOT  
      	li   $v0, 4		# specify Print String service
      	syscall               	# print heading
      	move   $a0, $t0      	# 
	li   $v0, 3           	# specify Print Double service
      	syscall               	# print $t0
	li $v0, 10
	syscall
	
exponencial:	
	abs $s2, $a0			# Taking the absolute value of the argument
	beqz $s2, zero			# If the argument is zero goes to the respective procedure
	beq $a0, 1, normal		# If the argument is one goes to the respective procedure
	beq $a0, -1, inverse		# If the argument is minus one goes to the respective procedure
	
	li $s1, 1			# Setting the counter of the multiplications
	mov.d $f30, $f20		# Holding the constant in another variable not to lose it during the procedure
	for:
		mul.d $f20, $f20, $f30	# f20 = f20 * previous
		addiu $s1, $s1, 1	# Incrementing the counter
		bne $s2, $s1, for	# If the counter is different of the argument branch to for
		
	blt $a0, $zero, inverse		# If the argument is negative goes to the respective procedure
	
	normal:			
		jr $ra			# Returning to the normal flow
	inverse:
		l.d $f22, const1	# f22 = 1
		div.d $f20, $f22, $f20	# Calculating the inverse of exponentiation
		jr $ra			# Returning to the normal flow
	zero:
		l.d $f20, const1	# If the argument is zero the result is 1
		jr $ra			# Returning to the normal flow

raiz:
	# Calculating the rest of the sum when input absolute is less than 1
	l.d $f28, pi			# f28 = pi
	l.d $f30, meio			# f30 = 0.5
	mul.d $f2, $f28, $f30		# (1/2)*pi
	
	# Testing if the input is different of zero
	# If this is the case, the input square root can't be calculate, because this would raise error
	l.d $f30,const0			# Setting the 0 to f30 to test the input
	li $t9, 1			# Assuming that the input is different of 0
	c.eq.d  $f0, $f30		# f0 == 0 ? --> If the absolute input is equal to zero condition flag 0 is true
	movt $t9, $zero			# Confronting the assumed theory
	beqz $t9, goBack		# If input equals zero goes to respective procedure
	
	mul.d $f20, $f0, $f0		# x²
	l.d $f28, const1		# f28 = 1
	div.d $f20, $f28, $f20		# 1/x²
	sqrt.d $f6, $f20		# sqrt(1/x²)
	mul.d $f6, $f6, $f0		# sqrt(1/x²) * x
	mul.d $f24, $f6, $f2		# (1/2) * pi * sqrt(1/x²) * x
	jr $ra				# Returning to the normal flow
	
	goBack:	
		l.d $f30, const0	# f30 = 0
		add.d $f24, $f2, $f30	# f24 = (1/2)*pi + x
		jr $ra			# Returning to the normal flow
