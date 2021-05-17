.data
	userInput:.space 80 	# Bytes que o dado precisa * tamanho do array
	
.text
	li $v0, 8
	la $a0, userInput	# Vetor onde será salvo
	li $a1, 4		# Quantidade de bytes a serem lidas
	syscall

#------------------------------------------------------------------------------------#
	
	# Jeito que se aprende a mexer internamente com a memória --> bem útil
	la $t1, userInput	
	lw $t2, 0($t1)		# Carrega em $t2 o primeiro bloco de memória do vetor (4 bytes) 

	# Pega o primeiro caracter em $t3
	sll $t3, $t2, 24	# "Empurra" os 3 primeiros bytes (8 bits) para frente
	srl $t3, $t3, 24	# Retorna o valor desejado para a posição adequada
	
	# Pega o segundo caracter em $t4
	sll $t4, $t2, 16	# "Empurra" os 2 primeiros bytes (8 bits) para frente
	srl $t4, $t4, 24	# "Empurra" o ulltimo byte para fora e deixa o valor desejado na poosição correta

	# Pega o terceiro caracter em $t5
	srl $t5, $t2, 16	# "Empurra" os 2 ultimos bytes (8 bits) para trás e deixa o valor desejado na posição correta
	
#-----------------------------------------------------------------------------------#
	
	# Jeito eficiente, mas não didático
	li $t7, 2
	lb $t6, userInput($t7) # Carrega $t6 a posição 2 do vetor