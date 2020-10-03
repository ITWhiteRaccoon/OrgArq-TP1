#Trabalho Pratico 1 para OrgArqI 2020/2
#Eduardo Andrade, Vinicius Berizzi
	.text
	.globl main
main:	
	
	
	
carrega_vetor:
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
	move	$t0, $v0	#Insere dado na posicao do vetor
	
	addiu	$t2, $t2, 1	#$t2 (posicao) = $t2 + 1
	addiu	$t3, $t3, 4	#$t3 (endereco) = $t3 + 4 (vai para o endereco do prox elem)
	
	j cv_loop
	
cv_loop_fim:
	addiu	$sp, $sp, -4	#Adiciona 1 espaço na pilha
	sw	$t1, 0($sp)	#Escreve tamVet($t1) na pilha
	jr	$ra
	
encontra_padrao:
	
	
	
	.data
str_tam_vet:	.asciiz "Informe o numero de dados a serem inseridos no vetor "
str_dado_vet:	.asciiz "Informe um dado a ser inserido no vetor "
str_qtd_padroes:	.asciiz "Quantidade de padroes contabilizados: "
str_dados:	.asciiz "dados: "
str_padrao:	.asciiz	"padrao: "
int_tam_dados:	.word	0
int_tam_padrao:	.word	0
vet_dados:	.space	200
vet_padrao:	.space	20
