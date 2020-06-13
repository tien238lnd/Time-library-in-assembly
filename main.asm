#  trong hàm ???c g?i n?u dùng $t thì không ph?i l?u vào stack, n?u dùng $s thì ph?i l?u vào stack, 
# còn hàm th?c hi?n g?i thì n?u dùng $s không ph?i l?u vào stack, n?u c?n $t thì ph?i l?u vào stack


.data # data segment
	askDay: .asciiz "Nhap ngay DAY: "
	askMonth: .asciiz "Nhap thang MONTH: "
	askYear: .asciiz "Nhap nam YEAR: "
	askAgain: .asciiz "Khong dung format, nhap lai: "
	inputAgain: .asciiz "Khong hop le, nhap lai: "
	sDay: .space 2
	sMonth: .space 2
	sYear: .space 4
.text # text segment
	.globl main
main:

	jal _input
	add $s0, $a0, $0
	add $s1, $a1, $0
	add $s2, $a2, $0


main.END:
		addi $v0,$0, 10
		syscall



	_input:
	# => $t5 ~ day, $t6 ~ month, $t7 ~ year
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	# cout << askDay
	addi $v0, $0, 4
	la $a0, askDay
	syscall
	# cin >> sDay
	addi $v0, $0, 8
	la $a0, sDay
	la $a1, 3
	syscall
	# day=stoi(sday, length)
	addi $a1, $a1, -1
	jal _stoi
	add $t5, $v0, $0
	CheckDayAgain.LOOP:
		#if day < 1 goto CHECK_AGAIN
		#if day <= 31 goto EXIT
		#if day >=1 t0=1 ~ if day < 1 t0=0 ||| if day < 1 t0=1 
		slti $t0, $t5, 1
		#if day <=31 t1=1 ||| if 31 < day t1=1
		addi $t3, $0, 31
		slt $t1, $t3, $t5
		#t2=t0+t1
		add $t2, $t0, $t1
		#if t2=2 goto EXIT ||| if t2=0 goto EXIT
		beq $t2, 0, CheckDayAgain.EXIT
		#CHECK_AGAIN:
		# cout << askAgain
		addi $v0, $0, 4
		la $a0, askAgain
		syscall
		# cin >> sDay
		addi $v0, $0, 8
		la $a0, sDay
		la $a1, 3
		syscall
		# day=stoi(sday, length)
		addi $a1, $a1, -1
		jal _stoi
		add $t5, $v0, $0
		j CheckDayAgain.LOOP
	CheckDayAgain.EXIT:
	
	# cout << askMonth
	addi $v0, $0, 4
	la $a0, askMonth
	syscall
	# cin >> sMonth
	addi $v0, $0, 8
	la $a0, sMonth
	la $a1, 3
	syscall
	# month=stoi(smonth, length)
	addi $a1, $a1, -1
	jal _stoi
	add $t6, $v0, $0
	CheckMonthAgain.LOOP:
		# if month < 1 t0=1 
		slti $t0, $t6, 1
		# if 12 < day t1=1
		addi $t3, $0, 12
		slt $t1, $t3, $t6
		# t2=t0+t1
		add $t2, $t0, $t1
		# if t2=0 goto EXIT
		beq $t2, 0, CheckMonthAgain.EXIT
		# cout << askAgain
		addi $v0, $0, 4
		la $a0, askAgain
		syscall
		# cin >> sMonth
		addi $v0, $0, 8
		la $a0, sMonth
		la $a1, 3
		syscall
		# month=stoi(smonth, length)
		addi $a1, $a1, -1
		jal _stoi
		add $t6, $v0, $0
		j CheckMonthAgain.LOOP
	CheckMonthAgain.EXIT:
	
	# cout << askYear
	addi $v0, $0, 4
	la $a0, askYear
	syscall
	# cin >> sYear
	addi $v0, $0, 8
	la $a0, sYear
	la $a1, 5
	syscall
	# year=stoi(syear, length)
	addi $a1, $a1, -1
	jal _stoi
	add $t7, $v0, $0
	CheckYearAgain.LOOP:
		# if year < 1900 t0=1 
		slti $t0, $t7, 1900
		# if 2100 < day t1=1
		addi $t3, $0, 2100
		slt $t1, $t3, $t7
		# t2=t0+t1
		add $t2, $t0, $t1
		# if t2=0 goto EXIT
		beq $t2, 0, CheckYearAgain.EXIT
		# cout << askAgain
		addi $v0, $0, 4
		la $a0, askAgain
		syscall
		# cin >> sYear
		addi $v0, $0, 8
		la $a0, sYear
		la $a1, 5
		syscall
		# year=stoi(syear, length)
		addi $a1, $a1, -1
		jal _stoi
		add $t7, $v0, $0
		j CheckYearAgain.LOOP
	CheckYearAgain.EXIT:
	
	CheckValid:
		beq $t6, 4, CHECKDAY31
		beq $t6, 6, CHECKDAY31
		beq $t6, 9, CHECKDAY31
		beq $t6, 11, CHECKDAY31
		j CHECKMONTH2
	CHECKDAY31:
		beq $t5, 31, INPUTAGAIN
		j CheckValid.EXIT
	CHECKMONTH2:
		beq $t6, 2, CHECKLEAP
		j CheckValid.EXIT
	CHECKLEAP:
		add $a0, $t7, $0
		jal _isLeap
		beq $v0, 1, OK_LEAP
		j NOT_LEAP
	OK_LEAP:
		slti $t0, $t5, 30
		beq $t0, 1, CheckValid.EXIT
		j INPUTAGAIN
	NOT_LEAP:
		slti $t0, $t5, 29
		beq $t0, 1, CheckValid.EXIT
	INPUTAGAIN:
		# cout << inputAgain
		addi $v0, $0, 4
		la $a0, inputAgain
		syscall
		j _input

	CheckValid.EXIT:
	
	add $a0, $t5, $0
	add $a1, $t6, $0
	add $a2, $t7, $0
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
	
	
_isLeap: # ch?a vi?t, ?? t?m cái label ?? debug
	
_stoi:	# ham chuyen doi char* thanh int, $a0 la strBuffer, $a1 la max_length
	add $v0, $0, 0
	#add $t0, $0, 0	# bien dem vong for
	addi $t0, $a0, 0 
	add $a1, $a0, $a1 # a1 bay gio la dc cuoi cung cua string
	stoi.LOOP:
		beq $t0, $a1, stoi.EXIT
		
		#lb $t1, $t0($a0)	# str[i]
		lb $t1, 0($t0)	# str[i]
		beq $t1, '\n', stoi.EXIT
		
		slti $t2, $t1, '0'
		beq $t2, 1, stoi.ERROR
		addi $t3, $0, '9'
		slt $t2, $t3, $t1
		beq $t2, 1, stoi.ERROR
		
		mul $v0, $v0, 10
		add $v0, $v0, $t1
		sub $v0, $v0, '0'
		addi $t0, $t0, 1
		j stoi.LOOP
	stoi.ERROR:
		addi $v0, $0, -1 
	stoi.EXIT:
		jr $ra
	

	
	
