.data 
	str_ask_day: .asciiz "\nNhap ngay DAY: "
	str_ask_month: .asciiz "\nNhap thang MONTH: "
	str_ask_year: .asciiz "\nNhap nam YEAR [0-2399): "
	str_invalid: .asciiz "\nKhong hop le, nhap lai: "
	
	TIME: .asciiz "DD/MM/YYYYsparespare"
	TIME2: .asciiz "DD/MM/YYYYsparespare"
	str_MONTH_NAME: .ascii "January   February  March     April     May       June      July      August    September October   November  December "
	str_WEEKDAY_NAME: .asciiz "Sun","  Mon","  Tues"," Wed","  Thurs","Fri","  Sat"
	
	str_menu:	
		.asciiz "\n\n--- MENU ---"
	str_option0:
		.asciiz "\n0. Nhap lai ngay thang nam khac"
	str_option1:
		.asciiz "\n1. Xuat theo dinh dang DD/MM/YYYY"
	str_option2:
		.asciiz "\n2. Chuyen doi thanh cac dinh dang khac"
	str_option2_ask_type:
		.asciiz "\nChon kieu convert (A- MM/DD/YYYY | B- Month DD, YYYY | C- DD Month, YYYY): "
	str_option3:
		.asciiz "\n3. Cho biet ngay vua nhap la thu may trong tuan"
	str_option4:
		.asciiz "\n4. Kiem tra nam nhuan"
	str_option5:
		.asciiz "\n5. Cho biet khoang thoi gian giua chuoi TIME_1 va TIME_2"
	str_option6:
		.asciiz "\n6. Cho biet 2 nam nhuan gan nhat voi nam vua nhap"
	str_option7:
		.asciiz "\n7. Thoat"
	str_ask_option:
		.asciiz "\nChon mot chuc nang: "
	
	str_result: .asciiz "\n===> "
	str_leap: .asciiz "Dung la nam nhuan!"
	str_not_leap: .asciiz "Khong phai nam nhuan."
	str_ask_TIME2: .asciiz "\nNhap ngay thang nam cho TIME2: "
	str_get_time: .asciiz "Khoang cach giua "
	str_closest: .asciiz "Hai nam nhuan gan nhat la "
	str_and: .asciiz " va "
	str_is: .asciiz " la: "
	
.text 
	.globl main

