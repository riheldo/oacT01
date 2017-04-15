.data

# image_name:		.asciiz "P:\Pedro\Dropbox\Arquivos\UNB\OAC\trabalho1\lenaeye.raw"
image_name:		.asciiz "/Users/riheldomelosantos/repo/oacT01/oacT01/lenaeye.raw"

address:		.word 0x10040000 # endereco do bitmap display na memoria	
buffer:			.word 0 # configuracao default do MARS
size:			.word 4096 # numero de pixels da imagem

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

draw_point_menux:	.asciiz "Digite a posicao desejada em X (0-63)\n"
draw_point_menuy:	.asciiz "Digite a posicao desejada em Y (0-63)\n"
draw_point_menucorR:	.asciiz "Digite a componente da cor em R (0-255)\n"
draw_point_menucorG:	.asciiz "Digite a componente da cor em G (0-255)\n"
draw_point_menucorB:	.asciiz "Digite a componente da cor em B (0-255)\n"
draw_empty_rectangle_menuxi:	.asciiz "Digite a posicao desejada em xi (0-63)\n"
draw_empty_rectangle_menuyi:	.asciiz "Digite a posicao desejada em yi (0-63)\n"
draw_empty_rectangle_menuxf:	.asciiz "Digite a posicao desejada em xf (0-63)\n"
draw_empty_rectangle_menuyf:	.asciiz "Digite a posicao desejada em yf (0-63)\n"
draw_empty_rectangle_menucorR:	.asciiz "Digite a componente da cor em R (0-255)\n"
draw_empty_rectangle_menucorG:	.asciiz "Digite a componente da cor em G (0-255)\n"
draw_empty_rectangle_menucorB:	.asciiz "Digite a componente da cor em B (0-255)\n"




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
	beq $t0, $t2, draw_point_menu		#  ||
	beq $t0, $t3, draw_empty_rectangle_menu	#  ||		
	beq $t0, $t4, quit 			#  ||
	beq $t0, $t5, load_image		#  ||
	beq $t0, $t6, quit			#  --
	j menu
	
	

										
draw_point_menu:
	li $v0, 4
	la $a0,  draw_point_menux  	#carrega e imprime a string
	syscall
	li $v0, 5			#le o parametro inserido pelo usuario para o x			
	syscall
	move $t0, $v0			#guarda o x inserido pelo ususario em t0
	li $v0, 4
	la $a0, draw_point_menuy 	#carrega e imprime a string
	syscall
	li $v0, 5			#le o parametro inserido pelo usuario para o y
	syscall
	move $t1, $v0			#guarda o y inserido pelo usuario em t1
	li $v0, 4
	la $a0, draw_point_menucorR	#carrega e imprime a string
	syscall
	li $v0, 5			#le o parametro inserido pelo ususario para a cor R
	syscall
	move $t2, $v0			#guarda o R inserido pelo usuario em t2
	li $v0, 4
	la $a0, draw_point_menucorG	#carrega e imprime a string
	syscall
	li $v0, 5			#le o parametro inserido pelo ususario para a cor G
	syscall
	move $t3, $v0			#guarda o G inserido pelo usuario em t3
	li $v0, 4
	la $a0, draw_point_menucorB	#carrega e imprime a string
	syscall
	li $v0, 5			#le o parametro inserido pelo ususario para a cor B
	syscall
	move $t4, $v0			#guarda o B inserido pelo usuario em t4
	
	li $t5, 63			#carrega 63 no t5 para inverter o x
	sub $t0, $t5, $t0		#inverte o x para que ele inicie na base da tela
	li $a0, 0			#limpa o a0
	move $a0, $t2			#carrega o R em a0
	sll $a0, $a0, 8			#desloca o R para a esquerda para carrega o G
	add $a0, $a0, $t3		#carrega o G em a0
	sll $a0, $a0, 8			#desloca o R e o G para a esquerda para carregar o B
	add $a0, $a0, $t4		#carrega o B em a0
	move $a1, $t0			#move o X para a1
	move $a2, $t1			#mvoe o Y para a2
	jal draw_point
	j menu
	
	
	
	

draw_point:
	move $t1, $a0  		#recebe o parametro a0 (cor)
	move $t2, $a1  		#recebe o parametro a1 (posicao_x)
	move $t3, $a2  		#recebe o parametro a2 (posicao_y)
	sll $t2, $t2, 6  	#multiplica o posicao_x por 64 para representar as linhas
	add $t4, $t2, $t3  	#soma o posicao_x e posicao_y para achar o pixel
	sll $t4, $t4, 2  	#multiplica o pixel por 4 pois cada pixel ocupa 4 bytes na memoria
	add $t6, $t4, $s0  	#acha a posicao de memoria
	sw $t1, 0($t6)  	#grava a cor na posicao de memoria referente ao pixel desejado
	jr $ra
	

