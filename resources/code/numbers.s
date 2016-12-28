#------------------------------
# Number Fun
# Author: Taylor Lloyd
# Date: June 19, 2012
#------------------------------

main:
	li	$t0 1
	li	$t1 1
	li	$t2 2
	li	$t4 7
	
	loop:
		move	$t3 $t0
		add	$t0 $t0 $t1
		move	$t1 $t3
		addi	$t2 $t2 1
		blt	$t2 $t4 loop
	
	li	$v0 1
	move	$a0 $t0
	syscall

	li	$v0 10
	syscall
