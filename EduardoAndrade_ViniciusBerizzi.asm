#Trabalho Pratico 1 para OrgArqI 2020/2
#Eduardo Andrade, Vinicius Berizzi
	.text
	.globl main
main:	
	la	$s0, vet_dados
	addiu	$sp, $sp, -4	#Adiciona posicao na pilha
	sw	$s0, 0($sp)	#Guarda endereco do vet_dados($s0) na pilha para argumento de carrega_vetor
	jal	carrega_vetor
	lw	$s1, 0($sp)	#$s1 = retorno da funcao (tamanho do vetor de dados)
	addiu	$sp, $sp, 4	#Remove da pilha
	la	$t0, int_tam_dados 
	sw	$s1, 0($t0)	#Guarda tamanho do vetor dados em int_tam_dados
	
	la	$s2, vet_padrao
	addiu	$sp, $sp, -4
	sw	$s2, 0($sp)	#Guarda endereco do vet_padrao($s2) na pilha
	jal	carrega_vetor
	lw	$s3, 0($sp)	#$s3 = tamanho do vetor padrao
	addiu	$sp, $sp, 4
	la	$t0, int_tam_padrao
	sw	$s3, 0($t0)	#Guarda tamanho do vetor padrao em int_tam_padrao
	
	li	$s4, 0		#$s4 = contabilizaPadrao = 0
	li	$s5, 0		#$s5 = posicaoDados = 0
	
m_loop:
	addu	$t0, $s5, $s3	#$t0 = posicaoDados + int_tam_padrao
	bgt	$t0, $s1, main_end	#if ((posicaoDados + int_tam_padrao) > int_tam_dados) goto main_end
	addiu	$sp, $sp, -20	#Abre 5 posicoes na pilha para os 5 parametros
	sw	$s0, 0($sp)	# *_vetDados
	sw	$s5, 4($sp)	# _posDados
	sw	$s2, 8($sp)	# *_vetPadrao
	sw	$zero, 12($sp)	# 0
	sw	$s3, 16($sp)	# _tamPadrao
	jal	encontra_padrao
	lw	$t1, 0($sp)	#Le retorno da pilha 
	addiu	$sp, $sp, 4	#Tira da pilha
	addu	$s4, $s4, $t1	#contabilizaPadrao += retorno
	addiu	$s5, $s5, 1	#posicaoDados++
	j	m_loop
	
main_end:
	la	$a0, str_qtd_padroes	#Imprime string 'Qtd de padroes encontrados...'
	li	$v0, 4
	syscall
	
	move	$a0, $s4	#Imprime o nro resultante
	li	$v0, 1
	syscall
	
	li	$v0, 10		#Encerra programa
	syscall
	
carrega_vetor: #(int * _enderecoVetor) : int
	lw	$t0, 0($sp)	#$t0 = _enderecoVetor (arg da funcao na pilha - pop)
	addiu	$sp, $sp, 4	#Ajusta pilha
	
	la	$a0, str_tam_vet	#Pede tam do vetor
	li	$v0, 4
	syscall
	
#	la	$a0, str_dados	#Estava usando para completar o pedido com 'vetor dados / vetor padrao'
#	li	$v0, 4
#	syscall
	
	li	$v0, 5		#Leitura do tam
	syscall
	move	$t1, $v0	#Move tam lido para $t1
	
	li	$t2, 0		#$t2 = posicao (necessario incrementar 1 a 1 para controlar se já chegou ao tam do vetor
	addiu	$t3, $t0, 0	#$t3 = enderecoVetor (usado para percorrer vet, pode ser incrementado em 4)

cv_loop:
	bge	$t2, $t1, cv_loop_fim	#if (posicao >= tamVet) goto cv_loop_fim

	la	$a0, str_dado_vet	#Pede dado p/ inserir no vet
	li	$v0, 4
	syscall
	
	li	$v0, 5		#Le dado
	syscall
	sw	$v0, 0($t3)	#Insere dado na posicao do vetor
	
	addiu	$t2, $t2, 1	#$t2 (posicao) = $t2 + 1
	addiu	$t3, $t3, 4	#$t3 (endereco) = $t3 + 4 (vai para o endereco do prox elem)
	
	j cv_loop
	
cv_loop_fim:
	addiu	$sp, $sp, -4	#Adiciona 1 espaço na pilha
	sw	$t1, 0($sp)	#Escreve tamVet($t1) na pilha
	jr	$ra
	
encontra_padrao: #(int *_vetDados, int _posDados, int *_vetPadrao, int _posPadrao, int _) : int
	lw	$t0, 0($sp)	#*_vetDados
	lw	$t1, 4($sp)	# _posDados
	lw	$t2, 8($sp)	#*_vetPadrao
	lw	$t3, 12($sp)	# _posPadrao
	lw	$t4, 16($sp)	# _tamPadrao
	addiu	$sp, $sp, 20	#Consome os parametros
	
	sll	$t1, $t1, 2	#$t1 = _posDados($t1) * 4 (indice p/ bytes de deslocamento)
	sll	$t3, $t3, 2	#$t3 = _posPadrao($t3) * 4
	addu	$t5, $t0, $t1	#$t5 = *_vetDados + deslocamento
	addu	$t6, $t2, $t3	#$t6 = *_vetPadrao + deslocamento
	lw	$t5, 0($t5)	#$t5 = conteudo do endereço $t5
	lw	$t6, 0($t6)	#$t6 = conteudo do endereço $t6
	
	bne	$t5, $t6, ep_end_zero #if(_vetDados[_posDados] != _vetPadrao[_posPadrao]) return 0
	srl	$t1, $t1, 2	#$t1 = _posDados / 4 (bytes de deslocamento p/ indice)
	srl	$t3, $t3, 2	#$t3 = _posPadrao / 4 (bytes de deslocamento p/ indice)
	addiu	$t7, $t4, -1	#$t7 = _tamPadrao - 1
	
	beq	$t3, $t7, ep_end_one #if(_posPadrao == _tamPadrao - 1) return 1
	addiu	$t1, $t1, 1	#_posDados++
	addiu	$t3, $t3, 1	#_posPadrao++
	addiu	$sp, $sp, -24	#Guarda $ra e parametros, este sera consumido no inicio da funcao
	sw	$ra, 0($sp)	#ultimo endereco de retorno
	sw	$t0, 4($sp)	# *_vetDados
	sw	$t1, 8($sp)	# _posDados
	sw	$t2, 12($sp)	# *_vetPadrao
	sw	$t3, 16($sp)	# _posPadrao
	sw	$t4, 20($sp)	# _tamPadrao
	jal	encontra_padrao
	lw	$t0, 0($s0)	#Le resultado
	lw	$ra, 4($sp)	#Le retorno guardado
	addiu	$sp, $sp, 4	#Remove uma das posicoes da pilha
	
	j	ep_end
	
ep_end_zero:
	li	$t0, 0		#Retorna 0
	j	ep_end
	
ep_end_one:
	li	$t0, 1		#Retorna 1
	
ep_end:
	sw	$t0, 0($sp)	#Guarda resultado na pilha
	jr	$ra
	
	.data
int_tam_dados:	.word	0
int_tam_padrao:	.word	0
vet_dados:	.space	200
vet_padrao:	.space	20
str_tam_vet:	.asciiz "Informe o numero de dados a serem inseridos no vetor: "
str_dado_vet:	.asciiz "Informe um dado a ser inserido no vetor: "
str_qtd_padroes:.asciiz "Quantidade de padroes contabilizados: "
str_dados:	.asciiz "dados: "
str_padrao:	.asciiz	"padrao: "