draw_empty_rectangle_menu:
	
	li $v0, 4
	la $a0,  draw_empty_rectangle_menuxi  	#carrega e imprime a string
	syscall
	li $v0, 5				#le o parametro inserido pelo usuario para o xi			
	syscall
	move $t0, $v0				#guarda o xi inserido pelo ususario em t0
	li $v0, 4
	la $a0, draw_empty_rectangle_menuyi	#carrega e imprime a string
	syscall
	li $v0, 5				#le o parametro inserido pelo usuario para o yi
	syscall
	move $t1, $v0				#guarda o yi inserido pelo usuario em t1
	li $v0, 4
	la $a0,  draw_empty_rectangle_menuxf  	#carrega e imprime a string
	syscall
	li $v0, 5				#le o parametro inserido pelo usuario para o xf			
	syscall
	move $t2, $v0				#guarda o xf inserido pelo ususario em t2
	li $v0, 4
	la $a0, draw_empty_rectangle_menuyf	#carrega e imprime a string
	syscall
	li $v0, 5				#le o parametro inserido pelo usuario para o yf
	syscall
	move $t3, $v0				#guarda o yf inserido pelo usuario em t3
						#cores
	li $v0, 4
	la $a0, draw_empty_rectangle_menucorR	#carrega e imprime a string
	syscall
	li $v0, 5				#le o parametro inserido pelo ususario para a cor R
	syscall
	move $t4, $v0				#guarda o R inserido pelo usuario em t4
	li $v0, 4
	la $a0, draw_empty_rectangle_menucorG	#carrega e imprime a string
	syscall
	li $v0, 5				#le o parametro inserido pelo ususario para a cor G
	syscall
	move $t5, $v0				#guarda o G inserido pelo usuario em t5
	li $v0, 4
	la $a0, draw_empty_rectangle_menucorB	#carrega e imprime a string
	syscall
	li $v0, 5				#le o parametro inserido pelo ususario para a cor B
	syscall
	move $t6, $v0				#guarda o B inserido pelo usuario em t6
	
	li $a0, 0			#limpa o a0
	move $a0, $t4			#carrega o R em a0
	sll $a0, $a0, 8			#desloca o R para a esquerda para carrega o G
	add $a0, $a0, $t5		#carrega o G em a0
	sll $a0, $a0, 8			#desloca o R e o G para a esquerda para carregar o B
	add $a0, $a0, $t6		#carrega o B em a0
	
	li $t7, 63				#carrega 63 no t7 para inverter o x
	sub $t0, $t7, $t0			#inverte o xi para que ele inicie na base da tela
	sub $t2, $t7, $t2			#inverte o xf para que ele inicie na base da tela
	
	sub $s1, $t0, $t2			#s1 recebe a distancia de xi a xf
	slti $t8, $s1, 0			#checa se a distancia e negativa
	move $t5, $t0				#guarda o menor x em t5
	move $s3, $t2				#guarda o maior x em s3
	beqz $t8, der_cond_1
	move $t5, $t2				#guarda o menor x em t5
	move $s3, $t0				#guarda o maior x em s3
	negu $s1, $s1				#se negativa, inverter
	der_cond_1:
	sub $s2, $t1, $t3			#s2 recebe a distancia de yi a yf
	slti $t4, $s2, 0			#checa se a distancia e negativa
	move $s4, $t3				#guarda o menor y em s4
	beqz $t4, der_cond_2
	move $s4, $t1				#guarda o menor y em s4
	negu $s2, $s2				#se for negativa inverte
	der_cond_2:

	der_draw_loop_1_start:					#comeca a printar o retangulo
		li $t7, 0
	der_draw_loop_1:					#printa a primeira linha e a ultima linha do retangulo
		move $a1, $s3
		add $t9, $t7, $s4
		move $a2, $t9
		jal draw_point
		beq $t7, $s2, der_draw_loop_2_start
		addi $t7, $t7, 1
		j der_draw_loop_1
	der_draw_loop_2_start:
		li $t7, 0
		beq $t5, $s3, der_draw_loop_end			#para se o x atual for igual ao menor (fim do retangulo)
	der_draw_loop_2:					#printa as verticais do retangulo
		beq $t7, $s1, der_draw_loop_1_start	
		addi $s3, $s3, 1
		move $a1, $s3
		addi $t9, $s4, 0
		move $a2, $t9
		jal draw_point
		add $t9, $t9, $s2
		move $a2, $t9
		jal draw_point
		addi $t7, $t7, 1
		j der_draw_loop_2
	der_draw_loop_end:
	j menu
	
	
	
	
load_image:
	la $a0, image_name
	lw $a1, address
	la $a2, buffer
	lw $a3, size
	move $t7, $a0
	move $t8, $a1
	move $t9, $a2
	
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
  	j menu


quit:
	li $v0, 10
	syscall
	
