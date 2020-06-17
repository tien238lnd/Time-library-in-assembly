.data 
	str_ask_day: .asciiz "\nNhap ngay DAY: "
	str_ask_month: .asciiz "\nNhap thang MONTH: "
	str_ask_year: .asciiz "\nNhap nam YEAR: "
	str_invalid: .asciiz "\nKhong hop le, nhap lai: "
	str_day: .space 2
	str_month: .space 2
	str_year: .space 4
	TIME: .asciiz "DD/MM/YYYYsparespare"
	TIME2: .asciiz "DD/MM/YYYYsparespare"
	str_MONTH_NAME: .ascii "January   February  March     April     May       June      July      August    September October   November  December "
	str_WEEKDAY_NAME: .asciiz "Sun","  Mon","  Tues"," Wed","  Thurs","Fri","  Sat"
	
	str_menu:	
		.asciiz "\n\n--- MENU ---\n"
	str_option0:
		.asciiz "0. Nhap lai ngay thang nam khac\n"
	str_option1:
		.asciiz "1. Xuat theo dinh dang DD/MM/YYYY\n"
	str_option2:
		.asciiz "2. Chuyen doi thanh cac dinh dang khac\n"
	str_option2_ask_type:
		.asciiz "Chon kieu convert (A- MM/DD/YYYY | B- Month DD, YYYY | C- DD Month, YYYY): "
	str_option3:
		.asciiz "3. Cho biet ngay vua nhap la thu may trong tuan\n"
	str_option4:
		.asciiz "4. Kiem tra nam nhuan\n"
	str_option5:
		.asciiz "5. Cho biet khoang thoi gian giua chuoi TIME_1 va TIME_2\n"
	str_option6:
		.asciiz "6. Cho biet 2 nam nhuan gan nhat voi nam vua nhap\n"
	str_option7:
		.asciiz "7. Thoat\n"
	str_ask_option:
		.asciiz "Chon mot chuc nang: "
	
	str_leap: .asciiz "Dung la nam nhuan!"
	str_not_leap: .asciiz "Khong phai nam nhuan."
	str_ask_TIME2: .asciiz "Nhap ngay thang nam cho TIME2: "
	str_get_time: .asciiz "\nKhoang cach giua TIME1 va TIME2 la: "
	str_2_closest_1: .asciiz "Hai nam nhuan gan nhat la "
	str_2_closest_2: .asciiz " va "
	
.text 
	.globl main

# Chuong trinh chinh
main:
	main_LOOP:
	# Nhap NGAY THANG NAM , s0: NGAY, s1: THANG, s2: NAM
	jal Input
	add $s0, $a0, $0
	add $s1, $a1, $0
	add $s2, $a2, $0
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
	OPTION_LOOP:
	# Doc thao tac cua nguoi dung, luu vao $s3
	addi $v0, $0, 5 
	syscall
	add $s3, $0, $v0
	addi $t0, $0, 0					
	beq $s3, $t0, main_LOOP
	addi $t0, $0, 1				
	beq $s3, $t0, main_OPTION1
	addi $t0, $0, 2
	beq $s3, $t0, main_OPTION2
	addi $t0, $0, 3				
	beq $s3, $t0, main_OPTION3
	addi $t0, $0, 4 			
	beq $s3, $t0, main_OPTION4
	addi $t0, $0, 5 		
	beq $s3, $t0, main_OPTION5
	addi $t0, $0, 6 	
	beq $s3, $t0, main_OPTION6
	addi $t0, $0, 7 
	beq $s3, $t0, main_EXIT
	# neu so khac thi yeu cau nhap lai
	la $a0, str_invalid
	addi $v0, $0, 4	
	syscall
	j OPTION_LOOP
	
# duoc goi khi nguoi dung muon thoat chuong trinh
main_EXIT:
	addi $v0,$0, 10		# thoat chuong trinh
	syscall
	
