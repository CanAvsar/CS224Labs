# CS224 Lab 6 Preliminary Work: Matrix Average
# Can Avşar
# 21902111

	# Text segment
	.text
	main:
	
	la $a0, promptGetN		# Print prompt to ask the user
	li $v0, 4 
	syscall
	
	li $v0, 5			# Get the matrix size (N)
	syscall
	move $t1, $v0			# $t1 = N
	
	mul $t2, $t1, $t1		# $t2 = N^2
	mul $t3, $t2, 4			# $t3 = (N^2)*4 (size for the array)
	
	move $a0, $t3 			# Allocate (N^2)*4 bit memory space
	li $v0, 9			# Syscall 9 is used for dynamic storage allocation
	syscall 	
	
	move $s1, $v0 			# $s1 <== $v0, $s1 points to the beginning of the array.
	
	li $s0, 0			# i = 0
	
	InitLoop:			# For loop to array size getting array elements and set them to their location				
	bge $s0, $t2, EndLoop
	add $t4, $s0, 1			# value = i+1
	sw $t4, ($s1)			# Pass the value to #s1
	add $s1, $s1, 4             	# Make the element the next element
	addi $s0, $s0, 1
	j InitLoop
	EndLoop:
	
	
	#move $s1, $v0  		# Pass the beginning of array to the function  
	#jal PrintMatrix
	#PrintMatrix:

	move $s1, $v0 			# $s1 <== $v0, $s1 points to the beginning of the array.
	
	move $a0, $s1  			# $a0 = Beginning of array 
	move $a1, $t1			# $a1 = N
	li   $a2, 3			# $a2 = i
	li   $a3, 1			# $a3 = j
	jal DisplayElement
	
	move $a0, $s1  			# $a0 = Beginning of array 
	move $a1, $t1			# $a1 = N
	jal CalculateRowAverages
	
	move $a0, $s1  			# $a0 = Beginning of array 
	move $a1, $t1			# $a1 = N
	jal CalculateColAverages
	
	li $v0, 10             		 # Exit
    	syscall
	
	DisplayElement:
	move $s3, $a0			# $s3 = Beginning of array		
	move $s4, $a1			# $s4 = N
	move $s5, $a2			# $s5 = i
	move $s6, $a3			# $s6 = j
	
	sub $t5, $s5, 1			# i - 1
	mul $t6, $s4, 4			# N * 4
	mul $t6, $t6, $t5		# (i - 1) * N * 4	
	
	sub $t5, $s6, 1			# j - 1
	mul $t5, $t5, 4			# (j - 1) * 4
	
	add $t7, $t6, $t5		# (i - 1) * N * 4 + (j - 1) * 4
	
	add $t8, $s3, $t7		# $t8 desired element
	
	lw $s7, ($t8)			# Pass the element to a register
	
	la $a0, promptValue		# Print prompt
	li $v0, 4 
	syscall
	
	li $v0, 1			# Print the element
 	move $a0, $s7
 	syscall
 	
	jr $ra     			# Jump back to the caller
	
	
	
	CalculateColAverages:
	move $s3, $a0			# $s3 = Beginning of col
	move $s4, $a1			# $s4 = N
	

	
	mul $s5, $s4, 4			# $s4 = N*4
	
	li $s0, 0			# i = 0	
	
	ColLoop:			
	bge $s0, $s4, EndColLoop
	
	li $t8, 0			# total = 0
	move $s6, $s3			# $s6 col value index
	
	li $t7, 0			# j = 0
	
		ColLoop2:
		bge $t7, $s4, EndColLoop2
		lw  $s7, ($s6)			# Pass the first element to a register	
		add $t8, $t8, $s7		# $t8 is total
		add $s6, $s6, $s5		# Increment the col counter by N*4 to go to new item same col
		addi $t7, $t7, 1 		# Increment j
		j ColLoop2		
		EndColLoop2:
	
	addi $s0, $s0, 1 	# Increment i
	
	la $a0, promptCol		# Print prompt
	li $v0, 4 
	syscall
	
	li $v0, 1			# Print col no
 	move $a0, $s0
 	syscall
 	
 	div $t8, $s4
 	mflo $t9 
 	
 	la $a0, equals		# Print prompt
	li $v0, 4 
	syscall
 	
	li $v0, 1		# Print the element
 	move $a0, $t9
 	syscall
	
	add $s3, $s3, 4		# Increment the col beginning address by 4 to go to next item in first row
	
	j ColLoop
	EndColLoop:
	jr $ra     			# Jump back to the caller
	
	
	
	
	
	CalculateRowAverages:
	move $s3, $a0			# $s3 = Beginning of col
	move $s4, $a1			# $s4 = N
	

	
	mul $s5, $s4, 4			# $s4 = N*4
	
	li $s0, 0			# i = 0	
	
	RowLoop:			
	bge $s0, $s4, EndRowLoop
	
	li $t8, 0			# total = 0
	move $s6, $s3			# $s6 col value index
	
	li $t7, 0			# j = 0
	
		RowLoop2:
		bge $t7, $s4, EndRowLoop2
		lw  $s7, ($s6)			# Pass the first element to a register	
		add $t8, $t8, $s7		# $t8 is total
		add $s6, $s6, 4		# Increment the col counter by N*4 to go to new item same col
		addi $t7, $t7, 1 		# Increment j
		j RowLoop2		
		EndRowLoop2:
	
	addi $s0, $s0, 1 	# Increment i
	
	la $a0, promptRow		# Print prompt
	li $v0, 4 
	syscall
	
	li $v0, 1			# Print col no
 	move $a0, $s0
 	syscall
 	
 	div $t8, $s4
 	mflo $t9 
 	
 	la $a0, equals		# Print prompt
	li $v0, 4 
	syscall
 	
	li $v0, 1		# Print the element
 	move $a0, $t9
 	syscall
	
	add $s3, $s3, $s5		# Increment the col beginning address by 4 to go to next item in first row
	
	j RowLoop
	EndRowLoop:
	jr $ra     			# Jump back to the caller
	
	
	
	
	
	
	
	
	# Data segment
	.data    
	promptGetN:.asciiz "Enter the matrix size (N): "
	promptValue:.asciiz "The element on desired index: "
	promptCol:.asciiz "\nAverage of column "
	promptRow:.asciiz "\nAverage of row "
	equals:.asciiz " = "
	