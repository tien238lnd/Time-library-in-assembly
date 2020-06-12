# Ham tra ve ngay trong DD/MM/YYYY
# a0 la chuoi TIME
# v0 la ngay trong TIME
GetDay:
	# Luu vao stack , de phong khi co ham khac goi ham nay
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# ngay = stoi(time, 0, 1)
	add $a1, $0, $0
	addi $a2, $0, 1
	jal stoi

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


# Ham tra ve thang trong DD/MM/YYYY
# a0 la chuoi TIME
# v0 la thang trong TIME
GetMonth:
	# Luu vao stack , de phong khi co ham khac goi ham nay
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# thang = stoi(time, 3, 4)
	addi $a1, $0, 3
	addi $a2, $0, 4
	jal stoi

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


# Ham tra ve nam trong  DD/MM/YYYY
# $a0 TIME
# $v0 year in TIME
Year:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# nam= stoi(time, 6, 9)
	addi $a1, $zero, 6
	addi $a2, $zero, 9
	jal stoi

	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


# Ham chuyen tu string o chi so bat ky sang int 
# stoi (str a0, start a1, end a2)
stoi:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# khoi tao v0 
	add $v0, $0, $0 

	# khoi tao t0 = a1 (i = start)
	add $t0 $0 $a1  

Loop:
	# kiem tra dieu kien, neu nhu t0 > a2 (i > end) thi exit
	slt $t4, $a2, $t0 
	beq $t4 , 1, Exit

	# t1 chua gia tri cua str[i]
	# t1 sau do chua luon so sau khi chuyen
	sll $t1, $t0, 2
	lw $t1, $t1($a0) 
	subi $t1, $t1, 48

	# tang v0 len 10 lan
	addi $t3, $0, 10
	mult $v0, $t3
	mflo $v0

	# vo = v0 + chusomoivualayduoc
	add $v0, $v0, $t1

	# i = i + 1
	addi $t0 , $t0, 1
	j Loop

Exit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
		
	
	

	
	
	
	
	
	
	
	
	
	

