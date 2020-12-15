.data # Declaração dos textor e variaveis

       	
	txtNeu:	.asciiz "Qual a taxa de aprendizado no neuronio: "
	txtEp:	.asciiz "Qual o numero de epocas que deseja treinar: "
	txtDad:	.asciiz "Qual o numero de dados para treinamento: "
	txtPes:	.asciiz "Pesos iniciais: "
	txtPes2: .asciiz "Novos Pesos: "
	txtTest: .asciiz "Testes"
	barra: .asciiz "\n"
	mais: .asciiz " + "
	igual: .asciiz " = "
        esp: .asciiz " "
	preencheDados: .asciiz "\nDado: "
	
	peso1: 	.float 0 
	pesoDois: .float 0 
	aprendizado: .float 0 
	qtdEpocas: .word 0 
	qtdDados: .word 0 
	vetorDados:.word 0 
	
	
		
														
.text # Code

			
	#Pegando a tx de aprendizado
	addi $v0, $zero, 4
	la $a0, txtNeu
	syscall

        #Armazenando
	addi $v0, $zero, 6
	syscall
	swc1 $f0, aprendizado
			
	#Pegando a qtd de epocas
	addi $v0, $zero, 4
	la $a0, txtEp
	syscall

	#armazenando
	addi $v0, $zero, 5
	syscall
	sw $v0, qtdEpocas
			
	#qtd de dados p treino
	addi $v0, $zero, 4
	la $a0, txtDad
	syscall

	
	addi $v0, $zero, 5
	syscall
	sw $v0, qtdDados
			
			
	# Inicializando o FOR0
	lw $s0, qtdDados
	add $t0, $zero, $zero
	addi $t4, $zero, 4
		
	# Preenchendo o vetor de dados de entrada	
        FOR0:
        	
        	slt $t1, $t0, $s0
                beq $t1, $zero, FIMFOR0
                
                mul $t2, $t0, $t4
                        	
		# Solicita o dado atual do vetor de dados
		addi $v0, $zero, 4
		la $a0, preencheDados
		syscall
				
		
		addi $v0, $zero, 5
		syscall
		sw $v0, vetorDados($t2)	
				
		#i++
		addi $t0, $t0, 1
                j FOR0	
       FIMFOR0:
       
       	# Gerando e salvando um num randomico/peso um e peso dois
	addi $v0, $zero, 43 #Gera numero randomico entre 0 e 1 float
	syscall
	swc1 $f0, peso1 # Salvar o numero aleatorio no endereco da data float
	syscall
	swc1 $f0, pesoDois # Salvar o numero aleatorio no endereco da data float
       
        # Mostra pesos inicias do neuronio
	addi $v0, $zero, 4
	la $a0, txtPes
	syscall
       
        lwc1 $f12, peso1 
	addi $v0, $zero, 2
	syscall
	
	addi $v0, $zero, 4
	la $a0, esp
	syscall
	
	lwc1 $f12, pesoDois
	addi $v0, $zero, 2 
	syscall
       
        # Carregando a taxa de aprendizado a $f3
        lwc1 $f3, aprendizado
        # Inicializa o FOR1
	lw $s0, qtdEpocas
	add $t0, $zero, $zero
		
	# For para executar todas as épocas
        FOR1:
        	# Condição de parada do FOR1
        	slt $t1, $t0, $s0
                beq $t1, $zero, FIMFOR1
		
		
		# Inicializa o FOR2
		lw $s1, qtdDados
		add $t5, $zero, $zero
		# For para treinar todos os dados
        	FOR2:
        		# Condição de parada do FOR0
        		slt $t6, $t5, $s1
                	beq $t6, $zero, FIMFOR2
                	
                	mul $t2, $t5, $t4
                	
               
      			lw $s2, vetorDados($t2)
      			mtc1 $s2, $f13
  			cvt.s.w $f13, $f13
      			lwc1 $f4, peso1
      			lwc1 $f5, pesoDois
      			
      			#//funcao de ativacao
      			#float res = pesoA*dados[j] + pesoB*dados[j] => dados[j] * (pesoA + pesoB)
      			add.s $f0, $f4, $f5
      			mul.s $f1, $f13, $f0
      			
      			# erro = (2*dados[j]) - res
      			add.s $f0, $f13, $f13
      			sub.s $f2, $f0, $f1
      			
      			
      			#calculando novos pesos
      			mul.s $f0, $f2, $f3
      			mul.s $f0, $f0, $f13
      			#pesoA += erro * taxa * dados[j]
      			add.s $f4, $f4, $f0
      			swc1 $f4, peso1
      			#pesoB += erro * taxa * dados[j]
      			add.s $f5, $f5, $f0
      			swc1 $f5, pesoDois
      			
      			#printf("\n%d + %d = %.2f", dados[j], dados[j], res);
      			# Print do resultado
      			addi $v0, $zero, 4
			la $a0, barra
			syscall
      			add $a0, $s2 ,$zero 
			addi $v0, $zero, 1
			syscall
			
      			addi $v0, $zero, 4
			la $a0, mais
			syscall
			
			add $a0, $s2 ,$zero 
			addi $v0, $zero, 1
			syscall
			
			addi $v0, $zero, 4
			la $a0, igual
			syscall
			
			sub.s $f11, $f11, $f11
			add.s $f12, $f1, $f11
			addi $v0, $zero, 2 
			syscall
			
      			#printf("\nNovos pesos - A: %.2f, B: %.2f\n", pesoA, pesoB);
      			# Mostra pesos novos do neuronio
			addi $v0, $zero, 4
			la $a0, txtPes2
			syscall
       
        		add.s $f12, $f4, $f11
			addi $v0, $zero, 2
			syscall
	
			addi $v0, $zero, 4
			la $a0, esp
			syscall
	
			add.s $f12, $f5, $f11
			addi $v0, $zero, 2 
			syscall
				
				
				
			#i++
			addi $t5, $t5, 1
                	j FOR2	
       		FIMFOR2:
		
				
		#i++
		addi $t0, $t0, 1
                j FOR1	
       FIMFOR1:
       
        addi $v0, $zero, 4
	la $a0, txtTest
	syscall
                 
        #Pesos
        lwc1 $f4, peso1
        lwc1 $f5, pesoDois       
        #inicializa FOR3                
 	lw $s0, qtdDados
     	add $t0, $zero, $zero

	# For para executar fase de testes
        FOR3:
        	# Condição de parada do FOR3
                slt $t1, $t0, $s0
       		beq $t1, $zero, FIMFOR3
                
             	# Solicita o dado atual do vetor de dados
		addi $v0, $zero, 4
		la $a0, preencheDados
		syscall
				
		# le e armazena o dado no vetor
		addi $v0, $zero, 5
		syscall
  		add $s2, $v0, $zero
		mtc1 $s2, $f13
  		cvt.s.w $f13, $f13
		
		#//funcao de ativacao
      		#float res = pesoA*dados[j] + pesoB*dados[j] => dados[j] * (pesoA + pesoB)
      		add.s $f0, $f4, $f5
      		mul.s $f1, $f13, $f0
      		
      		#printf("\n%d + %d = %.2f", dados[j], dados[j], res);
      		# Print do resultado
      		addi $v0, $zero, 4
		la $a0, barra
		syscall
      		add $a0, $s2 ,$zero 
		addi $v0, $zero, 1
		syscall
			
      		addi $v0, $zero, 4
		la $a0, mais
		syscall
			
		add $a0, $s2 ,$zero 
		addi $v0, $zero, 1
		syscall
			
		addi $v0, $zero, 4
		la $a0, igual
		syscall
			
		sub.s $f11, $f11, $f11
		add.s $f12, $f1, $f11
		addi $v0, $zero, 2 
		syscall
             	
             	# i++
                addi $t0, $t0, 1
        	j FOR3
	FIMFOR3:        
                                      
                        
                                            
	jr $ra 