main_OPTION1:
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
	beq $s0, 'A', main_OPTION2_CONVERT
	beq $s0, 'B', main_OPTION2_CONVERT
	beq $s0, 'C', main_OPTION2_CONVERT
	la $a0, str_invalid
	addi $v0, $0, 4	
	syscall
	j main_OPTION2_LOOP
	
	main_OPTION2_CONVERT:
		# copy TIME ra TIME2
		la $a0, TIME
		la $a1, TIME2
		addi $a2, $0, 10
		jal CopyStr
		# convert TIME
		add $a1, $s0, $0
		jal Convert
		# print new TIME
		la $a0, TIME
		addi $v0, $0, 4	
		syscall
		# copy TIME2 ve TIME
		la $a0, TIME2
		la $a1, TIME
		addi $a2, $0, 10
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
	la $a0, TIME
	jal WeekDay
	add $a0, $v0, $0
	addi $v0, $0, 1		# dung ra phai la 4, tam thoi sua lai la 0 de check xem
	syscall
	j MENU_LOOP
	
main_OPTION4:
	la $a0, TIME
	jal LeapYear
	beq $v0, 1, main_OPTION4_PRINT_LEAP
	
	la $a0, str_not_leap
	addi $v0, $0, 4	
	syscall
	j MENU_LOOP
	
	main_OPTION4_PRINT_LEAP:
	la $a0, str_leap
	addi $v0, $0, 4	
	syscall
	j MENU_LOOP

main_OPTION5:
	la $a0, str_ask_TIME2
	addi $v0, $0, 4	
	syscall

	jal Input
	la $a3, TIME2
	jal Date
	la $a0, TIME
	la $a1, TIME2
	jal GetTime
	add $t0, $v0, $0
	la $a0, str_get_time
	addi $v0, $0, 4	
	syscall
	add $a0, $t0, $0
	addi $v0, $0, 1	
	syscall
	
	j MENU_LOOP
	
main_OPTION6:
	la $a0, TIME
	jal Find2LeapYearClosest
	add $s0, $v0, $0
	add $s1, $v1, $0
	la $a0, str_2_closest_1
	addi $v0, $0, 4	
	syscall
	add $a0, $s0, $0
	addi $v0, $0, 4	
	syscall
	la $a0, str_2_closest_2
	addi $v0, $0, 4	
	syscall
	add $a0, $s1, $0
	addi $v0, $0, 4	
	syscall
	j MENU_LOOP
	
	
# Nhap NGAY THANG NAM, kiem tra tinh hop le, neu sai thi nhap lai
# Ket qua duoc luu vao a0:NGAY, a1:THANG, a2:NAM
Input:
	add $sp, $sp, -4   					# Luu $ra vao stack					
	sw $ra, 0($sp)
	
	# => $t5 ~ day, $t6 ~ month, $t7 ~ year
	# Nhap chuoi NGAY
	addi $v0, $0, 4  					# cout << str_ask_day
	la $a0, str_ask_day
	syscall
	addi $v0, $0, 8						# cin >> str_day
	la $a0, str_day
	la $a1, 3
	syscall	
	addi $a1, $a1, -1 					# day=stoi(sday, length)
	jal _stoi
	add $t5, $v0, $0
	
	# kiem tra xem NGAY co hop le ? , neu khong hop le thi nhap lai
	Input_CHECK_DAY_AGAIN_LOOP:
	#if day >=1 t0=1 ~ if day < 1 t0=0 ||| if day < 1 t0=1 
	slti $t0, $t5, 1
	addi $t3, $0, 31				#if day <=31 t1=1 ||| if 31 < day t1=1
	slt $t1, $t3, $t5
	add $t2, $t0, $t1				#t2=t0+t1
	beq $t2, 0, Input_CHECK_DAY_AGAIN_EXIT	#if t2=2 goto EXIT ||| if t2=0 goto EXIT
		
	
	addi $v0, $0, 4 				# cout << str_invalid
	la $a0, str_invalid
	syscall
	addi $v0, $0, 8					# cin >> str_day
	la $a0, str_day
	la $a1, 3
	syscall
	addi $a1, $a1, -1				# day=stoi(sday, length)
	jal _stoi
	add $t5, $v0, $0
	j Input_CHECK_DAY_AGAIN_LOOP
	Input_CHECK_DAY_AGAIN_EXIT:
	

	# Nhap chuoi THANG
	addi $v0, $0, 4 				# cout << str_ask_month
	la $a0, str_ask_month
	syscall
	addi $v0, $0, 8					# cin >> str_month
	la $a0, str_month
	la $a1, 3
	syscall
	addi $a1, $a1, -1				# month=stoi(smonth, length)
	jal _stoi
	add $t6, $v0, $0
	
	# kiem tra xem THANG co hop le, neu khong hop le thi nhap lai
	Input_CHECK_MONTH_AGAIN_LOOP:
	slti $t0, $t6, 1			# if month < 1 t0=1
	addi $t3, $0, 12			# if 12 < day t1=1
	slt $t1, $t3, $t6
	add $t2, $t0, $t1			# t2=t0+t1
	beq $t2, 0, Input_CHECK_MONTH_AGAIN_EXIT 		# if t2=0 goto EXIT
	addi $v0, $0, 4				# cout << str_invalid
	la $a0, str_invalid
	syscall
	addi $v0, $0, 8				# cin >> str_month
	la $a0, str_month
	la $a1, 3
	syscall
	addi $a1, $a1, -1			# month=stoi(smonth, length)
	jal _stoi
	add $t6, $v0, $0
	j Input_CHECK_MONTH_AGAIN_LOOP
	Input_CHECK_MONTH_AGAIN_EXIT:
	
	
	# Nhap chuoi NAM
	addi $v0, $0, 4						# cout << str_ask_year
	la $a0, str_ask_year
	syscall
	addi $v0, $0, 8						# cin >> str_year
	la $a0, str_year
	la $a1, 5
	syscall
	addi $a1, $a1, -1					# year=stoi(syear, length)
	jal _stoi
	add $t7, $v0, $0
	# kiem tra NAM co hop le, neu khong hop le thi nhap lai
	Input_CHECK_YEAR_AGAIN_LOOP:	 
	slti $t0, $t7, 1900				# if year < 1900 t0=1
	addi $t3, $0, 2100				# if 2100 < day t1=1
	slt $t1, $t3, $t7	
	add $t2, $t0, $t1				# t2=t0+t1
	beq $t2, 0, Input_CHECK_YEAR_AGAIN_EXIT				# if t2=0 goto EXIT
	addi $v0, $0, 4					# cout << str_invalid
	la $a0, str_invalid
	syscall
	addi $v0, $0, 8					# cin >> str_year
	la $a0, str_year
	la $a1, 5
	syscall
	addi $a1, $a1, -1				# year=stoi(syear, length)
	jal _stoi
	add $t7, $v0, $0
	j Input_CHECK_YEAR_AGAIN_LOOP
	Input_CHECK_YEAR_AGAIN_EXIT:
	
	Input_CHECK_VALID:
	beq $t6, 4, Input_CHECKDAY31
	beq $t6, 6, Input_CHECKDAY31
	beq $t6, 9, Input_CHECKDAY31
	beq $t6, 11, Input_CHECKDAY31
	j Input_CHECKMONTH2

	Input_CHECKDAY31:
	beq $t5, 31, Input_INPUTAGAIN
	j Input_CHECK_VALID_END

	Input_CHECKMONTH2:
	beq $t6, 2, Input_CHECKLEAP
	j Input_CHECK_VALID_END

	Input_CHECKLEAP:
	add $a0, $t7, $0
	jal CheckLeapYear
	beq $v0, 1, Input_OK_LEAP
	j Input_NOT_LEAP

	Input_OK_LEAP:
	slti $t0, $t5, 30
	beq $t0, 1, Input_CHECK_VALID_END
	j Input_INPUTAGAIN

	Input_NOT_LEAP:
	slti $t0, $t5, 29
	beq $t0, 1, Input_CHECK_VALID_END

	Input_INPUTAGAIN:
	# cout << str_invalid
	addi $v0, $0, 4
	la $a0, str_invalid
	syscall
	j Input

	Input_CHECK_VALID_END:
	add $a0, $t5, $0
	add $a1, $t6, $0
	add $a2, $t7, $0
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
# function for option 1
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
	
# function for option 2:	
Convert:
	addi $sp, $sp, -12
	sw $s0, 0($sp)		#for check type, index, other
	sw $s1, 4($sp)		#...
	sw $t0, 8($sp)		#for temp use

	addi $t0, $0, 65
	bne $t0, $a1, Convert_TYPE_B_C
	Convert_TYPE_A:			#this label just for clear, no use
		lb $s0, 0($a0)		#exchange first digit of month and day
		lb $s1, 3($a0)
		sb $s1, 0($a0)
		sb $s0, 3($a0)
		lb $s0, 1($a0)		#exchange second digit of month and day
		lb $s1, 4($a0)
		sb $s1, 1($a0)
		sb $s0, 4($a0)
		j Convert_END
	Convert_TYPE_B_C:
		#shift right 10 character
		addi $s0, $a0, 10
		Convert_FOR_1:
			slt $t0, $a0, $s0
			beq $t0, $0, Convert_FOR_1_EXIT
			lb $s1, 0($a0)
			sb $s1, 10($a0)
			addi $a0, $a0, 1
			j Convert_FOR_1
		Convert_FOR_1_EXIT:
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
		#find the pos begin of month in string str_MONTH_NAME
		addi $s1, $s1, -1
		mult $s1, $s0		#$s2*10, character-th
		mflo $s1
		la $s0, str_MONTH_NAME	#add begin address, str_MONTH_NAME[0]+k
		add $s1, $s1, $s0	#$s2=&str_MONTH_NAME[k]

		addi $sp, $sp, -4	#spare to save $s0
		sw $a0, 0($sp)		#save $s0		
		#check type B or C
		addi $t0, $0, 66	#'B'
		beq $t0, $a1, Convert_ADD_MONTH
		addi $a0, $a0, 3	#case C: 'DD Month'=> begin add month at index 3
		addi $t0, $0, 32	#' '
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
		lw $s1, 0($sp)		#get back saved $s0, save to $s2
		addi $s1, $s1, 10
		#check type B or C
		addi $t0, $0, 66	#'B'
		bne $t0, $a1, Convert_TYPE_C		
	Convert_TYPE_B:
		#shift day
		lb $s0, 0($s1)
		sb $s0, 1($a0)
		lb $s0, 1($s1)
		sb $s0, 2($a0)
		addi $a0, $a0, 3	#don't jump, go next to Type C to get year on	
	Convert_TYPE_C:
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

	Convert_END:
	#lw $a0, 0($sp)
	lw $v0, 0($sp)		#first $a0, &TIME[0]
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $t0, 8($sp)
	addi $sp, $sp, 12
	jr $ra

# function for option 3:
#char* WeekDay(char* TIME)
#return the day of the week (Sun, Mon, Tues, Wed, Thurs, Fri, Sat)
WeekDay:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	add $s0, $a0, $0	#&TIME[0]
	jal Day
	add $s1, $v0, $0	#add d
	
	add $a0, $s0, $0
	jal Year
	add $s2, $v0, $0
	
	add $a0, $s0, $0
	jal CheckGregorianDate
	
	addi $t0, $0, 100
	div $s2, $t0
	mflo $t0
	mfhi $t1
	
	#add c
	#if v0==0 => Julian Date
	beq $v0, $0, WeekDay_JULIAN_DATE
	#if gregorian date
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
	
	addi $t0, $t0, -17	#century=17->index 0
	sll $t0, $t0, 2
	add $t0, $t0, $sp
	lw $t0, 0($t0)
	add $s1, $s1, $t0
	addi $sp, $sp, 28
	j WeekDay_ADD_YEAR
	
	#if julian date
	WeekDay_JULIAN_DATE:
	addi $t2, $0, 18
	sub $t2, $t2, $t0
	add $s1, $s1, $t2
	
	WeekDay_ADD_YEAR:
	add $s1, $s1, $t1	#add y
	
	addi $t0, $0, 4
	div $t1, $t0
	mflo $t0
	add $s1, $s1, $t0	#add floor(y/4)
	
	add $a0, $s0, $0
	jal Month
	add $s3, $v0, $0	#save month
	
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
	sw $t0, 4($sp)		#do not jump
	WeekDay_NOT_LEAP_YEAR:
	
	add $s2, $sp, $0	#begin pos of m array
	addi $s3, $s3, -1
	sll $s3, $s3, 2
	add $s2, $s2, $s3	#pos of particular m element needed
	lw $t0, 0($s2)		#load m
	add $s1, $s1, $t0	#add m
	
	addi $sp, $sp, 48
	
	addi $s2, $0, 7
	div $s1, $s2
	mfhi $v0		#number of result 0->6
	
	add $t0, $0, 6
	mult $v0, $t0
	mflo $v0		#start byte of name in weekdayname
	
	la $t0, str_WEEKDAY_NAME
	add $v0, $v0, $t0
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra
#int CheckGregorianDate(char* TIME)
#return 1 if TIME is in Gregorian Date, others it will return 0 (include 3/9/1752->13/9/1752).
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

# function for option 4:
# Ham kiem tra nam nhuan voi input la time
# tra ve 1 - nam nhuan, 0 - khong la nam nhuan
LeapYear:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal Year
	add $a0, $0, $v0
	jal CheckLeapYear

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	
	
# ham kiem tra nam nhuan, phuc vu input, câu 4, 5 (getTime), 6 (closest)
# a0 la mot nam, tra ve 0 neu nam khong nhuan, 1 neu nam nhuan
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
	

# ham chuyen doi char* thanh int, $a0 la strBuffer, $a1 la max_length	
_stoi:	
	add $v0, $0, 0
	#add $t0, $0, 0	# bien dem vong for
	addi $t0, $a0, 0 
	add $a1, $a0, $a1 # a1 bay gio la dc cuoi cung cua string
	
	_stoi.LOOP:
	beq $t0, $a1, _stoi.EXIT
	
	#lb $t1, $t0($a0)	# str[i]
	lb $t1, 0($t0)	# str[i]
	beq $t1, '\n', _stoi.EXIT
	
	slti $t2, $t1, '0'
	beq $t2, 1, _stoi.ERROR
	addi $t3, $0, '9'
	slt $t2, $t3, $t1
	beq $t2, 1, _stoi.ERROR
	
	mul $v0, $v0, 10
	add $v0, $v0, $t1
	sub $v0, $v0, '0'
	addi $t0, $t0, 1
	j _stoi.LOOP
	
	_stoi.ERROR:
	addi $v0, $0, -1 
	
	_stoi.EXIT:
	jr $ra

# function for option 5:
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
	
	#year diff->$s0
	sub $s0, $s3, $s0

	#if (month 2 < month 1)=>year diff-=1 
	slt $t0, $s4, $s1
	beq $t0, $0, GetTime_MONTH2_NOT_SMALLER
	addi $v0, $s0, -1
	j GetTime_END

	GetTime_MONTH2_NOT_SMALLER:
	#if (month 1<month 2)=>year diff not change, return
	slt $t0, $s1, $s4
	beq $t0, $0, GetTime_MONTH2_NOT_BIGGER
	add $v0, $s0, $0
	j GetTime_END

	GetTime_MONTH2_NOT_BIGGER:
	#(day 2 < day 1)? YES=> year-=1
	slt $t0, $s5, $s2
	beq $t0, $0, GetTime_DAY2_NOT_SMALLER
	#day 2 smaller: check if month ==2 and year2 is a leap year, and day 2 is 28
	addi $s4, $0, 2
	bne $s1, $s4, GetTime_NOT_ENOUGH_DAY
	addi $s4, $0, 28
	bne $s5, $s4, GetTime_NOT_ENOUGH_DAY
	add $a0, $s3, $0
	jal CheckLeapYear
	bne $v0, $0, GetTime_NOT_ENOUGH_DAY	#is a leap year=>not enough day
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

# function for option 6:	
# Ham tim xem 2 nam nhuan gan nhat trong nam 
# $a0 la TIME
# $v0 la nam thu nhat
# $v1 la nam thu hai
Find2LeapYearClosest:
	### HAM CUA HIEU ###

# Ham tra ve ngay trong DD/MM/YYYY
# a0 la chuoi TIME
# v0 la ngay trong TIME
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
# a0 la chuoi TIME
# v0 la thang trong TIME
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
# $a0 TIME
# $v0 year in TIME
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