# Chuong trinh chinh
main:
	main_LOOP:
	# Nhap NGAY THANG NAM
	addi $sp, $sp, -12
	addi $a0, $sp, 0	# &day
	addi $a1, $sp, 4	# &month
	addi $a2, $sp, 8	# &year
	# Input(&day, &month, &year)
	jal Input
	# chuyen gia tri day, hien dang nam o vung nho co dia chi $a0, vao trong thanh ghi $a0
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
	la $a3, TIME
	jal Date

	MENU_LOOP:
	# In ra toan bo cac thao tac
	la $a0, str_menu
	addi $v0, $0, 4	
	syscall
	la $a0, str_option0
	addi $v0, $0, 4	
	syscall
	la $a0, str_option1
	addi $v0, $0, 4	
	syscall
	la $a0, str_option2
	addi $v0, $0, 4
	syscall
	la $a0, str_option3
	addi $v0, $0, 4
	syscall
	la $a0, str_option4
	addi $v0, $0, 4
	syscall
	la $a0, str_option5
	addi $v0, $0, 4
	syscall
	la $a0, str_option6
	addi $v0, $0, 4	
	syscall
	la $a0, str_option7
	addi $v0, $0, 4
	syscall
	la $a0, str_ask_option
	addi $v0, $0, 4
	syscall

	main_OPTION_LOOP:
		# Doc thao tac cua nguoi dung, luu vao $s3
		addi $v0, $0, 12 
		syscall
		add $s3, $0, $v0
		addi $t0, $0, '0'					
		beq $s3, $t0, main_LOOP
		addi $t0, $0, '1'				
		beq $s3, $t0, main_OPTION1
		addi $t0, $0, '2'
		beq $s3, $t0, main_OPTION2
		addi $t0, $0, '3'				
		beq $s3, $t0, main_OPTION3
		addi $t0, $0, '4' 			
		beq $s3, $t0, main_OPTION4
		addi $t0, $0, '5' 		
		beq $s3, $t0, main_OPTION5
		addi $t0, $0, '6' 	
		beq $s3, $t0, main_OPTION6
		addi $t0, $0, '7' 
		beq $s3, $t0, main_EXIT
		# neu so khac thi yeu cau nhap lai
		la $a0, str_invalid
		addi $v0, $0, 4	
		syscall
		j main_OPTION_LOOP
	
	main_EXIT:
		addi $v0,$0, 10		# thoat chuong trinh
		syscall
		
	main_OPTION1:
		la $a0, str_result
		addi $v0, $0, 4	
		syscall
		la $a0, TIME
		addi $v0, $0, 4	
		syscall
		j MENU_LOOP
		
	main_OPTION2:
		la $a0, str_option2_ask_type
		addi $v0, $0, 4	
		syscall
		main_OPTION2_LOOP:
			addi $v0, $0, 12 
			syscall
			add $s0, $0, $v0
			addi $t0, $0, 65
			beq $s0, $t0, main_OPTION2_CONVERT
			addi $t0, $0, 66
			beq $s0, $t0, main_OPTION2_CONVERT
			addi $t0, $0, 67
			beq $s0, $t0, main_OPTION2_CONVERT
			addi $s0, $s0, -32
			addi $t0, $0, 65
			beq $s0, $t0, main_OPTION2_CONVERT
			addi $t0, $0, 66
			beq $s0, $t0, main_OPTION2_CONVERT
			addi $t0, $0, 67
			beq $s0, $t0, main_OPTION2_CONVERT
			la $a0, str_invalid
			addi $v0, $0, 4	
			syscall
			j main_OPTION2_LOOP
		
		main_OPTION2_CONVERT:
			# copy TIME ra TIME2
			la $a0, TIME
			la $a1, TIME2
			addi $a2, $0, 11
			jal CopyStr
			# convert TIME
			add $a1, $s0, $0
			jal Convert
			# print new TIME
			la $a0, str_result
			addi $v0, $0, 4	
			syscall
			la $a0, TIME
			addi $v0, $0, 4	
			syscall
			# copy TIME2 vao lai TIME
			la $a0, TIME2
			la $a1, TIME
			addi $a2, $0, 11
			jal CopyStr
			j MENU_LOOP
			
		#void CopyStr(char* src, char*dst, int len)
		CopyStr:
			add $t0, $0, $0
			CopyStr_LOOP:
			slt $t1, $t0, $a2
			beq $t1, $0, CopyStr_END
			add $t1, $t0, $a0
			lb $t2, 0($t1)
			add $t1, $t0, $a1
			sb $t2, 0($t1)
			addi $t0, $t0, 1
			j CopyStr_LOOP
			CopyStr_END:
			jr $ra

	main_OPTION3:
		la $a0, str_result
		addi $v0, $0, 4	
		syscall
		la $a0, TIME
		jal WeekDay
		add $a0, $v0, $0
		addi $v0, $0, 4
		syscall
		j MENU_LOOP
		
	main_OPTION4:
		la $a0, str_result
		addi $v0, $0, 4	
		syscall
		la $a0, TIME
		jal LeapYear
		beq $v0, $0, main_OPTION4_PRINT_NOT_LEAP
		
		main_OPTION4_PRINT_LEAP:
			la $a0, str_leap
			addi $v0, $0, 4	
			syscall
			j MENU_LOOP
		
		main_OPTION4_PRINT_NOT_LEAP:
			la $a0, str_not_leap
			addi $v0, $0, 4	
			syscall
			j MENU_LOOP

	main_OPTION5:
		la $a0, str_ask_TIME2
		addi $v0, $0, 4	
		syscall
		# Nhap NGAY THANG NAM
		addi $sp, $sp, -12
		addi $a0, $sp, 0	# &day
		addi $a1, $sp, 4	# &month
		addi $a2, $sp, 8	# &year
		# Input(&day, &month, &year)
		jal Input
		# chuyen gia tri day, hien dang nam o vung nho co dia chi $a0, vao trong thanh ghi $a0
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $a2, 8($sp)
		addi $sp, $sp, 12
		la $a3, TIME2
		jal Date
		
		la $a0, str_result
		addi $v0, $0, 4	
		syscall
		la $a0, str_get_time
		addi $v0, $0, 4	
		syscall
		la $a0, TIME
		addi $v0, $0, 4	
		syscall
		la $a0, str_and
		addi $v0, $0, 4	
		syscall
		la $a0, TIME2
		addi $v0, $0, 4	
		syscall
		la $a0, str_is
		addi $v0, $0, 4	
		syscall
		la $a0, TIME
		la $a1, TIME2
		jal GetTime
		add $a0, $v0, $0
		addi $v0, $0, 1
		syscall
		j MENU_LOOP
		
	main_OPTION6:
		la $a0, TIME
		jal Find2LeapYearClosest
		add $s0, $v0, $0
		add $s1, $v1, $0
		la $a0, str_result
		addi $v0, $0, 4	
		syscall
		la $a0, str_closest
		addi $v0, $0, 4	
		syscall
		add $a0, $s0, $0
		addi $v0, $0, 1	
		syscall
		la $a0, str_and
		addi $v0, $0, 4	
		syscall
		add $a0, $s1, $0
		addi $v0, $0, 1	
		syscall
		j MENU_LOOP
	
	
# Nhap NGAY THANG NAM, kiem tra tinh hop le, neu sai thi nhap lai
# void Input(int* day, int* month, int* year)
# Ket qua duoc luu vao $a0 ~ &day, $a1 ~ &month, $a2 ~ &year
Input:
	addi $sp, $sp, -48  	# Luu $ra vao stack					
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $s0, 16($sp)
	sw $s1, 20($sp)
	sw $s2, 24($sp)
	addi $s0, $sp, 28		# char sday[2]
	addi $s1, $sp, 30		# char smonth[2]
	addi $s2, $sp, 32		# char syear[4]
	sw $s4, 36($sp)			# int day
	sw $s5, 40($sp)			# int month
	sw $s6, 44($sp)			# int year
	
	Input_ENTRY:

	# Nhap chuoi NGAY
	addi $v0, $0, 4  		# cout << str_ask_day
	la $a0, str_ask_day
	syscall
	addi $v0, $0, 8			# cin >> sday
	add $a0, $s0, $0
	addi $a1, $0, 3
	syscall	
	addi $a1, $a1, -1 		# day = stoi(sday, length)
	jal stoi
	add $s4, $v0, $0
	Input_CHECK_DAY_LOOP:
	slti $t0, $s4, 1					# if day < 1, t0 = 1 
	addi $t3, $0, 31					
	slt $t1, $t3, $s4					# if 31 < day, t1 = 1
	add $t2, $t0, $t1					# t2 = t0 + t1
	beq $t2, $0, Input_CHECK_DAY_EXIT	# if t2 = 0 goto EXIT (valid)
	addi $v0, $0, 4 				# cout << str_invalid
	la $a0, str_invalid
	syscall
	addi $v0, $0, 8					# cin >> sday
	add $a0, $s0, $0
	addi $a1, $0, 3
	syscall
	addi $a1, $a1, -1				# day = stoi(sday, length)
	jal stoi
	add $s4, $v0, $0
	j Input_CHECK_DAY_LOOP
	Input_CHECK_DAY_EXIT:
	
	# Nhap chuoi THANG
	addi $v0, $0, 4 				# cout << str_ask_month
	la $a0, str_ask_month
	syscall
	addi $v0, $0, 8					# cin >> smonth
	add $a0, $s1, $0
	addi $a1, $0, 3
	syscall
	addi $a1, $a1, -1				# month = stoi(smonth, length)
	jal stoi
	add $s5, $v0, $0
	Input_CHECK_MONTH_LOOP:
	slti $t0, $s5, 1				# if month < 1, t0 = 1
	addi $t3, $0, 12				
	slt $t1, $t3, $s5				# if 12 < month, t1 = 1
	add $t2, $t0, $t1				# t2 = t0 + t1
	beq $t2, $0, Input_CHECK_MONTH_EXIT 	# if t2 = 0 goto EXIT (valid)
	addi $v0, $0, 4					# cout << str_invalid
	la $a0, str_invalid
	syscall
	addi $v0, $0, 8					# cin >> smonth
	add $a0, $s1, $0
	addi $a1, $0, 3
	syscall
	addi $a1, $a1, -1				# month = stoi(smonth, length)
	jal stoi
	add $s5, $v0, $0
	j Input_CHECK_MONTH_LOOP
	Input_CHECK_MONTH_EXIT:
	
	# Nhap chuoi NAM
	addi $v0, $0, 4					# cout << str_ask_year
	la $a0, str_ask_year
	syscall
	addi $v0, $0, 8					# cin >> syear
	add $a0, $s2, $0
	addi $a1, $0, 5
	syscall
	addi $a1, $a1, -1				# year = stoi(syear, length)
	jal stoi
	add $s6, $v0, $0
	Input_CHECK_YEAR_LOOP:	 
	slti $t0, $s6, 0				# if year < 0, t0 = 1
	addi $t3, $0, 2399				
	slt $t1, $t3, $s6				# if 2399 < year, t1 = 1
	add $t2, $t0, $t1				# t2 = t0 + t1
	beq $t2, $0, Input_CHECK_YEAR_EXIT	# if t2 = 0 goto EXIT (valid)
	addi $v0, $0, 4					# cout << str_invalid
	la $a0, str_invalid
	syscall
	addi $v0, $0, 8					# cin >> syear
	add $a0, $s2, $0
	addi $a1, $0, 5
	syscall
	addi $a1, $a1, -1				# year = stoi(syear, length)
	jal stoi
	add $s6, $v0, $0
	j Input_CHECK_YEAR_LOOP
	Input_CHECK_YEAR_EXIT:
	
	Input_CHECK_VALID:
		addi $t0, $0, 4
		beq $s5, $t0, Input_CHECKDAY31
		addi $t0, $0, 6
		beq $s5, $t0, Input_CHECKDAY31
		addi $t0, $0, 9
		beq $s5, $t0, Input_CHECKDAY31
		addi $t0, $0, 11
		beq $s5, $t0, Input_CHECKDAY31
		j Input_CHECKMONTH2

	Input_CHECKDAY31:
		addi $t0, $0, 31
		beq $s4, $t0, Input_INPUTAGAIN
		j Input_CHECK_VALID_END

	Input_CHECKMONTH2:
		addi $t0, $0, 2
		beq $s5, $t0, Input_CHECKLEAP
		j Input_CHECK_VALID_END

	Input_CHECKLEAP:
		add $a0, $s6, $0
		jal CheckLeapYear
		beq $v0, $0, Input_NOT_LEAP

	Input_OK_LEAP:
		slti $t0, $s4, 30
		beq $t0, $0, Input_INPUTAGAIN
		j Input_CHECK_VALID_END
	
	Input_NOT_LEAP:
		slti $t0, $s4, 29
		beq $t0, $0, Input_INPUTAGAIN
		j Input_CHECK_VALID_END

	Input_INPUTAGAIN:
		# cout << str_invalid
		addi $v0, $0, 4
		la $a0, str_invalid
		syscall
		j Input_ENTRY

	Input_CHECK_VALID_END:
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $a2, 12($sp)
		sw $s4, 0($a0)
		sw $s5, 0($a1)
		sw $s6, 0($a2)
		lw $s0, 16($sp)
		lw $s1, 20($sp)
		lw $s2, 24($sp)
		lw $s4, 36($sp)
		lw $s5, 40($sp)
		lw $s6, 44($sp)
		
		lw $ra, 0($sp)
		addi $sp, $sp, 48
		jr $ra

# int stoi(char* str, int length)
stoi:	
	addi $v0, $0, 0
	#add $t0, $0, 0	# bien dem vong for
	addi $t0, $a0, 0 
	add $a1, $a0, $a1 # a1 bay gio la dc cuoi cung cua string
	
	stoi_LOOP:
	beq $t0, $a1, stoi_EXIT

	lb $t1, 0($t0)	# str[i]
	addi $t2, $0, '\n'
	beq $t1, $t2, stoi_EXIT
	
	addi $t4, $0, 1
	slti $t2, $t1, '0'
	beq $t2, $t4, stoi_ERROR
	addi $t3, $0, '9'
	slt $t2, $t3, $t1
	beq $t2, $t4, stoi_ERROR
	
	mul $v0, $v0, 10
	add $v0, $v0, $t1
	addi $v0, $v0, -48
	addi $t0, $t0, 1
	j stoi_LOOP
	
	stoi_ERROR:
	addi $v0, $0, -1 
	
	stoi_EXIT:
	jr $ra
	
# function for option 1
# char* Date(int day, int month, int year, char* TIME)
Date:
	addi $sp, $sp, -8
	# save base 10 to register
	sw $s0, 0($sp)
	addi $s0, $0, 10
	# spare $t0 for temp use, remainder
	sw $t0, 4($sp)

	addi $t0, $0, 47	# $t0 = '/'
	sb $t0, 2($a3)		# TIME[2] = '/'
	sb $t0, 5($a3)		# TIME[5] = '/'
	add $t0, $0, $0		# '\0'
	sb $t0, 10($a3)		# TIME[10] = '\0'

	# convert day to char
	div $a0, $s0		# day = day / 10
	mflo $a0
	mfhi $t0			# $t0 = day % 10
	addi $t0, $t0, 48	# convert number to char
	sb $t0, 1($a3)		# save byte to place hold by $s0 (TIME[1])
	addi $t0, $a0, 48	# to char
	sb $t0, 0($a3)		# save byte to TIME[0]

	#convert month to char
	div $a1, $s0		# month = month / 10
	mflo $a1
	mfhi $t0			# $t0 = month % 10
	addi $t0, $t0, 48	# number to char
	sb $t0, 4($a3)		
	addi $t0, $a1, 48	# number to char
	sb $t0, 3($a3)		

	# convert year to char
	div $a2, $s0		# year = year / 10
	mflo $a2
	mfhi $t0			# $t0 = year % 10
	addi $t0, $t0, 48	# number to char
	sb $t0, 9($a3)		

	div $a2, $s0		# year = year / 10
	mflo $a2
	mfhi $t0			# $t0 = year % 10
	addi $t0, $t0, 48	# number to char
	sb $t0, 8($a3)		

	div $a2, $s0		# year = year / 10
	mflo $a2
	mfhi $t0			# $t0 = year % 10
	addi $t0, $t0, 48	# number to char
	sb $t0, 7($a3)		

	addi $t0, $a2, 48	# number to char
	sb $t0, 6($a3)		

	# return value
	add $v0, $a3, $0	
	# get back $s0, $s1, $t0
	lw $s0, 0($sp)
	lw $t0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
