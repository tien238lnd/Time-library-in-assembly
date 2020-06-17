#  trong h�m ???c g?i n?u d�ng $t th� kh�ng ph?i l?u v�o stack, n?u d�ng $s th� ph?i l?u v�o stack, 
# c�n h�m th?c hi?n g?i th� n?u d�ng $s kh�ng ph?i l?u v�o stack, n?u c?n $t th� ph?i l?u v�o stack


.data 
	askDay: .asciiz "\nNhap ngay DAY: "
	askMonth: .asciiz "\nNhap thang MONTH: "
	askYear: .asciiz "\nNhap nam YEAR: "
	askAgain: .asciiz "\nKhong dung format, nhap lai: "
	inputAgain: .asciiz "\nKhong hop le, nhap lai: "
	sDay: .space 2
	sMonth: .space 2
	sYear: .space 4

	luachon:	
		.asciiz "\n----Ban hay chon 1 trong cac thao tac duoi day----\n"
	luachon1:
		.asciiz "\n1. Xuat chuoi TIME theo dinh dang DD/MM/YYYY\n"
	luachon2:
		.asciiz "2. Xuat chuoi TIME thanh mot trong cac dinh dang sau\n   A. MM/DD/YYYY\n   B. Month DD, YYYY\n   C. DD Month, YYYY\n"
	luachon2_type:
		.asciiz "Chon dinh dang A, B hay C\n"
	luachon3:
		.asciiz "3. Cho biet ngay vua nhap la thu may trong tuan\n"
	luachon4:
		.asciiz "4. Kiem tra nam trong chuoi TIME co phai la nam nhuan khong\n"
	luachon5:
		.asciiz "5. Cho biet khoang thoi gian giua chuoi TIME_1 va TIME_2\n"
	luachon6:
		.asciiz "6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi TIME\n"
	luachon7:
		.asciiz "7. Kiem tra bo du lieu dau vao khi nhap, neu du lieu khong hop le thi yeu cau nguoi dung nhap lai\n"

.text 
	.globl main

# Chuong trinh chinh
main:
	# Nhap NGAY THANG NAM , s0:NGAY, s1:THANG, s2:NAM
	jal _input
	add $s0, $a0, $0
	add $s1, $a1, $0
	add $s2, $a2, $0

	# In ra toan bo cac thao tac
	la $a0, luachon
	addi $v0, $zero, 4	
	syscall
	la $a0, luachon1
	addi $v0, $zero, 4	
	syscall
	la $a0, luachon2
	addi $v0, $zero, 4
	syscall
	la $a0, luachon3
	addi $v0, $zero, 4
	syscall
	la $a0, luachon4
	addi $v0, $zero, 4
	syscall
	la $a0, luachon5
	addi $v0, $zero, 4
	syscall
	la $a0, luachon6
	addi $v0, $zero, 4	
	syscall
	la $a0, luachon7
	addi $v0, $zero, 4
	syscall

	# Doc thao tac cua nguoi dung, luu vao $s3
	addi $v0, $zero, 5 
	syscall
	add $s3, $zero, $v0

	addi $t0, $zero, 1					# thao tac 1
	beq $s3, $t0, main_tt1
	addi $t0, $zero, 2					# thao tac 2
	beq $s3, $t0, main_tt2
	addi $t0, $zero, 3					# thao tac 3
	beq $s3, $t0, main_tt3
	addi $t0, $zero, 4 					# thao tac 4
	beq $s3, $t0, main_tt4
	addi $t0, $zero, 5 					# thao tac 5
	beq $s3, $t0, main_tt5
	addi $t0, $zero, 6 					# thao tac 6
	beq $s3, $t0, main_tt6
	addi $t0, $zero, 7 					# thao tac 7
	beq $s3, $t0, main_tt7



# duoc goi khi nguoi dung muon thoat chuong trinh
main.END:
	addi $v0,$0, 10						# thoat chuong trinh
	syscall



main_tt1:
#bla

main_tt2:
#bla

main_tt3:
#bla

main_tt4:
#bla

main_tt5:
#bla

main_tt6:
#bla

main_tt7:
#bla
	
