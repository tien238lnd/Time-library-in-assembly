.data
	dayline: .asciiz"Nhap ngay: "
	monthline: .asciiz "Nhap thang: "
	yearline: .asciiz "Nhap nam: "
	TIME: .asciiz "DD/MM/YYYYsparespare"
	monthname: .ascii "January   February  March     April     May       June      July      August    September October   November  December "
		
.text
.globl main
main:
	addi $v0, $0, 4
	la $a0, dayline
	syscall
	
	addi $v0, $0, 5
	syscall
	add $s0, $v0, $0
	
	addi $v0, $0, 4
	la $a0, monthline
	syscall
	
	addi $v0, $0, 5
	syscall
	add $s1, $v0, $0
	
	addi $v0, $0, 4
	la $a0, yearline
	syscall
	
	addi $v0, $0, 5
	syscall
	add $s2, $v0, $0
	
	add $a0, $s0, $0
	add $a1, $s1, $0
	add $a2, $s2, $0
	la $a3, TIME
	jal Date
		
	addi $v0, $0, 4
	la $a0, TIME
	syscall
	#newline
	addi $a0, $0, 10
	addi $v0, $0, 11
	syscall
	
	la $a0, TIME
	add $a1, $0, 66
	jal Convert
		
	addi $v0, $0, 4
	la $a0, TIME
	syscall
	
	j endtext
Date:
	addi $sp, $sp, -8
	#save base 10 to register
	sw $s0, 0($sp)
	addi $s0, $0, 10
	#spare $t0 for temp use, remainder
	sw $t0, 4($sp)
	
	addi $t0, $0, 47	#$t0='/'
	sb $t0, 2($a3)		#TIME[2]='/'
	sb $t0, 5($a3)		#TIME[5]='/'
	add $t0, $0, $0		#'\0'
	sb $t0, 10($a3)		#TIME[10]='\0'
	
	#convert day to char
	div $a0, $s0		#day=day/10
	mflo $a0
	mfhi $t0		#$t0=day%10
	addi $t0, $t0, 48	#convert number to char
	sb $t0, 1($a3)		#save byte to place hold by $s0 (TIME[1])
	addi $t0, $a0, 48	#to char
	sb $t0, 0($a3)		#save byte to TIME[0]

	#convert month to char
	div $a1, $s0		#month=month/10
	mflo $a1
	mfhi $t0		#$t0=month%10
	addi $t0, $t0, 48	#number to char
	sb $t0, 4($a3)		#
	addi $t0, $a1, 48	#number to char
	sb $t0, 3($a3)		#
	
	#convert year to char
	div $a2, $s0		#year=year/10
	mflo $a2
	mfhi $t0		#$t0=year%10
	addi $t0, $t0, 48	#number to char
	sb $t0, 9($a3)		#
	
	div $a2, $s0		#year=year/10
	mflo $a2
	mfhi $t0		#$t0=year%10
	addi $t0, $t0, 48	#number to char
	sb $t0, 8($a3)		#
	
	div $a2, $s0		#year=year/10
	mflo $a2
	mfhi $t0		#$t0=year%10
	addi $t0, $t0, 48	#number to char
	sb $t0, 7($a3)		#
	
	addi $t0, $a2, 48	#number to char
	sb $t0, 6($a3)		#
	
	#return value
	add $v0, $a3, $0	
	#get back $s0, $s1, $t0
	lw $s0, 0($sp)
	lw $t0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
Convert:
	addi $sp, $sp, -12
	sw $s0, 0($sp)		#for check type, index, other
	sw $s1, 4($sp)		#...
	sw $t0, 8($sp)		#for temp use
	
	addi $t0, $0, 65
	bne $t0, $a1, TypeBC
	TypeA:			#this label just for clear, no use
		lb $s0, 0($a0)		#exchange first digit of month and day
		lb $s1, 3($a0)
		sb $s1, 0($a0)
		sb $s0, 3($a0)
		lb $s0, 1($a0)		#exchange second digit of month and day
		lb $s1, 4($a0)
		sb $s1, 1($a0)
		sb $s0, 4($a0)
		j EndConvert
	TypeBC:
		#shift right 10 character
		addi $s0, $a0, 10
		For1:
			slt $t0, $a0, $s0
			beq $t0, $0, ExitFor1
			lb $s1, 0($a0)
			sb $s1, 10($a0)
			addi $a0, $a0, 1
			j For1
		ExitFor1:
		addi $a0, $a0, -10	#TIME[0]
		addi $s0, $0, 10
		#get month to s2
		lb $s1, 3($a0)		#first digit of month
		addi $s1, $s1, -48	#character to number
		mult $s1, $s0		#$s2*10
		mflo $s1
		lb $t0, 4($a0)
		addi $t0, $t0, -48	#character to number
		add $s1, $s1, $t0
		#find the pos begin of month in string monthname
		addi $s1, $s1, -1
		mult $s1, $s0		#$s2*10, character-th
		mflo $s1
		la $s0, monthname	#add begin address, monthname[0]+k
		add $s1, $s1, $s0	#$s2=&monthname[k]
		
		addi $sp, $sp, -4	#spare to save $s0
		sw $a0, 0($sp)		#save $s0		
		#check type B or C
		addi $t0, $0, 66	#'B'
		beq $t0, $a1, AddMonth
		addi $a0, $a0, 3	#case C: 'DD Month'=> begin add month at index 3
		addi $t0, $0, 32	#' '
		sb $t0, -1($a0)
		AddMonth:
			lb $s0, 0($s1)
			sb $s0, 0($a0)
			addi $t0, $s0, -32
			beq $t0, $0, EndAddMonth
			addi $s1, $s1, 1
			addi $a0, $a0, 1
			j AddMonth
		EndAddMonth:
		lw $s1, 0($sp)		#get back saved $s0, save to $s2
		addi $s1, $s1, 10
		#check type B or C
		addi $t0, $0, 66	#'B'
		bne $t0, $a1, TypeC		
	TypeB:
		#shift day
		lb $s0, 0($s1)
		sb $s0, 1($a0)
		lb $s0, 1($s1)
		sb $s0, 2($a0)
		addi $a0, $a0, 3	#don't jump, go next to Type C to get year on	
	TypeC:
		addi $t0, $0, 44	#','
		sb $t0, 0($a0)
		addi $t0, $0, 32	#' '
		sb $t0, 1($a0)
		#shift year
		lb $s0, 6($s1)
		sb $s0, 2($a0)
		lb $s0, 7($s1)
		sb $s0, 3($a0)
		lb $s0, 8($s1)
		sb $s0, 4($a0)
		lb $s0, 9($s1)
		sb $s0, 5($a0)
		add $t0, $0, $0	#'\0'
		sb $t0, 6($a0)
		
	EndConvert:
	#lw $a0, 0($sp)
	lw $v0, 0($sp)		#first $a0, &TIME[0]
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $t0, 8($sp)
	addi $sp, $sp, 12
	jr $ra
endtext:
