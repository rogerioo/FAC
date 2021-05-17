.text

	main: 
	li $v0, 5
	syscall
	move $t0, $v0
	
	andi $t1, $t0, 0x1 # Aplico a máscara para ver se o bit 1 está ativo | 0000000(correspondente binário entrada) and 0000001
	srl $t2, $t2, 0    # Tiro os n-1 (1-1 = 0) bits restantes
	andi $t2, $t0, 0x2 # Aplico a máscara para ver se o bit 2 está ativo | 0000000(correspondente binário entrada) and 0000010
	srl $t2, $t2, 1    # Tiro os n-1 (2-1 = 1) bits restantes
	andi $t3, $t0, 0x4 # Aplico a máscara para ver se o bit 3 está ativo | 0000000(correspondente binário entrada) and 0000100
	srl $t3 $t3, 2     # Tiro os n-1 (3-1 = 2) bits restantes
	
	# A função andi está verificando se o bit desejado está ativo ou não
	# A função srl, desse jeito, está fazendo como se fosse a divisão inteira por 10, para tirar os números desejados