# Nhap NGAY THANG NAM, kiem tra tinh hop le, neu sai thi nhap lai
# Ket qua duoc luu vao a0:NGAY, a1:THANG, a2:NAM
_input:
	add $sp, $sp, -4   					# Luu $ra vao stack					
	sw $ra, 0($sp)
	
	# => $t5 ~ day, $t6 ~ month, $t7 ~ year
	# Nhap chuoi NGAY
	addi $v0, $0, 4  					# cout << askDay
	la $a0, askDay
	syscall
	addi $v0, $0, 8						# cin >> sDay
	la $a0, sDay
	la $a1, 3
	syscall	
	addi $a1, $a1, -1 					# day=stoi(sday, length)
	jal _stoi
	add $t5, $v0, $0
	
	# kiem tra xem NGAY co hop le ? , neu khong hop le thi nhap lai
	_input_CheckDayAgain.LOOP:
	#if day < 1 goto CHECK_AGAIN
	#if day <= 31 goto EXIT
	#if day >=1 t0=1 ~ if day < 1 t0=0 ||| if day < 1 t0=1 
	slti $t0, $t5, 1
	addi $t3, $0, 31				#if day <=31 t1=1 ||| if 31 < day t1=1
	slt $t1, $t3, $t5
	add $t2, $t0, $t1				#t2=t0+t1
	beq $t2, 0, _input_CheckDayAgain.EXIT	#if t2=2 goto EXIT ||| if t2=0 goto EXIT
		
	#CHECK_AGAIN:
	addi $v0, $0, 4 				# cout << askAgain
	la $a0, askAgain
	syscall
	addi $v0, $0, 8					# cin >> sDay
	la $a0, sDay
	la $a1, 3
	syscall
	addi $a1, $a1, -1				# day=stoi(sday, length)
	jal _stoi
	add $t5, $v0, $0
	j _input_CheckDayAgain.LOOP

	_input_CheckDayAgain.EXIT:
	

	# Nhap chuoi THANG
	addi $v0, $0, 4 				# cout << askMonth
	la $a0, askMonth
	syscall
	addi $v0, $0, 8					# cin >> sMonth
	la $a0, sMonth
	la $a1, 3
	syscall
	addi $a1, $a1, -1				# month=stoi(smonth, length)
	jal _stoi
	add $t6, $v0, $0
	
	# kiem tra xem THANG co hop le, neu khong hop le thi nhap lai
	_input_CheckMonthAgain.LOOP:
	slti $t0, $t6, 1			# if month < 1 t0=1
	addi $t3, $0, 12			# if 12 < day t1=1
	slt $t1, $t3, $t6
	add $t2, $t0, $t1			# t2=t0+t1
	beq $t2, 0, _input_CheckMonthAgain.EXIT 		# if t2=0 goto EXIT
	addi $v0, $0, 4				# cout << askAgain
	la $a0, askAgain
	syscall
	addi $v0, $0, 8				# cin >> sMonth
	la $a0, sMonth
	la $a1, 3
	syscall
	addi $a1, $a1, -1			# month=stoi(smonth, length)
	jal _stoi
	add $t6, $v0, $0
	j _input_CheckMonthAgain.LOOP
	
	_input_CheckMonthAgain.EXIT:
	
	
	# Nhap chuoi NAM
	addi $v0, $0, 4						# cout << askYear
	la $a0, askYear
	syscall
	addi $v0, $0, 8						# cin >> sYear
	la $a0, sYear
	la $a1, 5
	syscall
	addi $a1, $a1, -1					# year=stoi(syear, length)
	jal _stoi
	add $t7, $v0, $0
	# kiem tra NAM co hop le, neu khong hop le thi nhap lai
	_input_CheckYearAgain.LOOP:	 
	slti $t0, $t7, 1900				# if year < 1900 t0=1
	addi $t3, $0, 2100				# if 2100 < day t1=1
	slt $t1, $t3, $t7	
	add $t2, $t0, $t1				# t2=t0+t1
	beq $t2, 0, _input_CheckYearAgain.EXIT				# if t2=0 goto EXIT
	addi $v0, $0, 4					# cout << askAgain
	la $a0, askAgain
	syscall
	addi $v0, $0, 8					# cin >> sYear
	la $a0, sYear
	la $a1, 5
	syscall
	addi $a1, $a1, -1				# year=stoi(syear, length)
	jal _stoi
	add $t7, $v0, $0
	j _input_CheckYearAgain.LOOP

	_input_CheckYearAgain.EXIT:
	
	_input_CheckValid:
	beq $t6, 4, _input_CHECKDAY31
	beq $t6, 6, _input_CHECKDAY31
	beq $t6, 9, _input_CHECKDAY31
	beq $t6, 11, _input_CHECKDAY31
	j _input_CHECKMONTH2

	_input_CHECKDAY31:
	beq $t5, 31, _input_INPUTAGAIN
	j _input_CheckValid.EXIT

	_input_CHECKMONTH2:
	beq $t6, 2, _input_CHECKLEAP
	j _input_CheckValid.EXIT

	_input_CHECKLEAP:
	add $a0, $t7, $0
	jal CheckLeapYear
	beq $v0, 1, _input_OK_LEAP
	j _input_NOT_LEAP

	_input_OK_LEAP:
	slti $t0, $t5, 30
	beq $t0, 1, _input_CheckValid.EXIT
	j _input_INPUTAGAIN

	_input_NOT_LEAP:
	slti $t0, $t5, 29
	beq $t0, 1, _input_CheckValid.EXIT

	_input_INPUTAGAIN:
	# cout << inputAgain
	addi $v0, $0, 4
	la $a0, inputAgain
	syscall
	j _input

	_input_CheckValid.EXIT:
	add $a0, $t5, $0
	add $a1, $t6, $0
	add $a2, $t7, $0
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
	
# ham kiem tra nam nhuan 
# a0 la mot nam, tra ve 0 neu nam khong nhuan, 1 neu nam nhuan
CheckLeapYear:
	addi $t1, $zero, 400
	div $a0, $t1
	mfhi $t2 										# $t2 = year % 400
	beq $t2, $zero, CheckLeapYear_true				# neu year chia het cho 400 thi nam nhuan

	addi $t1, $zero, 4
	div $a0, $t1
	mfhi $t2 # $t2 = year % 4
	bne $t2, $zero, CheckLeapYear_false 			# neu year khong chia het cho 4 -> false

	addi $t1, $zero, 100
	div $a0, $t1
	mfhi $t2 										# $t2 = year % 100
	beq $t2, $zero, CheckLeapYear_false 			# neu year chia het cho 4 va 100 nhung khong chia het cho 400 -> false
	
	CheckLeapYear_true:								# year chia het 4, khong chia het cho 100 va 400 -> true
	addi $v0, $zero, 1			
	j CheckLeapYear_exit
	
	CheckLeapYear_false:
	add $v0, $zero, $zero			
	
	CheckLeapYear_exit:
	jr $ra
	

# ham chuyen doi char* thanh int, $a0 la strBuffer, $a1 la max_length	
_stoi:	
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
	
# Ham tim xem 2 nam nhuan gan nhat trong nam 
# $a0 la TIME
# $v0 la nam thu nhat
# $v1 la nam thu hai
Find2LeapYearClosest:
	# trong luc tinh toan thi t1 chua nam dau, t2 chua nam thu hai, t3 chua so du, t4 chua cac bien tam
	addi $sp, $sp, -4		# save  ra
	sw $ra, 0($sp)
	jal GetYear
	add $t0 , $v0, $0		# t0 chua nam cua TIME

	addi $t4, $0, 4			# lay t0 % 4 va lay t3 chua so du
	div $t0, $t4	
	mfhi $t3

	sub $t1, $t0, $t3		# t1 (nam dau tien) = nam - t3

	subi $t4, 4, $t3  		# t2 (nam thu hai) = nam + (4- t3)
	add $t1, $t0, $t4 

	add $a0, $t1, $0
	jal CheckLeapYear		# neu t1 khong nhuan thi t1 = t1 -4
	beq $v0, 1, Find2Leap_Second
	sub $t1, $t1, 4  

	Find2Leap_Second:
	add $a0, $t2, $0
	jal CheckLeapYear		# neu t2 khong nhuan thi t2 = t2 + 4
	beq $v0, 1, Find2Leap_Continue
	add $t2, $t2, 4  

	# t4 = t0 - t1
	# t5 = t2 + 4 - t0
	# t6 chua gia tri ket qua
	sub $t4, $t0, $t1
	addi $t5, $t2, 4
	sub $t5, $t5, $t0
	slt $t5, $t4, $t6		# neu nhu t5 < t4 thi t1 = t2, t2 = t1 + 4
	beq $t6 , 0 ,  Find2Leap_Next1
	add $t1, $t0, $t2
	addi $t2, $t1, 4

	Find2Leap_Next1:
	# t5 = t2 + 4 - t0
	# t4 = t0 - t1 + 4 
	# t6 chua gia tri ket qua
	addi $t4, $t4, 4
	slt $t4, $t5, $t6		# neu nhu t4 < t5 thi  t2 = t1 - 4
	beq $t6 , 0 ,  Find2Leap_Next2
	subi $t2, $t1, 4

	add $v0, $t1, $0
	add $v1, $t2, $0

	lw $ra, 0($sp)			# pop tro ve ra
	addi $sp, $sp, 4
	jr $ra