# function for option 2:
# char* Convert(char* TIME, char type)
Convert:
	addi $sp, $sp, -12
	sw $s0, 0($sp)		# for check type, index, other
	sw $s1, 4($sp)		# ...
	sw $t0, 8($sp)		# for temp use

	addi $t0, $0, 65
	bne $t0, $a1, Convert_TYPE_B_C
	Convert_TYPE_A:			# this label just for clear, no use
		lb $s0, 0($a0)		# exchange first digit of month and day
		lb $s1, 3($a0)
		sb $s1, 0($a0)
		sb $s0, 3($a0)
		lb $s0, 1($a0)		# exchange second digit of month and day
		lb $s1, 4($a0)
		sb $s1, 1($a0)
		sb $s0, 4($a0)
		j Convert_END
	Convert_TYPE_B_C:
		# shift right 10 character
		addi $s0, $a0, 10
		Convert_FOR_1:
			slt $t0, $a0, $s0
			beq $t0, $0, Convert_FOR_1_EXIT
			lb $s1, 0($a0)
			sb $s1, 10($a0)
			addi $a0, $a0, 1
			j Convert_FOR_1
		Convert_FOR_1_EXIT:
		addi $a0, $a0, -10	# TIME[0]
		addi $s0, $0, 10
		# get month to s2
		lb $s1, 3($a0)		# first digit of month
		addi $s1, $s1, -48	# character to number
		mult $s1, $s0		# $s2 * 10
		mflo $s1
		lb $t0, 4($a0)
		addi $t0, $t0, -48	# character to number
		add $s1, $s1, $t0
		# find the pos begin of month in string str_MONTH_NAME
		addi $s1, $s1, -1
		mult $s1, $s0		# $s2 * 10, character-th
		mflo $s1
		la $s0, str_MONTH_NAME	# add begin address, str_MONTH_NAME[0] + k
		add $s1, $s1, $s0	# $s2 = &str_MONTH_NAME[k]

		addi $sp, $sp, -4	# spare to save $s0
		sw $a0, 0($sp)		# save $s0		
		# check type B or C
		addi $t0, $0, 66	# 'B'
		beq $t0, $a1, Convert_ADD_MONTH
		addi $a0, $a0, 3	# case C: 'DD Month'=> begin add month at index 3
		addi $t0, $0, 32	# ' '
		sb $t0, -1($a0)
		Convert_ADD_MONTH:
			lb $s0, 0($s1)
			sb $s0, 0($a0)
			addi $t0, $s0, -32
			beq $t0, $0, Convert_ADD_MONTH_EXIT
			addi $s1, $s1, 1
			addi $a0, $a0, 1
			j Convert_ADD_MONTH
		Convert_ADD_MONTH_EXIT:
		lw $s1, 0($sp)		# get back saved $s0, save to $s2
		addi $s1, $s1, 10
		# check type B or C
		addi $t0, $0, 66	# 'B'
		bne $t0, $a1, Convert_TYPE_C		
	Convert_TYPE_B:
		# shift day
		lb $s0, 0($s1)
		sb $s0, 1($a0)
		lb $s0, 1($s1)
		sb $s0, 2($a0)
		addi $a0, $a0, 3	# don't jump, go next to Type C to get year on	
	Convert_TYPE_C:
		addi $t0, $0, 44	# ','
		sb $t0, 0($a0)
		addi $t0, $0, 32	# ' '
		sb $t0, 1($a0)
		# shift year
		lb $s0, 6($s1)
		sb $s0, 2($a0)
		lb $s0, 7($s1)
		sb $s0, 3($a0)
		lb $s0, 8($s1)
		sb $s0, 4($a0)
		lb $s0, 9($s1)
		sb $s0, 5($a0)
		add $t0, $0, $0	# '\0'
		sb $t0, 6($a0)

	Convert_END:
	lw $v0, 0($sp)		# first $a0, &TIME[0]
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $t0, 8($sp)
	addi $sp, $sp, 12
	jr $ra

# function for option 3:
# char* WeekDay(char* TIME)
# return the day of the week (Sun, Mon, Tues, Wed, Thurs, Fri, Sat)
WeekDay:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	add $s0, $a0, $0	# &TIME[0]
	jal Day
	add $s1, $v0, $0	# add d
	
	add $a0, $s0, $0
	jal Year
	add $s2, $v0, $0
	
	add $a0, $s0, $0
	jal CheckGregorianDate
	
	addi $t0, $0, 100
	div $s2, $t0
	mflo $t0
	mfhi $t1
	
	# add c
	# if v0 == 0 => Julian Date
	beq $v0, $0, WeekDay_JULIAN_DATE
	# if Gregorian date
	addi $sp, $sp, -28
	addi $t2, $0, 4
	sw $t2, 0($sp)
	addi $t2, $0, 2
	sw $t2, 4($sp)
	addi $t2, $0, 0
	sw $t2, 8($sp)
	addi $t2, $0, 6
	sw $t2, 12($sp)
	addi $t2, $0, 4
	sw $t2, 16($sp)
	addi $t2, $0, 2
	sw $t2, 20($sp)
	addi $t2, $0, 0
	sw $t2, 24($sp)
	
	addi $t0, $t0, -17	# century = 17 -> index 0
	sll $t0, $t0, 2
	add $t0, $t0, $sp
	lw $t0, 0($t0)
	add $s1, $s1, $t0
	addi $sp, $sp, 28
	j WeekDay_ADD_YEAR
	
	# if Julian date
	WeekDay_JULIAN_DATE:
	addi $t2, $0, 18
	sub $t2, $t2, $t0
	add $s1, $s1, $t2
	
	WeekDay_ADD_YEAR:
	add $s1, $s1, $t1	# add y
	
	addi $t0, $0, 4
	div $t1, $t0
	mflo $t0
	add $s1, $s1, $t0	# add floor(y/4)
	
	add $a0, $s0, $0
	jal Month
	add $s3, $v0, $0	# save month
	
	addi $sp, $sp, -48
	addi $t0, $0, 0
	sw $t0, 0($sp)
	addi $t0, $0, 3
	sw $t0, 4($sp)
	addi $t0, $0, 3
	sw $t0, 8($sp)
	addi $t0, $0, 6
	sw $t0, 12($sp)
	addi $t0, $0, 1
	sw $t0, 16($sp)
	addi $t0, $0, 4
	sw $t0, 20($sp)
	addi $t0, $0, 6
	sw $t0, 24($sp)
	addi $t0, $0, 2
	sw $t0, 28($sp)
	addi $t0, $0, 5
	sw $t0, 32($sp)
	addi $t0, $0, 0
	sw $t0, 36($sp)
	addi $t0, $0, 3
	sw $t0, 40($sp)
	addi $t0, $0, 5
	sw $t0, 44($sp)

	add $a0, $s2, $0
	jal CheckLeapYear
	beq $v0, $0, WeekDay_NOT_LEAP_YEAR
	addi $t0, $0, 6
	sw $t0, 0($sp)
	addi $t0, $0, 2
	sw $t0, 4($sp)		# do not jump
	WeekDay_NOT_LEAP_YEAR:
	
	add $s2, $sp, $0	# begin pos of m array
	addi $s3, $s3, -1
	sll $s3, $s3, 2
	add $s2, $s2, $s3	# pos of particular m element needed
	lw $t0, 0($s2)		# load m
	add $s1, $s1, $t0	# add m
	
	addi $sp, $sp, 48
	
	addi $s2, $0, 7
	div $s1, $s2
	mfhi $v0		# number of result 0->6
	
	addi $t0, $0, 6
	mult $v0, $t0
	mflo $v0		# start byte of name in weekdayname
	
	la $t0, str_WEEKDAY_NAME
	add $v0, $v0, $t0
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra

	# int CheckGregorianDate(char* TIME)
	# return 1 if TIME is in Gregorian Date, others it will return 0 (include 3/9/1752 -> 13/9/1752)
	CheckGregorianDate:
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		
		jal Year
		addi $t0, $0, 1752
		slt $t1, $v0, $t0
		bne $t1, $0, CheckGregorianDate_RETURN_0
		slt $t1, $t0, $v0
		bne $t1, $0, CheckGregorianDate_RETURN_1
		
		lw $a0, 4($sp)
		jal Month
		addi $t0, $0, 9
		slt $t1, $v0, $t0
		bne $t1, $0, CheckGregorianDate_RETURN_0
		slt $t1, $t0, $v0
		bne $t1, $0, CheckGregorianDate_RETURN_1
		
		lw $a0, 4($sp)
		jal Day
		addi $t0, $0, 14
		slt $t0, $v0, $t0
		bne $t0, $0, CheckGregorianDate_RETURN_0
		j CheckGregorianDate_RETURN_1
		
		CheckGregorianDate_RETURN_0:
		add $v0, $0, $0
		j CheckGregorianDate_END

		CheckGregorianDate_RETURN_1:
		addi $v0, $0, 1

		CheckGregorianDate_END:
		lw $ra, 0($sp)
		addi, $sp, $sp, 8
		jr $ra

# function for option 4, phuc vu input, cau 4, 5 (getTime), 6 (closest)
# int LeapYear(char* TIME)
# tra ve 1 - nam nhuan, 0 - khong phai nam nhuan
LeapYear:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal Year
	add $a0, $0, $v0
	jal CheckLeapYear

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	
	
# int CheckLeapYear(int year)
CheckLeapYear:
	addi $t1, $0, 400
	div $a0, $t1
	mfhi $t2 					# $t2 = year % 400
	beq $t2, $0, CheckLeapYear_TRUE			# neu year chia het cho 400 thi nam nhuan

	addi $t1, $0, 4
	div $a0, $t1
	mfhi $t2 # $t2 = year % 4
	bne $t2, $0, CheckLeapYear_FALSE 		# neu year khong chia het cho 4 -> false

	addi $t1, $0, 100
	div $a0, $t1
	mfhi $t2 										# $t2 = year % 100
	beq $t2, $0, CheckLeapYear_FALSE 		# neu year chia het cho 4 va 100 nhung khong chia het cho 400 -> false
	
	CheckLeapYear_TRUE:				# year chia het 4, khong chia het cho 100 va 400 -> true
	addi $v0, $0, 1			
	j CheckLeapYear_END
	
	CheckLeapYear_FALSE:
	add $v0, $0, $0			
	
	CheckLeapYear_END:
	jr $ra

