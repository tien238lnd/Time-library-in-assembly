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
	beq $s2, $t0, main_tt1
	addi $t0, $zero, 2					# thao tac 2
	beq $s2, $t0, main_tt2
	addi $t0, $zero, 3					# thao tac 3
	beq $s2, $t0, main_tt3
	addi $t0, $zero, 4 					# thao tac 4
	beq $s2, $t0, main_tt4
	addi $t0, $zero, 5 					# thao tac 5
	beq $s2, $t0, main_tt5
	addi $t0, $zero, 6 					# thao tac 6
	beq $s2, $t0, main_tt6
	addi $t0, $zero, 7 					# thao tac 7
	beq $s2, $t0, main_tt7



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
	



	
	