# Ham kiem tra nam nhuan voi input la time
# tra ve 1 - nam nhuan, 0 - khong la nam nhuan
CheckLeapYear_byTIME:
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal GetYear
	add $a0, $zero, $v0
	jal CheckLeapYear

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	

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
	
	
#char* Date(int day, int month, int year, char*TIME)
#convert number day, month, year into string TIME
#return address of TIME
Date:
	#save base 10 to register
	addi $t1, $0, 10
	
	addi $t0, $0, 47	#$t0='/'
	sb $t0, 2($a3)		#TIME[2]='/'
	sb $t0, 5($a3)		#TIME[5]='/'
	add $t0, $0, $0		#'\0'
	sb $t0, 10($a3)		#TIME[10]='\0'
	
	#convert day to char
	div $a0, $t1		#day=day/10
	mflo $a0
	mfhi $t0		#$t0=day%10
	addi $t0, $t0, 48	#convert number to char
	sb $t0, 1($a3)		#save byte to place hold by $s0 (TIME[1])
	addi $t0, $a0, 48	#to char
	sb $t0, 0($a3)		#save byte to TIME[0]

	#convert month to char
	div $a1, $t1		#month=month/10
	mflo $a1
	mfhi $t0		#$t0=month%10
	addi $t0, $t0, 48	#number to char
	sb $t0, 4($a3)		#
	addi $t0, $a1, 48	#number to char
	sb $t0, 3($a3)		#
	
	#convert year to char
	div $a2, $t1		#year=year/10
	mflo $a2
	mfhi $t0		#$t0=year%10
	addi $t0, $t0, 48	#number to char
	sb $t0, 9($a3)		#
	
	div $a2, $t1		#year=year/10
	mflo $a2
	mfhi $t0		#$t0=year%10
	addi $t0, $t0, 48	#number to char
	sb $t0, 8($a3)		#
	
	div $a2, $t1		#year=year/10
	mflo $a2
	mfhi $t0		#$t0=year%10
	addi $t0, $t0, 48	#number to char
	sb $t0, 7($a3)		#
	
	addi $t0, $a2, 48	#number to char
	sb $t0, 6($a3)		#
	
	#return value
	add $v0, $a3, $0	
	jr $ra

#char* Convert(char*TIME, char type)
#convert TIME format (DD/MM/YYYY) to:
#type='A': MM/DD/YYYY
#type='B': Month DD, YYYY
#type='C': DD Month, YYYY
#return address of TIME
Convert:
	addi $t0, $0, 65
	bne $t0, $a1, TypeBC
	TypeA:			#this label just for clear, no use
		lb $t0, 0($a0)		#exchange first digit of month and day
		lb $t1, 3($a0)
		sb $t1, 0($a0)
		sb $t0, 3($a0)
		lb $t0, 1($a0)		#exchange second digit of month and day
		lb $t1, 4($a0)
		sb $t1, 1($a0)
		sb $t0, 4($a0)
		add $v0, $a0, $0
		j EndConvert
	TypeBC:
		#shift right 10 character
		addi $t1, $a0, 10
		For1:
			slt $t0, $a0, $t1
			beq $t0, $0, ExitFor1
			lb $t0, 0($a0)
			sb $t0, 10($a0)
			addi $a0, $a0, 1
			j For1
		ExitFor1:
		addi $a0, $a0, -10	#TIME[0]
		addi $t2, $0, 10
		#get month to s2
		lb $t1, 3($a0)		#first digit of month
		addi $t1, $t1, -48	#character to number
		mult $t1, $t2		#*10
		mflo $t1
		lb $t0, 4($a0)
		addi $t0, $t0, -48	#character to number
		add $t1, $t1, $t0
		#find the pos begin of month in string monthname
		addi $t1, $t1, -1
		mult $t1, $t2		#*10, character-th
		mflo $t1
		la $t2, monthname	#add begin address, monthname[0]+k
		add $t1, $t1, $t2	#&monthname[k]
		
		addi $sp, $sp, -4	#spare to save TIME[0]
		sw $a0, 0($sp)		#save TIME[0]
		#check type B or C
		addi $t0, $0, 66	#'B'
		beq $t0, $a1, AddMonth
		addi $a0, $a0, 3	#case C: 'DD Month'=> begin add month at index 3
		addi $t0, $0, 32	#' '
		sb $t0, -1($a0)
		AddMonth:
			lb $t2, 0($t1)
			sb $t2, 0($a0)
			addi $t0, $t2, -32
			beq $t0, $0, EndAddMonth
			addi $t1, $t1, 1
			addi $a0, $a0, 1
			j AddMonth
		EndAddMonth:
		lw $t1, 0($sp)		#get back saved TIME[0]
		addi $t1, $t1, 10	#TIME[10]
		#check type B or C
		addi $t0, $0, 66	#'B'
		bne $t0, $a1, TypeC		
	TypeB:
		#shift day
		lb $t0, 0($t1)
		sb $t0, 1($a0)
		lb $t0, 1($t1)
		sb $t0, 2($a0)
		addi $a0, $a0, 3	#don't jump, go next to Type C to get year on	
	TypeC:
		addi $t0, $0, 44	#','
		sb $t0, 0($a0)
		addi $t0, $0, 32	#' '
		sb $t0, 1($a0)
		#shift year
		lb $t0, 6($t1)
		sb $t0, 2($a0)
		lb $t0, 7($t1)
		sb $t0, 3($a0)
		lb $t0, 8($t1)
		sb $t0, 4($a0)
		lb $t0, 9($t1)
		sb $t0, 5($a0)
		add $t0, $0, $0	#'\0'
		sb $t0, 6($a0)

		lw $v0, 0($sp)		#first $a0, &TIME[0]
		addi $sp, $sp, 4	#Just in case BC, we spare $sp for use, so we move back
	EndConvert:
	jr $ra


