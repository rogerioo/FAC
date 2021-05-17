.data
string: .space 80

.text
read_string:
	# syscall para ler string
	li $v0, 8
	la $a0, string
	li $a1, 80
	syscall

set_useful_data:
	addi $t0, $zero, -4 	# índice da string
	addi $t1, $zero, 0 	# conta os espaços
	addi $t2, $zero, 0x000000ff 	# mascara pra pegar 2 ultimos nibbles
	addi $t7, $zero, 0x0000000a 	# marca final da string

get_4_chars:
	addi $t0, $t0, 4 	# incrementa o indice da string
	lw $t3, string($t0) 	# carrega 4 chars da string
	addi $t4, $zero, 4 	# inicia contador auxiliar em 4
compare_chars:
	li $t5, ' ' 		# carrega o char espaco 
	and $t6, $t3, $t2 	# isola um char
	beq $t6, $t5, count_spaces # caso esse char seja um espaço, incrementa o contador
	beq $t6, $t7, exit 	# se chagar no fim da string, pula para exit
	checkpoint:
	srl $t3, $t3, 8 	# move 8 bits para a direta
	blez $t4, get_4_chars 	# depois de percorrer os 4 chars, volta para pegar mais 4
	addi $t4, $t4, -1 	# decrementa o contador auxiliar em 1
	j compare_chars		# executa novamente caso ainda tenha algum char para comparar
	
count_spaces:	
	addi $t1, $t1, 1	# incrementa o contador de espacos
	j checkpoint		# volta para a funcao de comparar

exit:
	# syscall para printar inteiro
	add $a0, $t1, $zero
	li $v0, 1
	syscall
	# syscall para finalizar o programa
	li $v0, 10
	syscall

	
