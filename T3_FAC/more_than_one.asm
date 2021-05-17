# FAC: TRABALHO 03
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
	const1n: .double -1.0
	const2n: .double -2.0
	const0: .double 0.0
	relative_error: .double 0.000000000001
	
.text
	l.d $f10, const1
	l.d $f14, const2
	l.d $f16, const0
	l.d $f18, const2n
	l.d $f24, const0
	l.d $f26, relative_error
	li $t0, 0
	li $t1, -2
	li $t3, -1
arccot_more_than_one:		
	move $a0, $t0
	l.d $f20, const1n
	jal exponencial		# (-1)^k
	mov.d $f2, $f20		# f2 = (-10)^k 

	mul $a0, $t0, $t1	# a0 = (-2) * k
	add $a0, $a0, $t3	# a0 = (-2) * k - 1
	mov.d $f20, $f0		# f20 = x
	jal exponencial		# x^(-1-2k)
	mov.d $f4, $f20		# f4 = x^(-1-2k)
	
	mul.d $f2, $f2, $f4	# f2 = (-1)^k * x^(-1-2k)
	
	
	mtc1.d $t0, $f4		# f4 = k
	cvt.d.w $f4, $f4
	mul.d $f4, $f14, $f4	# f4 = 2*k
	add.d $f4, $f4, $f10	# f4 = 2*k + 1
	
	div.d $f4, $f2, $f4	# f4 = f2/f4
	add.d $f16, $f4, $f16	# f12 = f12 + f4
	
	sub.d $f28, $f16, $f24	# f28 = f12 - f24 --> Calculate relative error
	c.lt.d $f28, $f26	# f28 < relative_error ?
	mov.d $f24, $f16	# f24 is the previous term
	addiu $t0, $t0, 1	# k = k+1
	bc1f arccot_more_than_one
	mov.d $f12, $f16

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
		abs $s2, $a0
		beqz $s2, zero
		beq $a0, 1, normal
		beq $a0, -1, inverse
		
		li $s1, 1
		mov.d $f30, $f20
		for:
			mul.d $f20, $f20, $f30
			addiu $s1, $s1, 1
			bne $s2, $s1, for

		blt $a0, $zero, inverse
		
		normal:			
			jr $ra
		inverse:
			l.d $f22, const1
			div.d $f20, $f22, $f20
			jr $ra
		zero:
			l.d $f20, const1
			jr $ra
