.data

image_name:		.asciiz "lenaeye.raw" 
address:		.word 0x10040000
buffer:			.word 0
size:			.word 4096
menu0:			.asciiz "-Digite a opcao desejada (digite o numero):\n"
menu1:			.asciiz "1-Obtem Ponto;\n"
menu1.1:		.asciiz "Recebe uma posicao (x, y) e imprime os componentes R, G e B de um ponto na posicao indicada por x e y;\n"
menu2:			.asciiz "2-Desenha Ponto\n"
menu2.1:		.asciiz "Recebe uma posicao (x, y) e uma cor em RGB, imprimindo esta cor no pixel na posicao indicada por x e y;\n"
menu3:			.asciiz "3-Desenha Retangulo sem Preenchimento\n"
menu3.1:		.asciiz "Recebe duas posicoes (xi, yi) e (xf, yf) e uma cor em RGB. Sera impresso um retangulo da cor especificada, com um canto em (xi, yi) e outro em (xf, yf);\n"
menu4:			.asciiz "4-Converte a Imagem para Negativo\n"
menu4.1:		.asciiz "Nao recebe parametros. Inverte a imagem ja impressa no Display para o seu negativo;\n"
menu5:			.asciiz "5-Carrega Imagem\n"
menu5.1:		.asciiz "Carrega uma imagem ja pronta no Display (no caso, o Olho de Lena);\n"
menu6:			.asciiz "6-Encerra\n"
menu6.1:		.asciiz "Encerra a execucao do programa (Obrigado por utilizar!);\n"





.text

menu:
	lw $s0, address		#carrega no S0 o endereco base da memoria -(PERMANENTE DURANTE TODA A EXECUCAO DO PROGRAMA)-
	li $v0, 4		#carrega o codigo de imprimir strings no v0 para fazer o syscall
	la $a0, menu0		#carrega e imprime cada string para formar o menu
	syscall			#  ||
	la $a0, menu1		#  ||
	syscall			#  ||		
	la $a0, menu1.1		#  ||
	syscall			#  ||
	la $a0, menu2		#  ||
	syscall			#  ||
	la $a0, menu2.1		#  ||
	syscall			#  ||
	la $a0, menu3		#  ||
	syscall			#  ||
	la $a0, menu3.1		#  ||
	syscall			#  ||
	la $a0, menu4		#  ||
	syscall			#  ||
	la $a0, menu4.1		#  ||
	syscall 		#  ||
	la $a0, menu5		#  ||
	syscall			#  ||
	la $a0, menu5.1		#  ||
	syscall			#  ||
	la $a0, menu6		#  ||
	syscall			#  ||
	la $a0, menu6.1		#  ||
	syscall			#  ||
				#  --
	li $v0, 5		#le um inteiro que representa a escolha do ususario
	syscall
	move $t0, $v0		#move o numero lido para o t0
	li $t1, 1		#carrega os valores para comparacao da escolha do usuario
	li $t2, 2		#  ||
	li $t3, 3		#  ||
	li $t4, 4		#  ||
	li $t5, 5		#  ||
	li $t6, 6		#  --
	beq $t0, $t1, quit			#compara os valores com a escolha do ususario e pula para a funcao adequada
	beq $t0, $t2, draw_point		#  ||
	beq $t0, $t3, quit			#  ||		
	beq $t0, $t4, quit 			#  ||
	beq $t0, $t5, load_image		#  ||
	beq $t0, $t6, quit			#  ||
	
	


draw_point:
	move $t1, $a0  		#recebe o parametro a0 (cor)
	move $t2, $a1  		#recebe o parametro a1 (posicao_x)
	move $t3, $a2  		#recebe o parametro a2 (posicao_y)
	sll $t2, $t2, 6  	#multiplica o posicao_x por 64 para representar as linhas
	add $t4, $t2, $t3  	#soma o posicao_x e posicao_y para achar o pixel
	sll $t4, $t4, 2  	#multiplica o pixel por 4 pois cada pixel ocupa 4 bytes na memoria
	add $t5, $t4, $s0  	#acha a posicao de memoria
	sw $t1, 0($t5)  	#grava a cor na posicao de memoria referente ao pixel desejado
	jr $ra
	
load_image:
	la $t7, image_name
  	lw $t8, address
  	la $t9, buffer
  	lw $a3, size
  
  	li   $v0, 13       # system call para abertura de arquivo
  	li   $a1, 0        # Abre arquivo para leitura (parâmtros são 0: leitura, 1: escrita)
  	li   $a2, 0        # modo é ignorado
  	syscall            # abre um arquivo (descritor do arquivo é retornado em $v0)
  	move $t6, $v0      # salva o descritor do arquivo
  
  	move $a0, $t6      # descritor do arquivo 
  	move $a1, $t9      # endereço do buffer 
  	li   $a2, 3        # largura do buffer

loop_load_image:  

  	beq  $a3, $zero, close_load_image
  
  	li   $v0, 14       # system call para leitura de arquivo
  	syscall            # lê o arquivo
  	lw   $t0, 0($a1)   # lê pixel do buffer	
  	sw   $t0, 0($t8)   # escreve pixel no display
  	addi $t8, $t8, 4   # próximo pixel
  	addi $a3, $a3, -1  # decrementa countador
  
	j loop_load_image
   
close_load_image:  
  	li   $v0, 16       # system call para fechamento do arquivo
  	move $a0, $t6      # descritor do arquivo a ser fechado
  	syscall            # fecha arquivo


quit:
	li $v0, 10
	syscall
	