# function for option 5:
# int GetTime(char* TIME_1, char* TIME_2) 
GetTime:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	
	add $s5, $a0, $0
	jal Year
	add $s0, $v0, $0
	
	add $a0, $s5, $0
	jal Month
	add $s1, $v0, $0
	
	add $a0, $s5, $0
	jal Day
	add $s2, $v0, $0
	
	lw $s5, 8($sp)
	add $a0, $s5, $0
	jal Year
	add $s3, $v0, $0
	
	add $a0, $s5, $0
	jal Month
	add $s4, $v0, $0
	
	add $a0, $s5, $0
	jal Day
	add $s5, $v0, $0
	
	# check if date1 > date2 -> exchange
	slt $t0, $s3, $s0
	bne $t0, $0, GetTime_EXCHANGE_DATE
	slt $t0, $s0, $s3
	bne $t0, $0, GetTime_PASS_EXCHANGE_DATE
	slt $t0, $s4, $s1
	bne $t0, $0, GetTime_EXCHANGE_DATE
	slt $t0, $s1, $s4
	bne $t0, $0, GetTime_PASS_EXCHANGE_DATE
	slt $t0, $s5, $s2
	bne $t0, $0, GetTime_EXCHANGE_DATE
	slt $t0, $s2, $s5
	bne $t0, $0, GetTime_PASS_EXCHANGE_DATE
	GetTime_EXCHANGE_DATE:
	add $t0, $0, $s0
	add $s0, $0, $s3
	add $s3, $0, $t0
	add $t0, $0, $s1
	add $s1, $0, $s4
	add $s4, $0, $t0
	add $t0, $0, $s2
	add $s2, $0, $s5
	add $s5, $0, $t0
	GetTime_PASS_EXCHANGE_DATE:
	
	# year_diff -> $s0
	sub $s0, $s3, $s0

	# if (month2 < month1) => year_diff -= 1 
	slt $t0, $s4, $s1
	beq $t0, $0, GetTime_MONTH2_NOT_SMALLER
	addi $v0, $s0, -1
	j GetTime_END

	GetTime_MONTH2_NOT_SMALLER:
	# if (month 1 < month 2) => year_diff not change, return
	slt $t0, $s1, $s4
	beq $t0, $0, GetTime_MONTH2_NOT_BIGGER
	add $v0, $s0, $0
	j GetTime_END

	GetTime_MONTH2_NOT_BIGGER:
	# (day 2 < day 1) ? YES => year -= 1
	slt $t0, $s5, $s2
	beq $t0, $0, GetTime_DAY2_NOT_SMALLER
	# day 2 smaller: check if month == 2 and year2 is a leap year, and day 2 is 28
	addi $s4, $0, 2
	bne $s1, $s4, GetTime_NOT_ENOUGH_DAY
	addi $s4, $0, 28
	bne $s5, $s4, GetTime_NOT_ENOUGH_DAY
	add $a0, $s3, $0
	jal CheckLeapYear
	bne $v0, $0, GetTime_NOT_ENOUGH_DAY	# is a leap year => not enough day
	j GetTime_DAY2_NOT_SMALLER
	GetTime_NOT_ENOUGH_DAY:
	addi $v0, $s0, -1
	j GetTime_END
	GetTime_DAY2_NOT_SMALLER:
	add $v0, $s0, $0	
	
	GetTime_END:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s4, 28($sp)
	lw $s5, 32($sp)
	addi $sp, $sp, 36
	jr $ra

