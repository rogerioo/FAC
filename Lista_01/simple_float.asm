.text

	li $v0, 7
	syscall
	
	mov.d $f2, $f0
	
	li $v0, 7
	syscall
	
	mov.d $f4, $f0
	
	mul.d $f6, $f2, $f4
	
	