#int GetTime(char*TIME1, char*TIME2)
#return the distance from TIME1 to TIME2, TIME1<TIME2
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
	beq $t0, $0, MONTH2_NOT_SMALLER
	addi $v0, $s0, -1
	j END_GETTIME

	MONTH2_NOT_SMALLER:
	#if (month 1<month 2)=>year diff not change, return
	slt $t0, $s1, $s4
	beq $t0, $0, MONTH2_NOT_BIGGER
	add $v0, $s0, $0
	j END_GETTIME

	MONTH2_NOT_BIGGER:
	#(day 2 < day 1)? YES=> year-=1
	slt $t0, $s5, $s2
	beq $t0, $0, DAY2_NOT_SMALLER
	#day 2 smaller: check if month ==2 and year2 is a leap year, and day 2 is 28
	addi $s4, $0, 2
	bne $s1, $s4, NOT_ENOUGH_DAY
	addi $s4, $0, 28
	bne $s5, $s4, NOT_ENOUGH_DAY
	add $a0, $s3, $0
	jal CheckLeapYear
	bne $v0, $0, NOT_ENOUGH_DAY	#is a leap year=>not enough day
	j DAY2_NOT_SMALLER
	NOT_ENOUGH_DAY:
	addi $v0, $s0, -1
	j END_GETTIME
	DAY2_NOT_SMALLER:
	add $v0, $s0, $0	
	
	END_GETTIME:
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

#int WeekDay(char* TIME)
#return the day of the week (0,1,2,3,4,5,6)->(Sun, Mon, Tue, Wed, Thu, Fri, Sar)
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
	beq $v0, $0, JULIAN_DATE
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
	j ADD_YEAR
	
	#if julian date
	JULIAN_DATE:
	addi $t2, $0, 18
	sub $t2, $t2, $t0
	add $s1, $s1, $t2
	
	ADD_YEAR:
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
	beq $v0, $0, NOT_LEAP_YEAR
	addi $t0, $0, 6
	sw $t0, 0($sp)
	addi $t0, $0, 2
	sw $t0, 4($sp)		#do not jump
	NOT_LEAP_YEAR:
	
	add $s2, $sp, $0	#begin pos of m array
	addi $s3, $s3, -1
	sll $s3, $s3, 2
	add $s2, $s2, $s3	#pos of particular m element needed
	lw $t0, 0($s2)		#load m
	add $s1, $s1, $t0	#add m
	
	addi $sp, $sp, 48
	
	addi $s2, $0, 7
	div $s1, $s2
	mfhi $v0
	
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
	slt $t0, $v0, $t0
	bne $t0, $0, CheckGregorianDate_RETURN_0
	
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
	
