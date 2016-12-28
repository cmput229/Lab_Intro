#------------------------------
# Introductory Lab - First Program
# Author: Taylor Lloyd
# Date: June 19, 2012
#------------------------------

.data
nums:	.word 20, 34, 52, 86, 19, 0
str:	.asciiz "Number = "
nl:	.asciiz "\n"

.text
main:
	la	$s0 nums
	li	$t0 0
	li	$t2 0
	
	loop:
		lw	$t1 0($s0)
		addi	$s0 $s0 4
		add	$t0 $t0 $t1
		addi	$t2 $t2 1
		bnez	$t1 loop

	div	$t0 $t2
	
	li	$v0 4
	la	$a0 str
	syscall
	
	li	$v0 1
	mflo	$a0
	syscall

	li	$v0 4
	la	$a0 nl
	syscall

	jr	$ra