# function for option 6: Ham tim 2 nam nhuan gan nhat voi TIME
# void Find2LeapYearClosest(char* TIME, int& year1, int& year2)
# $a0 la TIME, $v0 la nam thu nhat, $v1 la nam thu hai
Find2LeapYearClosest:
	# trong luc tinh toan thi t1 chua nam dau, t2 chua nam thu hai, t3 chua so du, t4 chua cac bien tam
	addi $t7, $0, 1
	addi $sp, $sp, -16		# save  ra
	sw $ra, 0($sp)
	jal Year
	add $t0 , $v0, $0		# t0 chua nam cua TIME
	addi $t4, $0, 4			# lay t0 % 4 va lay t3 chua so du
	div $t0, $t4	
	mfhi $t3

	add $t1, $0, $0
	bne $t3, $t1, Find2Leap_KHONGNHUAN
	addi $t1, $t0, -4
	j Find2Leap_NHUAN
	Find2Leap_KHONGNHUAN:
	sub $t1, $t0, $t3		# t1 (nam dau tien) = nam - t3
	
	Find2Leap_NHUAN:	
	addi $t2, $t0, 4  		# t2 (nam thu hai) = nam + (4- t3)
	sub $t2, $t2, $t3 

	add $a0, $t1, $0
	# Luu lai t0 t1 t2
	sw $t0, 4($sp)     		# Luu $t0
    	sw $t1, 8($sp)     	# Luu $t1
	sw $t2, 12($sp)			# Luu $t2
	jal CheckLeapYear		# neu t1 khong nhuan thi t1 = t1 -4, check dieu kien gan nhat -> return
	# hoi phuc lai t0, t1 t2
	lw $t2, 12($sp)	   		# hp $t2
	lw $t1, 8($sp)     		# Hp $t1
	lw $t0, 4($sp)     		# HP $t0
	addi $t5, $0, 1
	beq $v0, $t5, Find2Leap_SECOND	# neu nhuan thi kiem tra cai tiep theo
	addi $t1, $t1, -4
	
	# check dieu kien gan nhat
	# t4 = t0 - t1
	# t5 = t2 + 4 - t0
	# t6 chua gia tri ket qua
	sub $t4, $t0, $t1
	addi $t5, $t2, 4
	sub $t5, $t5, $t0
	slt $t6, $t5, $t4		# neu nhu t5 < t4 thi t1 = t2, t2 = t1 + 4, neu khong thi return
	beq $t6, $0, Find2LeapYearClosest_END
	add $t1, $0, $t2
	addi $t2, $t1, 4
	j Find2LeapYearClosest_END

	Find2Leap_SECOND:
	add $a0, $t2, $0
	# Luu lai t0 t1 t2
	sw $t0, 4($sp)     		# Luu $t0
   	sw $t1, 8($sp)     		# Luu $t1
	sw $t2, 12($sp)			# Luu $t2
	jal CheckLeapYear		# neu t2 khong nhuan thi t2 = t2 + 4, check dieu kien, neu nhuan thi return 
	# hoi phuc lai t0, t1 t2
	lw $t2, 12($sp)	   		# hp $t2
	lw $t1, 8($sp)     		# Hp $t1
	lw $t0, 4($sp)     		# HP $t0
	addi $t7, $0, 1
	beq $v0, $t7, Find2LeapYearClosest_END
	addi $t2, $t2, 4 
	
	# t5 = t2 + 4 - t0
	# t4 = t0 - t1 + 4 
	# t6 chua gia tri ket qua
	sub $t4, $t0, $t1
	addi $t4, $t4, 4
	addi $t5, $t2, 4
	sub $t5, $t5, $t0
	slt $t6, $t4, $t5 		# neu nhu t4 < t5 thi  t2 = t1 - 4, khong thi return 
	beq $t6 , $0 , Find2LeapYearClosest_END
	addi $t2, $t1, -4

	Find2LeapYearClosest_END:
	add $v0, $t1, $0
	add $v1, $t2, $0

	lw $ra, 0($sp)		
	addi $sp, $sp, 16
	jr $ra

# Ham tra ve ngay trong DD/MM/YYYY
# int Day(char* TIME)
# a0 la chuoi TIME, v0 la ngay trong TIME
Day:
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $t0, $0, 10

	lb $v0, 0($a0)
	addi $v0, $v0, -48
	mult $v0, $t0
	mflo $v0
	lb $t0, 1($a0)
	addi $t0, $t0, -48
	add $v0, $v0, $t0	

	lw $t0, 0($sp)
	addi $sp, $sp, 4	
	jr $ra


# Ham tra ve thang trong DD/MM/YYYY
# int Month(char* TIME)
# a0 la chuoi TIME, v0 la thang trong TIME
Month:
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $t0, $0, 10

	lb $v0, 3($a0)
	addi $v0, $v0, -48
	mult $v0, $t0
	mflo $v0
	lb $t0, 4($a0)
	addi $t0, $t0, -48
	add $v0, $v0, $t0	

	lw $t0, 0($sp)
	addi $sp, $sp, 4	
	jr $ra

# Ham tra ve nam trong  DD/MM/YYYY
# int Year(char* TIME)
# $a0 ~ TIME, $v0 ~ year in TIME
Year:
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)

	addi $t0, $0, 10

	lb $v0, 6($a0)
	addi $v0, $v0, -48
	mult $v0, $t0
	mflo $v0

	lb $t1, 7($a0)
	addi $t1, $t1, -48
	add $v0, $v0, $t1
	mult $v0, $t0
	mflo $v0

	lb $t1, 8($a0)
	addi $t1, $t1, -48
	add $v0, $v0, $t1
	mult $v0, $t0
	mflo $v0

	lb $t1, 9($a0)
	addi $t1, $t1, -48
	add $v0, $v0, $t1	

	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8	
	jr $ra
