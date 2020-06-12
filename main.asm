.data # data segment
	askDay: .asciiz "Nhap ngay DAY: "
	askMonth: .asciiz "Nhap thang MONTH: "
	askYear: .asciiz "Nhap nam YEAR: "
	askAgain: .asciiz "Khong hop le, nhap lai: "
	sDay: .space 2
	sMonth: .space 2
	sYear: .space 4
.text # text segment
	.globl main
main:
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
	add $s0, $v0, $0
	CheckDayAgain.LOOP:
		#if day < 1 goto CHECK_AGAIN
		#if day <= 31 goto EXIT
		#if day >=1 t0=1 ~ if day < 1 t0=0 ||| if day < 1 t0=1 
		slti $t0, $s0, 1
		#if day <=31 t1=1 ||| if 31 < day t1=1
		addi $t3, $0, 31
		slt $t1, $t3, $s0
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
		add $s0, $v0, $0
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
	add $s1, $v0, $0
	CheckMonthAgain.LOOP:
		# if month < 1 t0=1 
		slti $t0, $s1, 1
		# if 12 < day t1=1
		addi $t3, $0, 12
		slt $t1, $t3, $s1
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
		add $s1, $v0, $0
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
	add $s2, $v0, $0
	CheckYearAgain.LOOP:
		# if year < 1900 t0=1 
		slti $t0, $s2, 1900
		# if 2100 < day t1=1
		addi $t3, $0, 2100
		slt $t1, $t3, $s2
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
		add $s2, $v0, $0
		j CheckYearAgain.LOOP
	CheckYearAgain.EXIT:
	
	# => $s0 ~ day, $s1 ~ month, $s2 ~ year
	main.END:
		addi $v0,$0, 10
		syscall
	
_stoi:	# ham chuyen doi char* thanh int, $a0 la strBuffer, $a1 la length
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
	
#_input: # $a0-day, $a1-month, $a2-year

	
	
